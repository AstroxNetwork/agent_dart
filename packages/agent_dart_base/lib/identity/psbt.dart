import 'dart:async';
import 'dart:typed_data';

import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:agent_dart_base/src/ffi/io.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

typedef PsbtSignature = Uint8List;

enum BitcoinNetwork {
  mainnet,
  testnet,
}

const keyTypes = [Bip.bip86, Bip.bip84, Bip.bip44, Bip.bip49];

abstract class AddressType {
  static const P2TR = 'p2tr';
  static const P2WPKH = 'p2wpkh';
  static const P2SH_P2WPKH = 'p2sh';
  static const P2PKH = 'p2pkh';
}

class BitcoinSigner {
  final int keyType;
  final BitcoinNetwork network;
  final KeyPair keyPair;
  final String addressType;
  final String address;
  BitcoinSigner(
      {required this.keyType,
      required this.network,
      required this.keyPair,
      required this.addressType,
      required this.address});

  @override
  String toString() {
    return 'BitcoinSigner(keyType: $keyType, network: $network, keyPair: ${keyPair.toString()}, addressType: $addressType, address: $address)';
  }

  PsbtWalletReq getWalletReq() {
    return PsbtWalletReq(
        prv: keyPair.secretKey.toHex(),
        addressType: addressType,
        network: network == BitcoinNetwork.mainnet ? 'bitcoin' : 'testnet');
  }
}

class BitcoinWallet {
  List<BitcoinSigner> signers = [];

  late BitcoinSigner _selectedSigner;

  BitcoinWallet({required this.signers});

  static Future<BitcoinWallet> fromPhrase(String phrase,
      {BitcoinNetwork? network = BitcoinNetwork.mainnet}) async {
    // final keyPair = Secp256k1KeyPair.fromPhrase(phrase);
    final net = network == BitcoinNetwork.mainnet ? 'bitcoin' : 'testnet';

    final signers = await Future.wait(keyTypes.map((e) async {
      return await signerGen(phrase, e, net);
    }));
    final wallet = BitcoinWallet(signers: signers);
    wallet.selectSigner(AddressType.P2TR);
    return wallet;
  }

  BitcoinSigner getSigner(String addressType) {
    return signers.firstWhere(
      (element) => element.addressType == addressType,
      orElse: () => throw 'No Signers Added',
    );
  }

  void selectSigner(String addressType) {
    _selectedSigner = getSigner(addressType);
  }

  BitcoinSigner currentSigner() {
    return _selectedSigner;
  }

  ///Return the [Balance], separated into available, trusted-pending, untrusted-pending and immature values.
  ///
  ///Note that this method only operates on the internal database, which first needs to be Wallet().sync manually.
  // Future<Balance> getBalance() async {
  //   try {
  //     var res = await AgentDartFFI.impl
  //         .psbtWalletGetBalance(wallet: _selectedSigner.getWalletReq());
  //     return res;
  //   } on FfiException catch (e) {
  //     throw (e.message);
  //   }
  // }

  // ///Get the Bitcoin network the wallet is using.
  // Future<Network> network() async {
  //   try {
  //     var res = await AgentDartFFI.impl.getNetwork(wallet: _wallet!);
  //     return res;
  //   } on FfiException catch (e) {
  //     throw (e.message);
  //   }
  // }

  ///Return the list of unspent outputs of this wallet
  ///
  /// Note that this method only operates on the internal database, which first needs to be Wallet().sync manually.
  // Future<List<LocalUtxo>> listUnspent() async {
  //   try {
  //     var res = await AgentDartFFI.impl
  //         .psbtWalletListUnspent(wallet: _selectedSigner.getWalletReq());
  //     return res;
  //   } on FfiException catch (e) {
  //     throw (e.message);
  //   }
  // }

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

  ///Sign a transaction with all the wallet’s signers, in the order specified by every signer’s SignerOrdering
  ///
  /// Note that it can’t be guaranteed that every signers will follow the options, but the “software signers” (WIF keys and xprv) defined in this library will.
  Future<PartiallySignedTransaction> sign(
      PartiallySignedTransaction psbt) async {
    try {
      final sbt = await AgentDartFFI.impl.psbtWalletSign(
          psbt: psbt.psbtBase64,
          wallet: _selectedSigner.getWalletReq()!,
          isMultiSig: false);
      if (sbt == null) {
        throw 'Unable to sign transaction';
      }
      return PartiallySignedTransaction(psbtBase64: sbt);
    } on FfiException catch (e) {
      throw (e.message);
    }
  }
}

Future<BitcoinSigner> signerGen(String phrase, int root, String network) async {
  final key = await getECKeysAsync(phrase, coinType: 0, root: root);
  final prv = key.ecPrivateKey;
  final pub = getPublicFromPrivateKey(prv!);
  final keyPair = Secp256k1KeyPair(
      secretKey: prv, publicKey: Secp256k1PublicKey.fromRaw(pub!));
  final adresses = (await AgentDartFFI.impl.psbtGetAddress(
      req: GetAddressReq(publicKey: pub.toHex(), network: network)));

  String address;
  String addressType;
  switch (root) {
    case Bip.bip86:
      address = adresses.p2Tr;
      addressType = AddressType.P2TR;
      break;
    case Bip.bip84:
      address = adresses.p2Wpkh;
      addressType = AddressType.P2WPKH;
      break;
    case Bip.bip49:
      address = adresses.p2ShP2Wpkh;
      addressType = AddressType.P2SH_P2WPKH;
      break;
    case Bip.bip44:
      address = adresses.p2Pkh;
      addressType = AddressType.P2PKH;
      break;
    default:
      address = adresses.p2Tr;
      addressType = AddressType.P2TR;
  }

  return BitcoinSigner(
      address: address,
      addressType: addressType,
      keyType: root,
      keyPair: keyPair,
      network: network == 'bitcoin'
          ? BitcoinNetwork.mainnet
          : BitcoinNetwork.testnet);
}

///A transaction builder
///
/// A TxBuilder is created by calling TxBuilder or BumpFeeTxBuilder on a wallet.
/// After assigning it, you set options on it until finally calling finish to consume the builder and generate the transaction.
class TxBuilder {
  final List<ScriptAmount> _recipients = [];
  final List<OutPoint> _utxos = [];
  bool _doNotSpendChange = false;
  final List<OutPoint> _unSpendable = [];
  bool _manuallySelectedOnly = false;
  bool _onlySpendChange = false;
  double? _feeRate;
  int? _feeAbsolute;
  bool _enableRbf = false;
  bool _drainWallet = false;
  String? _drainTo;
  int? _nSequence;
  Uint8List _data = Uint8List.fromList([]);

  ///Add data as an output, using OP_RETURN
  TxBuilder addData({required List<int> data}) {
    if (data.isEmpty) {
      throw 'List must not be empty';
    }
    _data = Uint8List.fromList(data);
    return this;
  }

  ///Add a recipient to the internal list
  // TxBuilder addRecipient(Script script, int amount) {
  //   _recipients.add(ScriptAmount(script: script.toString(), amount: amount));
  //   return this;
  // }

  ///Add a utxo to the internal list of unspendable utxos
  ///
  /// It’s important to note that the “must-be-spent” utxos added with TxBuilder().addUtxo have priority over this.
  /// See the docs of the two linked methods for more details.
  TxBuilder unSpendable(List<OutPoint> outpoints) {
    for (var e in outpoints) {
      _unSpendable.add(e);
    }
    return this;
  }

  ///Add a utxo to the internal list of utxos that must be spent
  ///
  /// These have priority over the “unspendable” utxos, meaning that if a utxo is present both in the “utxos” and the “unspendable” list, it will be spent.
  TxBuilder addUtxo(OutPoint outpoint) {
    _utxos.add(outpoint);
    return this;
  }

  ///Add the list of outpoints to the internal list of UTXOs that must be spent.
  ///
  ///If an error occurs while adding any of the UTXOs then none of them are added and the error is returned.
  ///
  /// These have priority over the “unspendable” utxos, meaning that if a utxo is present both in the “utxos” and the “unspendable” list, it will be spent.
  TxBuilder addUtxos(List<OutPoint> outpoints) {
    for (var e in outpoints) {
      _utxos.add(e);
    }
    return this;
  }

  ///Do not spend change outputs
  ///
  /// This effectively adds all the change outputs to the “unspendable” list. See TxBuilder().addUtxos
  TxBuilder doNotSpendChange() {
    _doNotSpendChange = true;
    return this;
  }

  ///Spend all the available inputs. This respects filters like TxBuilder().unSpendable and the change policy.
  TxBuilder drainWallet() {
    _drainWallet = true;
    return this;
  }

  ///Sets the address to drain excess coins to.
  ///
  /// Usually, when there are excess coins they are sent to a change address generated by the wallet.
  /// This option replaces the usual change address with an arbitrary scriptPubkey of your choosing.
  /// Just as with a change output, if the drain output is not needed (the excess coins are too small) it will not be included in the resulting transaction. T
  /// he only difference is that it is valid to use drainTo without setting any ordinary recipients with add_recipient (but it is perfectly fine to add recipients as well).
  ///
  /// If you choose not to set any recipients, you should either provide the utxos that the transaction should spend via add_utxos, or set drainWallet to spend all of them.
  ///
  /// When bumping the fees of a transaction made with this option, you probably want to use allowShrinking to allow this output to be reduced to pay for the extra fees.
  TxBuilder drainTo(String address) {
    _drainTo = address;
    return this;
  }

  ///Enable signaling RBF with a specific nSequence value
  ///
  /// This can cause conflicts if the wallet’s descriptors contain an “older” (OP_CSV) operator and the given nsequence is lower than the CSV value.
  ///
  ///If the nsequence is higher than 0xFFFFFFFD an error will be thrown, since it would not be a valid nSequence to signal RBF.
  TxBuilder enableRbfWithSequence(int nSequence) {
    _nSequence = nSequence;
    return this;
  }

  ///Enable signaling RBF
  ///
  /// This will use the default nSequence value of 0xFFFFFFFD.
  TxBuilder enableRbf() {
    _enableRbf = true;
    return this;
  }

  ///Set an absolute fee
  TxBuilder feeAbsolute(int feeAmount) {
    _feeAbsolute = feeAmount;
    return this;
  }

  ///Set a custom fee rate
  TxBuilder feeRate(double satPerVbyte) {
    _feeRate = satPerVbyte;
    return this;
  }

  ///Replace the recipients already added with a new list
  TxBuilder setRecipients(List<ScriptAmount> recipients) {
    for (var e in _recipients) {
      _recipients.add(e);
    }
    return this;
  }

  ///Only spend utxos added by add_utxo.
  ///
  /// The wallet will not add additional utxos to the transaction even if they are needed to make the transaction valid.
  TxBuilder manuallySelectedOnly() {
    _manuallySelectedOnly = true;
    return this;
  }

  ///Add a utxo to the internal list of unspendable utxos
  ///
  /// It’s important to note that the “must-be-spent” utxos added with TxBuilder().addUtxo
  /// have priority over this. See the docs of the two linked methods for more details.
  TxBuilder addUnSpendable(OutPoint unSpendable) {
    _unSpendable.add(unSpendable);
    return this;
  }

  ///Only spend change outputs
  ///
  /// This effectively adds all the non-change outputs to the “unspendable” list.
  TxBuilder onlySpendChange() {
    _onlySpendChange = true;
    return this;
  }

  ///Finish building the transaction.
  ///
  /// Returns a [TxBuilderResult].
  Future<TxBuilderResult> finish(
      BitcoinWallet wallet, String? addressType) async {
    if (_recipients.isEmpty) {
      throw 'No Recipients Added';
    }

    final signer = addressType != null
        ? wallet.getSigner(addressType)
        : wallet.currentSigner();
    try {
      final res = await AgentDartFFI.impl.psbtTxBuilderFinish(
          req: TxBulderReq(
              walletReq: signer.getWalletReq(),
              recipients: _recipients,
              utxos: _utxos,
              unspendable: _unSpendable,
              manuallySelectedOnly: _manuallySelectedOnly,
              onlySpendChange: _onlySpendChange,
              doNotSpendChange: _doNotSpendChange,
              drainWallet: _drainWallet,
              nSequence: _nSequence,
              enableRbf: _enableRbf,
              drainTo: _drainTo,
              feeAbsolute: _feeAbsolute,
              feeRate: _feeRate,
              data: _data));

      return TxBuilderResult(
          psbt: PartiallySignedTransaction(psbtBase64: res.field0),
          txDetails: res.field1);
    } on FfiException catch (e) {
      throw (e.message);
    }
  }
}

class FeeRate {
  double? _feeRate;
  FeeRate._();
  FeeRate _setFeeRate(double feeRate) {
    _feeRate = feeRate;
    return this;
  }

  double asSatPerVb() {
    return _feeRate!;
  }
}

///A bitcoin transaction.
class Transaction {
  List<int>? _transactionBytes;
  Transaction._();
  Transaction _setTransaction(List<int> transactionBytes) {
    _transactionBytes = transactionBytes;
    return this;
  }

  ///  [Transaction] constructor
  static Future<Transaction> create({
    required List<int> transactionBytes,
  }) async {
    try {
      final tx = Uint8List.fromList(transactionBytes);
      final res = await AgentDartFFI.impl.newTransaction(tx: tx);
      return Transaction._()._setTransaction(res);
    } on FfiException catch (e) {
      throw (e.message);
    }
  }

  ///Return the transaction bytes, bitcoin consensus encoded.
  List<int> serialize() {
    return _transactionBytes!;
  }
}

///The value returned from calling the .finish() method on the [TxBuilder] or [BumpFeeTxBuilder].
class TxBuilderResult {
  final PartiallySignedTransaction psbt;

  ///The transaction details.
  final TransactionDetails txDetails;

  TxBuilderResult({required this.psbt, required this.txDetails});
}

///A Partially Signed Transaction
class PartiallySignedTransaction {
  final String psbtBase64;

  PartiallySignedTransaction({required this.psbtBase64});

  /// Combines this [PartiallySignedTransaction] with other PSBT as described by BIP 174.
  ///
  /// In accordance with BIP 174 this function is commutative i.e., `A.combine(B) == B.combine(A)`
  Future<PartiallySignedTransaction> combine(
      PartiallySignedTransaction other) async {
    try {
      final res = await AgentDartFFI.impl.psbtCombinePsbt(
          req: PsbtCombineReq(psbtStr: psbtBase64, other: other.psbtBase64));
      return PartiallySignedTransaction(psbtBase64: res);
    } on FfiException catch (e) {
      throw (e.message);
    }
  }

  /// Return the transaction as bytes.
  Future<Transaction> extractTx() async {
    try {
      final res = await AgentDartFFI.impl
          .psbtExtractTx(req: PsbtToTxReq(psbtStr: psbtBase64));
      return Transaction._()._setTransaction(res);
    } on FfiException catch (e) {
      throw (e.message);
    }
  }

  /// Return feeAmount
  Future<int?> feeAmount() async {
    try {
      final res = await AgentDartFFI.impl
          .psbtGetFeeAmount(req: PsbtFreeAmountReq(psbtStr: psbtBase64));
      return res;
    } on FfiException catch (e) {
      throw (e.message);
    }
  }

  /// Return Fee Rate
  Future<FeeRate?> feeRate() async {
    try {
      final res = await AgentDartFFI.impl
          .psbtGetFeeRate(req: PsbtFreeRateReq(psbtStr: psbtBase64));
      if (res == null) return null;
      return FeeRate._()._setFeeRate(res);
    } on FfiException catch (e) {
      throw (e.message);
    }
  }

  /// Return txid as string
  Future<String> serialize() async {
    try {
      final res = await AgentDartFFI.impl
          .psbtToTxid(req: PsbtToTxidReq(psbtStr: psbtBase64));
      return res;
    } on FfiException catch (e) {
      throw (e.message);
    }
  }

  @override
  String toString() {
    return psbtBase64;
  }

  /// Returns the [PartiallySignedTransaction] transaction id
  Future<String> txId() async {
    try {
      final res = await AgentDartFFI.impl
          .psbtToTxid(req: PsbtToTxidReq(psbtStr: psbtBase64));
      return res;
    } on FfiException catch (e) {
      throw (e.message);
    }
  }
}

Future<String> asmToHex(String asm) async {
  return await AgentDartFFI.impl.psbtUtilAsmToHex(asm: asm);
}
