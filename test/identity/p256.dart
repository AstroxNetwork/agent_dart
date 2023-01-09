import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/identity/p256.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:agent_dart/utils/extension.dart';

void main() {
  p256Test();
}

void p256Test() {
  const prv =
      '4af1bceebf7f3634ec3cff8a2c38e51178d5d4ce585c52d6043e5e2cc3418bb0';
  const msg = 'Hello World';

  test('sign', () async {
    final res = await signP256Async(
      msg.plainToU8a(),
      prv.toU8a(),
    );
    expect(res.length, 64);

    final isValid = await verifyP256Async(
      msg.plainToU8a(),
      res,
      (await P256Identity.fromSecretKey(prv.toU8a())).getPublicKey(),
    );
    expect(isValid, true);
  });

  test('ffi', () async {
    final key = await getECKeysAsync(generateMnemonic());

    final derExpect = P256PublicKey.fromRaw(key.ecP256PublicKey!).toDer();
    expect(
      derExpect.toHex(),
      P256PublicKey.fromDer(await getP256DerPubFromFFI(key.ecPrivateKey!))
          .toDer()
          .toHex(),
    );
  });
}
