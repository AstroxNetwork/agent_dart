import '../../candid/idl.dart';
import '../../principal/principal.dart';
import '../agent.dart';

class AgentFactory {
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

  final Principal canisterId;
  final Identity identity;
  final bool _debug;
  final Service idl;
  final String _url;

  HttpAgent getAgent() => _agent;
  late HttpAgent _agent;

  CanisterActor? get actor => _actor;
  CanisterActor? _actor;

  String get agentUrl => _url;

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

  void setActor() {
    _actor = Actor.createActor(
      idl,
      ActorConfig.fromJson({'canisterId': canisterId, 'agent': _agent}),
    );
  }
}
