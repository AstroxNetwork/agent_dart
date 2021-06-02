import 'dart:convert';
import 'dart:typed_data';

String u8aToString(Uint8List u8a, {bool useDartEncode = false}) {
  if (useDartEncode) {
    return utf8.decode(u8a, allowMalformed: true);
  }
  return textDecoder(u8a);
}

Uint8List textEncoder(String value) {
  final u8a = Uint8List(value.length);
  for (var i = 0; i < value.length; i++) {
    u8a[i] = value.codeUnitAt(i);
  }
  return u8a;
}

String textDecoder(Uint8List value) {
  var _value = '';
  for (var i = 0; i < value.length; i += 1) {
    _value = _value + String.fromCharCode(value[i]);
  }
  return _value;
}

String strip0xHex(String hex) {
  if (hex.startsWith('0x', 0)) return hex.substring(2);
  return hex;
}

Uint8List stringToU8a(String msg, {String? enc, bool useDartEncode = true}) {
  if (useDartEncode == false) {
    if (enc == 'hex') {
      msg = strip0xHex(msg);
      List<int> hexRes = List.from([]);
      msg = msg.replaceAll(RegExp("[^a-z0-9]"), '');
      if (msg.length % 2 != 0) msg = '0' + msg;
      for (var i = 0; i < msg.length; i += 2) {
        var cul = msg[i] + msg[i + 1];
        var result = int.parse(cul, radix: 16);
        hexRes.add(result);
      }
      return Uint8List.fromList(hexRes);
    } else {
      List<int> noHexRes = List.from([]);
      for (var i = 0; i < msg.length; i++) {
        var c = msg.codeUnitAt(i);
        var hi = c >> 8;
        var lo = c & 0xff;
        if (hi > 0) {
          noHexRes.add(hi);
          noHexRes.add(lo);
        } else {
          noHexRes.add(lo);
        }
      }

      return Uint8List.fromList(noHexRes);
    }
  } else {
    return Uint8List.fromList(utf8.encode(msg));
  }
}

extension U8aExtension on Uint8List {
  String toUtf8String({bool useDartEncode = true}) =>
      u8aToString(this, useDartEncode: useDartEncode);
}

extension StringExtension on String {
  Uint8List plainToU8a({String? enc, bool useDartEncode = false}) =>
      stringToU8a(this, enc: enc, useDartEncode: useDartEncode);
}
