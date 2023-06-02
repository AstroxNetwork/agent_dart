import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../types.dart';
import 'dart:typed_data';

FinalScriptWitness decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.FINAL_SCRIPTWITNESS.index) {
    throw Exception(
      'Decode Error: could not decode finalScriptWitness with key 0x${keyVal.key.toHex()}',
    );
  }
  return keyVal.value;
}

KeyValue encode(FinalScriptWitness data) {
  return KeyValue(
      key: Uint8List.fromList([InputTypes.FINAL_SCRIPTWITNESS.index]),
      value: data);
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return data is Uint8List;
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.FinalScriptWitness == null;
}

final finalScriptWitnessConverter = FinalScriptWitnessConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class FinalScriptWitnessConverter implements BaseConverter<FinalScriptWitness> {
  @override
  FinalScriptWitness Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(FinalScriptWitness data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<FinalScriptWitness> array,
    FinalScriptWitness item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  FinalScriptWitnessConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
