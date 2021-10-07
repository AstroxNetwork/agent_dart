import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:typed_data/typed_buffers.dart';

import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:agent_dart/utils/extension.dart';

import 'agent/index.dart';
import 'types.dart';
import 'utils/leb128.dart';

abstract class ToHashable {
  Function toHash();
}

String requestIdToHex(RequestId requestId) {
  return blobToHex(requestId);
}

BinaryBlob hash(Uint8List data) {
  final hashed = sha256.convert(data).bytes;
  return blobFromUint8Array(Uint8List.fromList(hashed));
}

BinaryBlob hashString(String value) {
  return hash(Uint8List.fromList(value.plainToU8a()));
}

BinaryBlob concat(List<BinaryBlob> bs) {
  return blobFromBuffer(u8aConcat(bs.map((b) => b.buffer).toList()).buffer);
}

BinaryBlob hashValue(dynamic value) {
  if (value is String) {
    return hashString(value);
  } else if (value is num) {
    return hash(lebEncode(value));
  } else if (value is Uint8List) {
    return hash(blobFromUint8Array(value));
  } else if (value is Uint8Buffer) {
    return hash(blobFromUint8Array(Uint8List.fromList(value)));
  } else if (value is List && (value is! Uint8List)) {
    final vals = value.map(hashValue).toList();
    return hash(concat(vals));
  } else if (value is Principal) {
    return hash(blobFromUint8Array(value.toUint8Array()));
  } else if (value is Map && (value as ToHashable).toHash is Function) {
    return hashValue((value as ToHashable).toHash());
    // ignore: todo
    // TODO This should be move to a specific async method as the webauthn flow required
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
  throw 'Attempt to hash a value of unsupported type: $value';
}

int compareLists<T extends Comparable<T>>(List<T> a, List<T> b) {
  var aLength = a.length;
  var bLength = b.length;
  var minLength = aLength < bLength ? aLength : bLength;
  for (var i = 0; i < minLength; i++) {
    var result = a[i].compareTo(b[i]);
    if (result != 0) return result;
  }
  return aLength - bLength;
}

int compareListsBy<T>(List<T> a, List<T> b, int Function(T a, T b) compare) {
  var aLength = a.length;
  var bLength = b.length;
  var minLength = aLength < bLength ? aLength : bLength;
  for (var i = 0; i < minLength; i++) {
    var result = compare(a[i], b[i]);
    if (result != 0) return result;
  }
  return aLength - bLength;
}

extension CompareListExtension<T> on List<T> {
  int compare(List<T> other, int Function(T a, T b) compare) =>
      compareListsBy<T>(this, other, compare);
}

extension CompareListComparableExtension<T extends Comparable<T>> on List<T> {
  int compare(List<T> other, [int Function(T a, T b)? compare]) =>
      compareListsBy<T>(this, other, compare!);
}

/// Get the RequestId of the provided ic-ref request.
/// RequestId is the result of the representation-independent-hash function.
/// https://sdk.dfinity.org/docs/interface-spec/index.html#hash-of-map
/// @param request - ic-ref request to hash into RequestId

RequestId requestIdOf(Map<String, dynamic> request) {
  final hashed = request.entries.where((element) => element.value != null).map((e) {
    final hashedKey = hashString(e.key);
    final hashedValue = hashValue(e.value);
    return [hashedKey, hashedValue];
  }).toList();

  hashed.sort((k1, k2) {
    return k1.compare(k2, (a, b) => a.compare(b, (c, d) => c - d));
  });

  var concatenated = u8aConcat(hashed.map((d) => u8aConcat(d)).toList());

  return RequestId.fromList(hash(concatenated));
}
