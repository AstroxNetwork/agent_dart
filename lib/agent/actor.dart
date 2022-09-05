import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/agent/api.dart';
import 'package:agent_dart/agent/canisters/management.dart';
import 'package:agent_dart/agent/polling/index.dart';
import 'package:agent_dart/candid/idl.dart';

import 'package:agent_dart/principal/principal.dart';
import 'errors.dart';
import 'types.dart';
import 'request_id.dart';

class ActorCallError extends AgentError {
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
  ) : super(canisterId, methodName, 'update', {
          'Request ID': requestIdToHex(requestId),
          'HTTP status code': response.response!.status!.toString(),
          'HTTP status text': response.response!.statusText!,
        });
}

class CallConfig {
  CallConfig({
    this.agent,
    this.pollingStrategyFactory,
    this.canisterId,
    this.effectiveCanisterId,
  });

  factory CallConfig.fromMap(Map<String, dynamic> map) {
    return CallConfig(
      agent: map['agent'],
      pollingStrategyFactory: map['pollingStrategyFactory'],
      canisterId: map['canisterId'],
      effectiveCanisterId: map['effectiveCanisterId'],
    );
  }

  /// An agent to use in this call, otherwise the actor or call will try to discover the
  /// agent to use.
  Agent? agent;

  /// A polling strategy factory that dictates how much and often we should poll the
  /// read_state endpoint to get the result of an update call.
  PollStrategyFactory? pollingStrategyFactory;

  /// The canister ID of this Actor.
  Principal? canisterId;

  /// The effective canister ID. This should almost always be ignored.
  Principal? effectiveCanisterId;

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
  ActorConfig({
    Agent? agent,
    PollStrategyFactory? pollingStrategyFactory,
    Principal? canisterId,
    Principal? effectiveCanisterId,
    this.callTransform,
    this.queryTransform,
  }) : super(
          agent: agent,
          pollingStrategyFactory: pollingStrategyFactory,
          canisterId: canisterId,
          effectiveCanisterId: effectiveCanisterId,
        );

  factory ActorConfig.fromMap(Map map) {
    return ActorConfig()
      ..callTransform = map['callTransform']
      ..queryTransform = map['queryTransform']
      ..agent = map['agent']
      ..pollingStrategyFactory = map['pollingStrategyFactory']
      ..canisterId = map['canisterId']
      ..effectiveCanisterId = map['effectiveCanisterId'];
  }

  /// An override function for update calls' CallConfig. This will be called on every calls.
  CallConfig Function(
    String methodName,
    List args,
    CallConfig callConfig,
  )? callTransform;

  /// An override function for query calls' CallConfig. This will be called on every query.
  CallConfig Function(
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

// ignore: todo
// // TODO: move this to proper typing when Candid support TypeScript.
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

class CanisterInstallMode {
  const CanisterInstallMode._();

  static const install = 'install';
  static const reinstall = 'reinstall';
  static const upgrade = 'upgrade';
}

/* Internal metadata for actors. It's an enhanced version of ActorConfig with
 * some fields marked as required (as they are defaulted) and canisterId as
 * a Principal type.
 */
class ActorMetadata {
  const ActorMetadata({this.service, this.agent, this.config});

  final Service? service;
  final Agent? agent;
  final ActorConfig? config;
}

class FieldOptions {
  const FieldOptions(this.module, {this.mode, this.arg});

  factory FieldOptions.fromMap(Map<String, dynamic> map) {
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
    final mode = fields.mode ?? CanisterInstallMode.install;
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
    final canister = getManagementCanister(
      config ?? CallConfig(),
    );
    ActorMethod? func =
        canister.getFunc('provisional_create_canister_with_cycles');
    // ignore: prefer_typing_uninitialized_variables
    var result;
    if (func != null) {
      result = await func.call([
        {'amount': [], 'settings': []}
      ]);
    }

    var canisterId = Principal.from(result['canister_id']);

    return canisterId;
  }

  static createAndInstallCanister(
    Service interfaceFactory,
    FieldOptions fields,
    CallConfig? config,
  ) async {
    final canisterId = await createCanister(config);

    final newConfig = ActorConfig()
      ..agent = config?.agent
      ..canisterId = canisterId
      ..effectiveCanisterId = config?.effectiveCanisterId
      ..pollingStrategyFactory = config?.pollingStrategyFactory;

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

class CanisterActor extends Actor {
  CanisterActor(
    ActorConfig config,
    Service service,
  ) : super(ActorMetadata(service: service, config: config)) {
    var fields = service.fields;
    for (var e in fields) {
      methodMap.putIfAbsent(
        e.key,
        () => _createActorMethod(this, e.key, e.value),
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

_createActorMethod(Actor actor, String methodName, FuncClass func) {
  MethodCaller caller;
  if (func.annotations.contains('query')) {
    caller = (CallConfig options, List args) async {
      // First, if there's a config transformation, call it.
      var presetOption = actor.metadata.config!.queryTransform?.call(
        methodName,
        args,
        CallConfig.fromMap({
          ...actor.metadata.config!.toJson(),
          ...options.toJson(),
        }),
      );

      var newOptions = CallConfig.fromMap({
        ...options.toJson(),
        ...presetOption != null ? presetOption.toJson() : {},
      });

      final agent =
          newOptions.agent ?? actor.metadata.config!.agent; // getDefaultAgent()
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
      var presetOption = actor.metadata.config!.queryTransform?.call(
        methodName,
        args,
        CallConfig.fromMap({
          ...actor.metadata.config!.toJson(),
          ...options.toJson(),
        }),
      );

      var newOptions = CallConfig.fromMap({
        ...options.toJson(),
        ...presetOption != null ? presetOption.toJson() : {},
      });

      final agent =
          newOptions.agent ?? actor.metadata.config!.agent; // getDefaultAgent()
      // final { canisterId, effectiveCanisterId, pollingStrategyFactory } = {
      //   ...DEFAULT_ACTOR_CONFIG,
      //   ...actor[metadataSymbol].config,
      //   ...options,
      // };

      final canisterId =
          actor.metadata.config!.canisterId ?? newOptions.canisterId;
      final effectiveCanisterId = actor.metadata.config!.effectiveCanisterId ??
          newOptions.effectiveCanisterId;
      final pollingStrategyFactory =
          actor.metadata.config!.pollingStrategyFactory ??
              newOptions.pollingStrategyFactory ??
              defaultStrategy;
      final cid = Principal.from(canisterId);
      final ecid = effectiveCanisterId != null
          ? Principal.from(effectiveCanisterId)
          : cid;
      final arg = IDL.encode(func.argTypes, args);
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

      var response = result.response!;
      var requestId = result.requestId!;

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
      } else if (func.retTypes.isEmpty) {
        return null;
      } else {
        throw "Call was returned undefined, but type [${func.retTypes.join(',')}].";
      }
    };
  }

  var handler = ActorMethod(caller);
  return handler;
}

class ActorMethod {
  const ActorMethod(this.caller);

  final MethodCaller? caller;

  static Future<dynamic> handlerCall(
    MethodCaller caller,
    List<dynamic> args,
    CallConfig? withOptions,
  ) =>
      caller(withOptions ?? CallConfig(), args);

  Future<dynamic> call(List<dynamic>? args) async {
    return caller!(CallConfig(), args ?? []);
  }

  Future<dynamic> withOptions(
    CallConfig withOptions,
    List<dynamic>? args,
  ) async =>
      caller!(withOptions, args ?? []);
}

typedef ActorConstructor = CanisterActor Function(ActorConfig config);
