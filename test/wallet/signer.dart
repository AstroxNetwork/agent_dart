import 'package:agent_dart/wallet/keysmith.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/wallet/signer.dart';
import 'package:agent_dart/utils/extension.dart';

import '../test_utils.dart';

void main() {
  signerTest();
}

void signerTest() {
  test('encodes properly', () {
    // var mne = genrateMnemonic();
    // var mne = 'poem pause flame glue ocean diesel extra onion patch rich farm detail';
    // var prv =
    //     '2a29d1516eda736523fc10e20bd1929e738e71d85bc4d6bb2f1a92ae9046829b'; // equivilant above as bip39(index=0);
    // var acc = ICPAccount.fromPhrase(mne);

    var mne2 =
        'open jelly jeans corn ketchup supreme brief element armed lens vault weather original scissors rug priority vicious lesson raven spot gossip powder person volcano';
    var acc2 = ICPSigner.fromPhrase(mne2);

    print(acc2.account.ecKeys?.accountId!.toHex());
    print(acc2.account.identity?.accountId.toHex());
  });
}
