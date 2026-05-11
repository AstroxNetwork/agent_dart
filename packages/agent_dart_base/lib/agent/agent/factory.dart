import '../../candid/idl.dart';
import '../../principal/principal.dart';
import '../agent.dart';

/// Convenience factory for creating an [HttpAgent] and [CanisterActor].
///
/// `AgentFactory` is the easiest entry point for application developers: pass a
/// canister ID, replica URL, Candid [Service], and optional [Identity], then use
/// [actor] to call canister methods.
class AgentFactory {
  /// Creates a factory for [canisterId] at [url].
  AgentFactory({
    required String canisterId,
    required String url,
    required this.idl,
    Identity? identity,
    bool? debug = true,
  })  : canisterId = Principal.fromText(canisterId),
        identity = identity ?? const AnonymousIdentity(),
        _debug = debug ?? true,
        _url = url;

  /// Creates a canister actor for [idl] using an existing [agent].
  static CanisterActor createActor(
    Service idl,
    HttpAgent agent,
    Principal canisterId,
  ) {
    return Actor.createActor(
      idl,
      ActorConfig(canisterId: canisterId, agent: agent),
    );
  }

  /// Creates, initializes, and returns an [AgentFactory].
  ///
  /// When [debug] is true, the agent fetches a root key from the replica. Use
  /// that for local replicas, not for IC mainnet.
  static Future<AgentFactory> createAgent({
    required String canisterId,
    required String url,
    required Service idl,
    Identity? identity,
    bool? debug = true,
  }) async {
    final agentFactory = AgentFactory(
      canisterId: canisterId,
      url: url,
      idl: idl,
      identity: identity ?? const AnonymousIdentity(),
      debug: debug,
    );
    await agentFactory.initAgent(url);
    agentFactory.setActor();
    return agentFactory;
  }

  /// The canister principal this factory targets.
  final Principal canisterId;

  /// The identity used by the underlying HTTP agent.
  final Identity identity;
  final bool _debug;

  /// Candid service definition used to build the actor.
  final Service idl;
  final String _url;

  /// Returns the initialized HTTP agent.
  HttpAgent getAgent() => _agent;
  late HttpAgent _agent;

  /// The actor generated from [idl], or `null` until [setActor] is called.
  CanisterActor? get actor => _actor;
  CanisterActor? _actor;

  /// Replica URL used by this factory.
  String get agentUrl => _url;

  /// Initializes the underlying HTTP agent for [url].
  Future<void> initAgent(String url) async {
    _agent = HttpAgent.fromUri(
      Uri.parse(url),
      options: HttpAgentOptions(identity: identity),
    );
    if (_debug) {
      await _agent.fetchRootKey();
    }
    _agent.addTransform(
      HttpAgentRequestTransformFn(call: makeNonceTransform()),
    );
  }

  /// Creates and stores the canister actor for this factory.
  void setActor() {
    _actor = Actor.createActor(
      idl,
      ActorConfig.fromJson({'canisterId': canisterId, 'agent': _agent}),
    );
  }
}
