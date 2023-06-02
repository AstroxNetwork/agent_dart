import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';

RedeemConverter makeConverter(int TYPE_BYTE) {
  RedeemScript decode(KeyValue keyVal) {
    if (keyVal.key[0] != TYPE_BYTE) {
      throw Exception(
        'Decode Error: could not decode redeemScript with key 0x${keyVal.key.toHex()}',
      );
    }
    return keyVal.value;
  }

  KeyValue encode(RedeemScript data) {
    return KeyValue(key: Uint8List.fromList([TYPE_BYTE]), value: data);
  }

  const expected = 'Uint8List';
  bool check(dynamic data) {
    return data is Uint8List;
  }

  bool canAdd(dynamic currentData, dynamic newData) {
    return !!currentData && !!newData && currentData.redeemScript == null;
  }

  return RedeemConverter(
      decode: decode, encode: encode, check: check, canAdd: canAdd);
}

class RedeemConverter implements BaseConverter<RedeemScript> {
  @override
  RedeemScript Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(RedeemScript data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  @override
  bool Function(
    List<RedeemScript> array,
    RedeemScript item,
    Set<String> dupeSet,
  )? canAddToArray;
  RedeemConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
