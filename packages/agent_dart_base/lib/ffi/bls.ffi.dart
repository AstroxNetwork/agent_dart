import 'dart:typed_data';

import 'bls.base.dart';

class FFIBls implements BaseBLS {
  late bool _isInit = false;

  @override
  Future<bool> blsInit() async {
    _isInit = await blsInit();
    return _isInit;
  }

  @override
  Future<bool> blsVerify(
    Uint8List pk,
    Uint8List sig,
    Uint8List msg,
  ) {
    return blsVerify(pk, sig, msg);
  }

  @override
  bool get isInit => _isInit;
}

BaseBLS createBLS() => FFIBls();
