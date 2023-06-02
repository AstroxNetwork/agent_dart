import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';

TapInternalKeyConverter makeConverter(
  int typeByte,
) {
  TapInternalKey decode(KeyValue keyVal) {
    if (keyVal.key[0] != typeByte || keyVal.key.length != 1) {
      throw Exception(
          'Decode Error: could not decode tapInternalKey with key 0x${keyVal.key.toHex()}');
    }
    if (keyVal.value.length != 32) {
      throw Exception(
          'Decode Error: tapInternalKey not a 32-byte x-only pubkey');
    }
    return keyVal.value;
  }

  KeyValue encode(TapInternalKey data) {
    return KeyValue(key: Uint8List.fromList([typeByte]), value: data);
  }

  bool check(dynamic data) {
    return data is Uint8List && data.length == 32;
  }

  bool canAdd(dynamic currentData, dynamic newData) {
    return !!currentData && !!newData && currentData.tapInternalKey == null;
  }

  return TapInternalKeyConverter(
    decode: decode,
    encode: encode,
    check: check,
    canAdd: canAdd,
  );
}

class TapInternalKeyConverter implements BaseConverter<TapInternalKey> {
  @override
  TapInternalKey Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(TapInternalKey data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<TapInternalKey> array,
    TapInternalKey item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  TapInternalKeyConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
