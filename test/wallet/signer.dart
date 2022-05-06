import 'dart:convert';

import 'package:agent_dart/agent/crypto/keystore/api.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/wallet/signer.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:pinenacl/ed25519.dart';

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

    var password = '11111111';
    var bytes =
        'd9d9f7a6666369706865724b6165732d3132382d6374726c636970686572706172616d73a16269765045f70cfd865af5a044383118d3ff8a856a636970686572746578745893651da7e54ef8fd80221cb4932945c6f4bd04860eb76114cd297480119f5df838c5fac7f5f4b2fb25e148a4416c0e20e16ee3571596d0b6727d0ba975860fd887a631eced31492fd3d9c878b8aa03a404b1bd46776208996d251f1ded03e6d0fdd3f0735232631b311ad648c4b7e2216c797055d19b174c5ad328b85991c2889fca34436f667988d3c2aaedd8f0fb0cabf163ce636b646646736372797074696b6466706172616d7358a0d9d9f7a565646b6c656e1820616e1920006170016172086473616c74788230786530353431646565343330633266653432613232313239313165636539336137333666613339323636346139323365306231323433386636386435643863343731313063373439323565326337663466306466666661356437306236303939623333326639316566653663393538336435333035653737373634633630343630636d6163982018da181d18c21863184a18821718eb184318f3188218b4186418250618c318a21518fe1849186918e61853188d18761818186b1877184b15121875'
            .toU8a();
    final phrase = await decryptCborPhrase(bytes, password);
    print("phrase  : $phrase");
  });
}
