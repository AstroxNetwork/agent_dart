import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/crypto/keystore/api.dart';
import 'package:agent_dart/identity/ed25519.dart';
import 'package:agent_dart/protobuf/ic_ledger/pb/v1/types.pb.dart' hide Hash;
import 'package:agent_dart/wallet/keysmith.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/wallet/signer.dart';
import 'package:agent_dart/utils/extension.dart';

import '../test_utils.dart';

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
        "852e8464176ea2199c8f885155483dbb112a7568895387f2c915933e");

    await acc2.lock("123");
    expect(acc2.isLocked, true);
    expect(acc2.account.identity, null);
    expect(acc2.account.ecKeys, null);

    await acc2.unlock("123");
    expect(acc2.isLocked, false);
    expect(acc2.account.identity?.accountId.toHex(),
        "852e8464176ea2199c8f885155483dbb112a7568895387f2c915933e");
    expect(acc2.account.ecKeys?.accountId!.toHex(),
        "02f2326544f2040d3985e31db5e7021402c541d3cde911cd20e951852ee4da47");

    var encryptedPhrase = await encodePhrase(mne2, "123");
    var decryptedPhrase = await decodePhrase(jsonDecode(encryptedPhrase), "123");
    expect(decryptedPhrase, mne2);
  });
}
