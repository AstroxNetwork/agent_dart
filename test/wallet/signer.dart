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
    var acc2_create_time = DateTime.now();
    var acc2 = ICPSigner.fromPhrase(mne2);
    var acc2_time_period = DateTime.now().millisecondsSinceEpoch -
        acc2_create_time.millisecondsSinceEpoch;

    var acc21_create_time = DateTime.now();
    var acc21 = ICPSigner.fromPhrase(mne2, curveType: CurveType.ED25519);
    var acc21_time_period = DateTime.now().millisecondsSinceEpoch -
        acc21_create_time.millisecondsSinceEpoch;

    var acc22_create_time = DateTime.now();
    var acc22 = ICPSigner.fromPhrase(mne2, curveType: CurveType.SECP256K1);
    var acc22_time_period = DateTime.now().millisecondsSinceEpoch -
        acc22_create_time.millisecondsSinceEpoch;

    expect(acc21_time_period < acc2_time_period, true);
    expect(acc22_time_period < acc2_time_period, true);
    expect(acc21_time_period < acc22_time_period, true);

    var acc3 = expect(acc2.account.ecKeys?.accountId!.toHex(),
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
    var decryptedCborPhrase =
        await decryptCborPhrase(encryptedCborPhrase, "123");
    expect(decryptedCborPhrase, mne2);
  });
}
