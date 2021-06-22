import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/wallet/signer.dart';
import 'package:agent_dart/wallet/types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/wallet/rosetta.dart';
import '../test_utils.dart';

void main() {
  rosettaTest();
}

///
/// first go checkout: https://github.com/AstroxNetwork/local-ledger-wasm
/// then run the test
/// this test is not complete yet
void rosettaTest() {
  test('encodes properly', () async {
    /// create signer
    var signer =
        ICPSigner.fromPrivatKey("07acb84879d371491ceccb357322b264fc7703e7966686c0fd4d39cebcaffab3");

    /// create receiver
    final seed = Uint8List.fromList(List.filled(32, 0)).toHex();
    var receiver = ICPSigner.fromPrivatKey(seed);

    /// setup RosettaApi and init
    RosettaApi rose = RosettaApi(host: "http://127.0.0.1:8080");
    await rose.init();

    /// create payload
    final amount = BigInt.one;
    var unsignedTransaction = await rose.transferPreCombine(
        signer.idPublicKey!.toU8a(), receiver.idAddress!.toU8a(), amount, null, null);

    print("\n ------ payload ------");
    print("\n from Identity: ${signer.account.getIdentity()?.getPrincipal().toText()}");
    print("\n from :${signer.idAddress}");
    print("\n to :${receiver.idAddress}");
    print("\n unsignedTransaction :${jsonEncode(unsignedTransaction.toJson())}");
    print("\n sender_pubkey :${signer.idPublicKey}");
    print(" ------ payload ------ \n");

    /// sign transaction, offline signer we assume
    var signedTransaction = await transferCombine(signer.account.identity!, unsignedTransaction);

    /// send transaction after
    var txn = await rose.transfer_post_combine(signedTransaction);

    /// get transaction confirmed
    var txRes = await Future.delayed(const Duration(seconds: 3), () {
      return rose.transactions(SearchTransactionsRequest.fromMap({
        "network_identifier": rose.networkIdentifier?.toJson(),
        "transaction_identifier": txn.transaction_identifier.toJson() // ,
      }));
    });

    print("\n ------ transaction confirm ------");
    print(txRes.toJson());
    print(" ------ transaction confirm ------ \n");
  });
}
