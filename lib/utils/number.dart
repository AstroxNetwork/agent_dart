import 'dart:typed_data';
import 'dart:math' as math;
import 'package:convert/convert.dart';

BigInt decodeBigInt(List<int> bytes, {Endian endian = Endian.little}) {
  BigInt result = BigInt.from(0);
  for (int i = 0; i < bytes.length; i++) {
    final newValue = BigInt.from(
      bytes[endian == Endian.little ? i : bytes.length - i - 1],
    );
    result += newValue << (8 * i);
  }
  return result;
}

Uint8List encodeBigInt(
  BigInt number, {
  Endian endian = Endian.little,
  int? bitLength,
}) {
  final bl = (bitLength != null) ? bitLength : number.bitLength;
  final int size = (bl + 7) >> 3;
  final result = Uint8List(size);

  for (int i = 0; i < size; i++) {
    result[endian == Endian.little ? i : size - i - 1] =
        (number & BigInt.from(0xff)).toInt();
    number = number >> 8;
  }
  return result;
}

/// Converts the [number], which can either be a dart [int] or a [BigInt],
/// into a hexadecimal representation. The number needs to be positive or zero.
///
/// When [pad] is set to true, this method will prefix a zero so that the result
/// will have an even length. Further, if [forcePadLen] is not null and the
/// result has a length smaller than [forcePadLen], the rest will be left-padded
/// with zeroes. Note that [forcePadLen] refers to the string length, meaning
/// that one byte has a length of 2. When [include0x] is set to true, the
/// output wil have "0x" prepended to it after any padding is done.
String numberToHex(
  dynamic number, {
  bool pad = false,
  bool include0x = false,
  int? forcePadLen,
}) {
  String toHexSimple() {
    if (number is int) {
      return number.toRadixString(16);
    } else if (number is BigInt) {
      return number.toRadixString(16);
    } else {
      throw TypeError();
    }
  }

  var hexString = toHexSimple();
  if (pad && !hexString.length.isEven) hexString = '0$hexString';
  if (forcePadLen != null) hexString = hexString.padLeft(forcePadLen, '0');
  if (include0x) hexString = '0x$hexString';

  return hexString;
}

/// Converts the [bytes] given as a list of integers into a hexadecimal
/// representation.
///
/// If any of the bytes is outside of the range [0, 256], the method will throw.
/// The outcome of this function will prefix a 0 if it would otherwise not be
/// of even length. If [include0x] is set, it will prefix "0x" to the hexadecimal
/// representation.
String bytesToHex(List<int> bytes, {bool include0x = false}) {
  return (include0x ? '0x' : '') + hex.encode(bytes);
}

///Converts the bytes from that list (big endian) to a BigInt.
// BigInt bytesToInt(List<int> bytes) => p_utils.decodeBigInt(bytes);
BigInt bytesToInt(List<int> bytes) => decodeBigInt(bytes, endian: Endian.big);

// /// Converts the given number, either a [int] or a [BigInt] to a list of
// /// bytes representing the same value.
// List<int> numberToBytes(dynamic number) {
//   if (number is BigInt) return encodeBigInt(number, endian: Endian.big);

//   var hexString = numberToHex(number, pad: true);
//   return hex.decode(hexString);
// }

// /// wrapper to u8a
// Uint8List numberToU8a(dynamic number) {
//   final listInt = numberToBytes(number);
//   return Uint8List.fromList(listInt);
// }

// // List<int> intToBytes(BigInt number) => p_utils.encodeBigInt(number);
// /// big int to bytes
// List<int> bnToBytes(BigInt number, {int length}) {
//   Uint8List bigIntList = encodeBigInt(number);
//   if (length != null && length > bigIntList.length) {
//     var newList = new Int8List(length);
//     newList.setRange(length - bigIntList.length, length, bigIntList);
//     return newList;
//   } else if (length == null) {
//     return bigIntList;
//   } else {
//     throw 'length is to short, should be >= ${bigIntList.length}';
//   }
// }

// ///Takes the hexadecimal input and creates a BigInt.
// // BigInt hexToBN(String hex) {
// //   return BigInt.parse(strip0xHex(hex), radix: 16);
// // }

// List<String> numberToHexArray(int number, int size) {
//   String hexVal = number.toRadixString(16);
//   List<String> hexRep = List.filled(hexVal.length, '0');
//   List<String> hex = List.filled(size, '0');
//   for (int i = 0; i < hexVal.length; i++) {
//     hexRep[i] = hexVal.substring(i, i + 1);
//   }
//   hex.setRange(size - hexVal.length, size, hexRep);
//   return hex;
// }

num log2(num x) => math.log(x) / math.log(2);
