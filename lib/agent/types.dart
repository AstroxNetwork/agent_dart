import 'dart:typed_data';
import 'dart:math';
import 'package:agent_dart/utils/extension.dart';

import 'utils/leb128.dart';


enum BlobType { binary, der, nonce, requestId }

abstract class BaseBlob {
  late final Uint8List _buffer;
  late BlobType blobType;
  late String blobName;
  Uint8List get buffer => _buffer;
  int get byteLength;
}

typedef BinaryBlob = Uint8List;
typedef DerEncodedBlob = BinaryBlob;
typedef Nonce = BinaryBlob;
typedef RequestId = BinaryBlob;

extension ExtBinaryBlob on BinaryBlob {
  String get name => '__BLOB';
  BlobType get blobType => BlobType.binary;
  int get byteLength => lengthInBytes;
  static Uint8List from(Uint8List other) => Uint8List.fromList(other);
}

BinaryBlob blobFromBuffer(ByteBuffer b) {
  return BinaryBlob.fromList(b.asUint8List());
}

BinaryBlob blobFromUint8Array(Uint8List arr) {
  return BinaryBlob.fromList(arr);
}

BinaryBlob blobFromText(String text) {
  return BinaryBlob.fromList(text.plainToU8a(useDartEncode: true));
}

BinaryBlob blobFromUint32Array(Uint32List arr) {
  return BinaryBlob.fromList(arr.buffer.asUint8List());
}

DerEncodedBlob derBlobFromBlob(BinaryBlob blob) {
  return DerEncodedBlob.fromList(blob);
}

BinaryBlob blobFromHex(String hex) {
  return BinaryBlob.fromList(hex.toU8a());
}

String blobToHex(BinaryBlob blob) {
  return blob.toHex(include0x: false);
}

Uint8List blobToUint8Array(BinaryBlob blob) {
  return Uint8List.fromList(blob.sublist(0, blob.byteLength));
}

Nonce makeNonce() {
  return Nonce.fromList(lebEncode(
    BigInt.from(DateTime.now().millisecondsSinceEpoch) * BigInt.from(100000) +
        BigInt.from((Random.secure().nextInt(1) * 100000).floor()),
  ));
}
