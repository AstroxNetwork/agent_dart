import 'dart:typed_data';

import '../agent/errors.dart';
import 'hex.dart';
import 'is.dart';
import 'number.dart';
import 'u8a.dart';

BigInt bnToBn(dynamic value) {
  if (value == null) {
    return BigInt.zero;
  }
  BigInt? result;
  if (value is BigInt) {
    return value;
  } else if (value is int) {
    return BigInt.from(value);
  } else if (value is Map<String, dynamic>) {
    return compactToBn(value);
  } else if (value is String) {
    if (isHex(value)) {
      return hexToBn(value);
    }
    result = BigInt.tryParse(value, radix: 10);
  }
  if (result != null) {
    return result;
  }
  throw UnreachableError();
}

BigInt compactToBn(Map<String, dynamic> value) {
  final toBnTrue = value.containsKey('toBn') && value['toBn'] is Function;
  final toBigIntTrue =
      value.containsKey('toBigInt') && value['toBigInt'] is Function;
  if (toBnTrue && !toBigIntTrue) {
    return (value['toBn'] as Function).call();
  }
  if (!toBnTrue && toBigIntTrue) {
    return (value['toBigInt'] as Function).call();
  }
  throw UnreachableError();
}

BigInt bitnot(BigInt bn, {int? bitLength}) {
  // JavaScript's bitwise not doesn't work on negative BigInts (bn = ~bn; // WRONG!)
  // so we manually implement our own two's compliment (flip bits, add one)
  bn = -bn;
  String bin = bn.toRadixString(2).replaceAll('-', '');

  String prefix = '';
  while (bin.length % 8 != 0) {
    bin = '0$bin';
  }

  if ('1' == bin[0] && bin.substring(1).contains('1')) {
    prefix = '1' * 8;
  }

  if (bitLength != null && bitLength > 0 && bitLength > bin.length) {
    prefix = '1' * (bitLength - bin.length);
  }

  bin = bin.split('').map((i) {
    return '0' == i ? '1' : '0';
  }).join();

  return BigInt.parse(prefix + bin, radix: 2) + BigInt.one;
}

String bnToHex(
  BigInt bn, {
  int bitLength = -1,
  Endian endian = Endian.big,
  bool isNegative = false,
  bool include0x = false,
}) {
  final u8a = bnToU8a(
    bn,
    bitLength: bitLength,
    endian: endian,
    isNegative: isNegative,
  );
  return u8aToHex(u8a, include0x: include0x);
}

class Options {
  const Options({this.bitLength, this.endian, this.isNegative});

  final int? bitLength;
  final Endian? endian;
  final bool? isNegative;
}

Uint8List bnToU8a(
  BigInt? value, {
  int bitLength = -1,
  Endian endian = Endian.little,
  bool isNegative = false,
}) {
  final BigInt valueBn = bnToBn(value);
  int byteLength;
  if (bitLength == -1) {
    byteLength = (valueBn.bitLength / 8).ceil();
  } else {
    byteLength = (bitLength / 8).ceil();
  }

  if (value == null) {
    if (bitLength == -1) {
      return Uint8List.fromList([0]);
    } else {
      return Uint8List(byteLength);
    }
  }

  final newU8a = encodeBigInt(
    isNegative && (0x80 & valueBn.toInt()) > 0
        ? bitnot(valueBn, bitLength: byteLength * 8)
        : valueBn,
    endian: endian,
    bitLength: byteLength * 8,
  );
  final ret = Uint8List(byteLength);
  ret.setAll(0, newU8a);
  return ret;
}

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
  final x1 = (BigInt.from(n / x0) + x0) >> 1;
  if (x0 == x1 || x0 == (x1 - BigInt.from(1))) {
    return x0;
  }
  return newtonIteration(n, x1);
}
