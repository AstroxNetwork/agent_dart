import 'dart:async';
import 'package:agent_dart_base/agent/ord/inscriptionItem.dart';
import 'package:agent_dart_base/agent/ord/service.dart';
import 'package:agent_dart_base/agent/ord/utxo.dart';
import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:tuple/tuple.dart';

import 'btc/bdk/bdk.dart';

typedef PsbtSignature = Uint8List;

enum BitcoinNetwork {
  mainnet,
  testnet,
}

class BTCDescriptor {
  BTCDescriptor({
    required this.addressType,
    required this.descriptor,
    required this.network,
  });
  final AddressType addressType;
  final Descriptor descriptor;
  final Network network;
}

abstract class AddressTypeString {
  static const P2TR = 'p2tr';
  static const P2WPKH = 'p2wpkh';
  static const P2SH_P2WPKH = 'p2sh';
  static const P2PKH = 'p2pkh';
}

enum AddressType {
  P2TR,
  P2WPKH,
  P2SH_P2WPKH,
  P2PKH,
}

const UTXO_DUST = 546;

class BitcoinBalance {
  BitcoinBalance._(this.balance);
  final Balance balance;
  Map<String, dynamic> toJson() => {
        'immature': balance.immature,
        'trustedPending': balance.trustedPending,
        'untrustedPending': balance.untrustedPending,
        'confirmed': balance.confirmed,
        'spendable': balance.spendable,
        'total': balance.total,
      };
}

Future<List<BTCDescriptor>> getDescriptors(
  String mnemonic, {
  AddressType addressType = AddressType.P2TR,
  Network network = Network.Bitcoin,
}) async {
  final descriptors = <BTCDescriptor>[];
  try {
    for (final e in KeychainKind.values) {
      final mnemonicObj = await Mnemonic.fromString(mnemonic);
      final descriptorSecretKey = await DescriptorSecretKey.create(
        network: Network.Bitcoin,
        mnemonic: mnemonicObj,
      );
      Descriptor descriptor;
      switch (addressType) {
        case AddressType.P2TR:
          descriptorSecretKey.derivationPath =
              await DerivationPath.create(path: "m/86'/0'/0'/0/0");
          descriptor = await Descriptor.newBip86(
            secretKey: descriptorSecretKey,
            network: network,
            keychain: e,
          );
          break;
        case AddressType.P2WPKH:
          descriptorSecretKey.derivationPath =
              await DerivationPath.create(path: "m/84'/0'/0'/0/0");
          descriptor = await Descriptor.newBip84(
            secretKey: descriptorSecretKey,
            network: network,
            keychain: e,
          );
          break;
        case AddressType.P2SH_P2WPKH:
          descriptorSecretKey.derivationPath =
              await DerivationPath.create(path: "m/49'/0'/0'/0/0");
          descriptor = await Descriptor.newBip49(
            secretKey: descriptorSecretKey,
            network: network,
            keychain: e,
          );
          break;
        case AddressType.P2PKH:
          descriptorSecretKey.derivationPath =
              await DerivationPath.create(path: "m/44'/0'/0'/0/0");
          descriptor = await Descriptor.newBip44(
            secretKey: descriptorSecretKey,
            network: network,
            keychain: e,
          );
          break;
        default:
          descriptorSecretKey.derivationPath =
              await DerivationPath.create(path: "m/86'/0'/0'/0/0");
          descriptor = await Descriptor.newBip86(
            secretKey: descriptorSecretKey,
            network: network,
            keychain: e,
          );
      }

      descriptors.add(
        BTCDescriptor(
          addressType: addressType,
          descriptor: descriptor,
          network: network,
        ),
      );
    }
    return descriptors;
  } on Exception {
    rethrow;
  }
}

class BitcoinWallet {
  BitcoinWallet({
    required this.wallet,
    required this.addressType,
    required this.descriptor,
    this.ordService,
  });
  final Wallet wallet;
  final AddressType addressType;
  final BTCDescriptor descriptor;
  late AddressInfo _selectedSigner;
  late Blockchain blockchain;

  Network network = Network.Bitcoin;

  OrdService? ordService;

  String? _publicKey;

  String? getPublicKey() => _publicKey;

  void connect(OrdService service) {
    ordService = service;
  }

  void setNetwork(Network net) {
    network = net;
  }

  Future<void> blockchainInit({Network? net = Network.Bitcoin}) async {
    blockchain = await Blockchain.create(
      config: BlockchainConfig.electrum(
        config: ElectrumConfig(
          stopGap: 10,
          timeout: 5,
          retry: 5,
          url:
              'ssl://electrum.blockstream.info:${(net ?? network) == Network.Bitcoin ? 50002 : 60002}',
          validateDomain: false,
        ),
      ),
    );
    // blockchain = await Blockchain.create(
    //     config: BlockchainConfig.esplora(
    //         config: EsploraConfig(
    //   baseUrl:
    //       'https://mempool.space/${(net ?? network) == Network.Bitcoin ? '' : 'testnet/'}api', // https://mempool.space/api',
    //   concurrency: 4,
    //   stopGap: 10,
    //)));
  }

  static Future<BitcoinWallet> fromPhrase(
    String phrase, {
    Network? network = Network.Bitcoin,
  }) async {
    // final wallet = await BitcoinWallet.fromPhrase();
    final descriptors =
        await getDescriptors(phrase, network: network ?? Network.Bitcoin);

    final res = await Wallet.create(
      descriptor: descriptors[0].descriptor,
      changeDescriptor: descriptors[0].descriptor,
      network: network ?? Network.Bitcoin,
      databaseConfig: const DatabaseConfig.memory(),
    );

    final wallet = BitcoinWallet(
      wallet: res,
      addressType: descriptors[0].addressType,
      descriptor: descriptors[0],
    );
    wallet.setNetwork(network ?? Network.Bitcoin);
    await wallet.blockchainInit(net: network ?? Network.Bitcoin);
    return wallet;
  }

  // ====== Signer ======
  Future<AddressInfo> getSigner(int index) async {
    final k =
        await descriptor.descriptor.descriptorSecretKey!.deriveIndex(index);

    final kBytes = Uint8List.fromList(await k.secretBytes());
    _publicKey = await k.getPubFromBytes(kBytes);
    return wallet.getAddress(
      addressIndex: AddressIndex.reset(index: index),
    );
  }

  Future<void> selectSigner(int index) async {
    _selectedSigner = await getSigner(index);
  }

  AddressInfo currentSigner() {
    return _selectedSigner;
  }

  Future<void> sync() {
    return wallet.sync(blockchain);
  }

  // ====== OrdService ======

  ///Return the [Balance], separated into available, trusted-pending, untrusted-pending and immature values.
  ///
  ///Note that this method only operates on the internal database, which first needs to be Wallet().sync manually.
  Future<BitcoinBalance> getBalance() async {
    try {
      final res = await wallet.getBalance();
      return BitcoinBalance._(res);
    } on FfiException catch (e) {
      throw e.message;
    }
  }

  ///Return the list of unspent outputs of this wallet
  ///
  /// Note that this method only operates on the internal database, which first needs to be Wallet().sync manually.
  Future<List<Utxo>> listUnspent() async {
    try {
      // final utxos = await ordService!.getUtxo(_selectedSigner.address);
      final utxos = await ordService!.getUtxoGet(_selectedSigner.address);
      return utxos;
    } on FfiException catch (e) {
      throw e.message;
    }
  }

  Future<List<InscriptionItem>> listInscriptions() async {
    try {
      // final utxos = await ordService!.getUtxo(_selectedSigner.address);
      final ins = await ordService!.getInscriptions(_selectedSigner.address);
      return ins;
    } on FfiException catch (e) {
      throw e.message;
    }
  }

  ///Return an unsorted list of transactions made and received by the wallet
  // Future<List<TransactionDetails>> listTransactions() async {
  //   try {
  //     final res = await AgentDartFFI.impl
  //         .psbtWalletGetTxs(wallet: _selectedSigner.getWalletReq());
  //     return res;
  //   } on FfiException catch (e) {
  //     throw (e.message);
  //   }
  // }

  Future<String> broadCast(TxBuilderResult tx) async {
    try {
      return await blockchain.broadcast(await tx.psbt.extractTx());
    } on FfiException catch (e) {
      throw e.message;
    }
  }

  Future<Tuple2<List<OutPointExt>, List<OutPointExt>>> handleUtxo() async {
    final utxos = await listUnspent();
    final ins = <OutPointExt>[];
    final nonIns = <OutPointExt>[];
    final allIns = await listInscriptions()
      ..sort((a, b) => b.num!.compareTo(a.num!));

    utxos.forEach((e) async {
      if (e.inscriptions.isNotEmpty) {
        final idList = e.inscriptions.map((e) => e.id).toList();
        final insList =
            allIns.where((element) => idList.contains(element.id)).toList();
        ins.add(
          OutPointExt(
            insList,
            txid: e.txId,
            vout: e.outputIndex,
            satoshis: e.satoshis,
            scriptPk: e.scriptPk,
            outputIndex: e.outputIndex,
          ),
        );
      } else {
        nonIns.add(
          OutPointExt(
            null,
            txid: e.txId,
            vout: e.outputIndex,
            satoshis: e.satoshis,
            scriptPk: e.scriptPk,
            outputIndex: e.outputIndex,
          ),
        );
      }
    });
    return Tuple2<List<OutPointExt>, List<OutPointExt>>(ins, nonIns);
  }

  Future<int> getSafeBalance() async {
    final xos = await handleUtxo();

    final nonIns = xos.item2;
    final res = nonIns.fold(
      0,
      (previousValue, element) => previousValue + element.satoshis,
    );
    return res;
  }

  /// ====== OrdTransaction ======
  Future<TxBuilderResult> createSendBTC({
    required String toAddress,
    required int amount,
    required int feeRate,
  }) async {
    final builder = TxBuilder();
    builder.enableRbf();
    builder.manuallySelectedOnly();
    builder.feeRate(feeRate.toDouble());
    final formatedAddress = await Address.create(address: toAddress);
    final changeAddress =
        await (await Address.create(address: currentSigner().address))
            .scriptPubKey();

    // handle utxo
    final xos = await handleUtxo();
    final ins = xos.item1;
    final nonIns = xos.item2;
    // builder.addInscriptions(ins);
    for (final e in ins) {
      builder.addUnSpendable(e);
    }

    // recepient setting
    // calculate output amount
    builder.addOutput(
      OutPointExt(
        null,
        outputIndex: 0,
        txid: '',
        vout: 0,
        satoshis: amount,
        scriptPk: (await formatedAddress.scriptPubKey()).internal.toHex(),
      ),
    );
    builder.addRecipient(await formatedAddress.scriptPubKey(), amount);

    final outputAmount =
        builder.getTotalOutput() == 0 ? amount : builder.getTotalOutput();

    var tmpSum = builder.getTotalInput();

    var fee = 0;
    for (var i = 0; i < nonIns.length; i++) {
      final nonOrdUtxo = nonIns[i];
      if (tmpSum < outputAmount) {
        builder.addInput(nonOrdUtxo);
        builder.addUtxo(nonOrdUtxo);
        tmpSum += nonOrdUtxo.satoshis;
        continue;
      }

      fee = await builder.calNetworkFee(wallet) ?? 0;

      if (tmpSum < outputAmount + fee) {
        builder.addInput(nonOrdUtxo);
        builder.addUtxo(nonOrdUtxo);
        tmpSum += nonOrdUtxo.satoshis;
      } else {
        break;
      }
    }

    final unspent = builder.getUnspend();
    if (unspent == 0) {
      throw Exception('Balance not enough to pay network fee.');
    }

    final networkFee = await builder.calNetworkFee(wallet);
    if (unspent < networkFee!) {
      throw Exception(
        'Balance not enough. Need $networkFee Sats as network fee, but only $unspent BTC.',
      );
    }

    final leftAmount = unspent - networkFee;

    if (leftAmount >= UTXO_DUST) {
      // change dummy output to true output
      // add dummy output
      builder.addRecipient(changeAddress, leftAmount);
    } else {
      // remove dummy output
      throw Exception('Output below Dust Limit of $UTXO_DUST Sats.');
    }

    // build finish
    final res = await builder.finish(wallet);
    res.addInputs(nonIns);
    return res;
  }

  // ====== OrdTransaction ======
  Future<TxBuilderResult> createSendInscription({
    required String toAddress,
    required String insId,
    required int feeRate,
    int? outputValue,
  }) async {
    // 1. basic setting
    final builder = TxBuilder();
    builder.enableRbf();
    builder.manuallySelectedOnly();
    builder.feeRate(feeRate.toDouble());

    // 2. address setting
    final formatedAddress = await Address.create(address: toAddress);
    final changeAddress =
        await (await Address.create(address: currentSigner().address))
            .scriptPubKey();

    // 3. handle utxo and get inscriptions
    final xos = await handleUtxo();
    final ins = xos.item1;

    // 3.1 select inscription and proctect those unspendables
    final tempInputs = <OutPointExt>[];
    var satoshis = 0;
    var found = false;
    var ordLeft = 0;
    for (final e in ins) {
      // try and find the inscription matches the inscription id
      final index =
          e.inscriptions!.indexWhere((element) => element.detail.id == insId);
      if (index > -1) {
        // add to input map
        builder.addInput(e);
        // add to bdk utxo
        builder.addUtxo(OutPoint(txid: e.txid, vout: e.vout));
        // add to dump data inputs
        tempInputs.add(e);
        // get actual output value, if outputValue is null, use the original value
        satoshis = outputValue ?? e.inscriptions![index].detail.output_value;

        // add output to output map
        builder.addOutput(
          OutPointExt(
            e.inscriptions,
            outputIndex: e.outputIndex,
            txid: e.txid,
            vout: e.vout,
            satoshis: satoshis,
            scriptPk: (await formatedAddress.scriptPubKey()).internal.toHex(),
          ),
        );
        // add to bdk recipient
        builder.addRecipient(await formatedAddress.scriptPubKey(), satoshis);

        // add change output
        if (outputValue != null &&
            outputValue < e.inscriptions![index].detail.output_value) {
          ordLeft = e.inscriptions![index].detail.output_value - outputValue;
          // add to output map as part of change output value
          builder.addOutput(
            OutPointExt(
              e.inscriptions,
              outputIndex: e.outputIndex,
              txid: e.txid,
              vout: e.vout,
              satoshis:
                  e.inscriptions![index].detail.output_value - outputValue,
              scriptPk: changeAddress.internal.toHex(),
            ),
          );
        }
        found = true;
      } else {
        builder.addUnSpendable(e);
      }
    }
    if (found == false) {
      throw Exception('Inscription not found');
    }

    // 4. handle utxo
    // 4.1 add non inscriptions to inputs
    final nonIns = xos.item2;
    builder.addUtxos(nonIns);
    tempInputs.addAll(nonIns);

    // calcluate output amount
    final outputAmount = builder.getTotalOutput();
    // print('outputAmount: $outputAmount');

    var tmpSum = builder.getTotalInput();
    var fee = 0;
    for (var i = 0; i < nonIns.length; i++) {
      final nonOrdUtxo = nonIns[i];
      if (tmpSum < outputAmount) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        tmpSum += nonOrdUtxo.satoshis;
        continue;
      }

      fee = await builder.calNetworkFee(wallet) ?? 0;
      if (tmpSum < outputAmount + fee) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        tmpSum += nonOrdUtxo.satoshis;
      } else {
        break;
      }
    }

    final unspent = builder.getUnspend();
    if (unspent == 0) {
      throw Exception('Balance not enough to pay network fee.');
    }

    final networkFee = await builder.calNetworkFee(wallet);
    if (unspent < networkFee!) {
      throw Exception(
        'Balance not enough. Need $networkFee Sats as network fee, but only $unspent BTC.',
      );
    }

    final leftAmount = unspent - networkFee;
    if (leftAmount >= UTXO_DUST) {
      // change dummy output to true output
      builder.addRecipient(changeAddress, leftAmount + ordLeft);
    } else {
      // builder.addRecipient(changeAddress, 1);
      throw Exception('Output below Dust Limit of $UTXO_DUST Sats.');
    }

    // finish the build and get ready to dump Data
    final res = await builder.finish(wallet);
    res.addInputs(tempInputs);
    return res;
  }

  Future<TxBuilderResult> bumpFee({
    required String txid,
    required double feeRate,
  }) async {
    final builder = BumpFeeTxBuilder(txid: txid, feeRate: feeRate);
    builder.enableRbf();
    builder.keepChange(true); // don't know whether it works;
    // final leftAmount = unspent - networkFee;
    // builder.addRecipient(changeAddress, leftAmount);

    return builder.finish(wallet);
  }

  ///Sign a transaction with all the wallet’s signers, in the order specified by every signer’s SignerOrdering
  ///
  /// Note that it can’t be guaranteed that every signers will follow the options, but the “software signers” (WIF keys and xprv) defined in this library will.
  Future<TxBuilderResult> sign(TxBuilderResult buildResult) async {
    try {
      final res = await wallet.sign(psbt: buildResult.psbt);
      final sbt = PartiallySignedTransaction(psbtBase64: res.psbtBase64);
      return TxBuilderResult(
        psbt: sbt,
        txDetails: buildResult.txDetails,
        signed: true,
      );
    } on FfiException catch (e) {
      throw e.message;
    }
  }
}
