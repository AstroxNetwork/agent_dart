import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../tool.dart';
import '../../types.dart';
import '../../varint.dart' as varuint;
import 'dart:typed_data';

WitnessUtxo decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.WITNESS_UTXO.index) {
    throw Exception(
      'Decode Error: could not decode witnessUtxo with key 0x${keyVal.key.toHex()}',
    );
  }
  final value = readUInt64LE(keyVal.value, 0);
  var offset = 8;
  final scriptLen = varuint.decode(keyVal.value, offset);
  offset += varuint.encodingLength(scriptLen);
  final script = keyVal.value.sublist(offset);
  if (script.length != scriptLen) {
    throw Exception('Decode Error: WITNESS_UTXO script is not proper length');
  }
  return WitnessUtxo(script: script, value: value);
}

KeyValue encode(WitnessUtxo data) {
  final varintLen = varuint.encodingLength(data.script.length);
  final result = Uint8List(8 + varintLen + data.script.length);

  writeUInt64LE(result, data.value, 0);
  varuint.encode(data.script.length, result, 8);

  copy(data.script, result, 8 + varintLen, 0, data.script.length);

  return KeyValue(
    key: Uint8List.fromList([InputTypes.WITNESS_UTXO.index]),
    value: result,
  );
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return data.script is Uint8List && data.value is int;
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.witnessUtxo == null;
}

void copy(Uint8List source, Uint8List target, int targetStart, int sourceStart,
    int sourceEnd) {
  target.setRange(targetStart, targetStart + (sourceEnd - sourceStart),
      source.sublist(sourceStart, sourceEnd));
}

final witnessUtxoConverter = WitnessUtxoConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class WitnessUtxoConverter implements BaseConverter<WitnessUtxo> {
  @override
  WitnessUtxo Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(WitnessUtxo data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<WitnessUtxo> array,
    WitnessUtxo item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  WitnessUtxoConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
