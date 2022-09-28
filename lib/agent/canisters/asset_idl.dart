import 'dart:typed_data';

import 'package:agent_dart/agent/actor.dart';
import 'package:agent_dart/candid/idl.dart';

Service assetIDL() {
  return IDL.service({
    'retrieve': IDL.func([IDL.Text], [IDL.vec(IDL.Nat8)], ['query']),
    'store': IDL.func([IDL.Text, IDL.vec(IDL.Nat8)], [], []),
  });
}

enum AssetMethod { retrieve, store }

/// Try to understand how idl can be transformed.
class AssetActor {
  AssetActor();

  late final CanisterActor actor;

  Future<Uint8List> retrieve(String key) async {
    final res = await actor.getFunc(AssetMethod.retrieve.name)?.call([key]);
    if (res != null) {
      return res as Uint8List;
    }
    throw StateError('Request failed with the result: $res.');
  }

  Future<void> store(String key, Uint8List value) async {
    await actor.getFunc(AssetMethod.store.name)?.call([key, value]);
  }
}
