import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';
import '../../types.dart';
import 'dart:typed_data';

PartialSig decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.PARTIAL_SIG.index) {
    throw Exception(
      'Decode Error: could not decode nonWitnessUtxo with key 0x${keyVal.key.toHex()}',
    );
  }
  if (!(keyVal.key.length == 34 || keyVal.key.length == 66) ||
      ![2, 3, 4].contains(keyVal.key[1])) {
    throw Exception(
      ('Decode Error: partialSig has invalid pubkey in key 0x${keyVal.key.toHex()}'),
    );
  }
  final pubkey = keyVal.key.sublist(1);
  return PartialSig(pubkey: pubkey, signature: keyVal.value);
}

KeyValue encode(PartialSig data) {
  return KeyValue(
      key: Uint8List.fromList([InputTypes.PARTIAL_SIG.index]),
      value: data.signature);
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return (data.pubkey is Uint8List &&
      data.signature is Uint8List &&
      [33, 65].contains(data.pubkey.length) &&
      [2, 3, 4].contains(data.pubkey[0]) &&
      isDerSigWithSighash(data.signature));
}

bool isDerSigWithSighash(Uint8List buf) {
  if (buf.length < 9) return false;
  if (buf[0] != 0x30) return false;
  if (buf.length != buf[1] + 3) return false;
  if (buf[2] != 0x02) return false;
  final rLen = buf[3];
  if (rLen > 33 || rLen < 1) return false;
  if (buf[3 + rLen + 1] != 0x02) return false;
  final sLen = buf[3 + rLen + 2];
  if (sLen > 33 || sLen < 1) return false;
  if (buf.length != 3 + rLen + 2 + sLen + 2) return false;
  return true;
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.nonWitnessUtxo == null;
}

bool canAddToArray(
  List<PartialSig> array,
  PartialSig item,
  Set<String> dupeSet,
) {
  final dupeString = item.pubkey.toHex();
  if (dupeSet.contains(dupeString)) return false;
  dupeSet.add(dupeString);
  return array.where((v) => v.pubkey == (item.pubkey)).isEmpty;
}

final partialSigConverter = PartialSigConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class PartialSigConverter implements BaseConverter<PartialSig> {
  @override
  PartialSig Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(PartialSig data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<PartialSig> array,
    PartialSig item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  PartialSigConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
