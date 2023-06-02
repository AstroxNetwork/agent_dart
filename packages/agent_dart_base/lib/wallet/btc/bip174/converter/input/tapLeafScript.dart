import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../types.dart';
import 'dart:typed_data';

TapLeafScript decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.TAP_LEAF_SCRIPT.index) {
    throw Exception(
      'Decode Error: could not decode tapLeafScript with key 0x${keyVal.key.toHex()}',
    );
  }
  if ((keyVal.key.length - 2) % 32 != 0) {
    throw Exception(
      'Decode Error: tapLeafScript has invalid control block in key 0x${keyVal.key.toHex()}',
    );
  }

  final leafVersion = keyVal.value[keyVal.value.length - 1];
  if ((keyVal.key[1] & 0xfe) != leafVersion) {
    throw Exception(
      'Decode Error: tapLeafScript bad leaf version in key 0x${keyVal.key.toHex()}',
    );
  }

  final script = keyVal.value.sublist(0, keyVal.value.length - 1);
  final controlBlock = keyVal.key.sublist(1);

  return TapLeafScript(
      controlBlock: controlBlock, script: script, leafVersion: leafVersion);
}

KeyValue encode(TapLeafScript data) {
  return KeyValue(
      key: Uint8List.fromList(
          [InputTypes.TAP_KEY_SIG.index] + data.controlBlock),
      value: Uint8List.fromList(data.script + [data.leafVersion]));
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return (data.controlBlock is Uint8List &&
      (data.controlBlock.length - 1) % 32 == 0 &&
      (data.controlBlock[0] & 0xfe) == data.leafVersion &&
      data.script is Uint8List);
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.tapKeySig == null;
}

bool canAddToArray(
  List<TapLeafScript> array,
  TapLeafScript item,
  Set<String> dupeSet,
) {
  final dupeString = item.controlBlock.toHex();
  if (dupeSet.contains(dupeString)) return false;
  dupeSet.add(dupeString);
  return array.where((v) => v.controlBlock == item.controlBlock).isEmpty;
}

final tapLeafScriptConverter = TapLeafScriptConverter(
    decode: decode,
    encode: encode,
    check: check,
    canAdd: canAdd,
    canAddToArray: canAddToArray);

class TapLeafScriptConverter implements BaseConverter<TapLeafScript> {
  @override
  TapLeafScript Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(TapLeafScript data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<TapLeafScript> array,
    TapLeafScript item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  TapLeafScriptConverter(
      {this.decode, this.encode, this.check, this.canAdd, this.canAddToArray});
}
