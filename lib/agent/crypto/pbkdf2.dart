import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:agent_dart/agent/crypto/bls.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:ffi/ffi.dart';

Future<String> pbkdf2(String data, String salt, int rounds) async {
  // ignore: unnecessary_null_comparison
  if (dylib == null) throw "ERROR: The library is not initialized 🙁";
  final response = ReceivePort();
  await Isolate.spawn(
    _isolatePbkdf2,
    response.sendPort,
    onExit: response.sendPort,
  );
  final sendPort = await response.first as SendPort;
  final receivePort = ReceivePort();
  sendPort.send([data, salt, rounds, receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    final resultString = result.toString();
    response.close();

    return throwReturn(resultString);
  } catch (e) {
    rethrow;
  }
}

void _isolatePbkdf2(SendPort initialReplyTo) {
  final port = ReceivePort();

  initialReplyTo.send(port.sendPort);

  port.listen((message) async {
    try {
      final data = message[0] as String;
      final salt = message[1] as String;
      final rounds = message[2] as int;
      final send = message.last as SendPort;
      Pointer<Utf8> result = rustPbkdf2(data.plainToHex().hexStripPrefix().toUtf8(),
          salt.plainToHex().hexStripPrefix().toUtf8(), rounds);

      send.send(result.cast<Utf8>().toDartString());
      freeCString(result);
    } catch (e) {
      message.last.send(e);
    }
  });
}

class Pbkdf2Result {
  final Uint8List password;
  final int rounds;
  final Uint8List salt;
  Pbkdf2Result({required this.password, required this.rounds, required this.salt});
}

Future<Pbkdf2Result> pbkdf2Encode(String passphrase, Uint8List salt, [int rounds = 2048]) async {
  final u8aPass = passphrase.plainToU8a();
  final password = await pbkdf2(u8aPass.u8aToString(), salt.u8aToString(), rounds);

  return Pbkdf2Result(password: password.toU8a(), rounds: rounds, salt: salt);
}
