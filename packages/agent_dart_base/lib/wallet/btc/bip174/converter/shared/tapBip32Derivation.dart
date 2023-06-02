import 'dart:typed_data';

import 'package:agent_dart_base/utils/u8a.dart';

import '../../interfaces.dart';
import '../../varint.dart' as varuint;
import './bip32Derivation.dart' as bip32Derivation;

bool isValidBIP340Key(Uint8List pubkey) => pubkey.length == 32;

TapBip32Converter makeConverter(
  int typeByte,
) {
  final parent = bip32Derivation.makeConverter(typeByte, isValidBIP340Key);

  TapBip32Derivation decode(KeyValue keyVal) {
    final nHashes = varuint.decode(keyVal.value, null);
    final nHashesLen = varuint.encodingLength(nHashes);
    final base = parent.decode!(KeyValue(
      key: keyVal.key,
      value: keyVal.value.sublist(nHashesLen + nHashes * 32),
    ));
    final leafHashes = <Uint8List>[];
    for (var i = 0, _offset = nHashesLen; i < nHashes; i++, _offset += 32) {
      leafHashes.add(keyVal.value.sublist(_offset, _offset + 32));
    }

    return TapBip32Derivation(
      leafHashes: leafHashes,
      masterFingerprint: base.masterFingerprint,
      path: base.path,
      pubkey: base.pubkey,
    );
  }

  KeyValue encode(TapBip32Derivation data) {
    final base = parent.encode!(Bip32Derivation(
      masterFingerprint: data.masterFingerprint,
      path: data.path,
      pubkey: data.pubkey,
    ));
    final nHashesLen = varuint.encodingLength(data.leafHashes.length);
    final nHashesBuf = Uint8List(nHashesLen);
    varuint.encode(data.leafHashes.length, nHashesBuf, null);
    final value = Uint8List.fromList(
        [...nHashesBuf, ...u8aConcat(data.leafHashes), ...base.value]);
    return KeyValue(key: base.key, value: value);
  }

  bool check(dynamic data) {
    return (data.leafHashes is Uint8List &&
        data.leafHashes.every(
          (dynamic leafHash) => leafHash is Uint8List && leafHash.length == 32,
        ) &&
        parent.check!(data));
  }

  return TapBip32Converter(
    decode: decode,
    encode: encode,
    check: check,
    canAddToArray: parent.canAddToArray,
  );
}

class TapBip32Converter implements BaseConverter<TapBip32Derivation> {
  @override
  TapBip32Derivation Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(TapBip32Derivation data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected =
      '{ masterFingerprint: Uint8List; pubkey: Uint8List; path: String; leafHashes: List<Uint8List>; }';
  @override
  bool Function(
    List<TapBip32Derivation> array,
    TapBip32Derivation item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  TapBip32Converter({
    this.decode,
    this.encode,
    this.check,
    this.canAddToArray,
  });
}
