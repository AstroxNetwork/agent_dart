import 'dart:typed_data';

import 'package:agent_dart/wallet/rosetta.dart';
import 'package:agent_dart/wallet/signer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  rosettaTest();
}

///
/// first go checkout: https://github.com/AstroxNetwork/local-ledger-wasm
/// then run the test
/// this test is not complete yet
void rosettaTest() {
  test('encodes properly', () async {
    const phrase =
        'steel obey anxiety vast clever relax million girl cost pond elbow bridge hill health toilet desk sleep grid boost flavor shy cry armed mass';

    final signer =
        await ICPSigner.importPhrase(phrase, curveType: CurveType.all);

    final receiver = await ICPSigner.fromSeed(
      Uint8List.fromList(List.filled(32, 0)),
      curveType: CurveType.all,
    );

    /// setup RosettaApi and init
    final RosettaApi rose = RosettaApi(host: 'http://127.0.0.1:8080');
    await rose.init();
    print((await rose.blockByIndex(0)).toJson());
    // /// create payload
    // final amount = BigInt.from(100000000);
    // final unsignedTransaction = await rose.transferPreCombine(
    //   signer.idPublicKey!.toU8a(),
    //   receiver.idAddress!.toU8a(),
    //   amount,
    //   null,
    //   null,
    // );

    final accountBalance =
        await rose.accountBalanceByAddress(signer.idAddress!);
    print('\n Account balance: $accountBalance');
    print('\n ------ payload ------');
    print(
      '\n from Identity: ${signer.account.getIdentity()?.getPrincipal().toText()}',
    );
    print('\n from :${signer.idAddress}');
    print('\n to :${receiver.idAddress}');

    // print(
    //     "\n unsignedTransaction :${jsonEncode(unsignedTransaction.toJson())}");
    // print("\n sender_pubkey :${signer.idPublicKey}");

    // print(" ------ payload ------ \n");

    // /// sign transaction, offline signer we assume
    // final signedTransaction = await transferCombine(
    //   signer.account.identity!,
    //   unsignedTransaction,
    // );

    // /// send transaction after
    // final txn = await rose.transfer_post_combine(signedTransaction);

    // /// get transaction confirmed
    // final txRes = await Future.delayed(const Duration(seconds: 3), () {
    //   return rose.transactions(SearchTransactionsRequest.fromJson({
    //     "network_identifier": rose.networkIdentifier?.toJson(),
    //     "transaction_identifier": txn.transaction_identifier.toJson() // ,
    //   }));
    // });

    // final accountBalanceAfter = await rose.accountBalanceByAddress(
    //   signer.idAddress!,
    // );
    // print("\n ------ transaction confirm ------");
    // print(txRes.toJson());
    // print(" ------ transaction confirm ------ \n");

    // print(" ------ Balance change ------ \n");
    // print("\n sender balance BEFORE: ${accountBalance.toJson()}");
    // print("\n sender balance AFTER: ${accountBalanceAfter.toJson()}");
    // print(" ------ Balance change ------ \n");
  });
  test('getTransactionByBlock', () async {
    final RosettaApi rose = RosettaApi();
    await rose.init();
    final txn = await rose.getTransactionByBlock(3672726);
    expect(
      txn.hash,
      '6bbdef23f7c8859e2c5e2c1a99f96c977009760b3bfebcff6d3fa986ff84ffc2',
    );
  });
}
