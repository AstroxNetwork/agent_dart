import 'package:agent_dart/agent/actor.dart';
import 'package:agent_dart/principal/principal.dart';

import 'management_idl.dart';

// : ActorSubclass<ManagementCanisterRecord>
CanisterActor getManagementCanister(CallConfig config) {
  CallConfig transform(String methodName, List args, CallConfig callConfig) {
    final first = args[0];
    var effectiveCanisterId = Principal.fromHex('');
    if (first != null && first is Map && first['canister_id'] != null) {
      effectiveCanisterId = Principal.from(first['canister_id']);
    }
    return CallConfig()..effectiveCanisterId = effectiveCanisterId;
  }

  var newConfig = ActorConfig()
    ..agent = config.agent
    ..pollingStrategyFactory = config.pollingStrategyFactory
    ..effectiveCanisterId = config.effectiveCanisterId
    ..canisterId = Principal.fromHex('')
    ..callTransform = transform
    ..queryTransform = transform;

  return Actor.createActor(managementIDL(), newConfig);
}
