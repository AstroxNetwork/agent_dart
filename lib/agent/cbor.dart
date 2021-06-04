import 'dart:typed_data';
import 'package:agent_dart/principal/principal.dart';
import 'package:cbor/cbor.dart' as cbor;
import 'package:typed_data/typed_data.dart';

import 'types.dart';

abstract class ExtraEncoder<T> {
  String get name;
  bool match(dynamic value);
  void write(cbor.Encoder encoder, T value);
}

class SelfDescribeEncoder extends cbor.Encoder {
  late final cbor.Output _out;
  final Set<ExtraEncoder> _encoders = {};

  SelfDescribeEncoder(this._out) : super(_out) {
    var valBuff = Uint8Buffer();
    var hList = Uint8List.fromList([0xd9, 0xd9, 0xf7]);
    valBuff.addAll(hList);
    addBuilderOutput(valBuff);
  }

  addEncoder<T>(ExtraEncoder encoder) {
    _encoders.add(encoder);
  }

  removeEncoder<T>(String encoderName) {
    _encoders.removeWhere((element) => element.name == encoderName);
  }

  ExtraEncoder? getEncoderFor<T>(dynamic value) {
    // ignore: prefer_typing_uninitialized_variables
    ExtraEncoder? chosenEncoder;

    for (var encoder in _encoders) {
      if (chosenEncoder == null) {
        if (encoder.match(value)) {
          chosenEncoder = encoder;
        }
      }
    }
    // if (chosenEncoder == null) {
    //   throw "Could not find an encoder for value.";
    // }
    return chosenEncoder;
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
    final entries = map.entries;
    for (var entry in entries) {
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
      print('writeMapImpl::Non Iterable RT is ${data.runtimeType.toString()}');
    }
  }

  void serializeIterable(Iterable data) {
    if (data is Uint8Buffer) {
      writeBuff(data);
    } else if (data is Uint8List) {
      writeBytes(Uint8Buffer()..addAll(data));
    } else if (data is List) {
      for (final byte in data) {
        if (byte is Map) {
          serializeMap(byte);
        } else if (byte is Iterable) {
          serializeIterable(byte);
        } else if (writeExtra(byte) == false) {
          _out.putByte(byte);
        }
      }
    }
  }

  bool writeExtra(dynamic data) {
    var extraEnc = getEncoderFor(data);
    if (extraEnc != null) {
      extraEnc.write(this, data);
      return true;
    }
    return false;
  }
}

class PrincipalEncoder extends ExtraEncoder<Principal> {
  @override
  String get name => 'Principal';

  PrincipalEncoder() : super();

  @override
  bool match(dynamic value) {
    return value is Principal;
  }

  @override
  void write(cbor.Encoder encoder, Principal value) {
    var valBuff = Uint8Buffer();
    valBuff.addAll(value.toUint8Array());
    encoder.writeBytes(valBuff);
  }
}

class BufferEncoder extends ExtraEncoder<BinaryBlob> {
  @override
  String get name => 'Buffer';

  BufferEncoder() : super();

  @override
  bool match(dynamic value) {
    return value is BinaryBlob;
  }

  @override
  void write(cbor.Encoder encoder, BinaryBlob value) {
    var valBuff = Uint8Buffer();
    valBuff.addAll(value.buffer);
    encoder.writeBytes(valBuff);
  }
}

class BigIntEncoder extends ExtraEncoder<BigInt> {
  @override
  String get name => 'BigInt';

  BigIntEncoder() : super();

  @override
  bool match(dynamic value) {
    return value is BigInt;
  }

  @override
  void write(cbor.Encoder encoder, BigInt value) {
    encoder.writeBignum(value);
  }
}

SelfDescribeEncoder initCborSerializer() {
  cbor.init();
  final output = cbor.OutputStandard();
  final principalEncoder = PrincipalEncoder();
  final bigIntEncoder = BigIntEncoder();
  final bufferEncoder = BufferEncoder();

  return SelfDescribeEncoder(output)
    ..addEncoder(principalEncoder)
    ..addEncoder(bigIntEncoder)
    ..addEncoder(bufferEncoder);
}

BinaryBlob cborEncode(SelfDescribeEncoder serializer, dynamic value) {
  serializer.serialize(value);
  return blobFromBuffer(serializer._out.getData().buffer);
}
