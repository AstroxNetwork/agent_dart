import 'dart:typed_data';

import 'package:agent_dart/agent/actor.dart';
import 'package:agent_dart/candid/idl.dart';

Service assetIDL() {
  return IDL.Service({
    'retrieve': IDL.Func([IDL.Text], [IDL.Vec(IDL.Nat8)], ['query']),
    'store': IDL.Func([IDL.Text, IDL.Vec(IDL.Nat8)], [], []),
  });
}

class AssetMethod {
  static const retrieve = 'retrieve';
  static const store = 'store';
}

/// try to understand how idl can be transformed
class AssetActor {
  AssetActor();

  late final CanisterActor actor;

  Future<Uint8List> retrieve(String key) async {
    final res = await (actor.getFunc(AssetMethod.retrieve)?.call([key]));
    if (res != null) {
      return (res as Uint8List);
    }
    throw 'Cannot get result but $res';
  }

  Future<void> store(String key, Uint8List value) async {
    await actor.getFunc(AssetMethod.store)?.call([key, value]);
  }
}
