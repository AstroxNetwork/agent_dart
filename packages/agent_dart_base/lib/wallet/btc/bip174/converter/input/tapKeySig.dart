import 'package:agent_dart_base/utils/extension.dart';
import 'package:agent_dart_base/wallet/btc/bip174/converter/global/globalXpub.dart';

import '../../interfaces.dart';
import '../../types.dart';
import 'dart:typed_data';

TapKeySig decode(KeyValue keyVal) {
  if (keyVal.key[0] != InputTypes.TAP_KEY_SIG.index || keyVal.key.length != 1) {
    throw Exception(
      'Decode Error: could not decode tapSigKey with key 0x${keyVal.key.toHex()}',
    );
  }
  if (!check(keyVal.value)) {
    throw Exception(
      'Decode Error: tapKeySig not a valid 64-65-byte BIP340 signature',
    );
  }
  return keyVal.value;
}

KeyValue encode(TapKeySig data) {
  return KeyValue(
      key: Uint8List.fromList([InputTypes.TAP_KEY_SIG.index]), value: data);
}

// const expected = 'Buffer';

bool check(dynamic data) {
  return data is Uint8List && (data.length == 64 || data.length == 65);
}

bool canAdd(dynamic currentData, dynamic newData) {
  return !!currentData && !!newData && currentData.tapKeySig == null;
}

final tapKeySigConverter = TapKeySigConverter(
  decode: decode,
  encode: encode,
  check: check,
  canAdd: canAdd,
);

class TapKeySigConverter implements BaseConverter<TapKeySig> {
  @override
  TapKeySig Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(TapKeySig data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<TapKeySig> array,
    TapKeySig item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  TapKeySigConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAdd,
  });
}
