import 'dart:typed_data';

import 'package:agent_dart_base/utils/number.dart';
import 'package:crypto/crypto.dart';

// ignore: implementation_imports
import 'package:crypto/src/digest_sink.dart';

Uint8List sha224Hash(ByteBuffer buf) {
  return SHA224().update(buf.asUint8List()).toUint8List();
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

  Uint8List toUint8List() => Uint8List.fromList(_digest());

  Uint8List digest() => toUint8List();

  @override
  String toString() => bytesToHex(_digest());
}
