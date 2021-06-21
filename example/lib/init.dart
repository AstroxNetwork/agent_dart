import 'package:agent_dart/agent_dart.dart';

class AgentFactory {
  late final Principal _canisterId;
  late Identity _identity;
  late HttpAgent _agent;
  late final bool _debug;
  late CanisterActor _actor;
  Identity get identity => _identity;
  late Service _idl;

  CanisterActor get actor => _actor;

  AgentFactory(
      {required String canisterId,
      required String url,
      required Service idl,
      Identity? identity,
      bool? debug = true}) {
    _setCanisterId(canisterId);
    _identity = identity ?? Ed25519KeyIdentity.generate(null);
    _idl = idl;
    _debug = debug ?? true;
    _initAgent(url);
    _createActor();
  }
  factory AgentFactory.create(
      {required String canisterId,
      required String url,
      required Service idl,
      Identity? identity,
      bool? debug = true}) {
    return AgentFactory(
        canisterId: canisterId,
        url: url,
        idl: idl,
        identity: identity ?? Ed25519KeyIdentity.generate(null),
        debug: debug);
  }

  T hook<T extends ActorHook>(T target) {
    target.actor = actor;
    return target;
  }

  void _setCanisterId(String canisterId) {
    _canisterId = Principal.fromText(canisterId);
  }

  void _initAgent(String url) async {
    var uri = Uri.parse(url);
    var port = ":${uri.port}";
    var protocol = uri.scheme;
    var host = uri.host;

    _agent = HttpAgent(
        defaultProtocol: protocol,
        defaultHost: host,
        defaultPort: port,
        options: HttpAgentOptions()..identity = _identity);
    if (_debug) {
      await _agent.fetchRootKey();
    }
    _agent.addTransform(HttpAgentRequestTransformFn()..call = makeNonceTransform());
  }

  void _createActor() {
    _actor =
        Actor.createActor(_idl, ActorConfig.fromMap({"canisterId": _canisterId, "agent": _agent}));
  }
}

abstract class ActorHook {
  late final CanisterActor actor;
}
