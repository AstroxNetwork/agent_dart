import 'dart:convert';

import 'package:agent_dart/agent/crypto/keystore/api.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/wallet/phrase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encodes properly', () async {
    const mne2 = 'open jelly jeans corn ketchup supreme brief element '
        'armed lens vault weather original scissors rug priority '
        'vicious lesson raven spot gossip powder person volcano';
    var acc2CreateTime = DateTime.now();
    final acc2 = await ICPSigner.fromPhrase(mne2, curveType: CurveType.all);
    var acc2TimePeriod = DateTime.now().millisecondsSinceEpoch -
        acc2CreateTime.millisecondsSinceEpoch;

    var acc21CreateTime = DateTime.now();
    final acc21 =
        await ICPSigner.fromPhrase(mne2, curveType: CurveType.ed25519);
    var acc21TimePeriod = DateTime.now().millisecondsSinceEpoch -
        acc21CreateTime.millisecondsSinceEpoch;

    var acc22CreateTime = DateTime.now();
    final acc22 =
        await ICPSigner.fromPhrase(mne2, curveType: CurveType.secp256k1);
    var acc22TimePeriod = DateTime.now().millisecondsSinceEpoch -
        acc22CreateTime.millisecondsSinceEpoch;

    expect(acc21TimePeriod < acc2TimePeriod, true);
    expect(acc22TimePeriod < acc2TimePeriod, true);
    expect(acc2.account.identity != null, true);
    expect(acc2.account.ecIdentity != null, true);
    expect(acc21.account.ecIdentity, null);
    expect(acc22.account.identity, null);

    expect(
      acc2.account.ecKeys?.accountId!.toHex(),
      '02f2326544f2040d3985e31db5e7021402c541d3cde911cd20e951852ee4da47',
    );
    expect(
      acc2.account.identity?.accountId.toHex(),
      '2636e2e67910af41c53cddb31862f0fa2c31cbd58db9645d90ffb875c7abc8c9',
    );

    await acc2.lock('123');
    expect(acc2.isLocked, true);
    expect(acc2.account.identity, null);
    expect(acc2.account.ecKeys, null);

    await acc2.unlock('123');
    expect(acc2.isLocked, false);
    expect(
      acc2.account.identity?.accountId.toHex(),
      '2636e2e67910af41c53cddb31862f0fa2c31cbd58db9645d90ffb875c7abc8c9',
    );
    expect(
      acc2.account.ecKeys?.accountId!.toHex(),
      '02f2326544f2040d3985e31db5e7021402c541d3cde911cd20e951852ee4da47',
    );

    var encryptedPhrase = await encodePhrase(mne2, '123');
    var decryptedPhrase = await decodePhrase(
      jsonDecode(encryptedPhrase),
      '123',
    );
    expect(decryptedPhrase, mne2);
    var encryptedCborPhrase = await encryptCborPhrase(mne2, '123');

    var decryptedCborPhrase = await decryptCborPhrase(
      encryptedCborPhrase,
      '123',
    );
    expect(decryptedCborPhrase, mne2);

    final p = Phrase.fromString(mne2);
    expect(p.mnemonic, mne2);
    expect(p.list, stringToArr(mne2));

    try {
      Phrase.fromString(mne2.substring(0, mne2.length - 10));
    } catch (e) {
      expect((e as PhaseException).toString().contains("pers"), true);
    }

    try {
      Phrase.fromString(mne2.substring(0, mne2.length - 7));
    } catch (e) {
      expect((e as PhaseException).toString().contains("length of 23"), true);
    }
  });
}
