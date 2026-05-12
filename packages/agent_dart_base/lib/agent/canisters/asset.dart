/// Documents packages/agent_dart_base/lib/agent/canisters/asset.dart module purpose, public surface, and usage context
import '../actor.dart';
import 'asset_idl.dart';

/// Create a management canister actor.
/// @param config
CanisterActor createAssetCanisterActor(ActorConfig config) {
  return Actor.createActor(assetIDL(), config);
}
