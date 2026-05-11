import 'dart:convert';
import 'dart:typed_data';

import 'package:typed_data/typed_data.dart';

import '../candid/idl.dart';
import '../principal/principal.dart';
import 'agent/api.dart';
import 'agent/http/types.dart';
import 'canisters/management.dart';
import 'cbor.dart' as cbor;
import 'errors.dart';
import 'polling/polling.dart';
import 'request_id.dart';
import 'types.dart';

/// Error thrown when an actor query or update call fails.
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
      ...props.entries.map(
        (n) => "  '${n.key}': ${jsonEncode(props[n.value])}",
      ),
    ].join('\n');
    throw e;
  }
}

/// Error thrown when a canister query returns a rejected response.
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

/// Error thrown when an update call is rejected by the replica.
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

/// Runtime options for a single actor method call.
///
/// A [CallConfig] can override the actor's default agent, canister routing,
/// polling strategy, and synchronous-call behavior for one invocation.
class CallConfig {
  const CallConfig({
    this.agent,
    this.pollingStrategyFactory,
    this.canisterId,
    this.effectiveCanisterId,
    this.callSync = true,
  });

  /// Builds a call configuration from a JSON-like map.
  factory CallConfig.fromJson(Map<String, dynamic> map) {
    return CallConfig(
      agent: map['agent'],
      pollingStrategyFactory: map['pollingStrategyFactory'],
      canisterId: map['canisterId'],
      effectiveCanisterId: map['effectiveCanisterId'],
      callSync: map['callSync'] ?? true,
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

  /// Whether to call the endpoint synchronously.
  final bool callSync;

  /// Converts this configuration to a JSON-like map.
  Map<String, dynamic> toJson() {
    return {
      'agent': agent,
      'pollingStrategyFactory': pollingStrategyFactory,
      'canisterId': canisterId,
      'effectiveCanisterId': effectiveCanisterId,
      'callSync': callSync,
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
    super.callSync,
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
      callSync: map['callSync'] ?? true,
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
      'queryTransform': queryTransform,
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

/// Installation modes accepted by the IC management canister.
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

/// Options used when installing WASM code into a canister.
class FieldOptions {
  /// Creates install-code field options with a WASM [module].
  const FieldOptions(this.module, {this.mode, this.arg});

  /// Builds field options from a JSON-like map.
  factory FieldOptions.fromJson(Map<String, dynamic> map) {
    return FieldOptions(map['module'], mode: map['mode'], arg: map['arg']);
  }

  /// The WASM module bytes to install.
  final BinaryBlob module;

  /// The install mode, usually one of [CanisterInstallMode]'s names.
  final String? mode;

  /// Optional Candid-encoded initialization or upgrade argument.
  final BinaryBlob? arg;

  /// Converts these options to a JSON-like map.
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

  /// Returns the canister ID configured on [actor].
  static Principal canisterIdOf(Actor actor) {
    return Principal.from(actor.metadata.config!.canisterId);
  }

  /// Installs, reinstalls, or upgrades code on a canister via the management canister.
  static Future<void> install(FieldOptions fields, ActorConfig config) async {
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

  /// Creates a new canister and returns its principal.
  static Future<Principal> createCanister(CallConfig? config) async {
    final canister = getManagementCanister(config ?? const CallConfig());
    final ActorMethod? func = canister.getFunc(
      'provisional_create_canister_with_cycles',
    );
    dynamic result;
    if (func != null) {
      result = await func.call([
        {'amount': [], 'settings': []},
      ]);
    }
    final canisterId = Principal.from(result['canister_id']);
    return canisterId;
  }

  /// Creates a canister, installs [fields.module], and returns an actor for it.
  static Future<CanisterActor> createAndInstallCanister(
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

  /// Creates an actor constructor bound to a Candid [interfaceFactory].
  static ActorConstructor createActorClass(Service interfaceFactory) {
    return CanisterActor.withService(interfaceFactory);
  }

  /// Creates a canister actor from a Candid service and actor configuration.
  static CanisterActor createActor(
    Service interfaceFactory,
    ActorConfig configuration,
  ) {
    return createActorClass(interfaceFactory)(configuration);
  }

  static const String metadataSymbol = 'ic-agent-metadata';
}

/// Factory signature used to create callable actor methods.
typedef CreateActorMethod = ActorMethod Function(
  Actor actor,
  String methodName,
  Func func,
);

/// An [Actor] backed by a Candid service definition.
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

  /// Returns the actor method named [method], or `null` if it is not defined.
  ActorMethod? getFunc(String method) {
    return methodMap[method];
  }

  /// Creates a [CanisterActor] constructor for [service].
  static CanisterActor Function(ActorConfig config) withService(
    Service service,
  ) =>
      (ActorConfig config) => CanisterActor(config, service);
}

/// Decodes Candid response bytes into the Dart return value expected by callers.
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

/// Low-level actor method caller signature.
typedef MethodCaller = Future Function(CallConfig options, List args);

ActorMethod _createActorMethod(Actor actor, String methodName, Func func) {
  MethodCaller caller;
  if (func.annotations.contains('query') ||
      func.annotations.contains('composite_query')) {
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
      final callSync = actor.metadata.config?.callSync ?? newOptions.callSync;

      final result = await agent!.callRequest(
        cid,
        CallOptions(
          methodName: methodName,
          arg: arg,
          effectiveCanisterId: ecid,
          callSync: callSync,
        ),
        null,
      );

      final response = result.response!;
      final requestId = result.requestId!;
      if (!response.ok!) {
        throw UpdateCallRejectedError(cid, methodName, result, requestId);
      }

      BinaryBlob? certificate;
      // Fall back to polling if we receive an "Accepted" response code,
      // otherwise decode the certificate instantly.
      if (result is CallResponseBody && result.response?.status != 202) {
        final buffer = (result.response as HttpResponseBody).arrayBuffer!;
        final decoded = cbor.cborDecode<Map>(buffer);
        certificate = blobFromBuffer(
          (decoded['certificate'] as Uint8Buffer).buffer,
        );
      }

      final pollStrategy = pollingStrategyFactory();
      final responseBytes = await pollForResponse(
        agent,
        ecid,
        requestId,
        pollStrategy,
        methodName,
        overrideCertificate: certificate,
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

/// A callable canister method generated from a Candid function definition.
class ActorMethod {
  /// Creates an actor method backed by [caller].
  const ActorMethod(this.caller);

  /// The function that performs the query or update call.
  final MethodCaller caller;

  /// Invokes [caller] with optional per-call options.
  static Future<dynamic> handlerCall(
    MethodCaller caller,
    List<dynamic> args,
    CallConfig? withOptions,
  ) {
    return caller(withOptions ?? const CallConfig(), args);
  }

  /// Calls the method with default options.
  Future<dynamic> call(List<dynamic>? args) {
    return caller(const CallConfig(), args ?? []);
  }

  /// Calls the method with [withOptions] merged into the actor configuration.
  Future<dynamic> withOptions(
    CallConfig withOptions,
    List<dynamic>? args,
  ) {
    return caller(withOptions, args ?? []);
  }
}

/// Constructor signature for canister actors.
typedef ActorConstructor = CanisterActor Function(ActorConfig config);
