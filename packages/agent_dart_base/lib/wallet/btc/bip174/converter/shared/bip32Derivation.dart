import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';

List<int> range(int n) => List<int>.generate(n, (i) => i);

bool isValidDERKey(Uint8List pubkey) =>
    (pubkey.length == 33 && [2, 3].contains(pubkey[0])) ||
    (pubkey.length == 65 && 4 == pubkey[0]);

typedef IsValidDerKey = bool Function(Uint8List pubkey);

Bip32Converter makeConverter(int typeByte,
    [IsValidDerKey isValidPubkey = isValidDERKey]) {
  decode(KeyValue keyVal) {
    if (keyVal.key[0] != typeByte) {
      throw Exception(
        'Decode Error: could not decode bip32Derivation with key 0x${keyVal.key}',
      );
    }
    final pubkey = keyVal.key.sublist(1);
    if (!isValidPubkey(pubkey)) {
      throw Exception(
        'Decode Error: bip32Derivation has invalid pubkey in key 0x${keyVal.key}',
      );
    }
    if (keyVal.value.length != 4) {
      throw Exception(
        'Decode Error: bip32Derivation value length should be 4',
      );
    }
    return Bip32Derivation(
      pubkey: pubkey,
      masterFingerprint: keyVal.value.sublist(0, 4),
      path: 'm',
    );
  }

  KeyValue encode(Bip32Derivation data) {
    final head = [typeByte];
    final key = Uint8List.fromList(head + data.pubkey);
    final splitPath = data.path.split('/');
    final value = Uint8List(4);
    data.masterFingerprint.setRange(0, 4, value);
    var offset = 4;
    splitPath.sublist(1).forEach((level) {
      final isHard = level.substring(level.length - 1) == "'";
      var num = 0x7fffffff &
          int.parse(isHard ? level.substring(0, level.length - 1) : level);
      if (isHard) num += 0x80000000;
      value[offset] = num;
      offset += 4;
    });
    return KeyValue(key: key, value: value);
  }

  // export const expected =
  //   '{ pubkey: Buffer; masterFingerprint: Buffer; path: string; }';

  bool check(dynamic data) {
    return data is Bip32Derivation;
  }

  bool canAddToArray(
    List<Bip32Derivation> array,
    Bip32Derivation item,
    Set<String> dupeSet,
  ) {
    return !dupeSet.contains(item.pubkey.toHex());
  }

  return Bip32Converter(
    decode: decode,
    encode: encode,
    check: check,
    canAddToArray: canAddToArray,
  );
}

class Bip32Converter implements BaseConverter<Bip32Derivation> {
  @override
  Bip32Derivation Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(Bip32Derivation data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected =
      '{ masterFingerprint: Uint8List; pubkey: Uint8List; path: String; }';
  @override
  bool Function(
    List<Bip32Derivation> array,
    Bip32Derivation item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  Bip32Converter({
    this.decode,
    this.encode,
    this.check,
    this.canAddToArray,
  });
}
