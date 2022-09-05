import 'dart:typed_data';

import 'package:agent_dart/utils/number.dart';
import 'package:crypto/crypto.dart';

// ignore: implementation_imports
import 'package:crypto/src/digest_sink.dart';

Uint8List sha224Hash(ByteBuffer buf) {
  return SHA224().update(buf.asUint8List()).toU8a();
}

class SHA224 {
  SHA224() : ds = DigestSink();
  final DigestSink ds;
  late final sha = sha224.startChunkedConversion(ds);

  SHA224 update(List<int> bytes) {
    sha.add(bytes);
    return this;
  }

  List<int> _digest() {
    sha.close();
    return ds.value.bytes;
  }

  @override
  String toString() {
    var bytes = _digest();
    return bytesToHex(bytes);
  }

  Uint8List toU8a() {
    var bytes = _digest();
    return Uint8List.fromList(bytes);
  }

  Uint8List digest() {
    return toU8a();
  }
}
