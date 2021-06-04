import 'dart:typed_data';
import 'dart:math';
import 'package:agent_dart/utils/extension.dart';

import 'utils/leb128.dart';

// ignore: constant_identifier_names
enum BlobType { binary, der, nonce, requestId }

abstract class BaseBlob {
  late final Uint8List _buffer;
  late BlobType blobType;
  late String blobName;
  Uint8List get buffer => _buffer;
  int get byteLength;
}

class BinaryBlob extends BaseBlob {
  BinaryBlob(Uint8List buffer) {
    _buffer = buffer;
    blobName = "__BLOB";
    blobType = BlobType.binary;
  }

  @override
  int get byteLength => buffer.lengthInBytes;

  String toJson() {
    return _buffer.toString();
  }
}

class DerEncodedBlob extends BinaryBlob {
  DerEncodedBlob(Uint8List buffer) : super(buffer) {
    blobName = "__DER_BLOB";
    blobType = BlobType.der;
  }
}

class Nonce extends BinaryBlob {
  Nonce(Uint8List buffer) : super(buffer) {
    blobName = "__nonce__";
    blobType = BlobType.nonce;
  }
}

class RequestId extends BinaryBlob {
  RequestId(Uint8List buffer) : super(buffer) {
    blobName = "__requestId__";
    blobType = BlobType.requestId;
  }
}

BinaryBlob blobFromBuffer(ByteBuffer b) {
  return BinaryBlob(b.asUint8List());
}

BinaryBlob blobFromUint8Array(Uint8List arr) {
  return BinaryBlob(arr);
}

BinaryBlob blobFromText(String text) {
  return BinaryBlob(text.plainToU8a(useDartEncode: true));
}

BinaryBlob blobFromUint32Array(Uint32List arr) {
  return BinaryBlob(arr.buffer.asUint8List());
}

DerEncodedBlob derBlobFromBlob(BinaryBlob blob) {
  return DerEncodedBlob(blob.buffer);
}

BinaryBlob blobFromHex(String hex) {
  return BinaryBlob(hex.toU8a());
}

String blobToHex(BinaryBlob blob) {
  return blob.buffer.toHex(include0x: false);
}

Uint8List blobToUint8Array(BinaryBlob blob) {
  return Uint8List.fromList(blob.buffer.sublist(0, blob.byteLength));
}

Nonce makeNonce() {
  return Nonce(lebEncode(
    BigInt.from(DateTime.now().millisecondsSinceEpoch) * BigInt.from(100000) +
        BigInt.from((Random.secure().nextInt(1) * 100000).floor()),
  ));
}
