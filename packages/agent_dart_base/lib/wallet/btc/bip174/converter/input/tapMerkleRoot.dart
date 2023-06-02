import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../types.dart';
import 'dart:typed_data';

TapMerkleRoot decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.TAP_MERKLE_ROOT.index) {
    throw Exception(
      'Decode Error: could not decode tapMerkleRoot with key 0x${keyVal.key.toHex()}',
    );
  }
  if (!check(keyVal.value)) {
    throw Exception('Decode Error: tapMerkleRoot not a 32-byte hash');
  }
  return keyVal.value;
}

KeyValue encode(TapMerkleRoot data) {
  return KeyValue(
      key: Uint8List.fromList([InputTypes.TAP_MERKLE_ROOT.index]), value: data);
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return data is Uint8List && data.length == 32;
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.tapMerkleRoot == null;
}

final tapMerkleRootConverter = TapMerkleRootConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class TapMerkleRootConverter implements BaseConverter<TapMerkleRoot> {
  @override
  TapMerkleRoot Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(TapMerkleRoot data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<TapMerkleRoot> array,
    TapMerkleRoot item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  TapMerkleRootConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
