import 'dart:typed_data';
import 'dart:convert';
import 'utils/base32.dart';
import 'utils/get_crc.dart';
import 'utils/sha224.dart';

// ignore: constant_identifier_names
const SELF_AUTHENTICATING_SUFFIX = 2;
// ignore: constant_identifier_names
const ANONYMOUS_SUFFIX = 4;

Uint8List fromHexString(String hexString) =>
    Uint8List.fromList((RegExp(r'.{1,2}').allMatches(hexString).toList()).map<int>((byte) {
      return int.parse(byte.group(0)!, radix: 16);
    }).toList());

String toHexString(Uint8List bytes) =>
    bytes.fold<String>('', (str, byte) => str + byte.toRadixString(16).padLeft(2, '0'));

class Principal {
  static Principal anonymous() {
    var u8a = Uint8List.fromList([ANONYMOUS_SUFFIX]);
    return Principal(u8a);
  }

  static Principal selfAuthenticating(Uint8List publicKey) {
    var sha = sha224Hash(publicKey.buffer);
    var u8a = Uint8List.fromList([...sha, SELF_AUTHENTICATING_SUFFIX]);
    return Principal(u8a);
  }

  static Principal from(dynamic other) {
    if (other is String) {
      return Principal.fromText(other);
    } else if (other is Map<String, dynamic> && other['_isPrincipal'] == true) {
      return Principal(other['_arr']);
    }

    throw 'Impossible to convert ${jsonEncode(other)} to Principal.';
  }

  static Principal fromHex(String hex) {
    return Principal(fromHexString(hex));
  }

  static Principal fromText(String text) {
    try {
      final canisterIdNoDash = text.toLowerCase().replaceAll('-', '');

      var arr = decode(canisterIdNoDash);
      arr = arr.sublist(4, arr.length);

      final principal = Principal(arr);

      if (principal.toText() != text) {
        throw 'Principal "${principal.toText()}" does not have a valid checksum.';
      }

      return principal;
    } catch (e) {
      rethrow;
    }
  }

  static Principal fromUint8Array(Uint8List arr) {
    return Principal(arr);
  }

  // ignore: unused_field
  final bool _isPrincipal = true;

  final Uint8List _arr;
  Principal(this._arr);

  bool isAnonymous() {
    return _arr.lengthInBytes == 1 && _arr[0] == ANONYMOUS_SUFFIX;
  }

  Uint8List toUint8Array() {
    return _arr;
  }

  String toHex() {
    return toHexString(_arr).toUpperCase();
  }

  String toText() {
    final checksumArrayBuf = ByteData(4);

    checksumArrayBuf.setUint32(0, getCrc32(_arr.buffer));

    final checksum = checksumArrayBuf.buffer.asUint8List();

    final bytes = Uint8List.fromList(_arr);
    final array = Uint8List.fromList([...checksum, ...bytes]);

    final result = encode(array);
    var reg = RegExp(r".{1,5}");
    final matches = reg.allMatches(result);
    if (matches.isEmpty) {
      // This should only happen if there's no character, which is unreachable.
      throw "no character found";
    }
    return matches.map((e) => e.group(0)).join('-');
  }

  @override
  String toString() {
    return toText();
  }

  String toJson() {
    return toText();
  }
}
