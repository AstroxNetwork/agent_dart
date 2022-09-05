import 'package:agent_dart/agent/agent.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/candid/idl.dart';

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
    ServiceClass idl,
    HttpAgent agent,
    Principal canisterId,
  ) {
    return Actor.createActor(
      idl,
      ActorConfig.fromMap({'canisterId': canisterId, 'agent': agent}),
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
    final uri = Uri.parse(url);
    final port = ':${uri.port}';
    final protocol = uri.scheme;
    final host = uri.host;
    _agent = HttpAgent(
      defaultProtocol: protocol,
      defaultHost: host,
      defaultPort: port,
      options: HttpAgentOptions()..identity = identity,
    );
    if (_debug) {
      await _agent.fetchRootKey();
    }
    _agent.addTransform(
      HttpAgentRequestTransformFn()..call = makeNonceTransform(),
    );
  }

  void setActor() {
    _actor = Actor.createActor(
      idl,
      ActorConfig.fromMap({'canisterId': canisterId, 'agent': _agent}),
    );
  }
}
