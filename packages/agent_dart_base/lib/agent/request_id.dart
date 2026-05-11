import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:typed_data/typed_buffers.dart';

import '../../principal/principal.dart';
import '../../utils/extension.dart';
import '../../utils/u8a.dart';
import 'agent/index.dart';
import 'types.dart';
import 'utils/leb128.dart';

/// Interface for values that can produce a representation-independent hash.
@immutable
abstract class ToHashable {
  /// Creates a hashable value.
  const ToHashable();

  /// Returns the value to feed into request ID hashing.
  dynamic Function() toHash();
}

/// Converts a request ID to hex.
String requestIdToHex(RequestId requestId) {
  return blobToHex(requestId);
}

/// Computes a SHA-256 hash of [data].
BinaryBlob hash(Uint8List data) {
  final hashed = sha256.convert(data).bytes;
  return Uint8List.fromList(hashed);
}

/// Computes a SHA-256 hash of [value] encoded as UTF-8.
BinaryBlob hashString(String value) {
  return hash(Uint8List.fromList(value.plainToU8a()));
}

/// Concatenates multiple binary blobs.
BinaryBlob concat(List<BinaryBlob> bs) {
  return blobFromBuffer(u8aConcat(bs.map((b) => b.buffer).toList()).buffer);
}

/// Computes the representation-independent hash of a supported value.
BinaryBlob hashValue(dynamic value) {
  if (value is String) {
    return hashString(value);
  } else if (value is num) {
    return hash(lebEncode(value));
  } else if (value is Uint8List) {
    return hash(value);
  } else if (value is Uint8Buffer) {
    return hash(Uint8List.fromList(value));
  } else if (value is List && (value is! Uint8List)) {
    final vals = value.map(hashValue).toList();
    return hash(concat(vals));
  } else if (value is Principal) {
    return hash(value.toUint8List());
  } else if (value is ToHashable) {
    return hashValue(value.toHash());
    // TODO: This should be move to a specific async method as the webauthn flow required
    // the flow to be synchronous to ensure Safari touch id works.
    // } else if (value instanceof Promise) {
    //   return value.then(x => hashValue(x));
  } else if (value is BigInt) {
    // Do this check much later than the other bigint check because this one is much less
    // type-safe.
    // So we want to try all the high-assurance type guards before this 'probable' one.
    return hash(lebEncode(value));
  } else if (value is Expiry) {
    return hashValue(value.toHash());
  } else if (value is ByteBuffer) {
    return hashValue(value.asUint8List());
  }
  throw UnsupportedError(
    'Attempt to hash a value of unsupported type: $value.',
  );
}

/// Compares two lists lexicographically using the elements' natural order.
int compareLists<T extends Comparable<T>>(List<T> a, List<T> b) {
  final aLength = a.length;
  final bLength = b.length;
  final minLength = aLength < bLength ? aLength : bLength;
  for (int i = 0; i < minLength; i++) {
    final result = a[i].compareTo(b[i]);
    if (result != 0) return result;
  }
  return aLength - bLength;
}

/// Compares two lists lexicographically using a custom comparator.
int compareListsBy<T>(List<T> a, List<T> b, int Function(T a, T b) compare) {
  final aLength = a.length;
  final bLength = b.length;
  final minLength = aLength < bLength ? aLength : bLength;
  for (int i = 0; i < minLength; i++) {
    final result = compare(a[i], b[i]);
    if (result != 0) return result;
  }
  return aLength - bLength;
}

/// Adds lexicographic comparison with a custom comparator to lists.
extension CompareListExtension<T> on List<T> {
  /// Compares this list to [other] using [compare].
  int compare(List<T> other, int Function(T a, T b) compare) =>
      compareListsBy<T>(this, other, compare);
}

/// Adds lexicographic comparison to lists of comparable values.
extension CompareListComparableExtension<T extends Comparable<T>> on List<T> {
  /// Compares this list to [other] using natural ordering or [compare].
  int compare(List<T> other, [int Function(T a, T b)? compare]) =>
      compareListsBy<T>(this, other, compare!);
}

/// Get the RequestId of the provided ic-ref request.
/// RequestId is the result of the representation-independent-hash function.
/// https://sdk.dfinity.org/docs/interface-spec/index.html#hash-of-map
/// @param request - ic-ref request to hash into RequestId
RequestId requestIdOf(Map<String, dynamic> request) {
  final hashed = request.entries.where((e) => e.value != null).map((e) {
    final hashedKey = hashString(e.key);
    final hashedValue = hashValue(e.value);
    return [hashedKey, hashedValue];
  }).toList();
  hashed.sort((k1, k2) {
    return k1.compare(k2, (a, b) => a.compare(b, (c, d) => c - d));
  });
  final concatenated = u8aConcat(hashed.map((d) => u8aConcat(d)).toList());
  return RequestId.fromList(hash(concatenated));
}
