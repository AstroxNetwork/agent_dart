import 'dart:typed_data';

import '../../candid/idl.dart';
import '../actor.dart';

/// Returns the Candid service definition for the asset canister.
Service assetIDL() {
  return IDL.Service({
    'retrieve': IDL.Func([IDL.Text], [IDL.Vec(IDL.Nat8)], ['query']),
    'store': IDL.Func([IDL.Text, IDL.Vec(IDL.Nat8)], [], []),
  });
}

/// Asset canister method names.
enum AssetMethod { retrieve, store }

/// Try to understand how idl can be transformed.
class AssetActor {
  /// Creates an asset actor wrapper.
  AssetActor();

  late final CanisterActor actor;

  /// Retrieves asset bytes by [key].
  Future<Uint8List> retrieve(String key) async {
    final res = await actor.getFunc(AssetMethod.retrieve.name)?.call([key]);
    if (res != null) {
      return res as Uint8List;
    }
    throw StateError('Request failed with the result: $res.');
  }

  /// Stores asset [value] under [key].
  Future<void> store(String key, Uint8List value) async {
    await actor.getFunc(AssetMethod.store.name)?.call([key, value]);
  }
}
