import 'dart:typed_data';
import 'dart:math';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/u8a.dart';

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

typedef BinaryBlob = Uint8List;
typedef DerEncodedBlob = BinaryBlob;
typedef Nonce = BinaryBlob;
typedef RequestId = BinaryBlob;

extension ExtBinaryBlob on BinaryBlob {
  String get name => "__BLOB";
  BlobType get blobType => BlobType.binary;
  int get byteLength => lengthInBytes;
  static Uint8List from(Uint8List other) => Uint8List.fromList(other);
}

// class BinaryBlob extends BaseBlob {
//   BinaryBlob(Uint8List buffer) {
//     _buffer = buffer;
//     blobName = "__BLOB";
//     blobType = BlobType.binary;
//   }

//   @override
//   int get byteLength => buffer.lengthInBytes;

//   String toJson() {
//     return _buffer.toString();
//   }

//   @override
//   String toString() {
//     return toJson();
//   }

//   @override
//   bool operator ==(Object other) {
//     if (other is BinaryBlob) {
//       return u8aEq(buffer, other.buffer);
//     } else if (other is Uint8List) {
//       return u8aEq(buffer, other);
//     }
//     return false;
//   }

//   @override
//   // TODO: implement hashCode
//   // ignore: unnecessary_overrides
//   int get hashCode => super.hashCode;
// }

// class DerEncodedBlob extends BinaryBlob {
//   DerEncodedBlob(Uint8List buffer) : super(buffer) {
//     blobName = "__DER_BLOB";
//     blobType = BlobType.der;
//   }
// }

// class Nonce extends BinaryBlob {
//   Nonce(Uint8List buffer) : super(buffer) {
//     blobName = "__nonce__";
//     blobType = BlobType.nonce;
//   }
// }

// class RequestId extends BinaryBlob {
//   RequestId(Uint8List buffer) : super(buffer) {
//     blobName = "__requestId__";
//     blobType = BlobType.requestId;
//   }
// }

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
