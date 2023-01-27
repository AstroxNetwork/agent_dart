import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/identity/secp256k1.dart';
import 'package:agent_dart/principal/utils/sha256.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:agent_dart/utils/extension.dart';

void main() {
  secp256k1Test();
}

void secp256k1Test() {
  const prv =
      '4af1bceebf7f3634ec3cff8a2c38e51178d5d4ce585c52d6043e5e2cc3418bb0';
  const msg = 'Hello World';

  test('sign', () async {
    final res = signSecp256k1(msg, prv.toU8a());
    expect(res.length, 64);
    final isValid = verifySecp256k1(
      msg,
      res,
      Secp256k1PublicKey.from(
        (await Secp256k1KeyIdentity.fromSecretKey(prv.toU8a())).getPublicKey(),
      ),
    );
    expect(isValid, true);
  });
  test('sign', () async {
    final res = await signSecp256k1Async(msg.plainToU8a(), prv.toU8a());
    expect(res.length, 64);

    final pubKey = Secp256k1PublicKey.from(
      (await Secp256k1KeyIdentity.fromSecretKey(prv.toU8a())).getPublicKey(),
    );
    final isValid = verifySecp256k1(
      msg,
      res,
      pubKey,
    );
    expect(isValid, true);
  });

  test('random sign', () async {
    for (int i = 0; i < 1; i += 1) {
      final mne = generateMnemonic();
      final prvR = getECKeys(mne).ecPrivateKey!;
      const wordR = msg;
      final res = signSecp256k1(
        wordR,
        prvR,
      );
      expect(res.length, 64);

      final isValid = verifySecp256k1(
        wordR,
        res,
        Secp256k1PublicKey.from(
          (await Secp256k1KeyIdentity.fromSecretKey(prvR)).getPublicKey(),
        ),
      );
      expect(isValid, true);

      final prvR2 = (await getECKeysAsync(mne)).ecPrivateKey!;

      expect(prvR.toHex(), prvR2.toHex());
      const wordR2 = msg;

      final res2 = await signSecp256k1Async(
        wordR2.plainToU8a(),
        prvR2,
      );
      expect(res2.length, 64);
      expect(res.toHex(), res2.toHex());

      final isValid2 = verifySecp256k1(
        wordR2,
        res2,
        Secp256k1PublicKey.from(
          (await Secp256k1KeyIdentity.fromSecretKey(prvR2)).getPublicKey(),
        ),
      );

      expect(isValid2, true);
    }
  });

  test('ffi', () async {
    final mnemonic = generateMnemonic();
    final seed = mnemonicToSeed(mnemonic);
    final keys = ecKeysfromSeed(seed);
    final derExpect = Secp256k1PublicKey.fromRaw(keys.ecPublicKey!).toDer();
    final rawExpect = Secp256k1PublicKey.derDecode(derExpect);
    expect(
        rawExpect.toHex(),
        Secp256k1PublicKey.derDecode(await getDerFromFFI(keys.ecPrivateKey!))
            .toHex());
    expect(
      derExpect.toHex(),
      (await getDerFromFFI(keys.ecPrivateKey!)).toHex(),
    );
  });
  test('ffi ecdh share secret', () async {
    final key1 = await getECKeysAsync(generateMnemonic());
    final key2 = await getECKeysAsync(generateMnemonic());
    final ss = await getECShareSecret(
      key1.ecPrivateKey!,
      key2.ecPublicKey!,
    );
    final ss2 = await getECShareSecret(
      key2.ecPrivateKey!,
      key1.ecPublicKey!,
    );

    expect(ss2.toHex(), ss.toHex());
  });

  test('recover pubkey', () async {
    const message =
        '879a053d4800c6354e76c7985a865d2922c82fb5b3f4577b2fe08b998954f2e0';

    const signatures =
        '8ea8ec3af6234ce47a431e0bbb525a41c725b40a2d59921d98580b914fc438934a47284e5e90fcff763db5442cae37787683c85a9b3fe59af897b797e06374dd1c';

    final pub =
        await recoverSecp256k1PubKey(message.toU8a(), signatures.toU8a());
    print(pub.toHex());
  });
}
