import '../../interfaces.dart';
import '../../tool.dart';
import '../../types.dart';
import 'dart:typed_data';

GlobalXpub decode(KeyValue keyVal) {
  if (keyVal.key[0] != GlobalTypes.GLOBAL_XPUB) {
    throw Exception(
      'Decode Error: could not decode globalXpub with key 0x${keyVal.key}',
    );
  }
  if (keyVal.key.length != 79 || ![2, 3].contains(keyVal.key[46])) {
    throw Exception(
      'Decode Error: globalXpub has invalid extended pubkey in key 0x${keyVal.key}',
    );
  }
  if ((keyVal.value.length / 4) % 1 != 0) {
    throw Exception(
      'Decode Error: Global GLOBAL_XPUB value length should be multiple of 4',
    );
  }
  final extendedPubkey = keyVal.key.sublist(1);
  final data = GlobalXpub(
    masterFingerprint: keyVal.value.sublist(0, 4),
    extendedPubkey: extendedPubkey,
    path: 'm',
  );
  for (final i in range(keyVal.value.length ~/ 4 - 1)) {
    final val = readUInt32LE(keyVal.value, i * 4 + 4);
    final isHard = (val & 0x80000000) != 0;
    final idx = val & 0x7fffffff;
    data.path = '${data.path}/${idx.toString()}${isHard ? "'" : ''}';
  }
  return data;
}

KeyValue encode(GlobalXpub data) {
  final head = [GlobalTypes.GLOBAL_XPUB.index];
  final key = Uint8List.fromList(head + data.extendedPubkey);
  final splitPath = data.path.split('/');
  final value = Uint8List(splitPath.length * 4);
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
//   '{ masterFingerprint: Buffer; extendedPubkey: Buffer; path: string; }';

bool check(dynamic data) {
  if (data is! GlobalXpub) {
    throw Exception(
      'Check Error: Global GLOBAL_XPUB expected type GlobalXpub',
    );
  }
  if (data.extendedPubkey.length != 78) {
    throw Exception(
      'Check Error: Global GLOBAL_XPUB extendedPubkey must be 78 bytes',
    );
  }
  if (![2, 3].contains(data.extendedPubkey[45])) {
    throw Exception(
      'Check Error: Global GLOBAL_XPUB extendedPubkey must be a public key',
    );
  }
  if (data.masterFingerprint.length != 4) {
    throw Exception(
      'Check Error: Global GLOBAL_XPUB masterFingerprint must be 4 bytes',
    );
  }
  if (!data.path.startsWith('m/')) {
    throw Exception(
      'Check Error: Global GLOBAL_XPUB path must start with m/',
    );
  }
  if (RegExp(r'^m(\/\d+\?)*$').hasMatch(data.path)) {
    throw Exception(
      'Check Error: Global GLOBAL_XPUB path must follow BIP 32 path format',
    );
  }
  return true;
}

bool canAddToArray(
    List<GlobalXpub> array, GlobalXpub item, Set<String> dupeSet) {
  final dupeString = item.extendedPubkey.toString();
  if (dupeSet.contains(dupeString)) return false;
  dupeSet.add(dupeString);
  return array.where((v) => v.extendedPubkey == item.extendedPubkey).isEmpty;
}

final globalXpubConverter = GlobalXpubConverter(
    decode: decode, encode: encode, check: check, canAddToArray: canAddToArray);

class GlobalXpubConverter implements BaseConverter<GlobalXpub> {
  @override
  GlobalXpub Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(GlobalXpub data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<GlobalXpub> array,
    GlobalXpub item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  GlobalXpubConverter(
      {this.decode, this.encode, this.check, this.canAddToArray});
}
