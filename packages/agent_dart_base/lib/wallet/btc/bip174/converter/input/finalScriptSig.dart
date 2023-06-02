import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../types.dart';
import 'dart:typed_data';

FinalScriptSig decode(KeyValue keyVal) {
  if (keyVal.key[0] != GlobalTypes.UNSIGNED_TX.index) {
    throw Exception(
      'Decode Error: could not decode globalXpub with key 0x${keyVal.key.toHex()}',
    );
  }
  return keyVal.value;
}

KeyValue encode(FinalScriptSig data) {
  return KeyValue(
      key: Uint8List.fromList([GlobalTypes.UNSIGNED_TX.index]), value: data);
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return data is Uint8List;
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.finalScriptSig == null;
}

final finalScriptSigConverter = FinalScriptSigConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class FinalScriptSigConverter implements BaseConverter<FinalScriptSig> {
  @override
  FinalScriptSig Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(FinalScriptSig data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<FinalScriptSig> array,
    FinalScriptSig item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  FinalScriptSigConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
