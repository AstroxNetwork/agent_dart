import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/identity/secp256k1.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:agent_dart/utils/extension.dart';

void main() {
  secp256k1Test();
}

void secp256k1Test() {
  var prv = '4af1bceebf7f3634ec3cff8a2c38e51178d5d4ce585c52d6043e5e2cc3418bb0';
  var msg = 'Hello World';

  test('sign', () async {
    var res = sign(msg, prv.toU8a());
    expect(res.length, 64);
    var isValid = verify(msg, res,
        Secp256k1PublicKey.from(Secp256k1KeyIdentity.fromSecretKey(prv.toU8a()).getPublicKey()));
    expect(isValid, true);
  });
}
