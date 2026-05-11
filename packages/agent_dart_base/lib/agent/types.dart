import 'dart:math';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../utils/extension.dart';
import 'utils/leb128.dart';

/// HTTP methods supported by the agent transport layer.
enum FetchMethod {
  get,
  head,
  post,
  put,
  delete,
  connect,
  options,
  trace,
  patch,
}

/// Request status values returned by the replica read-state endpoint.
enum RequestStatusResponseStatus {
  received,
  processing,
  replied,
  rejected,
  unknown,
  done;

  /// Parses a request status from its wire-format [value].
  factory RequestStatusResponseStatus.fromName(String value) {
    return values.singleWhere((e) => e.name == value);
  }
}

/// Semantic blob categories used by agent request helpers.
enum BlobType { binary, der, nonce, requestId }

/// Base type for strongly labelled binary blobs.
@immutable
abstract class BaseBlob {
  /// Creates a blob wrapper with type and name metadata.
  const BaseBlob(
    Uint8List buffer,
    this.blobType,
    this.blobName,
  ) : _buffer = buffer;

  final Uint8List _buffer;
  /// Semantic type of this blob.
  final BlobType blobType;

  /// Human-readable blob name.
  final String blobName;

  /// Raw bytes for this blob.
  Uint8List get buffer => _buffer;

  /// Number of bytes in this blob.
  int get byteLength;
}

/// Raw binary blob used by agent request encoding.
typedef BinaryBlob = Uint8List;

/// DER-encoded binary blob.
typedef DerEncodedBlob = BinaryBlob;

/// Request nonce bytes.
typedef Nonce = BinaryBlob;

/// Request ID bytes.
typedef RequestId = BinaryBlob;

/// Convenience extension for binary blob metadata and copying.
extension ExtBinaryBlob on BinaryBlob {
  /// Marker name used by CBOR encoding helpers.
  String get name => '__BLOB';

  /// Blob type for raw binary blobs.
  BlobType get blobType => BlobType.binary;

  /// Number of bytes in this blob.
  int get byteLength => lengthInBytes;

  /// Returns a copy of [other].
  static Uint8List from(Uint8List other) => Uint8List.fromList(other);
}

/// Creates a [BinaryBlob] from a byte buffer.
BinaryBlob blobFromBuffer(ByteBuffer b) {
  return BinaryBlob.fromList(b.asUint8List());
}

/// Creates a [BinaryBlob] from a [Uint8List].
BinaryBlob blobFromUint8Array(Uint8List arr) {
  return BinaryBlob.fromList(arr);
}

/// Creates a UTF-8 [BinaryBlob] from [text].
BinaryBlob blobFromText(String text) {
  return BinaryBlob.fromList(text.plainToU8a(useDartEncode: true));
}

/// Creates a [BinaryBlob] from a 32-bit integer array.
BinaryBlob blobFromUint32Array(Uint32List arr) {
  return BinaryBlob.fromList(arr.buffer.asUint8List());
}

/// Treats [blob] as DER-encoded bytes.
DerEncodedBlob derBlobFromBlob(BinaryBlob blob) {
  return DerEncodedBlob.fromList(blob);
}

/// Parses a hex string into a [BinaryBlob].
BinaryBlob blobFromHex(String hex) {
  return BinaryBlob.fromList(hex.toU8a());
}

/// Converts a [BinaryBlob] to hex.
String blobToHex(BinaryBlob blob) {
  return blob.toHex();
}

/// Copies a [BinaryBlob] into a [Uint8List].
Uint8List blobToUint8Array(BinaryBlob blob) {
  return Uint8List.fromList(blob.sublist(0, blob.byteLength));
}

/// Creates a request nonce from the current timestamp and secure randomness.
Nonce makeNonce() {
  return Nonce.fromList(
    lebEncode(
      BigInt.from(DateTime.now().millisecondsSinceEpoch) * BigInt.from(100000) +
          BigInt.from((Random.secure().nextInt(1) * 100000).floor()),
    ),
  );
}
