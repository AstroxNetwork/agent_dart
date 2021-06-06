import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
// ignore: library_prefixes
import 'hex.dart' as hexUtil;
// ignore: library_prefixes
import 'string.dart' as stringUtil;

// ignore: library_prefixes
import 'u8a.dart' as u8aUtil;
// ignore: library_prefixes
import 'bn.dart' as bnUtil;
// ignore: library_prefixes
import 'is.dart' as isUtil;

extension StringExtension on String {
  bool isHex([int bitLength = -1, bool ignoreLength = false]) =>
      isUtil.isHex(this, bitLength, ignoreLength);
  bool isHexString() => isUtil.isHexString(this);
  String hexAddPrefix() => hexUtil.hexAddPrefix(this);
  String hexStripPrefix() => stringUtil.strip0xHex(this);
  String plainToHex() => u8aUtil.u8aToHex(stringUtil.stringToU8a(this));
  Uint8List toU8a({int bitLength = -1}) => hexUtil.hexToU8a(this, bitLength);
  Uint8List plainToU8a({String? enc, bool useDartEncode = false}) =>
      stringUtil.stringToU8a(this, enc: enc, useDartEncode: useDartEncode);
  BigInt hexToBn({Endian endian = Endian.big, bool isNegative = false}) =>
      hexUtil.hexToBn(this, endian: endian, isNegative: isNegative);
  Pointer<Utf8> toUtf8() => toNativeUtf8();
  String camelCase() => stringUtil.stringCamelCase(this);
}

extension U8aExtension on Uint8List {
  Uint8List toU8a() => u8aUtil.u8aToU8a(this);
  String toHex({bool include0x = true}) => u8aUtil.u8aToHex(this, include0x: include0x);
  String u8aToString({bool useDartEncode = true}) =>
      u8aUtil.u8aToString(this, useDartEncode: useDartEncode);
  bool eq(Uint8List other) => u8aUtil.u8aEq(this, other);
  BigInt toBn({Endian endian = Endian.little}) => u8aUtil.u8aToBn(this, endian: endian);
}

extension BnExtension on BigInt {
  BigInt toBn() => bnUtil.bnToBn(this);
  String toHex({int bitLength = -1, Endian endian = Endian.big, bool isNegative = false}) =>
      bnUtil.bnToHex(this, bitLength: bitLength, endian: endian, isNegative: isNegative);
  Uint8List toU8a({int bitLength = -1, Endian endian = Endian.big, bool isNegative = false}) =>
      bnUtil.bnToU8a(this, bitLength: bitLength, endian: endian, isNegative: isNegative);
  BigInt bitNot({int? bitLength}) => bnUtil.bitnot(this, bitLength: bitLength);
}

extension IntExtension on int {
  BigInt toBn() => bnUtil.bnToBn(this);
  String toHex({int bitLength = -1, Endian endian = Endian.big, bool isNegative = false}) =>
      bnUtil.bnToHex(toBn(), bitLength: bitLength, endian: endian, isNegative: isNegative);
  Uint8List toU8a({int bitLength = -1, Endian endian = Endian.big, bool isNegative = false}) =>
      bnUtil.bnToU8a(toBn(), bitLength: bitLength, endian: endian, isNegative: isNegative);
  BigInt bitNot({int? bitLength}) => bnUtil.bitnot(toBn(), bitLength: bitLength);
  static get max => 4294967296;
}
