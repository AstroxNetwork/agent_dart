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
      addressType: AddressType.P2TR,
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

      final tx2 = await blockstream.getTx(
          'ad4370edce9d1671f7fdc8bf56e409a4d82a6a9044531b1567daccdcd76e14df');
      // print(tx2);
      print('\n getTx ==> \n');
      print(tx2.toJson());

      final addressState = await blockstream
          .getAddressStats('bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76');
      print('\n getAddressStats ==> \n');
      print(addressState.toJson());

      final a = await Address.create(
          address:
              'bc1paa0y2d7kqwk9szjyykan484rgzce9huyhkadpmgu4lyuxkfz4k2sjh9dup');
      print('\n Address.create ==> \n');
      print(a);

      final addressType = await Address.getAddressType(
          address:
              'bc1paa0y2d7kqwk9szjyykan484rgzce9huyhkadpmgu4lyuxkfz4k2sjh9dup');
      print('\n Address.getAddressType ==> \n');
      print(addressType);

      final addessUtxo = await blockstream
          .getAddressUtxo('bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76');
      print('\n getAddressUtxo ==> \n');
      print(addessUtxo.map((e) => e.toJson()).toList());

      final txs = await blockstream.getAddressTxs(
        address: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
        filter: TxsFilter.Unconfirmed,
      );

      print('\n getAddressTxs ==> \n');
      print(txs.map((e) => e.toJson()).toList());

      final balance = await wallet.getBalance(
        address: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
        includeUnconfirmed: true,
      );
      print('\n getBalance ==> \n');
      print(balance.toJson());

      final c = await wallet.blockchain.getHeight();
      print('\n getHeight ==> \n');
      print(c);

      // final ins = await ord.getInscriptions(
      //   'bc1prhylusp2j4ks7ut2pu0scxtxz76p2wn849jjzay42vvvcyxy4uzqhkng7h',
      // );
      // ins.map((e) => e.toJson()).forEach(print);

      // final safeBlance = await wallet.getSafeBalance();

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
      // final btcTxId = await wallet.broadCast(signedBtcTX);
      // print(btcTxId)

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

      // send btc from an Ord
      // final ordTx2 = await wallet.sendBTCFromInscription(
      //   toAddress: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
      //   insId:
      //       '154f473080e054795e2e678ea20e0bdc482088abfef3e7e2cb9849441db3ade3i0',
      //   feeRate: 1,
      //   btcAmount: 2000,
      // );

      // await ordTx2.dumpTx();

      // final signedOrdTx = await wallet.sign(ordTx2);

      // final bumpFeeTx = await wallet.bumpFee(txid: ordTxId, feeRate: 20);
      // final signedBumpFeeTx = await wallet.sign(bumpFeeTx);
      // // final bumpFeeTxId = await wallet.broadCast(signedBumpFeeTx);
    },
    skip: false,
  );
}
