import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:convert/convert.dart';

import 'is.dart';
import 'number.dart';
import 'string.dart';
import 'u8a.dart';

bool hexHasPrefix(String value) {
  return isHex(value, -1, true) && value.substring(0, 2) == '0x';
}

String hexStripPrefix(String value) {
  if (value.isEmpty) {
    return '';
  }
  if (hexHasPrefix(value)) {
    return value.substring(2);
  }
  final reg = RegExp(r'^[a-fA-F\d]+$');
  if (reg.hasMatch(value)) {
    return value;
  }
  throw FallThroughError();
}

BigInt hexToBn(
  dynamic value, {
  Endian endian = Endian.big,
  bool isNegative = false,
}) {
  if (value == null) return BigInt.from(0);
  if (isNegative == false) {
    if (isHex(value)) {
      final sValue = value is num
          ? int.parse(value.toString(), radix: 10).toRadixString(16)
          : value;
      if (endian == Endian.big) {
        return BigInt.parse(
          hexStripPrefix(sValue) == '' ? '0' : hexStripPrefix(sValue),
          radix: 16,
        );
      } else {
        return decodeBigInt(
          hexToBytes(
            hexStripPrefix(sValue) == '' ? '0' : hexStripPrefix(sValue),
          ),
        );
      }
    }
    final sValue = value is num
        ? int.parse(value.toString(), radix: 10).toRadixString(16)
        : value;
    if (endian == Endian.big) {
      return BigInt.parse(sValue, radix: 16);
    }
    return decodeBigInt(
      hexToBytes(
        hexStripPrefix(sValue) == '' ? '0' : hexStripPrefix(sValue),
      ),
    );
  } else {
    String hex = value is num
        ? int.parse(value.toString(), radix: 10).toRadixString(16)
        : hexStripPrefix(value);
    if (hex.length % 2 > 0) {
      hex = '0$hex';
    }
    hex = decodeBigInt(
      hexToBytes(hexStripPrefix(hex) == '' ? '0' : hexStripPrefix(hex)),
      endian: endian,
    ).toRadixString(16);
    BigInt bn = BigInt.parse(hex, radix: 16);

    final result = 0x80 &
        int.parse(hex.substring(0, 2 > hex.length ? hex.length : 2), radix: 16);
    if (result > 0) {
      BigInt some = BigInt.parse(
        bn.toRadixString(2).split('').map((i) {
          return '0' == i ? 1 : 0;
        }).join(),
        radix: 2,
      );
      some += BigInt.one;
      bn = -some;
    }
    return bn;
  }
}

int? hexToNumber(dynamic value) {
  return value != null ? hexToBn(value).toInt() : null;
}

/// [value] should be `0x` hex string.
Uint8List hexToU8a(String value, [int bitLength = -1]) {
  if (!isHex(value) && !isHexString(value)) {
    throw ArgumentError.value(value, '$value is not a valid hex string');
  }
  final newValue = hexStripPrefix(value);
  final valLength = newValue.length / 2;
  final bufLength = (bitLength == -1 ? valLength : bitLength / 8).ceil();
  final result = Uint8List(bufLength);
  final offset = math.max(0, bufLength - valLength).toInt();
  for (int index = 0; index < bufLength - offset; index++) {
    final subStart = index * 2;
    final subEnd =
        subStart + 2 <= newValue.length ? subStart + 2 : newValue.length;
    final arrIndex = index + offset;
    result[arrIndex] = int.parse(
      newValue.substring(subStart, subEnd),
      radix: 16,
    );
  }
  return result;
}

Uint8List hexToU8aStream(String value) {
  final newValue = hexStripPrefix(value);
  final results = Uint8List((newValue.length / 2).ceil());
  final controller = StreamController<List<int>>(sync: true);
  controller.stream.listen((data) {
    results.setAll(0, data);
  });
  final sink = hex.decoder.startChunkedConversion(controller.sink);
  sink.add(newValue);
  return results;
}

String hexToString(String value) {
  return u8aToString(hexToU8a(value));
}

String hexAddPrefix(String? value) {
  if (value != null && hexHasPrefix(value)) {
    return value;
  }
  final prefix = (value != null && value.length % 2 == 1) ? '0' : '';
  return "0x$prefix${value ?? ''}";
}

String hexFixLength(
  String value, [
  int bitLength = -1,
  bool withPadding = false,
]) {
  final strLength = (bitLength / 4).ceil();
  final hexLength = strLength + 2;
  String beforeAdd;
  if (bitLength == -1 ||
      value.length == hexLength ||
      (!withPadding && value.length < hexLength)) {
    beforeAdd = hexStripPrefix(value);
  } else {
    if (value.length > hexLength) {
      final stripped = hexStripPrefix(value);
      beforeAdd = stripped.substring(stripped.length - 1 * strLength);
    } else {
      final stripped2 = "${'0' * strLength}${hexStripPrefix(value)}";
      beforeAdd = stripped2.substring(stripped2.length - 1 * strLength);
    }
  }
  return hexAddPrefix(beforeAdd);
}
