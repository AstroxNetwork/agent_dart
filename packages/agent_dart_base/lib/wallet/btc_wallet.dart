import 'dart:async';

import 'package:agent_dart_base/agent/ord/blockstream.dart';
import 'package:agent_dart_base/agent/ord/inscriptionItem.dart';
import 'package:agent_dart_base/agent/ord/service.dart';
import 'package:agent_dart_base/agent/ord/utxo.dart';
import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:collection/collection.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

typedef PsbtSignature = Uint8List;

enum BitcoinNetwork {
  mainnet,
  testnet,
}

class ReceiverItem {
  ReceiverItem({
    required this.address,
    required this.amount,
  });

  final String address;
  final int amount;
}

class ReceiverItemWithAddress {
  ReceiverItemWithAddress({
    required this.address,
    required this.amount,
  });

  final Address address;
  final int amount;
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

class UtxoHandlers {
  UtxoHandlers({required this.ins, required this.nonIns, required this.txs});

  final List<OutPointExt> ins;
  final List<OutPointExt> nonIns;
  final List<dynamic> txs;
}

const UTXO_DUST = 546;

class UnconfirmedBalance {
  UnconfirmedBalance({
    required this.mempoolSpendTxValue,
    required this.mempoolReceiveTxValue,
    required this.tooManyUnconfirmed,
  });

  int mempoolSpendTxValue = 0;
  int mempoolReceiveTxValue = 0;
  bool tooManyUnconfirmed = false;

  Map<String, dynamic> toJson() => {
        'mempoolSpendTxValue': mempoolSpendTxValue,
        'mempoolReceiveTxValue': mempoolReceiveTxValue,
        'tooManyUnconfirmed': tooManyUnconfirmed,
      };
}

class BitcoinBalance {
  factory BitcoinBalance.fromJson(Map json) {
    final balance = Balance(
      immature: json['immature'],
      trustedPending: json['trustedPending'],
      untrustedPending: json['untrustedPending'],
      confirmed: json['confirmed'],
      spendable: json['spendable'],
      total: json['total'],
    );
    final unconfirmed = (json['unconfirmed'] as Map).cast<String, dynamic>();
    final unconfirmedBalance = UnconfirmedBalance(
      mempoolReceiveTxValue: unconfirmed['mempoolReceiveTxValue'],
      mempoolSpendTxValue: unconfirmed['mempoolSpendTxValue'],
      tooManyUnconfirmed: unconfirmed['tooManyUnconfirmed'],
    );
    final bitcoinBalance = BitcoinBalance._(balance);
    bitcoinBalance.setUnconfirmed(unconfirmedBalance);
    return bitcoinBalance;
  }

  BitcoinBalance._(this.balance);

  final Balance balance;
  final UnconfirmedBalance _unconfirmedBalance = UnconfirmedBalance(
    mempoolReceiveTxValue: 0,
    mempoolSpendTxValue: 0,
    tooManyUnconfirmed: false,
  );

  void setMempoolSpendTxValue(int value) {
    _unconfirmedBalance.mempoolSpendTxValue = value;
  }

  void setMempoolReceiveTxValue(int value) {
    _unconfirmedBalance.mempoolReceiveTxValue = value;
  }

  void setTooManyUnconfirmed(bool value) {
    _unconfirmedBalance.tooManyUnconfirmed = value;
  }

  void setUnconfirmed(UnconfirmedBalance unconfirmedBalance) {
    setMempoolReceiveTxValue(unconfirmedBalance.mempoolReceiveTxValue);
    setMempoolSpendTxValue(unconfirmedBalance.mempoolSpendTxValue);
    setTooManyUnconfirmed(unconfirmedBalance.tooManyUnconfirmed);
  }

  Map<String, dynamic> toJson() => {
        'immature': balance.immature,
        'trustedPending': balance.trustedPending,
        'untrustedPending': balance.untrustedPending,
        'confirmed': balance.confirmed,
        'spendable': balance.spendable,
        'unconfirmed': _unconfirmedBalance.toJson(),
        'total': balance.total,
      };

  int get total => balance.total;

  int get spendable => balance.spendable;

  int get confirmed => balance.confirmed;

  int get untrustedPending => balance.untrustedPending;

  int get trustedPending => balance.trustedPending;

  int get immature => balance.immature;

  UnconfirmedBalance get unconfirmed => _unconfirmedBalance;
}

Future<AddressInfo> getAddressInfo({
  required String phrase,
  required int index,
  Network network = Network.Bitcoin,
  AddressType addressType = AddressType.P2TR,
}) async {
  final descriptors = await getDescriptors(
    phrase,
    network: network,
    addressType: addressType,
  );
  final descriptor = descriptors[KeychainKind.External]!;
  return descriptor.descriptor.deriveAddressAt(index, network);
}

Future<Map<KeychainKind, BTCDescriptor>> getDescriptors(
  String mnemonic, {
  AddressType addressType = AddressType.P2TR,
  Network network = Network.Bitcoin,
}) async {
  final mnemonicObj = await Mnemonic.fromString(mnemonic);
  final descriptorSecretKey = await DescriptorSecretKey.create(
    network: Network.Bitcoin,
    mnemonic: mnemonicObj,
  );
  final descriptors = <KeychainKind, BTCDescriptor>{};
  try {
    for (final e in KeychainKind.values) {
      Descriptor descriptor;
      switch (addressType) {
        case AddressType.P2TR:
          descriptorSecretKey.derivationPath =
              await DerivationPath.create(path: addressType.derivedPath);
          descriptor = await Descriptor.newBip86(
            secretKey: descriptorSecretKey,
            network: network,
            keychain: e,
          );
          break;
        case AddressType.P2WPKH:
          descriptorSecretKey.derivationPath =
              await DerivationPath.create(path: addressType.derivedPath);
          descriptor = await Descriptor.newBip84(
            secretKey: descriptorSecretKey,
            network: network,
            keychain: e,
          );
          break;
        case AddressType.P2SH_P2WPKH:
          descriptorSecretKey.derivationPath =
              await DerivationPath.create(path: addressType.derivedPath);
          descriptor = await Descriptor.newBip49(
            secretKey: descriptorSecretKey,
            network: network,
            keychain: e,
          );
          break;
        case AddressType.P2PKH:
          descriptorSecretKey.derivationPath =
              await DerivationPath.create(path: addressType.derivedPath);
          descriptor = await Descriptor.newBip44(
            secretKey: descriptorSecretKey,
            network: network,
            keychain: e,
          );
          break;
      }

      descriptors[e] = BTCDescriptor(
        addressType: addressType,
        descriptor: descriptor,
        network: network,
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
  BlockStreamApi? blockStreamApi;

  String? _publicKey;

  String? getPublicKey() => _publicKey;

  bool _useExternalApi = false;

  final int COINBASE_MATURITY = 100;

  void connect({OrdService? service, BlockStreamApi? api}) {
    ordService ??= service;
    blockStreamApi ??= api;
  }

  void setNetwork(Network net) {
    network = net;
  }

  void useExternalApi(bool use) {
    _useExternalApi = use;
  }

  Future<void> blockchainInit({
    Network network = Network.Bitcoin,
    BlockchainConfig? blockchainConfig,
  }) async {
    blockchain = await Blockchain.create(
      config: blockchainConfig ??
          BlockchainConfig.electrum(
            config: ElectrumConfig(
              stopGap: 10,
              timeout: 5,
              retry: 5,
              url:
                  'ssl://electrum.blockstream.info:${network == Network.Bitcoin ? 50002 : 60002}',
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
    // )));
  }

  static Future<BitcoinWallet> fromPhrase(
    String phrase, {
    Network network = Network.Bitcoin,
    AddressType addressType = AddressType.P2TR,
  }) async {
    // final wallet = await BitcoinWallet.fromPhrase();
    final descriptors = await getDescriptors(phrase,
        network: network, addressType: addressType);
    final descriptor = descriptors[KeychainKind.External]!;
    final res = await Wallet.create(
      descriptor: descriptor.descriptor,
      changeDescriptor: descriptor.descriptor,
      network: network,
      databaseConfig: const DatabaseConfig.memory(),
    );
    final wallet = BitcoinWallet(
      wallet: res,
      addressType: descriptor.addressType,
      descriptor: descriptor,
    );
    wallet.setNetwork(network);
    await wallet.blockchainInit(network: network);
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

  Future<bool> cacheAddress(int cacheSize) {
    return wallet.cacheAddresses(cacheSize: cacheSize);
  }

  // ====== OrdService ======

  ///Return the [Balance], separated into available, trusted-pending, untrusted-pending and immature values.
  ///
  /// Note that this method only operates on the internal database, which first needs to be Wallet().sync manually.
  /// Note we don't use  wallet sync anymore, use external api instead
  Future<BitcoinBalance> getBalance({
    String? address,
    bool includeUnconfirmed = false,
  }) async {
    try {
      if (blockStreamApi == null) {
        throw Exception('blockStreamApi should be initialized first');
      }
      final theAddress = address ?? _selectedSigner.address;
      var immature = 0;
      const trustedPending = 0; // we don't use internal key to receive
      var untrustedPending = 0;
      var confirmed = 0;
      var mempoolSpendTxValue = 0;
      var mempoolReceiveTxValue = 0;
      var tooManyUnconfirmed = false;

      final utxos = await blockStreamApi!.getAddressUtxo(theAddress);

      for (var i = 0; i < utxos.length; i++) {
        final u = utxos[i];

        if (u.status.confirmed) {
          final tx = await getTx(u.txid);

          final blockHeight = await blockchain.getHeight();

          if (await tx.isCoinBase() &&
              (blockHeight - u.status.block_height!) < COINBASE_MATURITY) {
            immature += u.value;
          } else {
            confirmed += u.value;
          }
        } else {
          untrustedPending += u.value;
        }
      }
      final spendable = confirmed + trustedPending;
      var total = spendable + immature;

      if (includeUnconfirmed) {
        final txCount = (await blockStreamApi!.getAddressStats(theAddress))
            .mempool_stats
            .tx_count;
        if (txCount <= 0) {
          mempoolSpendTxValue = 0;
          mempoolReceiveTxValue = 0;
        } else {
          if (txCount > 50) {
            tooManyUnconfirmed = true;
          }
          final mempoolTxs = await blockStreamApi!.getAddressTxs(
            address: theAddress,
          );

          for (var i = 0; i < mempoolTxs.length; i++) {
            final tx = mempoolTxs[i];
            if (tx.status.confirmed) {
              continue;
            }
            mempoolSpendTxValue += tx.vin
                .where(
                  (element) =>
                      element.prevout.scriptpubkey_address == theAddress,
                )
                .fold(
                  0,
                  (previousValue, element) =>
                      previousValue + element.prevout.value,
                );
            mempoolReceiveTxValue += tx.vout
                .where(
                  (element) => element.scriptpubkey_address == theAddress,
                )
                .fold(
                  0,
                  (previousValue, element) => previousValue + element.value,
                );
          }
        }

        total = total + mempoolReceiveTxValue + mempoolSpendTxValue;
      }

      final finalBalance = BitcoinBalance._(
        Balance(
          immature: immature,
          trustedPending: trustedPending,
          untrustedPending: untrustedPending,
          confirmed: confirmed,
          spendable: spendable,
          total: total,
        ),
      );
      if (includeUnconfirmed) {
        finalBalance.setUnconfirmed(UnconfirmedBalance(
          mempoolSpendTxValue: mempoolSpendTxValue,
          mempoolReceiveTxValue: mempoolReceiveTxValue,
          tooManyUnconfirmed: tooManyUnconfirmed,
        ));
      }
      return finalBalance;
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

  Future<int> getHeight() async {
    try {
      final res = await blockchain.getHeight();
      return res;
    } on FfiException catch (e) {
      throw e.message;
    }
  }

  Future<Transaction> getTx(String txid) async {
    try {
      final res = await blockchain.getTx(txid);
      return await Transaction.create(transactionBytes: res.toU8a());
    } on FfiException catch (e) {
      throw e.message;
    }
  }

  Future<String> broadCast(TxBuilderResult tx) async {
    try {
      return await blockchain.broadcast(await tx.psbt.extractTx());
    } on FfiException catch (e) {
      throw e.message;
    }
  }

  Completer<UtxoHandlers>? _handleUtxoCompleter;

  Future<UtxoHandlers> handleUtxo({
    bool useCache = false,
  }) async {
    if (_handleUtxoCompleter != null && useCache) {
      return _handleUtxoCompleter!.future;
    }
    final completer = Completer<UtxoHandlers>();
    _handleUtxoCompleter = completer;
    Future(() async {
      final utxos = await listUnspent();
      final ins = <OutPointExt>[];
      final nonIns = <OutPointExt>[];
      final txDetails = <TxBytes>[];
      final allIns = await listInscriptions()
        ..sort((a, b) => b.num!.compareTo(a.num!));

      for (var i = 0; i < utxos.length; i += 1) {
        final e = utxos[i];
        final bytes = !_useExternalApi
            ? Uint8List.fromList(await (await getTx(e.txId)).serialize())
            : ((await blockchain.getTx(e.txId)).toU8a());
        final tx = TxBytes(
          bytes: bytes,
          txId: e.txId,
        );
        txDetails.add(tx);
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
      }
      return UtxoHandlers(ins: ins, nonIns: nonIns, txs: txDetails);
    }).then(completer.complete).catchError((e, s) {
      completer.completeError(e, s);
      _handleUtxoCompleter = null;
    });

    return completer.future;
  }

  Future<int> getSafeBalance() async {
    final xos = await handleUtxo();
    final nonIns = xos.nonIns;
    final res = nonIns.fold(
      0,
      (previousValue, element) => previousValue + element.satoshis,
    );
    return res;
  }

  Future<int?> getSendBTCFee({
    required String toAddress,
    required int amount,
    required int feeRate,
    bool useUTXOCache = false,
  }) async {
    final txr = await createSendBTC(
      toAddress: toAddress,
      amount: amount,
      feeRate: feeRate,
      useUTXOCache: useUTXOCache,
    );
    final signed = await sign(txr);
    return signed.psbt.feeAmount();
  }

  /// ====== OrdTransaction ======
  Future<TxBuilderResult> createSendBTC({
    required String toAddress,
    required int amount,
    required int feeRate,
    bool useUTXOCache = false,
  }) async {
    final builder = TxBuilder();
    builder.enableRbf();
    builder.manuallySelectedOnly();
    builder.feeRate(feeRate.toDouble());
    final formatedAddress = await Address.create(address: toAddress);
    final changeAddress =
        await (await Address.create(address: currentSigner().address))
            .scriptPubKey();
    final xos = await handleUtxo(useCache: useUTXOCache);
    final ins = xos.ins;
    final nonIns = xos.nonIns;
    final txs = xos.txs;
    // builder.addInscriptions(ins);
    for (final e in ins) {
      builder.addUnSpendable(e);
    }

    Future<void> addTx(String txId) async {
      final tx = txs.firstWhereOrNull((element) => element.txId == txId);
      if (tx != null) {
        builder.addTx(tx);
      }
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
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
        continue;
      }

      fee = await builder.calFee(wallet) + amount;

      if (tmpSum < outputAmount + fee) {
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
      } else {
        break;
      }
    }

    final unspent = builder.getUnspend();

    if (unspent <= 0) {
      throw Exception('Balance not enough to pay network fee.');
    }

    final networkFee = (await builder.calNetworkFee(wallet))!;

    if (unspent < networkFee) {
      throw Exception(
        'Balance not enough. Need $networkFee Sats as network fee, but only $unspent Sats.',
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
    final lastFinalFee = amount + leftAmount + await builder.calFee(wallet);
    if (lastFinalFee > tmpSum) {
      throw Exception(
        'You need $lastFinalFee to finish the payment, but only $tmpSum avaliable.',
      );
    }

    // build finish
    final res = await builder.finish(wallet);
    res.addInputs(nonIns);
    return res;
  }

  Future<int?> getSendMultiBTCFee({
    required List<ReceiverItem> toAddresses,
    required int feeRate,
    bool useUTXOCache = false,
  }) async {
    final txr = await createSendMultiBTC(
      toAddresses: toAddresses,
      feeRate: feeRate,
      useUTXOCache: useUTXOCache,
    );
    final signed = await sign(txr);
    return signed.psbt.feeAmount();
  }

  Future<TxBuilderResult> createSendMultiBTC({
    required List<ReceiverItem> toAddresses,
    required int feeRate,
    bool useUTXOCache = false,
  }) async {
    final builder = TxBuilder();
    builder.enableRbf();
    builder.manuallySelectedOnly();
    builder.feeRate(feeRate.toDouble());

    int amount = 0;
    // formatted addresses
    final formattedAddresses = <ReceiverItemWithAddress>[];
    for (var i = 0; i < toAddresses.length; i++) {
      formattedAddresses.add(ReceiverItemWithAddress(
          address: await Address.create(address: toAddresses[i].address),
          amount: toAddresses[i].amount));
    }

    final changeAddress =
        await (await Address.create(address: currentSigner().address))
            .scriptPubKey();
    final xos = await handleUtxo(useCache: useUTXOCache);
    final ins = xos.ins;
    final nonIns = xos.nonIns;
    final txs = xos.txs;
    // builder.addInscriptions(ins);
    for (final e in ins) {
      builder.addUnSpendable(e);
    }

    Future<void> addTx(String txId) async {
      final tx = txs.firstWhereOrNull((element) => element.txId == txId);
      if (tx != null) {
        builder.addTx(tx);
      }
    }

    for (var i = 0; i < formattedAddresses.length; i++) {
      final formattedAddress = formattedAddresses[i];
      // recepient setting
      // calculate output amount
      builder.addOutput(
        OutPointExt(
          null,
          outputIndex: 0,
          txid: '',
          vout: 0,
          satoshis: formattedAddress.amount,
          scriptPk:
              (await formattedAddress.address.scriptPubKey()).internal.toHex(),
        ),
      );
      builder.addRecipient(
        await formattedAddress.address.scriptPubKey(),
        formattedAddress.amount,
      );
      amount += formattedAddress.amount;
    }

    final outputAmount =
        builder.getTotalOutput() == 0 ? amount : builder.getTotalOutput();

    var tmpSum = builder.getTotalInput();

    var fee = 0;
    for (var i = 0; i < nonIns.length; i++) {
      final nonOrdUtxo = nonIns[i];
      if (tmpSum < outputAmount) {
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
        continue;
      }

      fee = await builder.calFee(wallet) + amount;

      if (tmpSum < outputAmount + fee) {
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
      } else {
        break;
      }
    }

    final unspent = builder.getUnspend();

    if (unspent <= 0) {
      throw Exception('Balance not enough to pay network fee.');
    }

    final networkFee = (await builder.calNetworkFee(wallet))!;

    if (unspent < networkFee) {
      throw Exception(
        'Balance not enough. Need $networkFee Sats as network fee, but only $unspent Sats.',
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
    final lastFinalFee = amount + leftAmount + await builder.calFee(wallet);
    if (lastFinalFee > tmpSum) {
      throw Exception(
        'You need $lastFinalFee to finish the payment, but only $tmpSum avaliable.',
      );
    }

    // build finish
    final res = await builder.finish(wallet);
    res.addInputs(nonIns);
    return res;
  }

  Future<int?> getSendInscriptionFee({
    required String toAddress,
    required String insId,
    required int feeRate,
    int? outputValue,
    bool useUTXOCache = false,
  }) async {
    final txr = await createSendInscription(
      toAddress: toAddress,
      insId: insId,
      feeRate: feeRate,
      outputValue: outputValue,
      useUTXOCache: useUTXOCache,
    );
    final signed = await sign(txr);
    return signed.psbt.feeAmount();
  }

  // ====== OrdTransaction ======
  Future<TxBuilderResult> createSendInscription({
    required String toAddress,
    required String insId,
    required int feeRate,
    int? outputValue,
    bool useUTXOCache = false,
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
    final xos = await handleUtxo(useCache: useUTXOCache);
    final ins = xos.ins;
    final txs = xos.txs;

    void addTx(String txId) {
      final tx = txs.firstWhereOrNull((element) => element.txId == txId);
      if (tx != null) {
        builder.addTx(tx);
      }
    }

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
        builder.addForeignUtxo(e);

        addTx(e.txid);
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
          // builder.addOutput(
          //   OutPointExt(
          //     e.inscriptions,
          //     outputIndex: e.outputIndex,
          //     txid: e.txid,
          //     vout: e.vout,
          //     satoshis: ordLeft,
          //     scriptPk: changeAddress.internal.toHex(),
          //   ),
          // );
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
    final nonIns = xos.nonIns;

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
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
        continue;
      }

      fee = (await builder.calFee(wallet)) + satoshis;

      if (tmpSum < outputAmount + fee) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
      } else {
        break;
      }
    }

    final unspent = builder.getUnspend();
    if (unspent <= 0) {
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
      builder.addRecipient(changeAddress, leftAmount);
    } else {
      // builder.addRecipient(changeAddress, 1);
      throw Exception('Output below Dust Limit of $UTXO_DUST Sats.');
    }

    final lastFinalFee = leftAmount + (await builder.calNetworkFee(wallet))!;

    if (lastFinalFee > tmpSum) {
      throw Exception(
          'You need $lastFinalFee to finish the payment, but only $tmpSum avaliable.');
    }

    // finish the build and get ready to dump Data
    final res = await builder.finish(wallet);
    res.addInputs(tempInputs);

    return res;
  }

  Future<int?> getSendMultiInscriptionsFee({
    required String toAddress,
    required List<String> insIds,
    required int feeRate,
    int? outputValue,
    bool useUTXOCache = false,
  }) async {
    final txr = await createSendMultiInscriptions(
      toAddress: toAddress,
      insIds: insIds,
      feeRate: feeRate,
      outputValue: outputValue,
      useUTXOCache: useUTXOCache,
    );
    final signed = await sign(txr);
    return signed.psbt.feeAmount();
  }

  // ====== OrdTransaction ======
  Future<TxBuilderResult> createSendMultiInscriptions({
    required String toAddress,
    required List<String> insIds,
    required int feeRate,
    int? outputValue,
    bool useUTXOCache = false,
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
    final xos = await handleUtxo(useCache: useUTXOCache);
    final ins = xos.ins;
    final txs = xos.txs;

    void addTx(String txId) {
      final tx = txs.firstWhereOrNull((element) => element.txId == txId);
      if (tx != null) {
        builder.addTx(tx);
      }
    }

    // 3.1 select inscription and proctect those unspendables
    final tempInputs = <OutPointExt>[];
    var satoshis = 0;
    var found = false;
    var ordLeft = 0;
    for (final e in ins) {
      // try and find the inscription matches the inscription id
      final index = e.inscriptions!
          .indexWhere((element) => insIds.contains(element.detail.id));
      if (index > -1) {
        // add to input map
        builder.addInput(e);
        // add to bdk utxo
        builder.addForeignUtxo(e);

        addTx(e.txid);
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
          // builder.addOutput(
          //   OutPointExt(
          //     e.inscriptions,
          //     outputIndex: e.outputIndex,
          //     txid: e.txid,
          //     vout: e.vout,
          //     satoshis: ordLeft,
          //     scriptPk: changeAddress.internal.toHex(),
          //   ),
          // );
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
    final nonIns = xos.nonIns;

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
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
        continue;
      }

      fee = (await builder.calFee(wallet)) + satoshis;

      if (tmpSum < outputAmount + fee) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
      } else {
        break;
      }
    }

    final unspent = builder.getUnspend();
    if (unspent <= 0) {
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
      builder.addRecipient(changeAddress, leftAmount);
    } else {
      // builder.addRecipient(changeAddress, 1);
      throw Exception('Output below Dust Limit of $UTXO_DUST Sats.');
    }

    final lastFinalFee = leftAmount + (await builder.calNetworkFee(wallet))!;

    if (lastFinalFee > tmpSum) {
      throw Exception(
          'You need $lastFinalFee to finish the payment, but only $tmpSum avaliable.');
    }

    // finish the build and get ready to dump Data
    final res = await builder.finish(wallet);
    res.addInputs(tempInputs);

    return res;
  }

  // ====== OrdTransaction ======
  Future<TxBuilderResult> sendBTCFromInscription({
    required String toAddress,
    required String insId,
    required int feeRate,
    required int btcAmount,
  }) async {
    final builder = TxBuilder();
    builder.enableRbf();
    builder.manuallySelectedOnly();
    builder.feeRate(feeRate.toDouble());

    final outputValue = btcAmount;

    // 2. address setting
    final formatedAddress = await Address.create(address: toAddress);

    // changeAddress to be receiver
    final sendToAddress =
        await (await Address.create(address: currentSigner().address))
            .scriptPubKey();

    // 3. handle utxo and get inscriptions
    final xos = await handleUtxo();
    final ins = xos.ins;
    final txs = xos.txs;

    void addTx(String txId) {
      final tx = txs.firstWhereOrNull((element) => element.txId == txId);
      if (tx != null) {
        builder.addTx(tx);
      }
    }

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
        builder.addForeignUtxo(e);

        addTx(e.txid);
        // add to dump data inputs
        tempInputs.add(e);
        // get actual output value, if outputValue is null, use the original value
        satoshis = outputValue;

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
        if (outputValue < e.inscriptions![index].detail.output_value) {
          ordLeft = e.inscriptions![index].detail.output_value - outputValue;
          // add to output map as part of change output value
          // builder.addOutput(
          //   OutPointExt(
          //     e.inscriptions,
          //     outputIndex: e.outputIndex,
          //     txid: e.txid,
          //     vout: e.vout,
          //     satoshis: ordLeft,
          //     scriptPk: changeAddress.internal.toHex(),
          //   ),
          // );
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
    final nonIns = xos.nonIns;

    // tempInputs.addAll(nonIns);

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
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
        continue;
      }

      fee = await builder.calFee(wallet);

      if (tmpSum < outputAmount + fee) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.satoshis;
      } else {
        break;
      }
    }

    final unspent = builder.getUnspend();
    if (unspent <= 0) {
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
      builder.addRecipient(sendToAddress, leftAmount);
    } else {
      // builder.addRecipient(changeAddress, 1);
      throw Exception('Output below Dust Limit of $UTXO_DUST Sats.');
    }

    final lastFinalFee = leftAmount + (await builder.calNetworkFee(wallet))!;

    if (lastFinalFee > tmpSum) {
      throw Exception(
          'You need $lastFinalFee to finish the payment, but only $tmpSum avaliable.');
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

  Future<String> signPsbt(String psbtHex) async {
    try {
      if (isHex(psbtHex)) {
        final psbt = PartiallySignedTransaction(
            psbtBase64: base64Encode(psbtHex.toU8a()));
        final res = await wallet.sign(psbt: psbt);
        return base64Decode(res.psbtBase64).toHex();
      } else {
        throw Exception('Invalid psbt hex');
      }
    } on FfiException catch (e) {
      throw e.message;
    }
  }
}
