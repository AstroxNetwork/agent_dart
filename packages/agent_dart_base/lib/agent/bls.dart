import 'dart:typed_data';

import 'package:agent_dart_ffi/agent_dart_ffi.dart' as ffi;

/// Wrapper around native BLS initialization and verification.
class AgentBLS {
  /// Creates a BLS helper.
  AgentBLS();

  /// Whether the native BLS library has been initialized.
  bool get isInit => _isInit;
  late bool _isInit = false;

  /// Initializes the native BLS implementation.
  Future<bool> blsInit() async {
    _isInit = await ffi.blsInit();
    return _isInit;
  }

  /// Verifies a BLS [sig] over [msg] with public key [pk].
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
