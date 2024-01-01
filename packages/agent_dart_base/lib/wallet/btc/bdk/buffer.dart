/// Moved from `https://github.com/dart-bitcoin-lib/dart-buffer`
/// Buffer Reader and Buffer Writer

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:convert/convert.dart';

/// Buffer Reader
class BufferReader {
  /// BufferReader from ByteData
  BufferReader(this.buffer, [this.offset = 0]);

  /// BufferReader from TypedData
  factory BufferReader.fromTypedData(TypedData buffer, [offset = 0]) {
    return BufferReader(buffer.buffer.asByteData(), offset);
  }

  /// BufferReader from hex string
  factory BufferReader.fromHex(String data, [offset = 0]) {
    return BufferReader.fromTypedData(
        Uint8List.fromList(hex.decode(data)), offset);
  }

  ByteData buffer;
  int offset;

  int get length => buffer.lengthInBytes;

  /// Set offset to zero
  void reset() {
    offset = 0;
  }

  ///Reads byteLength number of bytes from buf at the current offset
  /// and interprets the result as an unsigned, [Endian] integer
  /// supporting up to 48 bits of accuracy.
  int getUInt([int byteLength = 0, Endian endian = Endian.little]) {
    if (offset + byteLength > length) {
      throw IndexError(byteLength, buffer, 'IndexError',
          'Cannot get UIntLE out of bounds', buffer.lengthInBytes);
    }
    if (endian != Endian.little) {
      var val = buffer.buffer.asUint8List()[offset];
      var mul = 1;
      var i = 0;
      while (++i < byteLength && (mul *= 0x100) != 0) {
        val += buffer.buffer.asUint8List()[offset + i] * mul;
      }
      return val;
    } else {
      var val = buffer.buffer.asUint8List()[offset + --byteLength];
      var mul = 1;
      while (byteLength > 0 && (mul *= 0x100) != 0) {
        val += buffer.buffer.asUint8List()[offset + --byteLength] * mul;
      }
      return val;
    }
  }

  /// Returns the (possibly negative) integer represented by the byte at
  /// current offset in buffer, in two's complement binary
  /// representation.
  ///
  /// The return value will be between -128 and 127, inclusive.
  int getInt8() {
    final result = buffer.getInt8(offset);
    offset++;
    return result;
  }

  /// Returns the positive integer represented by the byte.
  /// Increments the offset value by one.
  /// The return value will be between 0 and 255, inclusive.
  int getUInt8() {
    final result = buffer.getUint8(offset);
    offset++;
    return result;
  }

  /// Returns the (possibly negative) integer represented by the four bytes
  /// Increments the offset value by four
  /// The return value will be between -2<sup>15</sup> and 2<sup>15</sup> - 1,
  /// inclusive.
  int getInt16([Endian endian = Endian.little]) {
    final result = buffer.getInt16(offset, endian);
    offset += 2;
    return result;
  }

  /// Returns the positive integer represented by the four bytes
  /// Increments the offset value by four
  /// The return value will be between 0 and  2<sup>16</sup> - 1, inclusive.
  int getUInt16([Endian endian = Endian.little]) {
    final result = buffer.getUint16(offset, endian);
    offset += 2;
    return result;
  }

  /// Returns the (possibly negative) integer represented by the four bytes
  /// Increments the offset value by four
  /// The return value will be between -2<sup>15</sup> and 2<sup>15</sup> - 1,
  /// inclusive.
  int getInt32([Endian endian = Endian.little]) {
    final result = buffer.getInt32(offset, endian);
    offset += 4;
    return result;
  }

  /// Returns the positive integer represented by the four bytes
  /// Increments the offset value by four
  /// The return value will be between 0 and  2<sup>32</sup> - 1, inclusive.
  int getUInt32([Endian endian = Endian.little]) {
    final result = buffer.getUint32(offset, endian);
    offset += 4;
    return result;
  }

  /// Returns the positive integer represented by the eight bytes
  /// Increments the offset value by eight
  /// The return value will be between 0 and  2<sup>64</sup> - 1, inclusive.
  int getInt64([Endian endian = Endian.little]) {
    final result = buffer.getInt64(offset, endian);
    offset += 8;
    return result;
  }

  /// Returns the positive integer represented by the eight bytes
  /// Increments the offset value by eight
  /// The return value will be between 0 and  2<sup>64</sup> - 1, inclusive.
  int getUInt64([Endian endian = Endian.little]) {
    final result = buffer.getUint64(offset, endian);
    offset += 8;
    return result;
  }

  /// Returns the floating point number represented by the four bytes,
  /// in IEEE 754 single-precision binary floating-point format (binary32).
  double getFloat32([Endian endian = Endian.little]) {
    final result = buffer.getFloat32(offset, endian);
    offset += 4;
    return result;
  }

  /// Returns the floating point number represented by the eight bytes,
  /// in IEEE 754 double-precision binary floating-point format (binary64).
  double getFloat64([Endian endian = Endian.little]) {
    final result = buffer.getFloat64(offset, endian);
    offset += 8;
    return result;
  }

  /// Get next byte and return an int value based on the data length specified by this byte.
  /// The return value will between 0 and 2<sup>64</sup> - 1, inclusive.
  int getVarInt([Endian endian = Endian.little]) {
    final ByteData bufferByteData = buffer.buffer.asByteData();
    final int first = bufferByteData.getUint8(offset);
    int output;
    // 8 bit
    if (first < 0xfd) {
      output = first;
      offset += 1;
      // 16 bit
    } else if (first == 0xfd) {
      output = bufferByteData.getUint16(offset + 1, endian);
      offset += 3;

      // 32 bit
    } else if (first == 0xfe) {
      output = bufferByteData.getUint32(offset + 1, endian);
      offset += 5;

      // 64 bit
    } else {
      output = bufferByteData.getUint64(offset + 1, endian);
      offset += 9;
    }

    return output;
  }

  /// Get next n bytes
  /// The return value will be ByteData(n)
  ByteData getSlice(int n) {
    if (buffer.lengthInBytes < offset + n) {
      throw IndexError(n, buffer, 'IndexError',
          'Cannot get slice out of bounds', buffer.lengthInBytes);
    }
    final result = buffer.buffer
        .asUint8List()
        .sublist(offset, offset + n)
        .buffer
        .asByteData();
    offset += n;
    return result;
  }

  /// Get next byte and return an ByteData value based on the data length specified by this byte.
  /// The return value will be ByteData.
  ByteData getVarSlice([Endian endian = Endian.little]) {
    return getSlice(getVarInt(endian));
  }

  /// Get vector list
  /// The return value will be List<ByteData>.
  List<ByteData> getVector([Endian endian = Endian.little]) {
    final count = getVarInt();
    final List<ByteData> vector = [];
    for (int i = 0; i < count; i++) {
      vector.add(getVarSlice(endian));
    }
    return vector;
  }
}

/// Buffer Writer
class BufferWriter {
  /// BufferWriter from ByteData
  BufferWriter(this.buffer, [this.offset = 0]);

  /// BufferWriter from TypedData
  factory BufferWriter.fromTypedData(TypedData buffer, [offset = 0]) {
    return BufferWriter(buffer.buffer.asByteData(), offset);
  }

  /// BufferWriter from hex string
  factory BufferWriter.fromHex(String data, [offset = 0]) {
    return BufferWriter.fromTypedData(
        Uint8List.fromList(hex.decode(data)), offset);
  }

  /// BufferWriter with capacity
  factory BufferWriter.withCapacity(int size) {
    return BufferWriter(ByteData(size));
  }

  ByteData buffer;
  int offset;

  int get length => buffer.lengthInBytes;

  /// Set offset to zero
  void reset() {
    offset = 0;
  }

  static ByteData varintBufNum(int n) {
    ByteData buf;
    if (n < 253) {
      buf = ByteData(1);
      buf.setUint8(0, n);
    } else if (n < 0x10000) {
      buf = ByteData(1 + 2);
      buf.setUint8(0, 253);
      buf.setUint16(1, n, Endian.little);
    } else if (n < 0x100000000) {
      buf = ByteData(1 + 4);
      buf.setUint8(0, 254);
      buf.setUint32(1, n, Endian.little);
    } else {
      buf = ByteData(1 + 8);
      buf.setUint8(0, 255);
      buf.setInt32(1, n & -1, Endian.little);
      buf.setUint32(5, (n / 0x100000000).floor(), Endian.little);
    }
    return buf;
  }

  ///Writes byteLength bytes of value to buf at the current
  /// offset as [Endian]. Supports up to 48 bits of accuracy.
  void setUInt(int value, [int byteLength = 0, Endian endian = Endian.little]) {
    final num maxBytes = math.pow(2, 8 * byteLength) - 1;

    if (value > maxBytes || value < 0) {
      throw RangeError('"value" argument is out of bounds');
    }
    if (offset + byteLength > buffer.lengthInBytes) {
      throw RangeError('"byteLength" out of range');
    }
    int mul = 1;
    if (endian == Endian.little) {
      int i = 0;
      buffer.buffer.asUint8List()[offset] = value & 0xFF;
      while (++i < byteLength && (mul *= 0x100) != 0) {
        buffer.buffer.asUint8List()[offset + i] = value ~/ mul & 0xFF;
      }
    } else {
      int i = byteLength - 1;
      buffer.buffer.asUint8List()[offset + i] = value & 0xFF;
      while (--i >= 0 && (mul *= 0x100) != 0) {
        buffer.buffer.asUint8List()[offset + i] = value ~/ mul & 0xFF;
      }
    }
    offset = offset + byteLength;
  }

  /// Sets the byte at the current offset in buffer to the
  /// two's complement binary representation of the specified [value], which
  /// must fit in a single byte.
  ///
  /// In other words, [value] must be between -128 and 127, inclusive.
  void setInt8(int i) {
    buffer.setInt8(offset, i);
    offset++;
  }

  /// Sets the byte at the current offset in buffer to the
  /// unsigned binary representation of the specified [value], which must fit
  /// in a single byte.
  ///
  /// In other words, [value] must be between 0 and 255, inclusive.
  void setUInt8(int i) {
    buffer.setUint8(offset, i);
    offset++;
  }

  /// Sets the two bytes starting at the current offset in buffer
  /// to the two's complement binary representation of the specified
  /// [value], which must fit in two bytes.
  ///
  /// In other words, [value] must lie
  /// between -2<sup>15</sup> and 2<sup>15</sup> - 1, inclusive.
  void setInt16(int i, [Endian endian = Endian.little]) {
    buffer.setInt16(offset, i, endian);
    offset += 2;
  }

  /// Sets the two bytes starting at the current offset in this object
  /// to the unsigned binary representation of the specified [value],
  /// which must fit in two bytes.
  ///
  /// In other words, [value] must be between
  /// 0 and 2<sup>16</sup> - 1, inclusive.
  void setUInt16(int i, [Endian endian = Endian.little]) {
    buffer.setUint16(offset, i, endian);
    offset += 2;
  }

  /// Sets the four bytes starting at the current offset in buffer
  /// to the two's complement binary representation of the specified
  /// [value], which must fit in four bytes.
  ///
  /// In other words, [value] must lie
  /// between -2<sup>31</sup> and 2<sup>31</sup> - 1, inclusive.
  void setInt32(int i, [Endian endian = Endian.little]) {
    buffer.setInt32(offset, i, endian);
    offset += 4;
  }

  /// Sets the four bytes starting at the current offset in buffer
  /// to the unsigned binary representation of the specified [value],
  /// which must fit in four bytes.
  ///
  /// In other words, [value] must be between
  /// 0 and 2<sup>32</sup> - 1, inclusive.
  void setUInt32(int i, [Endian endian = Endian.little]) {
    buffer.setUint32(offset, i, endian);
    offset += 4;
  }

  /// Sets the eight bytes starting at the current offset in buffer
  /// object to the two's complement binary representation of the specified
  /// [value], which must fit in eight bytes.
  ///
  /// In other words, [value] must lie
  /// between -2<sup>63</sup> and 2<sup>63</sup> - 1, inclusive.
  void setInt64(int i, [Endian endian = Endian.little]) {
    buffer.setInt64(offset, i, endian);
    offset += 8;
  }

  /// Sets the eight bytes starting at the current offset in buffer
  /// to the unsigned binary representation of the specified [value],
  /// which must fit in eight bytes.
  ///
  /// In other words, [value] must be between
  /// 0 and 2<sup>64</sup> - 1, inclusive.
  void setUInt64(int i, [Endian endian = Endian.little]) {
    buffer.setUint64(offset, i, endian);
    offset += 8;
  }

  /// Sets the four bytes starting at the current offset in buffer
  /// to the IEEE 754 single-precision binary floating-point
  /// (binary32) representation of the specified [value].
  ///
  /// **Note that this method can lose precision.** The input [value] is
  /// a 64-bit floating point value, which will be converted to 32-bit
  /// floating point value by IEEE 754 rounding rules before it is stored.
  /// If [value] cannot be represented exactly as a binary32, it will be
  /// converted to the nearest binary32 value.  If two binary32 values are
  /// equally close, the one whose least significant bit is zero will be used.
  /// Note that finite (but large) values can be converted to infinity, and
  /// small non-zero values can be converted to zero.
  void setFloat32(double i, [Endian endian = Endian.little]) {
    buffer.setFloat32(offset, i, endian);
    offset += 4;
  }

  /// Sets the eight bytes starting at the current offset in byte
  /// to the IEEE 754 double-precision binary floating-point
  /// (binary64) representation of the specified [value].
  void setFloat64(double i, [Endian endian = Endian.little]) {
    buffer.setFloat64(offset, i, endian);
    offset += 8;
  }

  /// Sets next byte [i] byte length and after then write [i]
  void setVarInt(int i, [Endian endian = Endian.little]) {
    if (i < 0) {
      throw RangeError('value out of range');
    }

    final ByteData bufferByteData = buffer.buffer.asByteData();

    // 8 bit
    if (i < 0xfd) {
      bufferByteData.setUint8(offset, i);
      offset += 1;

      // 16 bit
    } else if (i <= 0xffff) {
      bufferByteData.setUint8(offset, 0xfd);
      bufferByteData.setUint16(offset + 1, i, endian);
      offset += 3;

      // 32 bit
    } else if (i <= 0xffffffff) {
      bufferByteData.setUint8(offset, 0xfe);
      bufferByteData.setUint32(offset + 1, i, endian);
      offset += 5;

      // 64 bit
    } else {
      bufferByteData.setUint8(offset, 0xff);
      bufferByteData.setUint64(offset + 1, i, endian);
      offset += 9;
    }
  }

  /// Sets next bytes
  void setSlice(TypedData slice) {
    if (buffer.lengthInBytes < offset + slice.lengthInBytes) {
      throw Exception('Cannot set slice out of bounds');
    }
    buffer.buffer.asUint8List().setAll(offset, slice.buffer.asUint8List());
    offset += slice.lengthInBytes;
  }

  /// Sets next byte and return an ByteData value based on the data length specified by this byte.
  void setVarSlice(TypedData slice) {
    setVarInt(slice.lengthInBytes);
    setSlice(slice);
  }

  /// Sets vector list
  void setVector(List<TypedData> vector) {
    setVarInt(vector.length);
    for (final buf in vector) {
      setVarSlice(buf);
    }
  }

  ByteData end() {
    if (buffer.lengthInBytes == offset) {
      return buffer;
    }
    throw Exception('buffer size ${buffer.lengthInBytes}, offset $offset');
  }

  /// Convert [ByteData] to [T]
  T toTypeData<T extends List<int>>() {
    switch (T) {
      case Uint8List:
        return buffer.buffer.asUint8List() as T;
      case Int8List:
        return buffer.buffer.asInt8List() as T;
      case Uint16List:
        return buffer.buffer.asUint16List() as T;
      case Int16List:
        return buffer.buffer.asInt16List() as T;
      case Uint32List:
        return buffer.buffer.asUint32List() as T;
      case Int32List:
        return buffer.buffer.asInt32List() as T;
      default:
        throw const FormatException('Invalid Generic Type');
    }
  }
}
