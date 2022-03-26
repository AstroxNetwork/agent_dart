import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:agent_dart/bls/bls.base.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:ffi/ffi.dart';
import 'ffi/ffi.dart';

class FFIBls implements BaseBLS {
  @override
  bool blsInitSync() {
    Pointer<Utf8> result = rustBlsInit();
    final rt = (result.cast<Utf8>().toDartString() == "true");
    freeCString(result);
    return rt;
  }

  @override
  bool blsVerifySync(
    Uint8List pk,
    Uint8List sig,
    Uint8List msg,
  ) {
    Pointer<Utf8> result = rustBlsVerify(
        sig.toHex(include0x: false).toNativeUtf8(),
        msg.toHex(include0x: false).toNativeUtf8(),
        pk.toHex(include0x: false).toNativeUtf8());
    final ret = result.cast<Utf8>().toDartString() == "true";
    freeCString(result);
    return ret;
  }

  @override
  Future<bool> blsInit() async {
    try {
      // ignore: unnecessary_null_comparison
      if (dylib == null) throw "ERROR: The library is not initialized 🙁";
      final response = ReceivePort();
      await Isolate.spawn(
        _isolateBlsInit,
        [response.sendPort],
      );
      return (await response.first) as bool;
    } catch (e) {
      throw "Cannot initialize BLS instance :$e";
    }
  }

  Future<void> _isolateBlsInit(List<dynamic> args) async {
    try {
      SendPort responsePort = args[0];
      Pointer<Utf8> result = rustBlsInit();
      final res = result.cast<Utf8>().toDartString() == "true";
      freeCString(result);
      Isolate.exit(responsePort, res);
    } catch (e) {
      rethrow;
    }
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
      // if (await blsInit() != true) {
      //   throw "ERROR: Cannot initialize BLS instance";
      // }
      final response = ReceivePort();
      await Isolate.spawn(
        _isolateBlsVerify,
        [
          response.sendPort,
          sig.toHex(include0x: false),
          msg.toHex(include0x: false),
          pk.toHex(include0x: false),
        ],
      );
      return (await response.first) as bool;
    } catch (e) {
      throw "Cannot verify bls_verify instance :$e";
    }
  }

  Future<void> _isolateBlsVerify(List<dynamic> args) {
    try {
      SendPort responsePort = args[0];
      final sig = args[1] as String;
      final msg = args[2] as String;
      final pk = args[3] as String;
      Pointer<Utf8> result = rustBlsVerify(
          sig.toNativeUtf8(), msg.toNativeUtf8(), pk.toNativeUtf8());
      final res = result.cast<Utf8>().toDartString() == "true";
      freeCString(result);
      Isolate.exit(responsePort, res);
    } catch (e) {
      rethrow;
    }
  }
}

BaseBLS createBLS() => FFIBls();

String throwReturn(String message) {
  if (message.startsWith("Error:")) {
    throw message;
  } else {
    return message;
  }
}
