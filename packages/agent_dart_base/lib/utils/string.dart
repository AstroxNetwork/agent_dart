import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';

import 'number.dart';

String strip0xHex(String hex) {
  if (hex.startsWith('0x')) {
    return hex.substring(2);
  }
  return hex;
}

Uint8List stringToU8a(String msg, {String? enc, bool useDartEncode = true}) {
  if (useDartEncode == false) {
    if (enc == 'hex') {
      msg = strip0xHex(msg);
      final List<int> hexRes = [];
      msg = msg.replaceAll(RegExp('[^a-z0-9]'), '');
      if (msg.length % 2 != 0) msg = '0$msg';
      for (int i = 0; i < msg.length; i += 2) {
        final cul = msg[i] + msg[i + 1];
        final result = int.parse(cul, radix: 16);
        hexRes.add(result);
      }
      return Uint8List.fromList(hexRes);
    } else {
      final List<int> noHexRes = [];
      for (int i = 0; i < msg.length; i++) {
        final c = msg.codeUnitAt(i);
        final hi = c >> 8;
        final lo = c & 0xff;
        if (hi > 0) {
          noHexRes.add(hi);
        }
        noHexRes.add(lo);
      }
      return Uint8List.fromList(noHexRes);
    }
  } else {
    return Uint8List.fromList(utf8.encode(msg));
  }
}

Uint8List textEncoder(String value) {
  final u8a = Uint8List(value.length);
  for (int i = 0; i < value.length; i++) {
    u8a[i] = value.codeUnitAt(i);
  }
  return u8a;
}

String textDecoder(Uint8List value) {
  return value.fold('', (p, e) => p += String.fromCharCode(e));
}

String plainTextToHex(String plainText) {
  final u8a = stringToU8a(plainText);
  return bytesToHex(u8a);
}

String hexToPlainText(String hex) {
  return utf8.decode(stringToU8a(hex, enc: 'hex'));
}

/// Converts the hexadecimal string, which can be prefixed with 0x,
/// to a byte sequence.
List<int> hexToBytes(String hexStr) {
  return hex.decode(strip0xHex(hexStr));
}

String stringShorten(String value, {int prefixLength = 6}) {
  if (value.length <= 2 + 2 * prefixLength) {
    return value.toString();
  }
  final tLength = value.length;
  final secStart = value.length - prefixLength;
  final firstPart = value.substring(0, prefixLength);
  final secondPart = value.substring(secStart, tLength);
  return '$firstPart…$secondPart';
}
