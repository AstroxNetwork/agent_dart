import 'dart:ffi';
import 'dart:isolate';

import 'package:agent_dart/utils/extension.dart';
import 'package:ffi/ffi.dart';

import 'bls.dart';
import 'ffi_helper.dart';

Future<String> encryptData(String data, String password) async {
  // ignore: unnecessary_null_comparison
  if (dylib == null) throw "ERROR: The library is not initialized 🙁";
  final response = ReceivePort();
  await Isolate.spawn(
    _isolateEncryptData,
    response.sendPort,
    onExit: response.sendPort,
  );
  final sendPort = await response.first as SendPort;
  final receivePort = ReceivePort();
  sendPort.send([data, password, receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    final resultString = result.toString();
    response.close();

    return throwReturn(resultString);
  } catch (e) {
    rethrow;
  }
}

void _isolateEncryptData(SendPort initialReplyTo) {
  final port = ReceivePort();

  initialReplyTo.send(port.sendPort);

  port.listen((message) async {
    try {
      final data = message[0] as String;
      final password = message[1] as String;

      final send = message.last as SendPort;
      Pointer<Utf8> result = rustEncrypt(data.toUtf8(), password.toUtf8());

      send.send(result.cast<Utf8>().toDartString());
      freeCString(result);
    } catch (e) {
      message.last.send(e);
    }
  });
}

Future<String> decryptData(String encrypted, String password) async {
  // ignore: unnecessary_null_comparison
  if (dylib == null) throw "ERROR: The library is not initialized 🙁";
  final response = ReceivePort();
  await Isolate.spawn(
    _isolateDecryptData,
    response.sendPort,
    onExit: response.sendPort,
  );
  final sendPort = await response.first as SendPort;
  final receivePort = ReceivePort();
  sendPort.send([encrypted, password, receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    final resultString = result.toString();
    response.close();

    return throwReturn(resultString);
  } catch (e) {
    rethrow;
  }
}

void _isolateDecryptData(SendPort initialReplyTo) {
  final port = ReceivePort();

  initialReplyTo.send(port.sendPort);

  port.listen((message) async {
    try {
      final encrypted = message[0] as String;
      final password = message[1] as String;

      final send = message.last as SendPort;
      Pointer<Utf8> result = rustDecrypt(encrypted.toUtf8(), password.toUtf8());

      send.send(result.cast<Utf8>().toDartString());
      freeCString(result);
    } catch (e) {
      message.last.send(e);
    }
  });
}
