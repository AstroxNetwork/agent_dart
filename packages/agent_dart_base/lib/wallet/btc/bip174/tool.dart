import 'dart:typed_data';

import 'package:collection/collection.dart';

import 'interfaces.dart';
import 'varint.dart' as varuint;

List<int> range(int n) => List<int>.generate(n, (i) => i);

int readUInt8(List<int> buffer, int offset) {
  final byteData = ByteData.view(Uint8List.fromList(buffer).buffer);
  return byteData.getUint8(offset);
}

int readUInt16LE(List<int> buffer, int offset) {
  final byteData = ByteData.view(Uint8List.fromList(buffer).buffer);
  return byteData.getUint16(offset, Endian.little);
}

int readUInt32LE(List<int> buffer, int offset) {
  final byteData = ByteData.view(Uint8List.fromList(buffer).buffer);
  return byteData.getUint32(offset, Endian.little);
}

void writeUInt32LE(Uint8List buffer, int value, int offset) {
  final byteData = ByteData.view(buffer.buffer);
  byteData.setUint32(offset, value, Endian.little);
}

void writeInt32LE(Uint8List buffer, int value, int offset) {
  final byteData = ByteData.view(buffer.buffer);
  byteData.setInt32(offset, value, Endian.little);
}

// int readUInt64LE(List<int> buffer, int offset) {
//   final byteData = ByteData.view(Uint8List.fromList(buffer).buffer);
//   return byteData.getUint64(offset, Endian.little);
// }

void writeUIntBE(Uint8List buffer, int value, int offset, int byteLength) {
  final view = ByteData.view(buffer.buffer);
  final shift = 8 * (byteLength - 1);
  for (var i = 0; i < byteLength; i++) {
    view.setUint8(offset + i, (value >> (shift - 8 * i)) & 0xff);
  }
}

void writeUInt8(Uint8List buffer, int value, int offset) {
  final byteData = ByteData.view(buffer.buffer);
  byteData.setUint8(offset, value);
}

void writeUInt16LE(Uint8List buffer, int value, int offset) {
  final byteData = ByteData.view(buffer.buffer);
  byteData.setUint16(offset, value, Endian.little);
}

int readUInt64LE(Uint8List buffer, int offset) {
  final a = readUInt32LE(buffer, offset);
  var b = readUInt32LE(buffer, offset + 4);
  b *= 0x100000000;

  verifuint(b + a, 0x001fffffffffffff);
  return b + a;
}

int writeUInt64LE(
  Uint8List buffer,
  int value,
  int offset,
) {
  verifuint(value, 0x001fffffffffffff);

  writeInt32LE(buffer, value & -1, offset);
  writeUInt32LE(buffer, (value / 0x100000000).floor(), offset + 4);
  return offset + 8;
}

void verifuint(int value, int max) {
  if (value < 0) {
    throw Exception('specified a negative value for writing an unsigned value');
  }
  if (value > max) {
    throw Exception('RangeError: value out of range');
  }
  if (value.floor() != value) {
    throw Exception('value has a fractional component');
  }
}

Uint8List keyValsToBuffer(List<KeyValue> keyVals) {
  final buffers = keyVals.map((e) => keyValToBuffer(e)).toList();
  buffers.add(Uint8List.fromList([0]));
  return Uint8List.fromList(buffers.flattened.toList());
}

Uint8List keyValToBuffer(KeyValue keyVal) {
  final keyLen = keyVal.key.length;
  final valLen = keyVal.value.length;
  final keyVarIntLen = varuint.encodingLength(keyLen);
  final valVarIntLen = varuint.encodingLength(valLen);

  final buffer = Uint8List(
    keyVarIntLen + keyLen + valVarIntLen + valLen,
  );

  varuint.encode(keyLen, buffer, 0);
  keyVal.key.setRange(keyVarIntLen, keyVarIntLen + buffer.length, buffer);
  varuint.encode(valLen, buffer, keyVarIntLen + keyLen);
  keyVal.value.setRange(keyVarIntLen + keyLen + valVarIntLen,
      keyVarIntLen + keyLen + valVarIntLen + buffer.length, buffer);

  return buffer;
}
