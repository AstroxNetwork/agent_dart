import 'dart:typed_data';

import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:test/test.dart';
import '../test_utils.dart';

void main() {
  matchFFI();
  schnorrTest();
}

void schnorrTest() {
  const prv =
      '4af1bceebf7f3634ec3cff8a2c38e51178d5d4ce585c52d6043e5e2cc3418bb0';
  const msg = 'Hello World';

  test('sign', () async {
    final res = await signSchnorrAsync(
      msg.plainToU8a(),
      prv.toU8a(),
      auxRand: Uint8List(32)..fillRange(0, 32, 0),
    );
    expect(res.length, 64);

    final isValid = await verifySchnorrAsync(
      msg.plainToU8a(),
      res,
      (await SchnorrIdentity.fromSecretKey(prv.toU8a())).getPublicKey(),
    );
    expect(isValid, true);
  });

  test('ffi', () async {
    final key = await getECKeysAsync(generateMnemonic());

    final derExpect =
        Secp256k1PublicKey.fromRaw(key.ecSchnorrPublicKey!).toDer();
    expect(
      derExpect.toHex(),
      Secp256k1PublicKey.fromRaw(await getSchnorrPubFromFFI(key.ecPrivateKey!))
          .toDer()
          .toHex(),
    );
  });
}
