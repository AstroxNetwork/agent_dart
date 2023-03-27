import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart_base/agent/agent/api.dart';
import 'package:agent_dart_base/agent/canisters/management.dart';
import 'package:agent_dart_base/agent/polling/polling.dart';
import 'package:agent_dart_base/candid/idl.dart';
import 'package:agent_dart_base/principal/principal.dart';

import 'errors.dart';
import 'request_id.dart';
import 'types.dart';

class ActorCallError extends AgentFetchError {
  ActorCallError(
    Principal canisterId,
    String methodName,
    String type, //: 'query' | 'update'
    Map<String, String> props,
  ) {
    final e = [
      'Call failed:',
      '  Canister: ${canisterId.toText()}',
      '  Method: $methodName ($type)',
      ...(props.entries).map((n) => "  '${n.key}': ${jsonEncode(props[n])}"),
    ].join('\n');
    throw e;
  }
}

class QueryCallRejectedError extends ActorCallError {
  QueryCallRejectedError(
    Principal canisterId,
    String methodName,
    QueryResponseRejected result,
  ) : super(
          canisterId,
          methodName,
          'query',
          {
            'Status': result.status,
            'Code': result.rejectCode != null
                ? result.rejectCode.toString()
                : "Unknown Code '${result.rejectCode}'",
            'Message': result.rejectMessage ?? '',
          },
        );
}

class UpdateCallRejectedError extends ActorCallError {
  UpdateCallRejectedError(
    Principal canisterId,
    String methodName,
    SubmitResponse response,
    RequestId requestId,
  ) : super(
          canisterId,
          methodName,
          'update',
          {
            'Request ID': requestIdToHex(requestId),
            'HTTP status code': response.response!.status!.toString(),
            'HTTP status text': response.response!.statusText!,
          },
        );
}

class CallConfig {
  const CallConfig({
    this.agent,
    this.pollingStrategyFactory,
    this.canisterId,
    this.effectiveCanisterId,
  });

  factory CallConfig.fromJson(Map<String, dynamic> map) {
    return CallConfig(
      agent: map['agent'],
      pollingStrategyFactory: map['pollingStrategyFactory'],
      canisterId: map['canisterId'],
      effectiveCanisterId: map['effectiveCanisterId'],
    );
  }

  /// An agent to use in this call, otherwise the actor or call will try to discover the
  /// agent to use.
  final Agent? agent;

  /// A polling strategy factory that dictates how much and often we should poll the
  /// read_state endpoint to get the result of an update call.
  final PollStrategyFactory? pollingStrategyFactory;

  /// The canister ID of this Actor.
  final Principal? canisterId;

  /// The effective canister ID. This should almost always be ignored.
  final Principal? effectiveCanisterId;

  Map<String, dynamic> toJson() {
    return {
      'agent': agent,
      'pollingStrategyFactory': pollingStrategyFactory,
      'canisterId': canisterId,
      'effectiveCanisterId': effectiveCanisterId
    };
  }
}

/// Configuration that can be passed to customize the Actor behaviour.
class ActorConfig extends CallConfig {
  const ActorConfig({
    super.agent,
    super.pollingStrategyFactory,
    super.canisterId,
    super.effectiveCanisterId,
    this.callTransform,
    this.queryTransform,
  });

  factory ActorConfig.fromJson(Map map) {
    return ActorConfig(
      callTransform: map['callTransform'],
      queryTransform: map['queryTransform'],
      agent: map['agent'],
      pollingStrategyFactory: map['pollingStrategyFactory'],
      canisterId: map['canisterId'],
      effectiveCanisterId: map['effectiveCanisterId'],
    );
  }

  /// An override function for update calls' CallConfig.
  /// This will be called on every calls.
  final CallConfig Function(
    String methodName,
    List args,
    CallConfig callConfig,
  )? callTransform;

  /// An override function for query calls' CallConfig.
  /// This will be called on every query.
  final CallConfig Function(
    String methodName,
    List args,
    CallConfig callConfig,
  )? queryTransform;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'callTransform': callTransform,
      'queryTransform': queryTransform
    };
  }
}

// TODO: move this to proper typing when Candid support TypeScript.
// /**
//  * A subclass of an actor. Actor class itself is meant to be a based class.
//  */
// export type ActorSubclass<T = Record<string, ActorMethod>> = Actor & T;

// /**
//  * An actor method type, defined for each methods of the actor service.
//  */
// export interface ActorMethod<Args extends unknown[] = unknown[], Ret extends unknown = unknown> {
//   (...args: Args): Promise<Ret>;
//   withOptions(options: CallConfig): (...args: Args) => Promise<Ret>;
// }

enum CanisterInstallMode { install, reinstall, upgrade }

/// Internal metadata for actors. It's an enhanced version of [ActorConfig] with
/// some fields marked as required (as they are defaulted) and canisterId as
/// a [Principal] type.
class ActorMetadata {
  const ActorMetadata({this.service, this.agent, this.config});

  final Service? service;
  final Agent? agent;
  final ActorConfig? config;
}

class FieldOptions {
  const FieldOptions(this.module, {this.mode, this.arg});

  factory FieldOptions.fromJson(Map<String, dynamic> map) {
    return FieldOptions(map['module'], mode: map['mode'], arg: map['arg']);
  }

  final BinaryBlob module;
  final String? mode;
  final BinaryBlob? arg;

  Map<String, dynamic> toJson() {
    return {'module': module, 'mode': mode, 'arg': arg};
  }
}

// const metadataSymbol = Symbol.for('ic-agent-metadata');

/// An actor base class. An actor is an object containing only functions that will
/// return a promise. These functions are derived from the IDL definition.
class Actor {
  const Actor(this.metadata);

  final ActorMetadata metadata;

  /// Get the Agent class this Actor would call, or undefined if the Actor would use
  /// the default agent (global.ic.agent).
  /// @param actor The actor to get the agent of.
  static Agent? agentOf(Actor actor) {
    return actor.metadata.config?.agent;
  }

  /// Get the interface of an actor, in the form of an instance of a Service.
  /// @param actor The actor to get the interface of.
  static Service? interfaceOf(Actor actor) {
    return actor.metadata.service;
  }

  static Principal canisterIdOf(Actor actor) {
    return Principal.from(actor.metadata.config!.canisterId);
  }

  static void install(
    FieldOptions fields,
    ActorConfig config,
  ) async {
    final String mode = fields.mode ?? CanisterInstallMode.install.name;
    // Need to transform the arg into a number array.
    final arg = fields.arg != null
        ? Uint8List.fromList([...?fields.arg])
        : Uint8List.fromList([]);
    // Same for module.
    final wasmModule = Uint8List.fromList([...fields.module]);

    final canisterId = config.canisterId ?? Principal.fromText('');

    final canister = getManagementCanister(config);

    await canister.getFunc('install_code')!.call([
      {
        'mode': {mode: null},
        'arg': arg,
        'wasm_module': wasmModule,
        'canister_id': canisterId,
      }
    ]);
  }

  static Future<Principal> createCanister(CallConfig? config) async {
    final canister = getManagementCanister(config ?? const CallConfig());
    final ActorMethod? func = canister.getFunc(
      'provisional_create_canister_with_cycles',
    );
    dynamic result;
    if (func != null) {
      result = await func.call([
        {'amount': [], 'settings': []}
      ]);
    }
    final canisterId = Principal.from(result['canister_id']);
    return canisterId;
  }

  static createAndInstallCanister(
    Service interfaceFactory,
    FieldOptions fields,
    CallConfig? config,
  ) async {
    final canisterId = await createCanister(config);

    final newConfig = ActorConfig(
      agent: config?.agent,
      canisterId: canisterId,
      effectiveCanisterId: config?.effectiveCanisterId,
      pollingStrategyFactory: config?.pollingStrategyFactory,
    );
    install(fields, newConfig);

    return createActor(interfaceFactory, newConfig);
  }

  static ActorConstructor createActorClass(Service interfaceFactory) {
    return CanisterActor.withService(interfaceFactory);
  }

  static CanisterActor createActor(
    Service interfaceFactory,
    ActorConfig configuration,
  ) {
    return createActorClass(interfaceFactory)(
      configuration,
    );
  }

  static const String metadataSymbol = 'ic-agent-metadata';
}

typedef CreateActorMethod = ActorMethod Function(
  Actor actor,
  String methodName,
  Func func,
);

class CanisterActor extends Actor {
  CanisterActor(
    ActorConfig config,
    Service service, {
    CreateActorMethod? createActorMethod,
  }) : super(ActorMetadata(service: service, config: config)) {
    final fields = service.fields;
    for (final e in fields) {
      methodMap.putIfAbsent(
        e.key,
        () => (createActorMethod ?? _createActorMethod)(this, e.key, e.value),
      );
    }
  }

  // [x: string]: ActorMethod;
  final Map<String, ActorMethod> methodMap = <String, ActorMethod>{};

  ActorMethod? getFunc(String method) {
    return methodMap[method];
  }

  static CanisterActor Function(ActorConfig config) withService(
    Service service,
  ) =>
      (ActorConfig config) => CanisterActor(config, service);
}

dynamic decodeReturnValue(List<CType> types, BinaryBlob msg) {
  final returnValues = IDL.decode(types, msg);
  switch (returnValues.length) {
    case 0:
      return null;
    case 1:
      return returnValues[0];
    default:
      return returnValues;
  }
}

typedef MethodCaller = Future Function(CallConfig options, List args);

ActorMethod _createActorMethod(Actor actor, String methodName, Func func) {
  MethodCaller caller;
  if (func.annotations.contains('query')) {
    caller = (CallConfig options, List args) async {
      // First, if there's a config transformation, call it.
      final presetOption = actor.metadata.config!.queryTransform?.call(
        methodName,
        args,
        CallConfig.fromJson({
          ...actor.metadata.config!.toJson(),
          ...options.toJson(),
        }),
      );

      final newOptions = CallConfig.fromJson({
        ...options.toJson(),
        ...?presetOption?.toJson(),
      });
      final agent = newOptions.agent ?? actor.metadata.config!.agent;
      final cid = Principal.from(
        newOptions.canisterId ?? actor.metadata.config!.canisterId,
      );
      final arg = IDL.encode(func.argTypes, args);
      final result = await agent!.query(
        cid,
        QueryFields(arg: arg, methodName: methodName),
        null,
      );
      switch (result.status) {
        case QueryResponseStatus.rejected:
          throw QueryCallRejectedError(
            cid,
            methodName,
            QueryResponseRejected(
              rejectCode: result.rejectCode,
              rejectMessage: result.rejectMessage,
            ),
          );
        case QueryResponseStatus.replied:
          return decodeReturnValue(func.retTypes, result.reply!.arg!);
      }
    };
  } else {
    caller = (CallConfig options, List args) async {
      // First, if there's a config transformation, call it.
      final presetOption = actor.metadata.config!.queryTransform?.call(
        methodName,
        args,
        CallConfig.fromJson({
          ...actor.metadata.config!.toJson(),
          ...options.toJson(),
        }),
      );
      final newOptions = CallConfig.fromJson({
        ...options.toJson(),
        ...?presetOption?.toJson(),
      });
      final agent = newOptions.agent ?? actor.metadata.config!.agent;
      final cid = Principal.from(
        newOptions.canisterId ?? actor.metadata.config!.canisterId,
      );
      final arg = IDL.encode(func.argTypes, args);
      final pollingStrategyFactory =
          actor.metadata.config!.pollingStrategyFactory ??
              newOptions.pollingStrategyFactory ??
              defaultStrategy;
      final effectiveCanisterId = actor.metadata.config!.effectiveCanisterId ??
          newOptions.effectiveCanisterId;
      final ecid = effectiveCanisterId != null
          ? Principal.from(effectiveCanisterId)
          : cid;
      // final { requestId, response } =
      final result = await agent!.call(
        cid,
        CallOptions(
          methodName: methodName,
          arg: arg,
          effectiveCanisterId: ecid,
        ),
        null,
      );

      final response = result.response!;
      final requestId = result.requestId!;
      if (!response.ok!) {
        throw UpdateCallRejectedError(cid, methodName, result, requestId);
      }

      final pollStrategy = pollingStrategyFactory();
      final responseBytes = await pollForResponse(
        agent,
        ecid,
        requestId,
        pollStrategy,
      );

      if (responseBytes.isNotEmpty) {
        return decodeReturnValue(func.retTypes, responseBytes);
      }
      if (func.retTypes.isEmpty) {
        return null;
      }
      throw StateError(
        'Call returned nothing, but expected [${func.retTypes.join(',')}].',
      );
    };
  }
  return ActorMethod(caller);
}

class ActorMethod {
  const ActorMethod(this.caller);

  final MethodCaller caller;

  static Future<dynamic> handlerCall(
    MethodCaller caller,
    List<dynamic> args,
    CallConfig? withOptions,
  ) =>
      caller(withOptions ?? const CallConfig(), args);

  Future<dynamic> call(List<dynamic>? args) async {
    return caller(const CallConfig(), args ?? []);
  }

  Future<dynamic> withOptions(
    CallConfig withOptions,
    List<dynamic>? args,
  ) async =>
      caller(withOptions, args ?? []);
}

typedef ActorConstructor = CanisterActor Function(ActorConfig config);
