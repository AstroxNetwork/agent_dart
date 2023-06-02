import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../types.dart';
import 'dart:typed_data';

TapScriptSig decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.TAP_SCRIPT_SIG.index) {
    throw Exception(
      'Decode Error: could not decode tapScriptSig with key 0x${keyVal.key.toHex()}',
    );
  }
  if (keyVal.key.length != 65) {
    throw Exception(
      'Decode Error: tapScriptSig has invalid key 0x${keyVal.key.toHex()}',
    );
  }
  if (keyVal.value.length != 64 && keyVal.value.length != 65) {
    throw Exception(
      'Decode Error: tapScriptSig has invalid signature in key 0x${keyVal.key.toHex()}',
    );
  }
  final pubkey = keyVal.key.sublist(1, 33);
  final leafHash = keyVal.key.sublist(33);

  return TapScriptSig(
      pubkey: pubkey, leafHash: leafHash, signature: keyVal.value);
}

KeyValue encode(TapScriptSig data) {
  return KeyValue(
      key: Uint8List.fromList(
          [InputTypes.TAP_SCRIPT_SIG.index] + data.pubkey + data.leafHash),
      value: data.signature);
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return (data.pubkey is Uint8List &&
      data.leafHash is Uint8List &&
      data.signature is Uint8List &&
      data.pubkey.length == 32 &&
      data.leafHash.length == 32 &&
      (data.signature.length == 64 || data.signature.length == 65));
}

bool canAddToArray(
  List<TapScriptSig> array,
  TapScriptSig item,
  Set<String> dupeSet,
) {
  final dupeString = item.pubkey.toHex() + item.leafHash.toHex();
  if (dupeSet.contains(dupeString)) return false;
  dupeSet.add(dupeString);
  return array
      .where((v) => v.pubkey == item.pubkey && v.leafHash == item.leafHash)
      .isEmpty;
}

final tapScriptSigConverter = TapScriptSigConverter(
    decode: decode, encode: encode, check: check, canAddToArray: canAddToArray);

class TapScriptSigConverter implements BaseConverter<TapScriptSig> {
  @override
  TapScriptSig Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(TapScriptSig data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<TapScriptSig> array,
    TapScriptSig item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  TapScriptSigConverter(
      {this.decode, this.encode, this.check, this.canAddToArray});
}
