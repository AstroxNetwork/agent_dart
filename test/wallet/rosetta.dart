import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/wallet/signer.dart';
import 'package:agent_dart/wallet/types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/wallet/rosetta.dart';

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

    var receiver = await ICPSigner.fromSeed(
      Uint8List.fromList(List.filled(32, 0)),
      curveType: CurveType.all,
    );

    /// setup RosettaApi and init
    RosettaApi rose = RosettaApi(host: "http://127.0.0.1:8080");
    await rose.init();
    print((await rose.blockByIndex(0)).toJson());
    // /// create payload
    // final amount = BigInt.from(100000000);
    // var unsignedTransaction = await rose.transferPreCombine(
    //     signer.idPublicKey!.toU8a(),
    //     receiver.idAddress!.toU8a(),
    //     amount,
    //     null,
    //     null);

    var accountBalance = await rose.accountBalanceByAddress(signer.idAddress!);

    // // ignore: avoid_print
    print("\n ------ payload ------");
    // ignore: avoid_print
    print(
        "\n from Identity: ${signer.account.getIdentity()?.getPrincipal().toText()}");
    // ignore: avoid_print
    print("\n from :${signer.idAddress}");
    // ignore: avoid_print
    print("\n to :${receiver.idAddress}");

    // // ignore: avoid_print
    // print(
    //     "\n unsignedTransaction :${jsonEncode(unsignedTransaction.toJson())}");
    // // ignore: avoid_print
    // print("\n sender_pubkey :${signer.idPublicKey}");

    // // ignore: avoid_print
    // print(" ------ payload ------ \n");

    // /// sign transaction, offline signer we assume
    // var signedTransaction =
    //     await transferCombine(signer.account.identity!, unsignedTransaction);

    // /// send transaction after
    // var txn = await rose.transfer_post_combine(signedTransaction);

    // /// get transaction confirmed
    // var txRes = await Future.delayed(const Duration(seconds: 3), () {
    //   return rose.transactions(SearchTransactionsRequest.fromMap({
    //     "network_identifier": rose.networkIdentifier?.toJson(),
    //     "transaction_identifier": txn.transaction_identifier.toJson() // ,
    //   }));
    // });

    // var accountBalanceAfter =
    //     await rose.accountBalanceByAddress(signer.idAddress!);
    // // ignore: avoid_print
    // print("\n ------ transaction confirm ------");
    // // ignore: avoid_print
    // print(txRes.toJson());
    // // ignore: avoid_print
    // print(" ------ transaction confirm ------ \n");

    // // ignore: avoid_print
    // print(" ------ Balance change ------ \n");
    // // ignore: avoid_print
    // print("\n sender balance BEFORE: ${accountBalance.toJson()}");
    // // ignore: avoid_print
    // print("\n sender balance AFTER: ${accountBalanceAfter.toJson()}");
    // // ignore: avoid_print
    // print(" ------ Balance change ------ \n");
  });
  test('getTransactionByBlock', () async {
    RosettaApi rose = RosettaApi();
    await rose.init();
    final txn = await rose.getTransactionByBlock(3672726);
    expect(txn.hash,
        '6bbdef23f7c8859e2c5e2c1a99f96c977009760b3bfebcff6d3fa986ff84ffc2');
  });
}
