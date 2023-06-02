import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';

import '../../interfaces.dart';

PubkeyConverter makeChecker(List<int> pubkeyTypes) {
  Uint8List decode(KeyValue keyVal) {
    Uint8List? pubkey;
    if (pubkeyTypes.contains(keyVal.key[0])) {
      pubkey = Uint8List.fromList(keyVal.key.sublist(1));
      if (!(pubkey.length == 33 || pubkey.length == 65) ||
          ![2, 3, 4].contains(pubkey[0])) {
        throw Exception(
            'Format Error: invalid pubkey in key 0x${keyVal.key.toHex()}');
      }
    }
    return pubkey!;
  }

  return PubkeyConverter(decode: decode);
}

class PubkeyConverter implements BaseConverter<Uint8List> {
  @override
  Uint8List Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(Uint8List data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected =
      '{ masterFingerprint: Uint8List; pubkey: Uint8List; path: String; }';
  @override
  bool Function(
    List<Uint8List> array,
    Uint8List item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  PubkeyConverter({
    this.decode,
  });
}
