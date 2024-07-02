import 'dart:async';
import 'dart:typed_data';

import 'package:agent_dart_base/agent/ord/blockstream.dart';
import 'package:agent_dart_base/agent/ord/inscription_item.dart';
import 'package:agent_dart_base/agent/ord/service.dart';
import 'package:agent_dart_base/agent/ord/utxo.dart';
import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:agent_dart_base/wallet/btc/bdk/wif.dart';
import 'package:collection/collection.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

import 'btc/bdk/config.dart';

typedef PsbtSignature = Uint8List;

enum BitcoinNetwork {
  mainnet,
  testnet,
}

class ReceiverItem {
  const ReceiverItem({
    required this.address,
    required this.amount,
  });

  final String address;
  final int amount;
}

class ReceiverItemWithAddress {
  const ReceiverItemWithAddress({
    required this.address,
    required this.amount,
  });

  final Address address;
  final int amount;
}

class BTCDescriptor {
  const BTCDescriptor({
    required this.addressType,
    required this.descriptor,
    required this.network,
  });

  final AddressType addressType;
  final Descriptor descriptor;
  final Network network;
}

class PSBTDetail {
  const PSBTDetail({
    required this.inputs,
    required this.outputs,
    required this.fee,
    required this.feeRate,
    required this.size,
    required this.totalInputValue,
    required this.totalOutputValue,
    required this.txId,
    required this.psbt,
  });

  final String txId;
  final List<TxOutExt> inputs;
  final List<TxOutExt> outputs;
  final int fee;
  final double feeRate;
  final int size;
  final int totalInputValue;
  final int totalOutputValue;
  final PartiallySignedTransaction psbt;

  Map<String, dynamic> toJson() => {
        'txId': txId,
        'inputs': inputs.map((e) => e.toJson()),
        'outputs': outputs.map((e) => e.toJson()),
        'fee': fee,
        'feeRate': feeRate,
        'size': size,
        'totalInputValue': totalInputValue,
        'totalOutputValue': totalOutputValue,
        'psbt': psbt.psbtBase64
      };
}

class TxOutExt {
  TxOutExt({
    this.txId,
    required this.index,
    required this.address,
    required this.value,
    required this.isChange,
    required this.isMine,
  });

  String? txId;
  final int index;
  final Address address;
  final int value;
  final bool isChange;
  final bool isMine;

  Map<String, dynamic> toJson() => {
        'txId': txId,
        'index': index,
        'address': address.toString(),
        'value': value,
        'isChange': isChange,
        'isMine': isMine
      };
}

class UtxoHandlers {
  const UtxoHandlers(
      {required this.ins, required this.nonIns, required this.txs});

  final List<OutPointWithInscription> ins;
  final List<OutPointWithInscription> nonIns;
  final List<dynamic> txs;
}

// ignore: non_constant_identifier_names
const UTXO_DUST = 546;

class UnconfirmedBalance {
  UnconfirmedBalance({
    required this.mempoolSpendTxValue,
    required this.mempoolReceiveTxValue,
    required this.tooManyUnconfirmed,
  });

  BigInt mempoolSpendTxValue = BigInt.zero;
  BigInt mempoolReceiveTxValue = BigInt.zero;
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
    mempoolReceiveTxValue: BigInt.zero,
    mempoolSpendTxValue: BigInt.zero,
    tooManyUnconfirmed: false,
  );

  void setMempoolSpendTxValue(BigInt value) {
    _unconfirmedBalance.mempoolSpendTxValue = value;
  }

  void setMempoolReceiveTxValue(BigInt value) {
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

  BigInt get total => balance.total;

  BigInt get spendable => balance.spendable;

  BigInt get confirmed => balance.confirmed;

  BigInt get untrustedPending => balance.untrustedPending;

  BigInt get trustedPending => balance.trustedPending;

  BigInt get immature => balance.immature;

  UnconfirmedBalance get unconfirmed => _unconfirmedBalance;
}

Future<AddressInfo> getAddressInfo({
  required String phrase,
  required int index,
  Network network = Network.bitcoin,
  AddressType addressType = AddressType.P2TR,
  String? passcode,
}) async {
  final descriptors = await getDescriptors(
    phrase,
    network: network,
    addressType: addressType,
    passcode: passcode,
  );
  final descriptor = descriptors[KeychainKind.extern]!;
  return descriptor.descriptor.deriveAddressAt(index, network);
}

Future<AddressInfo> getAddressInfoFromWIF({
  required String wif,
  Network network = Network.bitcoin,
  AddressType addressType = AddressType.P2TR,
}) async {
  final descriptor = await importSingleWif(
    wif,
    addressType: addressType,
    network: network,
  );
  return descriptor.descriptor.deriveAddressAt(0, network);
}

Future<Map<KeychainKind, BTCDescriptor>> getDescriptors(
  String mnemonic, {
  AddressType addressType = AddressType.P2TR,
  Network network = Network.bitcoin,
  String? passcode,
}) async {
  final mnemonicObj = await Mnemonic.fromString(mnemonic);
  final descriptorSecretKey = await DescriptorSecretKey.create(
    network: network,
    mnemonic: mnemonicObj,
    password: passcode,
  );
  descriptorSecretKey.derivationPath = await DerivationPath.create(
    path: addressType.derivedPath,
  );
  final descriptors = <KeychainKind, BTCDescriptor>{};
  for (final e in KeychainKind.values) {
    final create = switch (addressType) {
      AddressType.P2PKHTR => Descriptor.newBip44TR,
      AddressType.P2TR => Descriptor.newBip86,
      AddressType.P2SH_P2WPKH => Descriptor.newBip49,
      AddressType.P2WPKH => Descriptor.newBip84,
      AddressType.P2PKH => Descriptor.newBip44,
    };
    final descriptor = await create(
      secretKey: descriptorSecretKey,
      network: network,
      keychain: e,
    );
    descriptors[e] = BTCDescriptor(
      addressType: addressType,
      descriptor: descriptor,
      network: network,
    );
  }
  return descriptors;
}

Future<BTCDescriptor> importSingleWif(
  String wif, {
  AddressType addressType = AddressType.P2TR,
  Network network = Network.bitcoin,
}) async {
  final descriptor = await Descriptor.importSingleWif(
    wif: wif,
    addressType: addressType,
    network: network,
  );

  final sec = await DescriptorSecretKey.fromString(wif);

  descriptor.descriptorSecretKey = sec;

  return BTCDescriptor(
    addressType: addressType,
    descriptor: descriptor,
    network: network,
  );
}

enum WalletType { HD, Single }

class BitcoinWallet {
  BitcoinWallet({
    required this.wallet,
    required this.addressType,
    required this.descriptor,
    this.network = Network.bitcoin,
    this.ordService,
    this.blockStreamApi,
    WalletType walletType = WalletType.HD,
  }) : _walletType = walletType;

  final Wallet wallet;
  final AddressType addressType;
  final BTCDescriptor descriptor;

  // late Blockchain blockchain;
  Network network;
  WalletType _walletType;
  OrdService? ordService;
  BlockStreamApi? blockStreamApi;

  late AddressInfo _selectedSigner;
  String? _publicKey;
  int? _index;

  String? getPublicKey() => _publicKey;

  bool _useExternalApi = false;

  SignIdentity? _signIdentity;

  final int coinbaseMaturity = 100;

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

  void setWalletType(WalletType type) {
    _walletType = type;
  }

  WalletType getWalletType() {
    return _walletType;
  }

  // Future<void> blockchainInit({
  //   Network network = Network.bitcoin,
  //   BlockchainConfig? blockchainConfig,
  // }) async {
  //   blockchain = await Blockchain.create(
  //     config: blockchainConfig ??
  //         BlockchainConfig.electrum(
  //           config: ElectrumConfig(
  //             stopGap: 10,
  //             timeout: 5,
  //             retry: 5,
  //             url:
  //                 'ssl://electrum.blockstream.info:${network == Network.bitcoin ? 50002 : 60002}',
  //             validateDomain: false,
  //           ),
  //         ),
  //   );
  //   // blockchain = await Blockchain.create(
  //   //     config: BlockchainConfig.esplora(
  //   //         config: EsploraConfig(
  //   //   baseUrl:
  //   //       'https://mempool.space/${(net ?? network) == Network.bitcoin ? '' : 'testnet/'}api', // https://mempool.space/api',
  //   //   concurrency: 4,
  //   //   stopGap: 10,
  //   // )));
  // }

  static Future<BitcoinWallet> fromPhrase(
    String phrase, {
    Network network = Network.bitcoin,
    AddressType addressType = AddressType.P2TR,
    String? passcode,
  }) async {
    final descriptors = await getDescriptors(
      phrase,
      network: network,
      addressType: addressType,
      passcode: passcode,
    );
    final descriptor = descriptors[KeychainKind.extern]!;
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
      network: network,
      walletType: WalletType.HD,
    );
    // await wallet.blockchainInit(network: network);
    return wallet;
  }

  static Future<BitcoinWallet> fromWif(
    String wifOrHex, {
    Network network = Network.bitcoin,
    AddressType addressType = AddressType.P2TR,
    WalletType walletType = WalletType.HD,
  }) async {
    final WIF wif;
    final String mayBeWif;
    if (isHex(wifOrHex)) {
      wif = WIF.fromHex(wifOrHex.toU8a(), network: network);
      mayBeWif = wifEncoder.convert(wif);
    } else {
      wif = wifDecoder.convert(wifOrHex);
      mayBeWif = wifEncoder.convert(wif);
    }

    final descriptor = await importSingleWif(
      mayBeWif,
      network: network,
      addressType: addressType,
    );
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
      network: network,
      walletType: WalletType.Single,
    );
    // await wallet.blockchainInit(network: network);
    return wallet;
  }

  Future<DescriptorSecretKey> getDescriptorSecretKey(int? index) async {
    final DescriptorSecretKey k;
    if (descriptor.descriptor.descriptorSecretKey?.derivedPathPrefix != null) {
      k = await descriptor.descriptor.descriptorSecretKey!.deriveIndex(index!);
    } else {
      k = descriptor.descriptor.descriptorSecretKey!;
    }
    return k;
  }

  // ====== Signer ======
  Future<AddressInfo> getSigner(int index) async {
    final k = await getDescriptorSecretKey(index);
    final kBytes = Uint8List.fromList(await k.secretBytes());
    _publicKey = await k.getPubFromBytes(kBytes);
    return wallet.getAddress(
      addressIndex: AddressIndex.reset(
        index: getWalletType() == WalletType.HD ? index : 0,
      ),
    );
  }

  Future<void> selectSigner(int index) async {
    _selectedSigner =
        await getSigner(getWalletType() == WalletType.HD ? index : 0);
    _index = getWalletType() == WalletType.HD ? index : 0;
  }

  int? currentIndex() {
    return _index;
  }

  AddressInfo currentSigner() {
    return _selectedSigner;
  }

  // Future<void> sync() {
  //   return wallet.sync(blockchain);
  // }

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
      address ??= _selectedSigner.address;
      BigInt immature = BigInt.zero;
      final trustedPending =
          BigInt.zero; // we don't use internal key to receive
      BigInt untrustedPending = BigInt.zero;
      BigInt confirmed = BigInt.zero;
      BigInt mempoolSpendTxValue = BigInt.zero;
      BigInt mempoolReceiveTxValue = BigInt.zero;
      bool tooManyUnconfirmed = false;

      final utxos = await blockStreamApi!.getAddressUtxo(address);
      final blockHeight = await getHeight();
      for (int i = 0; i < utxos.length; i++) {
        final u = utxos[i];

        if (u.status.confirmed) {
          final tx = await getTxFromTxId(u.txid);
          if (await tx.isCoinBase() &&
              (blockHeight - u.status.blockHeight!) < coinbaseMaturity) {
            immature += BigInt.from(u.value);
          } else {
            confirmed += BigInt.from(u.value);
          }
        } else {
          untrustedPending += BigInt.from(u.value);
        }
      }
      final spendable = confirmed + trustedPending;
      var total = spendable + immature;

      if (includeUnconfirmed) {
        final txCount = (await blockStreamApi!.getAddressStats(address))
            .mempoolStats
            .txCount;
        if (txCount <= 0) {
          mempoolSpendTxValue = BigInt.zero;
          mempoolReceiveTxValue = BigInt.zero;
        } else {
          if (txCount > 50) {
            tooManyUnconfirmed = true;
          }
          final mempoolTxs =
              await blockStreamApi!.getAddressTxs(address: address);

          for (var i = 0; i < mempoolTxs.length; i++) {
            final tx = mempoolTxs[i];
            if (tx.status.confirmed) {
              continue;
            }
            mempoolSpendTxValue += tx.vin
                .where((e) => e.prevout.scriptpubkeyAddress == address)
                .fold(
                  BigInt.zero,
                  (prev, e) => prev + BigInt.from(e.prevout.value),
                );
            mempoolReceiveTxValue += tx.vout
                .where((e) => e.scriptpubkeyAddress == address)
                .fold(BigInt.zero, (prev, e) => prev + BigInt.from(e.value));
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
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  ///Return the list of unspent outputs of this wallet
  ///
  /// Note that this method only operates on the internal database, which first needs to be Wallet().sync manually.
  Future<List<Utxo>> listUnspent({
    String? address,
  }) async {
    try {
      // final utxos = await ordService!.getUtxo(_selectedSigner.address);
      final utxos =
          await ordService!.getUtxoGet(address ?? _selectedSigner.address);
      return utxos;
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  Future<List<InscriptionItem>> listInscriptions({
    String? address,
  }) async {
    try {
      // final utxos = await ordService!.getUtxo(_selectedSigner.address);
      final ins =
          await ordService!.getInscriptions(address ?? _selectedSigner.address);
      return ins;
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  ///Return an unsorted list of transactions made and received by the wallet
  // Future<List<TransactionDetails>> listTransactions() async {
  //   try {
  //     final res = await AgentDartFFI.impl
  //         .psbtWalletGetTxs(wallet: _selectedSigner.getWalletReq());
  //     return res;
  //   } on AnyhowException catch (e) {
  //     throw (e.message);
  //   }
  // }

  Future<int> getHeight() async {
    try {
      final res = await blockStreamApi!.getBlockHeight();
      return res;
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  // Future<Transaction> getTx(String txid) async {
  //   try {
  //     final res = await blockchain.getTx(txid);
  //     return await Transaction.create(transactionBytes: res.toU8a());
  //   } on AnyhowException catch (e) {
  //     throw e.message;
  //   }
  // }

  Future<Transaction> getTxFromTxId(String txid) async {
    try {
      final res = await blockStreamApi!.getTxHex(txid);
      return await Transaction.create(transactionBytes: res.toU8a());
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  Future<String> broadCast(TxBuilderResult tx) async {
    try {
      final theTx = await tx.psbt.extractTx();
      return await blockStreamApi!
          .broadcastTx(Uint8List.fromList(await theTx.serialize()).toHex());
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  Completer<UtxoHandlers>? _handleUtxoCompleter;

  Future<UtxoHandlers> handleUtxo({
    bool useCache = false,
    String? address,
  }) async {
    if (_handleUtxoCompleter != null && useCache) {
      return _handleUtxoCompleter!.future;
    }
    final completer = Completer<UtxoHandlers>();
    _handleUtxoCompleter = completer;
    Future(() async {
      final rets = await Future.wait([
        listUnspent(address: address),
        listInscriptions(address: address),
      ]);
      final List<Utxo> utxos = rets[0] as List<Utxo>;
      final List<InscriptionItem> allIns = (rets[1] as List<InscriptionItem>)
        ..sort((a, b) => b.num!.compareTo(a.num!));
      final ins = <OutPointWithInscription>[];
      final nonIns = <OutPointWithInscription>[];
      final txDetails = <TxBytes>[];
      for (var i = 0; i < utxos.length; i += 1) {
        final e = utxos[i];
        final bytes = !_useExternalApi
            ? Uint8List.fromList(
                await (await getTxFromTxId(e.txId)).serialize(),
              )
            : ((await blockStreamApi!.getTxHex(e.txId)).toU8a());
        final tx = TxBytes(
          bytes: bytes,
          txId: e.txId,
        );
        txDetails.add(tx);
        if (e.inscriptions.isNotEmpty) {
          final idList = e.inscriptions.map((e) => e.id).toSet();
          final insList = allIns
              .where((element) => idList.contains(element.id))
              .map(
                (e) => InscriptionValue(
                  inscriptionId: e.id,
                  outputValue: e.detail.outputValue,
                ),
              )
              .toList();
          ins.add(
            OutPointWithInscription(
              inscriptions: insList,
              txid: e.txId,
              vout: e.outputIndex,
              value: e.satoshis,
              scriptPk: e.scriptPk,
            ),
          );
        } else {
          nonIns.add(
            OutPointWithInscription(
              txid: e.txId,
              vout: e.outputIndex,
              value: e.satoshis,
              scriptPk: e.scriptPk,
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

  Future<int> getSafeBalance({String? address}) async {
    final xos = await handleUtxo(address: address);
    final nonIns = xos.nonIns;
    final res = nonIns.fold(0, (p, v) => p + v.value);
    return res;
  }

  Future<int> getOrdinalBalance({String? address}) async {
    final xos = await handleUtxo(address: address);
    final ins = xos.ins;
    final res = ins.fold(0, (p, v) => p + v.value);
    return res;
  }

  Future<int?> getSendBTCFee({
    required String toAddress,
    required int amount,
    required int feeRate,
    bool useUTXOCache = false,
    bool bigAmountFirst = true,
  }) async {
    final txr = await createSendBTC(
      toAddress: toAddress,
      amount: amount,
      feeRate: feeRate,
      useUTXOCache: useUTXOCache,
      bigAmountFirst: bigAmountFirst,
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
    bool bigAmountFirst = true,
  }) async {
    final builder = TxBuilder();
    builder.enableRbf();
    builder.manuallySelectedOnly();
    builder.feeRate(feeRate.toDouble());
    final formattedAddress = await Address.create(address: toAddress);
    final changeAddress =
        await (await Address.create(address: currentSigner().address))
            .scriptPubKey();
    final xos = await handleUtxo(useCache: useUTXOCache);
    final ins = xos.ins;
    final nonIns = xos.nonIns;

    if (bigAmountFirst) {
      nonIns.sort((a, b) => b.value.compareTo(a.value));
    } else {
      nonIns.sort((a, b) => a.value.compareTo(b.value));
    }

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
      OutPointWithInscription(
        txid: '',
        vout: 0,
        value: amount,
        scriptPk: (await formattedAddress.scriptPubKey()).internal.toHex(),
      ),
    );
    builder.addRecipient(await formattedAddress.scriptPubKey(), amount);

    final outputAmount =
        builder.getTotalOutput() == 0 ? amount : builder.getTotalOutput();

    var tmpSum = builder.getTotalInput();
    final tempAddInputs = <OutPointWithInscription>[];

    int fee = 0;
    for (int i = 0; i < nonIns.length; i++) {
      final nonOrdUtxo = nonIns[i];
      if (tmpSum < outputAmount) {
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempAddInputs.add(nonOrdUtxo);
        continue;
      }

      fee = (await builder.calFee(wallet)).toInt() + amount;

      if (tmpSum < outputAmount + fee) {
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempAddInputs.add(nonOrdUtxo);
      } else {
        break;
      }
    }

    final unspent = builder.getUnspend();

    if (unspent <= 0) {
      throw Exception('Balance not enough to pay network fee.');
    }

    final networkFee = (await builder.calNetworkFee(wallet))!.toInt();

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
    final lastFinalFee =
        amount + leftAmount + (await builder.calFee(wallet)).toInt();
    if (lastFinalFee > tmpSum) {
      throw Exception(
        'You need $lastFinalFee to finish the payment, '
        'but only $tmpSum available.',
      );
    }

    // build finish
    final res = await builder.finish(wallet);
    return res;
  }

  Future<int?> getSendMultiBTCFee({
    required List<ReceiverItem> toAddresses,
    required int feeRate,
    bool useUTXOCache = false,
    bool bigAmountFirst = true,
  }) async {
    final txr = await createSendMultiBTC(
      toAddresses: toAddresses,
      feeRate: feeRate,
      useUTXOCache: useUTXOCache,
      bigAmountFirst: bigAmountFirst,
    );
    final signed = await sign(txr);
    return signed.psbt.feeAmount();
  }

  Future<TxBuilderResult> createSendMultiBTC({
    required List<ReceiverItem> toAddresses,
    required int feeRate,
    bool useUTXOCache = false,
    bool bigAmountFirst = true,
  }) async {
    final builder = TxBuilder();
    builder.enableRbf();
    builder.manuallySelectedOnly();
    builder.feeRate(feeRate.toDouble());

    int amount = 0;
    // formatted addresses
    final formattedAddresses = <ReceiverItemWithAddress>[];
    for (var i = 0; i < toAddresses.length; i++) {
      formattedAddresses.add(
        ReceiverItemWithAddress(
          address: await Address.create(address: toAddresses[i].address),
          amount: toAddresses[i].amount,
        ),
      );
    }

    final changeAddress =
        await (await Address.create(address: currentSigner().address))
            .scriptPubKey();
    final xos = await handleUtxo(useCache: useUTXOCache);
    final ins = xos.ins;
    final nonIns = xos.nonIns;
    if (bigAmountFirst) {
      nonIns.sort((a, b) => b.value.compareTo(a.value));
    } else {
      nonIns.sort((a, b) => a.value.compareTo(b.value));
    }
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
        OutPointWithInscription(
          txid: '',
          vout: 0,
          value: formattedAddress.amount,
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
    final tempAddInputs = <OutPointWithInscription>[];

    int fee = 0;
    for (int i = 0; i < nonIns.length; i++) {
      final nonOrdUtxo = nonIns[i];
      if (tmpSum < outputAmount) {
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempAddInputs.add(nonOrdUtxo);
        continue;
      }

      fee = await builder.calFee(wallet) + amount;

      if (tmpSum < outputAmount + fee) {
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempAddInputs.add(nonOrdUtxo);
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
    return res;
  }

  Future<int?> getSendInscriptionFee({
    required String toAddress,
    required String insId,
    required int feeRate,
    int? outputValue,
    bool useUTXOCache = false,
    bool bigAmountFirst = true,
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
    bool bigAmountFirst = true,
  }) async {
    // 1. basic setting
    final builder = TxBuilder();
    builder.enableRbf();
    builder.manuallySelectedOnly();
    builder.feeRate(feeRate.toDouble());

    // 2. address setting
    final formattedAddress = await Address.create(address: toAddress);
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
    final tempInputs = <OutPointWithInscription>[];
    int satoshis = 0;
    bool found = false;
    int ordLeft = 0;
    for (final e in ins) {
      // try and find the inscription matches the inscription id
      final index = e.inscriptions!
          .indexWhere((element) => element.inscriptionId == insId);
      if (index > -1) {
        // add to input map
        builder.addInput(e);
        // add to bdk utxo
        builder.addForeignUtxo(e);

        addTx(e.txid);
        // add to dump data inputs
        tempInputs.add(e);
        // get actual output value, if outputValue is null, use the original value
        satoshis = outputValue ?? e.inscriptions![index].outputValue;

        // add output to output map
        builder.addOutput(
          OutPointWithInscription(
            inscriptions: e.inscriptions,
            txid: e.txid,
            vout: e.vout,
            value: satoshis,
            scriptPk: (await formattedAddress.scriptPubKey()).internal.toHex(),
          ),
        );
        // add to bdk recipient
        builder.addRecipient(await formattedAddress.scriptPubKey(), satoshis);

        // add change output
        if (outputValue != null &&
            outputValue < e.inscriptions![index].outputValue) {
          ordLeft = e.inscriptions![index].outputValue - outputValue;
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

    if (bigAmountFirst) {
      nonIns.sort((a, b) => b.value.compareTo(a.value));
    } else {
      nonIns.sort((a, b) => a.value.compareTo(b.value));
    }

    // calcluate output amount
    final outputAmount = builder.getTotalOutput();
    // print('outputAmount: $outputAmount');

    int tmpSum = builder.getTotalInput();
    int fee = 0;
    for (int i = 0; i < nonIns.length; i++) {
      final nonOrdUtxo = nonIns[i];
      if (tmpSum < outputAmount) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempInputs.add(nonOrdUtxo);
        continue;
      }

      fee = (await builder.calFee(wallet)) + satoshis;

      if (tmpSum < outputAmount + fee) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempInputs.add(nonOrdUtxo);
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
        'You need $lastFinalFee to finish the payment, '
        'but only $tmpSum available.',
      );
    }

    // finish the build and get ready to dump Data
    final res = await builder.finish(wallet);
    return res;
  }

  Future<int?> getSendMultiInscriptionsFee({
    required String toAddress,
    required List<String> insIds,
    required int feeRate,
    int? outputValue,
    bool useUTXOCache = false,
    bool bigAmountFirst = true,
  }) async {
    final txr = await createSendMultiInscriptions(
      toAddress: toAddress,
      insIds: insIds,
      feeRate: feeRate,
      outputValue: outputValue,
      useUTXOCache: useUTXOCache,
      bigAmountFirst: bigAmountFirst,
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
    bool bigAmountFirst = true,
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
    final tempInputs = <OutPointWithInscription>[];
    int satoshis = 0;
    bool found = false;
    int ordLeft = 0;
    for (final e in ins) {
      // try and find the inscription matches the inscription id
      final index = e.inscriptions!.indexWhere(
        (element) => insIds.contains(element.inscriptionId),
      );
      if (index > -1) {
        // add to input map
        builder.addInput(e);
        // add to bdk utxo
        builder.addForeignUtxo(e);

        addTx(e.txid);
        // add to dump data inputs
        tempInputs.add(e);
        // get actual output value, if outputValue is null, use the original value
        satoshis = outputValue ?? e.inscriptions![index].outputValue;

        // add output to output map
        builder.addOutput(
          OutPointWithInscription(
            inscriptions: e.inscriptions,
            txid: e.txid,
            vout: e.vout,
            value: satoshis,
            scriptPk: (await formatedAddress.scriptPubKey()).internal.toHex(),
          ),
        );
        // add to bdk recipient
        builder.addRecipient(await formatedAddress.scriptPubKey(), satoshis);

        // add change output
        if (outputValue != null &&
            outputValue < e.inscriptions![index].outputValue) {
          ordLeft = e.inscriptions![index].outputValue - outputValue;
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

    if (bigAmountFirst) {
      nonIns.sort((a, b) => b.value.compareTo(a.value));
    } else {
      nonIns.sort((a, b) => a.value.compareTo(b.value));
    }

    // calcluate output amount
    final outputAmount = builder.getTotalOutput();
    // print('outputAmount: $outputAmount');

    var tmpSum = builder.getTotalInput();
    int fee = 0;
    for (var i = 0; i < nonIns.length; i++) {
      final nonOrdUtxo = nonIns[i];
      if (tmpSum < outputAmount) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempInputs.add(nonOrdUtxo);
        continue;
      }

      fee = (await builder.calFee(wallet)) + satoshis;

      if (tmpSum < outputAmount + fee) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempInputs.add(nonOrdUtxo);
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
        'Balance not enough. Need $networkFee Sats as network fee, '
        'but only $unspent BTC.',
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
    return res;
  }

  // ====== OrdTransaction ======
  Future<TxBuilderResult> sendBTCFromInscription({
    required String toAddress,
    required String insId,
    required int feeRate,
    required int btcAmount,
    bool bigAmountFirst = true,
  }) async {
    final builder = TxBuilder();
    builder.enableRbf();
    builder.manuallySelectedOnly();
    builder.feeRate(feeRate.toDouble());

    final outputValue = btcAmount;

    // 2. address setting
    final formattedAddress = await Address.create(address: toAddress);

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
    final tempInputs = <OutPointWithInscription>[];
    int satoshis = 0;
    var found = false;
    int ordLeft = 0;
    for (final e in ins) {
      // try and find the inscription matches the inscription id
      final index = e.inscriptions!
          .indexWhere((element) => element.inscriptionId == insId);
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
          OutPointWithInscription(
            inscriptions: e.inscriptions,
            txid: e.txid,
            vout: e.vout,
            value: satoshis,
            scriptPk: (await formattedAddress.scriptPubKey()).internal.toHex(),
          ),
        );
        // add to bdk recipient
        builder.addRecipient(await formattedAddress.scriptPubKey(), satoshis);

        // add change output
        if (outputValue < e.inscriptions![index].outputValue) {
          ordLeft = e.inscriptions![index].outputValue - outputValue;
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

    if (bigAmountFirst) {
      nonIns.sort((a, b) => b.value.compareTo(a.value));
    } else {
      nonIns.sort((a, b) => a.value.compareTo(b.value));
    }

    // tempInputs.addAll(nonIns);

    // calcluate output amount
    final outputAmount = builder.getTotalOutput();
    // print('outputAmount: $outputAmount');

    var tmpSum = builder.getTotalInput();

    int fee = 0;
    for (int i = 0; i < nonIns.length; i++) {
      final nonOrdUtxo = nonIns[i];
      if (tmpSum < outputAmount) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempInputs.add(nonOrdUtxo);
        continue;
      }

      fee = await builder.calFee(wallet);

      if (tmpSum < outputAmount + fee) {
        // manually add input to inputs
        builder.addInput(nonOrdUtxo);
        builder.addForeignUtxo(nonOrdUtxo);
        addTx(nonOrdUtxo.txid);
        tmpSum += nonOrdUtxo.value;
        tempInputs.add(nonOrdUtxo);
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
        'Balance not enough. Need $networkFee Sats as network fee, '
        'but only $unspent BTC.',
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
        'You need $lastFinalFee to finish the payment, '
        'but only $tmpSum available.',
      );
    }

    // finish the build and get ready to dump Data
    final res = await builder.finish(wallet);
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

  /// Sign a transaction with all the wallet’s signers, in the order specified by every signer’s SignerOrdering
  ///
  /// Note that it can’t be guaranteed that every signers will follow the options, but the “software signers” (WIF keys and xprv) defined in this library will.
  Future<TxBuilderResult> sign(TxBuilderResult buildResult) async {
    try {
      final sbt = await wallet.sign(psbt: buildResult.psbt);
      return TxBuilderResult(
        psbt: sbt,
        txDetails: buildResult.txDetails,
        signed: true,
      );
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  Future<String> signPsbt(
    String psbtHex, {
    SignOptions options = defaultSignOptions,
  }) {
    return wallet.signPsbt(psbtHex, options: options);
  }

  Future<String> pushPsbt(String psbtHex) async {
    try {
      final psbt = PartiallySignedTransaction.parse(psbtHex);
      final tx = await psbt.extractTx();

      return await blockStreamApi!
          .broadcastTx(Uint8List.fromList(await tx.serialize()).toHex());
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  Future<List<String>> signPsbts(
    List<String> psbtHexs, {
    SignOptions options = defaultSignOptions,
  }) async {
    try {
      return await Future.wait(
        psbtHexs.map((hex) => signPsbt(hex, options: options)),
      );
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  Future<PSBTDetail> dumpPsbt(String psbtHex) async {
    final psbt = PartiallySignedTransaction.parse(psbtHex);
    final tx = await psbt.extractTx();

    final psbtInputs = await psbt.getPsbtInputs();

    final inputsExt = <TxOutExt>[];
    final txInputs = await tx.input();

    for (var i = 0; i < psbtInputs.length; i += 1) {
      final element = psbtInputs[i];
      final input = txInputs[i];
      final txId = input.previousOutput.txid;
      final addr = await Address.fromScript(element.scriptPubkey, network);

      inputsExt.add(
        TxOutExt(
          txId: txId,
          index: i,
          address: addr,
          value: element.value.toInt(),
          isMine: addr.address == currentSigner().address,
          isChange: false,
        ),
      );
    }
    final outputs = await tx.output();
    final outputsExt = <TxOutExt>[];

    for (var i = 0; i < outputs.length; i += 1) {
      final element = outputs[i];
      final addr = await Address.fromScript(element.scriptPubkey, network);

      outputsExt.add(
        TxOutExt(
          index: i,
          address: addr,
          value: element.value.toInt(),
          isMine: addr.address == currentSigner().address,
          isChange: i == outputs.length - 1 ? true : false,
        ),
      );
    }

    final size = Uint8List.fromList(await tx.serialize()).length;
    final feePaid = await psbt.feeAmount();
    final feeRate = (await psbt.feeRate())!.asSatPerVb();
    final txId = (await tx.txid()).toString();

    return PSBTDetail(
      txId: txId,
      inputs: inputsExt,
      outputs: outputsExt,
      fee: feePaid!,
      feeRate: feeRate,
      size: size,
      totalInputValue: inputsExt.fold(0, (v, i) => i.value + v),
      totalOutputValue: outputsExt.fold(0, (v, i) => i.value + v),
      psbt: psbt,
    );
  }

  Future<String> signMessage(
    String message, {
    bool toBase64 = true,
    bool useBip322 = false,
  }) async {
    try {
      final k = await getDescriptorSecretKey(currentIndex());
      final kBytes = Uint8List.fromList(await k.secretBytes());

      if (!useBip322) {
        final res = await signSecp256k1WithRNG(
          wallet.messageHandler(message),
          kBytes,
        );

        /// move v to the top, and plus 27
        final v = res.sublist(64, 65);
        v[0] = v[0] + 27;

        // regroup the signature
        final msgSig = u8aConcat([v, res.sublist(0, 64)]);

        if (toBase64) {
          return base64Encode(msgSig);
        }
        return msgSig.toHex();
      } else {
        String? res;
        if (addressType == AddressType.P2TR) {
          res = await Api.bip322SignTaproot(secret: kBytes, message: message);
        } else {
          res = await Api.bip322SignSegwit(secret: kBytes, message: message);
        }
        if (toBase64) {
          return res;
        } else {
          return base64Decode(res).toHex();
        }
      }
    } on AnyhowException catch (e) {
      throw e.message;
    }
  }

  Future<Secp256k1KeyIdentity> getIdentity() async {
    final k = await getDescriptorSecretKey(currentIndex());
    final kBytes = Uint8List.fromList(await k.secretBytes());
    _signIdentity = await Secp256k1KeyIdentity.fromSecretKey(kBytes);
    return _signIdentity as Secp256k1KeyIdentity;
  }
}
