import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:agent_dart/principal/principal.dart';
import 'package:cbor/cbor.dart' as cbor;
import 'package:typed_data/typed_data.dart';
import 'dart:math' as math;

import 'types.dart';

abstract class ExtraEncoder<T> {
  const ExtraEncoder({required this.name});

  final String name;

  bool match(Object? value);

  void write(cbor.Encoder encoder, T value);
}

class SelfDescribeEncoder extends cbor.Encoder {
  SelfDescribeEncoder(this._out) : super(_out) {
    final valBuff = Uint8Buffer();
    final hList = Uint8List.fromList([0xd9, 0xd9, 0xf7]);
    valBuff.addAll(hList);
    addBuilderOutput(valBuff);
  }

  SelfDescribeEncoder.noHead(this._out) : super(_out);

  late final cbor.Output _out;
  final Set<ExtraEncoder> _encoders = {};

  void addEncoder<T>(ExtraEncoder encoder) {
    _encoders.add(encoder);
  }

  void removeEncoder<T>(String encoderName) {
    _encoders.removeWhere((element) => element.name == encoderName);
  }

  ExtraEncoder? getEncoderFor<T>(dynamic value) {
    for (final encoder in _encoders) {
      if (encoder.match(value)) {
        return encoder;
      }
    }
    return null;
  }

  void serialize(dynamic val) {
    if (val is Map) {
      serializeMap(val);
    } else if (val is Iterable) {
      serializeIterable(val);
    } else {
      serializeData(val);
    }
  }

  void serializeMap(Map map) {
    writeTypeValue(cbor.majorTypeMap, map.length);
    final entries = map.entries;
    for (final entry in entries) {
      if (entry.key is String) {
        writeString(entry.key);
      } else if (entry.key is int) {
        writeInt(entry.key);
      }
      serializeData(entry.value);
    }
  }

  void serializeData(dynamic data) {
    if (writeExtra(data) == true) {
      return;
    } else if (data is ToCborable) {
      data.write(this);
    } else if (data is Map) {
      serializeMap(data);
    } else if (data is Iterable) {
      serializeIterable(data);
    } else if (data is int) {
      writeInt(data);
    } else if (data is String) {
      writeString(data);
    } else if (data is double) {
      writeFloat(data);
    } else if (data is bool) {
      writeBool(data);
    } else if (data == null) {
      writeNull();
    } else {
      throw UnsupportedError(
        '${data.runtimeType.toString()}'
        ' is not supported with CBOR serializations.',
      );
    }
  }

  void serializeIterable(Iterable data) {
    if (data is Uint8Buffer) {
      writeBuff(data);
    } else if (data is Uint8List) {
      writeBytes(Uint8Buffer()..addAll(data));
    } else if (data.every((element) => element is int)) {
      writeBytes(Uint8Buffer()..addAll(List<int>.from(data)));
    } else if (data is List) {
      writeTypeValue(cbor.majorTypeArray, data.length);
      for (final byte in data) {
        if (getEncoderFor(byte) != null) {
          writeExtra(byte);
        } else if (byte is Map) {
          serializeMap(byte);
        } else if (byte is Iterable) {
          serializeIterable(byte);
        } else if (byte is int) {
          _out.putByte(byte);
        } else {
          serializeData(byte);
        }
      }
    }
  }

  bool writeExtra(dynamic data) {
    final extraEnc = getEncoderFor(data);
    if (extraEnc != null) {
      extraEnc.write(this, data);
      return true;
    }
    return false;
  }

  void writeTypeValue(int majorType, int value) {
    int type = majorType;
    type <<= cbor.majorTypeShift;
    if (value < cbor.ai24) {
      // Value
      _out.putByte(type | value);
    } else if (value < cbor.two8) {
      // Uint8
      _out.putByte(type | cbor.ai24);
      _out.putByte(value);
    } else if (value < cbor.two16) {
      // Uint16
      _out.putByte(type | cbor.ai25);
      final buff = Uint16Buffer(1);
      buff[0] = value;
      final ulist = Uint8List.view(buff.buffer);
      final data = Uint8Buffer();
      data.addAll(ulist.toList().reversed);
      _out.putBytes(data);
    } else if (value < cbor.two32) {
      // Uint32
      _out.putByte(type | cbor.ai26);
      final buff = Uint32Buffer(1);
      buff[0] = value;
      final ulist = Uint8List.view(buff.buffer);
      final data = Uint8Buffer();
      data.addAll(ulist.toList().reversed);
      _out.putBytes(data);
    } else {
      // Encode to a bignum, if the value can be represented as
      // an integer it must be greater than 2*32 so encode as 64 bit.
      final bignum = BigInt.from(value);
      if (kIsWeb) {
        final data = serializeValue(0, 27, bignum.toRadixString(16));
        final buf = Uint8Buffer();
        buf.addAll(data.asUint8List());
        addBuilderOutput(buf);
      } else if (bignum.isValidInt) {
        // Uint64
        _out.putByte(type | cbor.ai27);
        final buff = Uint64Buffer(1);
        buff[0] = value;
        final ulist = Uint8List.view(buff.buffer);
        final data = Uint8Buffer();
        data.addAll(ulist.toList().reversed);
        _out.putBytes(data);
      } else {
        // Bignum - encoded as a tag value
        writeBignum(BigInt.from(value));
      }
    }
  }
}

class PrincipalEncoder extends ExtraEncoder<Principal> {
  const PrincipalEncoder() : super(name: 'Principal');

  @override
  bool match(Object? value) => value is Principal;

  @override
  void write(cbor.Encoder encoder, Principal value) {
    final valBuff = Uint8Buffer();
    valBuff.addAll(value.toUint8List());
    encoder.writeBytes(valBuff);
  }
}

class BufferEncoder extends ExtraEncoder<BinaryBlob> {
  const BufferEncoder() : super(name: 'Buffer');

  @override
  bool match(Object? value) => value is BinaryBlob;

  @override
  void write(cbor.Encoder encoder, BinaryBlob value) {
    final valBuff = Uint8Buffer();
    valBuff.addAll(value);
    encoder.writeBytes(valBuff);
  }
}

class ByteBufferEncoder extends ExtraEncoder<ByteBuffer> {
  const ByteBufferEncoder() : super(name: 'ByteBuffer');

  @override
  bool match(Object? value) => value is ByteBuffer;

  @override
  void write(cbor.Encoder encoder, ByteBuffer value) {
    final valBuff = Uint8Buffer();
    valBuff.addAll(value.asUint8List());
    encoder.writeBytes(valBuff);
  }
}

class BigIntEncoder extends ExtraEncoder<BigInt> {
  const BigIntEncoder() : super(name: 'BigInt');

  @override
  bool match(Object? value) => value is BigInt;

  @override
  void write(cbor.Encoder encoder, BigInt value) {
    encoder.writeBignum(value);
  }
}

abstract class ToCborable {
  const ToCborable();

  void write(cbor.Encoder encoder);
}

SelfDescribeEncoder initCborSerializer() {
  cbor.init();
  final output = cbor.OutputStandard();
  const principalEncoder = PrincipalEncoder();
  const bigIntEncoder = BigIntEncoder();
  const bufferEncoder = BufferEncoder();
  const byteBufferEncoder = ByteBufferEncoder();

  return SelfDescribeEncoder(output)
    ..addEncoder(principalEncoder)
    ..addEncoder(bigIntEncoder)
    ..addEncoder(bufferEncoder)
    ..addEncoder(byteBufferEncoder);
}

SelfDescribeEncoder initCborSerializerNoHead() {
  cbor.init();
  final output = cbor.OutputStandard();
  const principalEncoder = PrincipalEncoder();
  const bigIntEncoder = BigIntEncoder();
  const bufferEncoder = BufferEncoder();
  const byteBufferEncoder = ByteBufferEncoder();

  return SelfDescribeEncoder.noHead(output)
    ..addEncoder(principalEncoder)
    ..addEncoder(bigIntEncoder)
    ..addEncoder(bufferEncoder)
    ..addEncoder(byteBufferEncoder);
}

BinaryBlob cborEncode(dynamic value, {SelfDescribeEncoder? withSerializer}) {
  final serializer = withSerializer ?? initCborSerializer();
  serializer.serialize(value);
  return Uint8List.fromList(serializer._out.getData());
}

T cborDecode<T>(List<int> value) {
  final buffer = value is Uint8Buffer ? value : Uint8Buffer()
    ..addAll(value);
  final cbor.Input input = cbor.Input(buffer);
  final cbor.Listener listener = cbor.ListenerStack();
  final decodeStack = cbor.DecodeStack();
  listener.itemStack.clear();
  final cbor.Decoder decoder = cbor.Decoder.withListener(input, listener);
  decoder.run();
  decodeStack.build(listener.itemStack);
  final walked = decodeStack.walk();
  return walked![0] as T;
}

ByteBuffer serializeValue(int major, int minor, String val) {
  // Remove everything that's not an hexadecimal character. These are not
  // considered errors since the value was already validated and they might
  // be number decimals or sign.
  String value = val.replaceAll('r[^0-9a-fA-F]', '');
  // Create the buffer from the value with left padding with 0.
  final length = math.pow(2, minor - 24).toInt();
  final temp = value.substring(
    value.length <= length * 2 ? 0 : value.length - length * 2,
  );
  final prefix = '0' * (2 * length - temp.length);
  value = prefix + temp;
  final bytes = [(major << 5) + minor];
  final arr = <int>[];
  for (int i = 0; i < value.length; i += 2) {
    arr.add(int.parse(value.substring(i, i + 2), radix: 16));
  }
  bytes.addAll(arr);
  return Uint8List.fromList(bytes).buffer;
}
