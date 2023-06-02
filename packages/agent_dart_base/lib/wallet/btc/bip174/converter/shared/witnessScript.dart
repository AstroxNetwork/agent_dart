import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';

WitnessScriptConverter makeConverter(
  int typeByte,
) {
  WitnessScript decode(KeyValue keyVal) {
    if (keyVal.key[0] != typeByte) {
      throw Exception(
          'Decode Error: could not decode witnessScript with key 0x${keyVal.key.toHex()}');
    }

    return keyVal.value;
  }

  KeyValue encode(WitnessScript data) {
    return KeyValue(key: Uint8List.fromList([typeByte]), value: data);
  }

  bool check(dynamic data) {
    return data is Uint8List;
  }

  bool canAdd(dynamic currentData, dynamic newData) {
    return !!currentData && !!newData && currentData.witnessScript == null;
  }

  return WitnessScriptConverter(
    decode: decode,
    encode: encode,
    check: check,
    canAdd: canAdd,
  );
}

class WitnessScriptConverter implements BaseConverter<WitnessScript> {
  @override
  WitnessScript Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(WitnessScript data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<WitnessScript> array,
    WitnessScript item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  WitnessScriptConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
