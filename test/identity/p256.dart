import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/identity/p256.dart';
import 'package:agent_dart/identity/secp256k1.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:agent_dart/utils/extension.dart';

void main() {
  p256Test();
}

void p256Test() {
  const prv =
      '4af1bceebf7f3634ec3cff8a2c38e51178d5d4ce585c52d6043e5e2cc3418bb0';
  const msg = 'Hello world';

  test('sign', () async {
    final res = await signP256Async(
      msg.plainToU8a(),
      prv.toU8a(),
    );
    final derSig = wrapDerSignature(res);
    final unWrapDer = unwrapDerSignature(derSig);
    expect(unWrapDer.toHex(), res.toHex());
    final pub = (await P256Identity.fromSecretKey(prv.toU8a())).getPublicKey();

    expect(res.length, 64);

    final isValid = await verifyP256Async(
      msg.plainToU8a(),
      res,
      pub,
    );
    expect(isValid, true);
  });

  test('ffi', () async {
    final key = await getECKeysAsync(generateMnemonic());

    final derExpect = P256PublicKey.fromRaw(key.ecP256PublicKey!).toDer();
    print(derExpect.toHex());

    expect(
      derExpect.toHex(),
      P256PublicKey.fromDer(await getP256DerPubFromFFI(key.ecPrivateKey!))
          .toDer()
          .toHex(),
    );

    final testSig =
        ('3045022063de4381640b62f0f563ebd1723faacb5d147262b1ab9ae2cf174ea0e096bc3a022100a8dcc496fb5d92ab2c91455773d21fc42933ed3231e6d66889c3b4252cf852b4')
            .toU8a();

    final rawSig = unwrapDerSignature(testSig);
    print(await verifyP256Async(
      "Hello world".plainToU8a(),
      rawSig, // rawSig,
      P256PublicKey.fromDer(
        '3059301306072a8648ce3d020106082a8648ce3d030107034200047c453323484efff2779f0c050dd7681a99134c70b9dea729f455f27f7eee7b6e87db17cb4b9541b67f260d713b881f320356da02d9d1747bcd2935f7e3d8f14f'
            .toU8a(),
      ),
    ));
  });
}
