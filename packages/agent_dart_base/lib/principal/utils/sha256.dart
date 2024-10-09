import 'dart:typed_data';

import 'package:crypto/crypto.dart';

// ignore: implementation_imports
import 'package:crypto/src/digest_sink.dart';

import '../../utils/number.dart';

Uint8List sha256Hash(ByteBuffer buf) {
  return SHA256().update(buf.asUint8List()).toUint8List();
}

class SHA256 {
  SHA256();

  late final ds = DigestSink();
  late final sha = sha256.startChunkedConversion(ds);

  SHA256 update(List<int> bytes) {
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
