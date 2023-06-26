import 'package:agent_dart_base/agent/ord/blockstream.dart';
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
    override: const OverrideOptions(
      headers: {
        'Content-Type': 'application/json;charset=utf-8',
        'X-Client': 'UniSat Wallet',
        'X-Version': '1.1.12',
      },
    ),
  );

  final blockstream = BlockStreamApi(
    host: 'blockstream.info/api',
    override: const OverrideOptions(
      headers: {
        'Content-Type': 'application/json;charset=utf-8',
      },
    ),
  );

  Future<BitcoinWallet> getWallet() async {
    final wallet = await BitcoinWallet.fromPhrase(
      (await Mnemonic.create(WordCount.Words12)).asString(),
    );

    await wallet.selectSigner(0);
    await wallet.cacheAddress(100);
    // await wallet.sync();
    return wallet;
  }

  test('get address by seedphrase and index', () async {
    final seedphrase = (await Mnemonic.create(WordCount.Words12)).asString();
    final address = await getAddressInfo(phrase: seedphrase, index: 0);
    print(address.address);
  }, skip: true);
  test('get psbt address', () async {
    final wallet = await getWallet();
    print((await wallet.getBalance()).toJson());
  }, skip: true);
  test(
    'ord connect',
    () async {
      final wallet = await getWallet();

      wallet.connect(service: ord, api: blockstream);
      wallet.useExternalApi(true);
      print(wallet.currentSigner().address);

      final us = await wallet.listUnspent();
      us.forEach((e) => print(e.toJson()));

      final tx2 = await blockstream.getTxHex(
          'ad4370edce9d1671f7fdc8bf56e409a4d82a6a9044531b1567daccdcd76e14df');
      // print(tx2);

      final tx3 = await Transaction.create(transactionBytes: tx2.toU8a());
      // print(tx3);

      final ins = await ord.getInscriptions(
        'bc1prhylusp2j4ks7ut2pu0scxtxz76p2wn849jjzay42vvvcyxy4uzqhkng7h',
      );
      ins.map((e) => e.toJson()).forEach(print);

      final safeBlance = await wallet.getSafeBalance();

      // print(safeBlance);

      // send a btcTx
      // final btcTx = await wallet.createSendBTC(
      //   toAddress:
      //       'bc1prhylusp2j4ks7ut2pu0scxtxz76p2wn849jjzay42vvvcyxy4uzqhkng7h',
      //   amount: 508,
      //   feeRate: 1,
      // );

      // await btcTx.dumpTx();

      // final signedBtcTX = await wallet.sign(btcTx);
      // // final btcTxId = await wallet.broadCast(signedBtcTX);

      // send an ordTx
      // final ordTx = await wallet.createSendInscription(
      //   toAddress: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
      //   insId:
      //       '154f473080e054795e2e678ea20e0bdc482088abfef3e7e2cb9849441db3ade3i0',
      //   feeRate: 1,
      //   outputValue: 546,
      // );

      // await ordTx.dumpTx();

      // final signedOrdTx = await wallet.sign(ordTx);
      // final ordTxId = await wallet.broadCast(signedOrdTx);

      // final bumpFeeTx = await wallet.bumpFee(txid: ordTxId, feeRate: 20);
      // final signedBumpFeeTx = await wallet.sign(bumpFeeTx);
      // // final bumpFeeTxId = await wallet.broadCast(signedBumpFeeTx);
    },
    skip: false,
  );
}
