import 'package:agent_dart/agent/actor.dart';

import 'asset_idl.dart';

/// Create a management canister actor.
/// @param config
CanisterActor createAssetCanisterActor(ActorConfig config) {
  return Actor.createActor(assetIDL(), config);
}
