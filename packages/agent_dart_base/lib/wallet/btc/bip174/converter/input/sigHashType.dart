import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../tool.dart';
import '../../types.dart';
import 'dart:typed_data';

SighashType decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.SIGHASH_TYPE.index) {
    throw Exception(
      'Decode Error: could not decode sighashType with key 0x${keyVal.key.toHex()}',
    );
  }
  return readUInt32LE(keyVal.value, 0);
}

KeyValue encode(SighashType data) {
  var value = Uint8List(4);
  writeUInt32LE(value, data, 0);
  return KeyValue(
      key: Uint8List.fromList([InputTypes.POR_COMMITMENT.index]), value: value);
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return data is int;
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.sighashType == null;
}

final sighashTypeConverter = SighashTypeConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class SighashTypeConverter implements BaseConverter<SighashType> {
  @override
  SighashType Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(SighashType data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<SighashType> array,
    SighashType item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  SighashTypeConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
