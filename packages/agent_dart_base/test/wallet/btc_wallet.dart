import 'package:agent_dart_base/agent/ord/blockstream.dart';
import 'package:agent_dart_base/agent/ord/client.dart';
import 'package:agent_dart_base/agent/ord/service.dart';
import 'package:agent_dart_base/wallet/btc/bdk/bdk.dart';
import 'package:agent_dart_base/wallet/btc_wallet.dart';
import 'package:agent_dart_ffi/agent_dart_ffi.dart';
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
      addressType: AddressType.P2PKHTR,
        network: Network.Testnet
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
      // wallet.connect(service: ord, api: blockstream);
      // wallet.useExternalApi(true);
      print(wallet.currentSigner().address);

      // final us = await wallet.listUnspent();
      // us.forEach((e) => print(e.toJson()));

      // final tx2 = await blockstream.getTx(
      //     'ad4370edce9d1671f7fdc8bf56e409a4d82a6a9044531b1567daccdcd76e14df');
      // // print(tx2);
      // print('\n getTx ==> \n');
      // print(tx2.toJson());

      // final addressState = await blockstream
      //     .getAddressStats('bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76');
      // print('\n getAddressStats ==> \n');
      // print(addressState.toJson());

      // final a = await Address.create(
      //     address:
      //         'bc1paa0y2d7kqwk9szjyykan484rgzce9huyhkadpmgu4lyuxkfz4k2sjh9dup');
      // print('\n Address.create ==> \n');
      // print(a);

      // final addressType = await Address.getAddressType(
      //     'bc1paa0y2d7kqwk9szjyykan484rgzce9huyhkadpmgu4lyuxkfz4k2sjh9dup');
      // print('\n Address.getAddressType ==> \n');
      // print(addressType);

      // final addessUtxo = await blockstream
      //     .getAddressUtxo('bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76');
      // print('\n getAddressUtxo ==> \n');
      // print(addessUtxo.map((e) => e.toJson()).toList());

      // final txs = await blockstream.getAddressTxs(
      //   address: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
      //   filter: TxsFilter.Unconfirmed,
      // );

      // print('\n getAddressTxs ==> \n');
      // print(txs.map((e) => e.toJson()).toList());

      // final balance = await wallet.getBalance(
      //   address: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
      //   includeUnconfirmed: true,
      // );
      // print('\n getBalance ==> \n');
      // print(balance.toJson());

      // final c = await wallet.getHeight();
      // print('\n getHeight ==> \n');
      // print(c);

      // final ins = await ord.getInscriptions(
      //   'bc1prhylusp2j4ks7ut2pu0scxtxz76p2wn849jjzay42vvvcyxy4uzqhkng7h',
      // );
      // ins.map((e) => e.toJson()).forEach(print);

      // final safeBlance = await wallet.getSafeBalance();

      // print(safeBlance);

      // // send a btcTx
      // final btcTx = await wallet.createSendBTC(
      //   toAddress:
      //       'bc1prhylusp2j4ks7ut2pu0scxtxz76p2wn849jjzay42vvvcyxy4uzqhkng7h',
      //   amount: 10000,
      //   feeRate: 10,
      // );

      // await btcTx.dumpTx();

      // final feer = await wallet.getSendBTCFee(
      //   toAddress:
      //       'bc1prhylusp2j4ks7ut2pu0scxtxz76p2wn849jjzay42vvvcyxy4uzqhkng7h',
      //   amount: 10000,
      //   feeRate: 10,
      // );

      // print(feer);

      // print(Uint8List.fromList(await (await btcTx.psbt.extractTx()).serialize())
      //     .toHex());

      // final psbt = PartiallySignedTransaction(
      //     psbtBase64: base64Encode(
      //         (await wallet.signPsbt(await btcTx.psbt.psbtBase64)).toU8a()));
      // final tx = await psbt.extractTx();
      // print(Uint8List.fromList(await tx.serialize()).toHex());

      // await btcTx.dumpTx();

      // final signedBtcTX = await wallet.sign(btcTx);
      // final btcTxId = await wallet.broadCast(signedBtcTX);
      // print(btcTxId);

      // final recovered =
      //     PartiallySignedTransaction(psbtBase64: base64Encode(signed.toU8a()));

      // final tx = await recovered.getPsbtInputs();

      // print(decoded.inputs.length);

      // final hexed = base64Decode(decoded.psbt.psbtBase64).toHex();

      // final sss = await wallet.signPsbt(decoded.psbt.psbtBase64);

      // final recovered =
      //     PartiallySignedTransaction(psbtBase64: base64Encode(sss.toU8a()));
      // final txxx = await recovered.extractTx();
      // final xxxs = await txxx.input();
      // for (var i = 0; i < xxxs.length; i += 1) {
      //   print(xxxs[i].previousOutput.txid);
      //   print(xxxs[i].previousOutput.vout);
      // }

      // final btcTx = await wallet.createSendMultiBTC(toAddresses: [
      //   ReceiverItem(
      //       address:
      //           'bc1prhylusp2j4ks7ut2pu0scxtxz76p2wn849jjzay42vvvcyxy4uzqhkng7h',
      //       amount: 560),
      //   ReceiverItem(
      //       address:
      //           'bc1pkv9d7upgvuer37j79dpgkvkugk4z6jtt6gnjvd383duassc82mdqv73r35',
      //       amount: 560)
      // ], feeRate: 10);

      // await btcTx.dumpTx();

      // final signedBtcTX = await wallet.sign(btcTx);

      // send an ordTx
      // final ordTx = await wallet.createSendMultiInscriptions(
      //   toAddress: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
      //   insIds: [
      //     'e68ec4da1d52851d8310166cd944ae07e43f44bec664c36e24a029fd662debd8i0',
      //     '1e5430123fd517e8e48d8ddff9f7744100eb157a73b3081f5b07d6da93c640a8i0'
      //   ],
      //   feeRate: 10,
      //   outputValue: 546,
      // );

      // await ordTx.dumpTx();

      // final signedOrdTx = await wallet.sign(ordTx);
      // final ordTxId = await wallet.broadCast(signedOrdTx);

      // send btc from an Ord
      // final ordTx2 = await wallet.sendBTCFromInscription(
      //   toAddress: 'bc1qpxekutw2eq0jcmzx39gr5a75hdtuywt6uamt76',
      //   insId:
      //       'e68ec4da1d52851d8310166cd944ae07e43f44bec664c36e24a029fd662debd8i0',
      //   feeRate: 10,
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
