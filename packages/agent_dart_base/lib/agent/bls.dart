import 'dart:typed_data';

import 'package:agent_dart_ffi/agent_dart_ffi.dart' as ffi;

class AgentBLS {
  AgentBLS();

  bool get isInit => _isInit;
  late bool _isInit = false;

  Future<bool> blsInit() async {
    _isInit = await ffi.blsInit();
    return _isInit;
  }

  Future<bool> blsVerify(
    Uint8List pk,
    Uint8List sig,
    Uint8List msg,
  ) {
    return ffi.blsVerify(
      req: ffi.BLSVerifyReq(publicKey: pk, signature: sig, message: msg),
    );
  }
}
