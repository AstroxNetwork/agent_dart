import 'dart:typed_data';

import 'package:agent_dart_base/agent/ord/client.dart';
import 'package:agent_dart_base/agent/ord/service.dart';
import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:agent_dart_base/wallet/btc/bdk/bdk.dart';
import 'package:agent_dart_base/wallet/btc_wallet.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  matchFFI();
  btc_wallet();
}

void btc_wallet() {
  final ord = OrdService(
      host: 'unisat.io/api',
      override: const OverrideOptions(headers: {
        'Content-Type': 'application/json;charset=utf-8',
        'X-Client': 'UniSat Wallet',
        'X-Version': '1.1.12',
      }));
  Future<BitcoinWallet> getWallet() async {
    final wallet = await BitcoinWallet.fromPhrase(
        (await Mnemonic.create(WordCount.Words12)).asString());
    await wallet.selectSigner(0);
    await wallet.sync();
    return wallet;
  }

  test('get psbt address', () async {
    final wallet = await getWallet();
    (await wallet.getBalance()).toJson();
  });
  test('ord connect', () async {
    final wallet = await getWallet();
    wallet.connect(ord);
    final ins = await ord.getInscriptions(
        'bc1pmahh869alq9t6efy7wmtxtktkllpvvz4p6ea7n9r35mmnwukj2vsfn9ucy');
    ins.map((e) => e.toJson()).forEach(print);
    await wallet.getSafeBalance();

    // send a btcTx
    final btcTx = await wallet.createSendBTC(
        toAddress: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
        amount: 8000,
        feeRate: 16);

    await btcTx.dumpTx();

    final signedBtcTX = await wallet.sign(btcTx);
    // final btcTxId = await wallet.broadCast(signedBtcTX);

    // send an ordTx
    final ordTx = await wallet.createSendInscription(
      toAddress: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
      insId:
          '43547439b4f4d90b26a33484764db53636c48142df98db3dbe335e53ee307a8ei0',
      feeRate: 5,
      outputValue: 6500,
    );

    await ordTx.dumpTx();

    final signedOrdTx = await wallet.sign(ordTx);
    final ordTxId = await wallet.broadCast(signedOrdTx);

    final bumpFeeTx = await wallet.bumpFee(txid: ordTxId, feeRate: 20);
    final signedBumpFeeTx = await wallet.sign(bumpFeeTx);
    // final bumpFeeTxId = await wallet.broadCast(signedBumpFeeTx);
  });
}
