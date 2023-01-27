import 'dart:convert';

import 'package:agent_dart/agent/crypto/index.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/identity/secp256k1.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encodes properly', () async {
    const mne =
        'drama catch young miss please high blanket animal armor outdoor capital page';

    final key1 = await getECKeysAsync(mne);
    final key2 = await getECKeysAsync(mne, index: 1);

    final id1 = await Secp256k1KeyIdentity.fromSecretKey(key1.ecPrivateKey!);
    final id2 = await Secp256k1KeyIdentity.fromSecretKey(key2.ecPrivateKey!);

    print(id1.getPrincipal().toText());
    print(id2.getPrincipal().toText());

    const message =
        'usage depart wait tiny depart edit another rebuild ginger panel injury share';

    final encryptedResult = await encryptMessage(
      identity: id1,
      theirPublicKey: id2.getPublicKey(),
      text: message,
    );

    final decryptedResult = await decryptMessage(
      identity: id2,
      theirPublicKey: id1.getPublicKey(),
      cipherText: encryptedResult.content,
    );
    expect(message, decryptedResult);
  });
  test('p256 encrypt/decrypt ECIES', () async {
    const mne =
        'drama catch young miss please high blanket animal armor outdoor capital page';

    final key1 = await getECKeysAsync(mne);
    final key2 = await getECKeysAsync(mne, index: 1);

    final id1 = await P256Identity.fromSecretKey(key1.ecPrivateKey!);
    final id2 = await P256Identity.fromSecretKey(key2.ecPrivateKey!);

    print(id1.getPrincipal().toText());
    print(id2.getPrincipal().toText());

    const message =
        'usage depart wait tiny depart edit another rebuild ginger panel injury share';

    final encryptedResult = await encryptP256Message(
      identity: id1,
      theirPublicKey: id2.getPublicKey(),
      text: message,
    );

    final decryptedResult = await decryptP256Message(
      identity: id2,
      theirPublicKey: id1.getPublicKey(),
      cipherText: encryptedResult.content,
    );
    expect(message, decryptedResult);
  });
}
