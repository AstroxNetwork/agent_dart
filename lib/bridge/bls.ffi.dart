import 'dart:typed_data';

import 'package:agent_dart/bridge/bls.base.dart';
import 'ffi/ffi.dart';

class FFIBls implements BaseBLS {
  late bool _isInit = false;

  @override
  Future<bool> blsInit() async {
    _isInit = await AgentDartFFI.impl.blsInit();
    return _isInit;
  }

  @override
  Future<bool> blsVerify(
    Uint8List pk,
    Uint8List sig,
    Uint8List msg,
  ) {
    return AgentDartFFI.impl.blsVerify(
      req: BLSVerifyReq(signature: sig, message: msg, publicKey: pk),
    );
  }

  @override
  bool get isInit => _isInit;
}

BaseBLS createBLS() => FFIBls();
