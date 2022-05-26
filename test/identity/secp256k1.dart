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
    var isValid = verify(
        msg,
        res,
        Secp256k1PublicKey.from(
            (await Secp256k1KeyIdentity.fromSecretKey(prv.toU8a()))
                .getPublicKey()));
    expect(isValid, true);
  });
  test('sign', () async {
    var res = await signAsync(msg.plainToU8a(), prv.toU8a());
    expect(res.length, 64);
    var isValid = verify(
        msg,
        res,
        Secp256k1PublicKey.from(
            (await Secp256k1KeyIdentity.fromSecretKey(prv.toU8a()))
                .getPublicKey()));
    expect(isValid, true);
  });

  test('random sign', () async {
    for (var i = 0; i < 10; i += 1) {
      var mne = generateMnemonic();
      var prvR = getECKeys(mne).ecPrivateKey!;
      var wordR = msg;
      var res = sign(
        wordR,
        prvR,
      );
      expect(res.length, 64);

      var isValid = verify(
          wordR,
          res,
          Secp256k1PublicKey.from(
              (await Secp256k1KeyIdentity.fromSecretKey(prvR)).getPublicKey()));
      expect(isValid, true);

      var prvR2 = (await getECKeysAsync(mne)).ecPrivateKey!;

      expect(prvR.toHex(), prvR2.toHex());
      var wordR2 = msg;

      var res2 = await signAsync(
        wordR2.plainToU8a(),
        prvR2,
      );
      expect(res2.length, 64);
      expect(res.toHex(), res2.toHex());

      var isValid2 = verify(
          wordR2,
          res2,
          Secp256k1PublicKey.from(
              (await Secp256k1KeyIdentity.fromSecretKey(prvR2))
                  .getPublicKey()));

      expect(isValid2, true);
    }
  });

  test('ffi', () async {
    final mnemonic = generateMnemonic();
    final seed = mnemonicToSeed(mnemonic, passphrase: "");
    final keys = ecKeysfromSeed(seed, index: 0);
    final derExpect = Secp256k1PublicKey.fromRaw(keys.ecPublicKey!).toDer();
    expect(
        derExpect.toHex(), (await getDerFromFFI(keys.ecPrivateKey!)).toHex());
  });
}
