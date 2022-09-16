import 'package:agent_dart/agent_dart.dart';

class AgentFactory {
  AgentFactory({
    required String canisterId,
    required String url,
    required Service idl,
    Identity? identity,
    bool? debug = true,
  }) {
    _setCanisterId(canisterId);
    _identity = identity ?? const AnonymousIdentity();
    _idl = idl;
    _debug = debug ?? true;
    _initAgent(url);
    _createActor();
  }

  late final Principal _canisterId;
  late Identity _identity;
  late HttpAgent _agent;
  late final bool _debug;
  late CanisterActor _actor;

  Identity get identity => _identity;
  late Service _idl;

  CanisterActor get actor => _actor;

  static Future<AgentFactory> create({
    required String canisterId,
    required String url,
    required Service idl,
    Identity? identity,
    bool? debug = true,
  }) async {
    final newIdentity = identity ?? await Ed25519KeyIdentity.generate(null);
    return AgentFactory(
      canisterId: canisterId,
      url: url,
      idl: idl,
      identity: newIdentity,
      debug: debug,
    );
  }

  T hook<T extends ActorHook>(T target) {
    target.actor = actor;
    return target;
  }

  void _setCanisterId(String canisterId) {
    _canisterId = Principal.fromText(canisterId);
  }

  void _initAgent(String url) async {
    final uri = Uri.parse(url);
    final port = uri.port;
    final protocol = uri.scheme;
    final host = uri.host;
    _agent = HttpAgent(
      defaultProtocol: protocol,
      defaultHost: host,
      defaultPort: port,
      options: HttpAgentOptions(identity: _identity),
    );
    if (_debug) {
      await _agent.fetchRootKey();
    }
    _agent.addTransform(
      HttpAgentRequestTransformFn(call: makeNonceTransform()),
    );
  }

  void _createActor() {
    _actor = Actor.createActor(
      _idl,
      ActorConfig.fromJson({'canisterId': _canisterId, 'agent': _agent}),
    );
  }
}

abstract class ActorHook {
  late final CanisterActor actor;
}
