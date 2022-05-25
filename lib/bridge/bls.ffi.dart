import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:agent_dart/bridge/bls.base.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:ffi/ffi.dart';
import 'ffi/ffi.dart';

class FFIBls implements BaseBLS {
  late bool _isInit = false;
  @override
  Future<bool> blsInit() async {
    _isInit = await dylib.blsInit();
    return _isInit;
  }

  @override
  Future<bool> blsVerify(
    Uint8List pk,
    Uint8List sig,
    Uint8List msg,
  ) async {
    try {
      // ignore: unnecessary_null_comparison
      if (dylib == null) throw "ERROR: The library is not initialized 🙁";
      return await dylib.blsVerify(sig: sig, m: msg, w: pk);
    } catch (e) {
      throw "Cannot verify bls_verify instance :$e";
    }
  }

  @override
  bool get isInit => _isInit;
}

BaseBLS createBLS() => FFIBls();

String throwReturn(String message) {
  if (message.startsWith("Error:")) {
    throw message;
  } else {
    return message;
  }
}
