import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/utils/number.dart';
import 'package:crypto/crypto.dart';
// ignore: implementation_imports
import 'package:crypto/src/digest_sink.dart';

Uint8List sha256Hash(ByteBuffer buf) {
  return SHA256().update(buf.asUint8List()).toU8a();
}

class SHA256 {
  late DigestSink ds;
  late ByteConversionSink sha;

  SHA256() {
    ds = DigestSink();
    sha = sha256.startChunkedConversion(ds);
  }

  SHA256 update(List<int> bytes) {
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
