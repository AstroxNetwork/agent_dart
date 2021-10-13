import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';

import 'is.dart';
import 'number.dart';
import 'string.dart';
import 'u8a.dart';

bool hexHasPrefix(String value) {
  return !!(value is String &&
      isHex(value, -1, true) &&
      value.substring(0, 2) == '0x');
}

String hexStripPrefix(String value) {
  if (isNull(value)) {
    return '';
  }
  if (hexHasPrefix(value)) {
    return value.substring(2);
  }
  var reg = RegExp(r"^[a-fA-F0-9]+$");

  if (reg.allMatches(value).isNotEmpty) {
    return value;
  }
  throw "Invalid hex $value passed to hexStripPrefix";
}

BigInt hexToBn(dynamic value,
    {Endian endian = Endian.big, bool isNegative = false}) {
  try {
    if (value == null) return BigInt.from(0);
    if (isNegative == false) {
      if (isHex(value)) {
        var sValue = value is num
            ? int.parse(value.toString(), radix: 10).toRadixString(16)
            : value;
        if (endian == Endian.big) {
          return BigInt.parse(
              hexStripPrefix(sValue) == '' ? '0' : hexStripPrefix(sValue),
              radix: 16);
        } else {
          return decodeBigInt(hexToBytes(
              hexStripPrefix(sValue) == '' ? '0' : hexStripPrefix(sValue)));
        }
      }
      var _sValue = value is num
          ? int.parse(value.toString(), radix: 10).toRadixString(16)
          : value;
      if (endian == Endian.big) {
        return BigInt.parse(_sValue, radix: 16);
      } else {
        return decodeBigInt(hexToBytes(
            hexStripPrefix(_sValue) == '' ? '0' : hexStripPrefix(_sValue)));
      }
    } else {
      var hex = value is num
          ? int.parse(value.toString(), radix: 10).toRadixString(16)
          : hexStripPrefix(value);
      if (hex.length % 2 > 0) {
        hex = '0' + hex;
      }
      hex = decodeBigInt(
              hexToBytes(hexStripPrefix(hex) == '' ? '0' : hexStripPrefix(hex)),
              endian: endian)
          .toRadixString(16);
      var bn = BigInt.parse(hex, radix: 16);

      if ((0x80 &
              int.parse(hex.substring(0, 2 > hex.length ? hex.length : 2),
                  radix: 16)) >
          0) {
        var some = BigInt.parse(
                bn.toRadixString(2).split('').map((i) {
                  return '0' == i ? 1 : 0;
                }).join(''),
                radix: 2) +
            BigInt.one;
        // print(some);
        // add the sign character to output string (bytes are unaffected)
        bn = -some;
      }
      return bn;
    }

    // return value is String ? BigInt.parse(value, radix: 16) : BigInt.from(value as num);
  } catch (e) {
    throw "Error: can not parse $value to BigInt";
  }
}

int? hexToNumber(dynamic value) {
  try {
    return value != null ? hexToBn(value).toInt() : null;
  } catch (e) {
    rethrow;
  }
}

/// value sholud be `0x` hex
Uint8List hexToU8a(String value, [int bitLength = -1]) {
  try {
    if (!isHex(value) && !isHexString(value)) {
      throw 'Error: Expected hex value to convert, found $value';
    }
    var _value = hexStripPrefix(value);
    var valLength = _value.length / 2;
    var bufLength = (bitLength == -1 ? valLength : bitLength / 8).ceil();

    var result = Uint8List(bufLength);
    var offset = max(0, bufLength - valLength).toInt();

    for (var index = 0; index < bufLength - offset; index++) {
      var subStart = index * 2;
      var subEnd = subStart + 2 <= _value.length ? subStart + 2 : _value.length;
      var arrIndex = index + offset;
      result[arrIndex] =
          int.tryParse(_value.substring(subStart, subEnd), radix: 16)!;
    }
    return result;
  } catch (e) {
    throw "Error: hexToU8a $e";
  }
}

Uint8List hexToU8aStream(String value) {
  var _value = hexStripPrefix(value);
  Uint8List results = Uint8List((_value.length / 2).ceil());
  // ignore: prefer_typing_uninitialized_variables
  var sink;
  // ignore: close_sinks
  var controller = StreamController<List<int>>(sync: true);
  controller.stream.listen((data) {
    results.setAll(0, data);
  });
  sink = hex.decoder.startChunkedConversion(controller.sink);
  sink.add(_value);
  return results;
}

String hexToString(String value) {
  try {
    return u8aToString(hexToU8a(value));
  } catch (e) {
    rethrow;
  }
}

String hexAddPrefix(String? value) {
  if (value != null && hexHasPrefix(value)) {
    return value;
  }

  var prefix = (value != null && value.length % 2 == 1) ? '0' : '';

  return "0x$prefix${value ?? ''}";
}

String hexFixLength(String value,
    [int bitLength = -1, bool withPadding = false]) {
  var strLength = (bitLength / 4).ceil();
  var hexLength = strLength + 2;
  // ignore: prefer_typing_uninitialized_variables
  var beforeAdd;

  if ((bitLength == -1 ||
      value.length == hexLength ||
      (!withPadding && value.length < hexLength))) {
    beforeAdd = hexStripPrefix(value);
  } else {
    if ((value.length > hexLength)) {
      var stripped = hexStripPrefix(value);
      beforeAdd = stripped.substring(stripped.length - 1 * strLength);
    } else {
      var stripped2 = "${'0' * strLength}${hexStripPrefix(value)}";
      beforeAdd = stripped2.substring(stripped2.length - 1 * strLength);
    }
  }
  return hexAddPrefix(beforeAdd);
}
