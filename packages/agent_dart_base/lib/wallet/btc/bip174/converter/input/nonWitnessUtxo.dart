import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../types.dart';
import 'dart:typed_data';

NonWitnessUtxo decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.NON_WITNESS_UTXO.index) {
    throw Exception(
      'Decode Error: could not decode nonWitnessUtxo with key 0x${keyVal.key.toHex()}',
    );
  }
  return keyVal.value;
}

KeyValue encode(NonWitnessUtxo data) {
  return KeyValue(
      key: Uint8List.fromList([InputTypes.NON_WITNESS_UTXO.index]),
      value: data);
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return data is Uint8List;
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.nonWitnessUtxo == null;
}

final nonWitnessUtxoConverter = NonWitnessUtxoConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class NonWitnessUtxoConverter implements BaseConverter<NonWitnessUtxo> {
  @override
  NonWitnessUtxo Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(NonWitnessUtxo data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<NonWitnessUtxo> array,
    NonWitnessUtxo item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  NonWitnessUtxoConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
