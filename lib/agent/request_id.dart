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

  // 0a367b92cf0b037dfd89960ee832d56f7fc151681bb41e53690e776f5786998ae52d9c508c502347344d8c07ad91cbd6068afc75ff6292f062a09ca381c89e710a3eb2ba16702a387e6321066dd952db7a31f9b5cc92981e0a92dd56802d3df9b383d88bed6afef63bb62a049c8fc6cc9f01768268a6fcab56b71084668916a026cec6b6a9248a96ab24305b61b9d27e203af14a580a5b1ff2f67575cab4a868 dcd602f0215ce19798689d966f61429d1ee21cf048f31d1d1d676a2442d775a1 293536232cf9231c86002f4ee293176a0179c002daa9fc24be9bb51acdd642b6231bf89d726826891c1578a8ffe06ad898e70ecad4adb07668c2d9beca734b0c769e6f87bdda39c859642b74ce9763cdd37cb1cd672733e8c54efaa33ab78af97edb360f06acaef2cc80dba16cf563f199d347db4443da04da0c8173e3f9e4ed78377b525757b494427f89014f97d79928f3938d14eb51e20fb5dec9834eb3048a851ff82ee7048ad09ec3847f1ddf44944104d2cbd17ef4e3db22c6785a0d45b25f03dedd69be07f356a06fe35c1b0ddc0de77dcd9066c4be0c6bbde14b23ffe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
  // 0a367b92cf0b037dfd89960ee832d56f7fc151681bb41e53690e776f5786998ae52d9c508c502347344d8c07ad91cbd6068afc75ff6292f062a09ca381c89e710a3eb2ba16702a387e6321066dd952db7a31f9b5cc92981e0a92dd56802d3df9b383d88bed6afef63bb62a049c8fc6cc9f01768268a6fcab56b71084668916a026cec6b6a9248a96ab24305b61b9d27e203af14a580a5b1ff2f67575cab4a868 24bd6299a187a443a0af6d19534ea096560c360831a3d03ec52b8776f7ead30c 293536232cf9231c86002f4ee293176a0179c002daa9fc24be9bb51acdd642b6231bf89d726826891c1578a8ffe06ad898e70ecad4adb07668c2d9beca734b0c769e6f87bdda39c859642b74ce9763cdd37cb1cd672733e8c54efaa33ab78af97edb360f06acaef2cc80dba16cf563f199d347db4443da04da0c8173e3f9e4ed78377b525757b494427f89014f97d79928f3938d14eb51e20fb5dec9834eb3048a851ff82ee7048ad09ec3847f1ddf44944104d2cbd17ef4e3db22c6785a0d45b25f03dedd69be07f356a06fe35c1b0ddc0de77dcd9066c4be0c6bbde14b23ffe3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
  return RequestId.fromList(hash(concatenated));
}
