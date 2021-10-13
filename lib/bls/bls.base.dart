import 'dart:typed_data';
// ignore: unused_import
import 'bls.stub.dart'
    if (dart.library.io) 'bls.ffi.dart'
    if (dart.library.html) 'bls.web.dart';

abstract class BaseBLS {
  /// factory constructor to return the correct implementation.
  factory BaseBLS() => createBLS();
  bool blsInitSync();
  bool blsVerifySync(
    Uint8List pk,
    Uint8List sig,
    Uint8List msg,
  );
  Future<bool> blsInit();
  Future<bool> blsVerify(
    Uint8List pk,
    Uint8List sig,
    Uint8List msg,
  );
}
