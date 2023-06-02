import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../types.dart';
import 'dart:typed_data';

PorCommitment decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.POR_COMMITMENT.index) {
    throw Exception(
      'Decode Error: could not decode nonWitnessUtxo with key 0x${keyVal.key.toHex()}',
    );
  }
  return keyVal.value.u8aToString();
}

KeyValue encode(PorCommitment data) {
  return KeyValue(
      key: Uint8List.fromList([InputTypes.POR_COMMITMENT.index]),
      value: data.plainToU8a());
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return data is String;
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.porCommitment == null;
}

final porCommitmentConverter = PorCommitmentConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class PorCommitmentConverter implements BaseConverter<PorCommitment> {
  @override
  PorCommitment Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(PorCommitment data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<PorCommitment> array,
    PorCommitment item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  PorCommitmentConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
