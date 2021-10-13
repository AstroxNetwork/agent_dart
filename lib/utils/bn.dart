import 'dart:typed_data';

import 'hex.dart';
import 'is.dart';
import 'number.dart';
import 'u8a.dart';

BigInt bnToBn(dynamic value) {
  try {
    if (value == null) {
      return BigInt.zero;
    }
    BigInt? result;
    if (value is BigInt) {
      return value;
    } else if (value is int) {
      return BigInt.from(value);
    } else if (isHex(value)) {
      return hexToBn(value.toString());
    } else if (value is Map<String, dynamic>) {
      return compactToBn(value);
    } else if (value is String && !isHex(value)) {
      result = BigInt.tryParse(value, radix: 10);
    }
    if (result != null) {
      return result;
    }
    throw "failed converting:'$value' to BigInt";
  } catch (e) {
    throw "$e";
  }
}

BigInt compactToBn(Map<String, dynamic> value) {
  var toBnTrue = value.containsKey("toBn") && isFunction(value['toBn']);
  var toBigIntTrue =
      value.containsKey("toBigInt") && isFunction(value['toBigInt']);
  if (toBnTrue && !toBigIntTrue) {
    return (value["toBn"] as Function).call();
  }
  if (!toBnTrue && toBigIntTrue) {
    return (value["toBigInt"] as Function).call();
  }

  throw "toBn or toBigInt function not found";
}

BigInt bitnot(BigInt bn, {int? bitLength}) {
  // JavaScript's bitwise not doesn't work on negative BigInts (bn = ~bn; // WRONG!)
  // so we manually implement our own two's compliment (flip bits, add one)
  bn = -bn;
  var bin = (bn).toRadixString(2).replaceAll("-", "");

  var prefix = '';
  while (bin.length % 8 != 0) {
    bin = '0' + bin;
  }

  if ('1' == bin[0] && bin.substring(1).contains('1')) {
    prefix = '1' * 8;
  }

  if (bitLength != null && bitLength > 0 && bitLength > bin.length) {
    prefix = '1' * (bitLength - bin.length);
  }

  bin = bin.split('').map((i) {
    return '0' == i ? '1' : '0';
  }).join('');

  return BigInt.parse(prefix + bin, radix: 2) + BigInt.one;
}

String bnToHex(BigInt bn,
    {int bitLength = -1, Endian endian = Endian.big, bool isNegative = false}) {
  var u8a =
      bnToU8a(bn, bitLength: bitLength, endian: endian, isNegative: isNegative);
  return u8aToHex(u8a, include0x: true);
}

class Options {
  int? bitLength;
  Endian? endian;
  bool? isNegative;
}

Uint8List bnToU8a(BigInt? value,
    {int bitLength = -1,
    Endian endian = Endian.little,
    bool isNegative = false}) {
  BigInt valueBn = bnToBn(value);
  int byteLength;
  if (bitLength == -1) {
    byteLength = (valueBn.bitLength / 8).ceil();
  } else {
    byteLength = ((bitLength) / 8).ceil();
  }

  if (value == null) {
    if (bitLength == -1) {
      return Uint8List.fromList([0]);
    } else {
      return Uint8List(byteLength);
    }
  }

  // print((0x80 & valueBn.toInt()) > 0);

  var newU8a = encodeBigInt(
      isNegative
          ? (0x80 & valueBn.toInt()) > 0
              ? bitnot(valueBn, bitLength: byteLength * 8)
              : valueBn
          : valueBn,
      endian: endian,
      bitLength: byteLength * 8);

  var ret = Uint8List(byteLength);

  ret.setAll(0, newU8a);
  return ret;
}

final bnZero = BigInt.zero;
final bnOne = BigInt.one;
final bnTen = BigInt.from(10);
final bnHundred = BigInt.from(100);
final bnThrousand = BigInt.from(1000);

BigInt bnMax(List<BigInt> list) {
  list.sort((a, b) => a.compareTo(b));
  return list.last;
}

BigInt bnMin(List<BigInt> list) {
  list.sort((a, b) => a.compareTo(b));
  return list.first;
}

BigInt bnSqrt(BigInt bn) {
  return bn < BigInt.from(2) ? bn : newtonIteration(bn, BigInt.from(1));
}

BigInt newtonIteration(BigInt n, BigInt x0) {
  var x1 = (BigInt.from(n / x0) + x0) >> 1;
  if (x0 == x1 || x0 == (x1 - BigInt.from(1))) {
    return x0;
  }
  return newtonIteration(n, x1);
}
