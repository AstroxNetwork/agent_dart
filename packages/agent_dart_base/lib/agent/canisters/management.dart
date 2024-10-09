import '../../principal/principal.dart';
import '../actor.dart';
import 'management_idl.dart';

// : ActorSubclass<ManagementCanisterRecord>
CanisterActor getManagementCanister(CallConfig config) {
  CallConfig transform(String methodName, List args, CallConfig callConfig) {
    final first = args[0];
    Principal effectiveCanisterId = Principal.fromHex('');
    if (first != null && first is Map && first['canister_id'] != null) {
      effectiveCanisterId = Principal.from(first['canister_id']);
    }
    return CallConfig(effectiveCanisterId: effectiveCanisterId);
  }

  final newConfig = ActorConfig(
    agent: config.agent,
    pollingStrategyFactory: config.pollingStrategyFactory,
    effectiveCanisterId: config.effectiveCanisterId,
    canisterId: Principal.fromHex(''),
    callTransform: transform,
    queryTransform: transform,
  );
  return Actor.createActor(managementIDL(), newConfig);
}
