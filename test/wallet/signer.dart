import 'dart:convert';

import 'package:agent_dart/agent/crypto/keystore/api.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  signerTest();
}

void signerTest() {
  test('encodes properly', () async {
    var mne2 =
        'open jelly jeans corn ketchup supreme brief element armed lens vault weather original scissors rug priority vicious lesson raven spot gossip powder person volcano';
    var acc2 = ICPSigner.fromPhrase(mne2);

    expect(acc2.account.ecKeys?.accountId!.toHex(),
        "02f2326544f2040d3985e31db5e7021402c541d3cde911cd20e951852ee4da47");
    expect(acc2.account.identity?.accountId.toHex(),
        "7910af41c53cddb31862f0fa2c31cbd58db9645d90ffb875c7abc8c9");

    await acc2.lock("123");
    expect(acc2.isLocked, true);
    expect(acc2.account.identity, null);
    expect(acc2.account.ecKeys, null);

    await acc2.unlock("123");
    expect(acc2.isLocked, false);
    expect(acc2.account.identity?.accountId.toHex(),
        "7910af41c53cddb31862f0fa2c31cbd58db9645d90ffb875c7abc8c9");
    expect(acc2.account.ecKeys?.accountId!.toHex(),
        "02f2326544f2040d3985e31db5e7021402c541d3cde911cd20e951852ee4da47");

    var encryptedPhrase = await encodePhrase(mne2, "123");
    var decryptedPhrase =
        await decodePhrase(jsonDecode(encryptedPhrase), "123");
    expect(decryptedPhrase, mne2);
    var encryptedCborPhrase = await encryptCborPhrase(mne2, "123");
    var decryptedCborPhrase = await decryptCborPhrase(encryptedCborPhrase, "123");
    expect(decryptedCborPhrase, mne2);
  });
}
