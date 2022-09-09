import 'dart:typed_data';

import '../bridge/ffi/ffi.dart';

Future<Uint8List> keccak256(Uint8List message) async {
  return await AgentDartFFI.instance
      .keccak256Encode(req: KeccakReq(message: message));
}
