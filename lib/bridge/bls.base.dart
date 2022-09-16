import 'dart:typed_data';

import 'bls.stub.dart'
    if (dart.library.io) 'bls.ffi.dart'
    if (dart.library.html) 'bls.web.dart';

abstract class BaseBLS {
  /// factory constructor to return the correct implementation.
  factory BaseBLS() => createBLS();

  bool get isInit;

  Future<bool> blsInit();

  Future<bool> blsVerify(Uint8List pk, Uint8List sig, Uint8List msg);
}
