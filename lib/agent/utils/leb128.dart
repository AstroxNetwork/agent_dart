// ignore: unused_import
import 'dart:math';
import 'dart:typed_data';

import 'package:agent_dart/agent/utils/buffer_pipe.dart';
import 'package:agent_dart/utils/bn.dart';
import 'package:agent_dart/utils/hex.dart';
import 'package:agent_dart/utils/extension.dart';

List<T> safeRead<T>(BufferPipe<T> pipe, int ref) {
  if (pipe.length < ref) {
    throw 'unexpected end of buffer';
  }
  return pipe.read(ref);
}

/// Encode a positive number (or bigint) into a Buffer. The number will be floored to the
/// nearest integer.
/// @param value The number to encode.
Uint8List lebEncode(dynamic value) {
  var bn = value is BigInt ? value : BigInt.from(value);

  if (bn < BigInt.zero) {
    throw 'Cannot leb encode negative values.';
  }

  final List<int> pipe = [];

  while (true) {
    final i = (hexToBn(bn.toHex()) & BigInt.from(0x7f)).toInt();
    bn = (bn ~/ BigInt.from(0x80));
    if (bn == BigInt.zero) {
      pipe.add(i);
      break;
    } else {
      pipe.add(i | 0x80);
    }
  }

  return Uint8List.fromList(pipe);
}

/// Decode a leb encoded buffer into a bigint. The number will always be positive (does not
/// support signed leb encoding).
/// @param pipe A Buffer containing the leb encoded bits.
BigInt lebDecode<T>(BufferPipe<T> pipe) {
  var weight = BigInt.one;
  var value = BigInt.zero;
  // ignore: prefer_typing_uninitialized_variables
  var byte;

  do {
    byte = safeRead(pipe, 1)[0];
    value += BigInt.from(byte & 0x7f) * weight;
    weight *= BigInt.from(128);
  } while (byte >= 0x80);

  return value;
}

/// Encode a number (or bigint) into a Buffer, with support for negative numbers. The number
/// will be floored to the nearest integer.
/// @param value The number to encode.
Uint8List slebEncode(Comparable value) {
  var bn = value is BigInt ? value : BigInt.from(value as num);

  final isNeg = bn < BigInt.zero;
  if (isNeg) {
    bn = -bn - BigInt.one;
  }

  int getLowerBytes(BigInt num) {
    final bytes = num % BigInt.from(0x80);
    if (isNeg) {
      // We swap the bits here again, and remove 1 to do two's complement.
      return (BigInt.from(0x80) - bytes - BigInt.one).toInt();
    } else {
      return (bytes).toInt();
    }
  }

  final List<int> pipe = [];

  while (true) {
    final i = getLowerBytes(bn);
    bn = (bn ~/ BigInt.from(0x80));

    // prettier-ignore
    if ((isNeg && bn == BigInt.zero && (i & 0x40) != 0) ||
        (!isNeg && bn == BigInt.zero && (i & 0x40) == 0)) {
      pipe.add(i);
      break;
    } else {
      pipe.add(i | 0x80);
    }
  }

  return Uint8List.fromList(pipe);
}

/// Decode a leb encoded buffer into a bigint. The number is decoded with support for negative
/// signed-leb encoding.
/// @param pipe A Buffer containing the signed leb encoded bits.
BigInt slebDecode(BufferPipe pipe) {
  // Get the size of the buffer, then cut a buffer of that size.
  final pipeView = Uint8List.fromList(pipe.buffer as List<int>);
  var len = 0;
  for (; len < pipeView.lengthInBytes; len++) {
    if (pipeView[len] < 0x80) {
      // If it's a positive number, we reuse lebDecode.
      if ((pipeView[len] & 0x40) == 0) {
        return lebDecode(pipe);
      }
      break;
    }
  }

  final bytes = Uint8List.fromList(safeRead(pipe as BufferPipe<int>, len + 1));
  var value = BigInt.zero;
  for (var i = bytes.lengthInBytes - 1; i >= 0; i--) {
    value =
        value * BigInt.from(0x80) + BigInt.from(0x80 - (bytes[i] & 0x7f) - 1);
  }
  return -value - BigInt.one;
}

Uint8List writeUIntLE(dynamic value, int byteLength) {
  if (bnToBn(value) < BigInt.zero) {
    throw 'Cannot write negative values.';
  }
  return writeIntLE(value, byteLength);
}

Uint8List writeIntLE(dynamic value, int byteLength) {
  final bn = bnToBn(value);

  final List<int> pipe = [];
  var i = 0;
  var mul = BigInt.from(256);
  var sub = BigInt.zero;
  var byte = (bn % mul).toInt();
  pipe.add(byte);
  while (++i < byteLength) {
    if (bn < BigInt.zero && sub == BigInt.zero && byte != 0) {
      sub = BigInt.one;
    }
    byte = ((bn ~/ mul - sub) % BigInt.from(256)).toInt();
    pipe.add(byte);
    mul *= BigInt.from(256);
  }

  return Uint8List.fromList(pipe);
}

BigInt readUIntLE(BufferPipe pipe, int byteLength) {
  var val = BigInt.from(safeRead(pipe, 1)[0]);
  var mul = BigInt.one;
  var i = 0;
  while (++i < byteLength) {
    mul *= BigInt.from(256);
    final byte = BigInt.from(safeRead(pipe, 1)[0]);
    val = val + mul * byte;
  }
  return val;
}

BigInt readIntLE(BufferPipe pipe, int byteLength) {
  var val = readUIntLE(pipe, byteLength);
  final mul = BigInt.from(2).pow(
    (BigInt.from(8) * BigInt.from(byteLength - 1) + BigInt.from(7)).toInt(),
  );
  if (val >= mul) {
    val -= mul * BigInt.from(2);
  }
  return val;
}
