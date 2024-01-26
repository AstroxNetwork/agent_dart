import 'dart:typed_data' as typed_data;

import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:agent_dart_ffi/agent_dart_ffi.dart' as bridge;
import 'package:collection/collection.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

import './bdk_exception.dart';
import './config.dart';
import 'buffer.dart';

///A Bitcoin address.
class Address {
  Address._(this.address, this.addressType);

  final String address;
  final AddressType addressType;

  /// Creates an instance of [Address] from address given.
  ///
  /// Throws a [BdkException] if the address is not valid
  static Future<Address> create({required String address}) async {
    try {
      final res = await AgentDartFFI.impl
          .createAddressStaticMethodApi(address: address);
      final addressType = await getAddressType(res);
      return Address._(res, addressType);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Creates an instance of [Address] from address given [Script].
  ///
  static Future<Address> fromScript(
    bridge.Script script,
    Network network,
  ) async {
    try {
      final res = await AgentDartFFI.impl
          .addressFromScriptStaticMethodApi(script: script, network: network);
      final addressType = await getAddressType(res);
      return Address._(res, addressType);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  static Future<AddressType> getAddressType(String address) async {
    try {
      final res = await AgentDartFFI.impl
          .getAddressTypeStaticMethodApi(address: address);
      return AddressType.fromRaw(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///The type of the address.
  ///
  Future<Payload> payload() async {
    try {
      final res =
          await AgentDartFFI.impl.payloadStaticMethodApi(address: address);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<Network> network() async {
    try {
      final res = await AgentDartFFI.impl
          .addressNetworkStaticMethodApi(address: address);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Returns the script pub key of the [Address] object
  Future<bridge.Script> scriptPubKey() async {
    try {
      final res = await AgentDartFFI.impl
          .addressToScriptPubkeyStaticMethodApi(address: address);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  @override
  String toString() {
    return address;
  }
}

/// Blockchain backends  module provides the implementation of a few commonly-used backends like Electrum, and Esplora.
class Blockchain {
  Blockchain._(this._blockchain);

  final BlockchainInstance _blockchain;

  ///  [Blockchain] constructor
  static Future<Blockchain> create({required BlockchainConfig config}) async {
    try {
      final res = await AgentDartFFI.impl
          .createBlockchainStaticMethodApi(config: config);
      return Blockchain._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// The function for getting block hash by block height
  Future<String> getBlockHash(int height) async {
    try {
      final res = await AgentDartFFI.impl.getBlockchainHashStaticMethodApi(
        blockchainHeight: height,
        blockchain: _blockchain,
      );
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// The function for getting the current height of the blockchain.
  Future<int> getHeight() async {
    try {
      final res = await AgentDartFFI.impl
          .getHeightStaticMethodApi(blockchain: _blockchain);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Estimate the fee rate required to confirm a transaction in a given target of blocks
  Future<FeeRate> estimateFee(int target) async {
    try {
      final res = await AgentDartFFI.impl
          .estimateFeeStaticMethodApi(blockchain: _blockchain, target: target);
      return FeeRate._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// The function for broadcasting a transaction
  Future<String> broadcast(Transaction tx) async {
    try {
      final txid = await AgentDartFFI.impl
          .broadcastStaticMethodApi(blockchain: _blockchain, tx: tx._tx!);
      return txid;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// The function for getting a transaction
  Future<String> getTx(String txId) async {
    try {
      final txTring = await AgentDartFFI.impl
          .getTxStaticMethodApi(blockchain: _blockchain, tx: txId);
      return txTring;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }
}

/// The BumpFeeTxBuilder is used to bump the fee on a transaction that has been broadcast and has its RBF flag set to true.
class BumpFeeTxBuilder {
  BumpFeeTxBuilder({required this.txid, required this.feeRate});

  int? _nSequence;
  String? _allowShrinking;
  bool _enableRbf = false;
  bool _keepChange = true;
  final String txid;
  final double feeRate;

  ///Explicitly tells the wallet that it is allowed to reduce the amount of the output matching this `address` in order to bump the transaction fee. Without specifying this the wallet will attempt to find a change output to shrink instead.
  ///
  /// Note that the output may shrink to below the dust limit and therefore be removed. If it is preserved then it is currently not guaranteed to be in the same position as it was originally.
  ///
  /// Throws and exception if address can’t be found among the recipients of the transaction we are bumping.
  BumpFeeTxBuilder allowShrinking(String address) {
    _allowShrinking = address;
    return this;
  }

  ///Enable signaling RBF
  ///
  /// This will use the default nSequence value of `0xFFFFFFFD`
  BumpFeeTxBuilder enableRbf() {
    _enableRbf = true;
    return this;
  }

  BumpFeeTxBuilder keepChange(bool _keep) {
    _keepChange = _keep;
    return this;
  }

  ///Enable signaling RBF with a specific nSequence value
  ///
  /// This can cause conflicts if the wallet’s descriptors contain an “older” (OP_CSV) operator and the given nsequence is lower than the CSV value.
  ///
  /// If the nsequence is higher than `0xFFFFFFFD` an error will be thrown, since it would not be a valid nSequence to signal RBF.

  BumpFeeTxBuilder enableRbfWithSequence(int nSequence) {
    _nSequence = nSequence;
    return this;
  }

  /// Finish building the transaction. Returns the  [TxBuilderResult].
  Future<TxBuilderResult> finish(Wallet wallet) async {
    try {
      final res = await AgentDartFFI.impl.bumpFeeTxBuilderFinishStaticMethodApi(
        txid: txid.toString(),
        enableRbf: _enableRbf,
        feeRate: feeRate,
        wallet: wallet._wallet,
        nSequence: _nSequence,
        keepChange: _keepChange,
        allowShrinking: _allowShrinking,
      );
      return TxBuilderResult(
        psbt: PartiallySignedTransaction(psbtBase64: res.field0),
        txDetails: res.field1,
        bumpFeeBuilder: this,
      );
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }
}

///A `BIP-32` derivation path
class DerivationPath {
  DerivationPath._(this.path);

  final String path;

  ///  [DerivationPath] constructor
  static Future<DerivationPath> create({required String path}) async {
    try {
      final res = await AgentDartFFI.impl
          .createDerivationPathStaticMethodApi(path: path);
      return DerivationPath._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  @override
  String toString() {
    return path;
  }
}

///Script descriptor
class Descriptor {
  Descriptor._(this._descriptorInstance);

  final BdkDescriptor? _descriptorInstance;
  DescriptorSecretKey? descriptorSecretKey;

  ///  [Descriptor] constructor
  static Future<Descriptor> create({
    required String descriptor,
    required Network network,
  }) async {
    try {
      final res = await AgentDartFFI.impl.createDescriptorStaticMethodApi(
        descriptor: descriptor,
        network: network,
      );
      return Descriptor._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///  [Descriptor] constructor
  static Future<Descriptor> importSingleWif({
    required String wif,
    required AddressType addressType,
    required Network network,
  }) async {
    try {
      final res = await AgentDartFFI.impl.importSingleWifStaticMethodApi(
        wif: wif,
        addressType: addressType.name,
        network: network,
      );
      return Descriptor._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///BIP44 template. Expands to pkh(key/44'/{0,1}'/0'/{0,1}/*)
  ///
  /// Since there are hardened derivation steps, this template requires a private derivable key (generally a xprv/tprv).
  static Future<Descriptor> newBip44({
    required DescriptorSecretKey secretKey,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      secretKey.derivedPathPrefix = "m/44'/0'/0'/0";
      secretKey.derivedIndex = 0;
      final res = await AgentDartFFI.impl.newBip44DescriptorStaticMethodApi(
        secretKey: secretKey.asString(),
        network: network,
        keyChainKind: keychain,
      );
      final r = Descriptor._(res);
      r.descriptorSecretKey = secretKey;
      return r;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///BIP44 public template. Expands to pkh(key/{0,1}/*)
  ///
  /// This assumes that the key used has already been derived with m/44'/0'/0' for Mainnet or m/44'/1'/0' for Testnet.
  ///
  /// This template requires the parent fingerprint to populate correctly the metadata of PSBTs.
  static Future<Descriptor> newBip44Public({
    required DescriptorPublicKey publicKey,
    required String fingerPrint,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      final res = await AgentDartFFI.impl.newBip44PublicStaticMethodApi(
        keyChainKind: keychain,
        publicKey: publicKey.asString(),
        network: network,
        fingerprint: fingerPrint,
      );
      return Descriptor._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  static Future<Descriptor> newBip44TR({
    required DescriptorSecretKey secretKey,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      secretKey.derivedPathPrefix = "m/44'/0'/0'/0";
      secretKey.derivedIndex = 0;
      final res = await AgentDartFFI.impl.newBip44TrDescriptorStaticMethodApi(
        secretKey: secretKey.asString(),
        network: network,
        keyChainKind: keychain,
      );
      final r = Descriptor._(res);
      r.descriptorSecretKey = secretKey;
      return r;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///BIP44 public template. Expands to pkh(key/{0,1}/*)
  ///
  /// This assumes that the key used has already been derived with m/44'/0'/0' for Mainnet or m/44'/1'/0' for Testnet.
  ///
  /// This template requires the parent fingerprint to populate correctly the metadata of PSBTs.
  static Future<Descriptor> newBip44TRPublic({
    required DescriptorPublicKey publicKey,
    required String fingerPrint,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      final res = await AgentDartFFI.impl.newBip44TrPublicStaticMethodApi(
        keyChainKind: keychain,
        publicKey: publicKey.asString(),
        network: network,
        fingerprint: fingerPrint,
      );
      return Descriptor._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///BIP49 template. Expands to sh(wpkh(key/49'/{0,1}'/0'/{0,1}/*))
  ///
  ///Since there are hardened derivation steps, this template requires a private derivable key (generally a xprv/tprv).
  static Future<Descriptor> newBip49({
    required DescriptorSecretKey secretKey,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      secretKey.derivedPathPrefix = "m/49'/0'/0'/0";
      secretKey.derivedIndex = 0;
      final res = await AgentDartFFI.impl.newBip49DescriptorStaticMethodApi(
        secretKey: secretKey.asString(),
        network: network,
        keyChainKind: keychain,
      );
      final r = Descriptor._(res);
      r.descriptorSecretKey = secretKey;
      return r;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///BIP49 public template. Expands to sh(wpkh(key/{0,1}/*))
  ///
  /// This assumes that the key used has already been derived with m/49'/0'/0'.
  ///
  /// This template requires the parent fingerprint to populate correctly the metadata of PSBTs.
  static Future<Descriptor> newBip49Public({
    required DescriptorPublicKey publicKey,
    required String fingerPrint,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      final res = await AgentDartFFI.impl.newBip49PublicStaticMethodApi(
        keyChainKind: keychain,
        publicKey: publicKey.asString(),
        network: network,
        fingerprint: fingerPrint,
      );
      return Descriptor._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///BIP84 template. Expands to wpkh(key/84'/{0,1}'/0'/{0,1}/*)
  ///
  ///Since there are hardened derivation steps, this template requires a private derivable key (generally a xprv/tprv).
  static Future<Descriptor> newBip84({
    required DescriptorSecretKey secretKey,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      secretKey.derivedPathPrefix = "m/84'/0'/0'/0";
      secretKey.derivedIndex = 0;
      final res = await AgentDartFFI.impl.newBip84DescriptorStaticMethodApi(
        secretKey: secretKey.asString(),
        network: network,
        keyChainKind: keychain,
      );
      final r = Descriptor._(res);
      r.descriptorSecretKey = secretKey;
      return r;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///BIP84 public template. Expands to wpkh(key/{0,1}/*)
  ///
  /// This assumes that the key used has already been derived with m/84'/0'/0'.
  ///
  /// This template requires the parent fingerprint to populate correctly the metadata of PSBTs.
  static Future<Descriptor> newBip84Public({
    required DescriptorPublicKey publicKey,
    required String fingerPrint,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      final res = await AgentDartFFI.impl.newBip84PublicStaticMethodApi(
        keyChainKind: keychain,
        publicKey: publicKey.asString(),
        network: network,
        fingerprint: fingerPrint,
      );
      return Descriptor._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///BIP86 template. Expands to wpkh(key/86'/{0,1}'/0'/{0,1}/*)
  ///
  ///Since there are hardened derivation steps, this template requires a private derivable key (generally a xprv/tprv).
  static Future<Descriptor> newBip86({
    required DescriptorSecretKey secretKey,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      secretKey.derivedPathPrefix = "m/86'/0'/0'/0";
      secretKey.derivedIndex = 0;
      final res = await AgentDartFFI.impl.newBip86DescriptorStaticMethodApi(
        secretKey: secretKey.asString(),
        network: network,
        keyChainKind: keychain,
      );
      final r = Descriptor._(res);
      r.descriptorSecretKey = secretKey;
      return r;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///BIP86 public template. Expands to wpkh(key/{0,1}/*)
  ///
  /// This assumes that the key used has already been derived with m/86'/0'/0'.
  ///
  /// This template requires the parent fingerprint to populate correctly the metadata of PSBTs.
  static Future<Descriptor> newBip86Public({
    required DescriptorPublicKey publicKey,
    required String fingerPrint,
    required Network network,
    required KeychainKind keychain,
  }) async {
    try {
      final res = await AgentDartFFI.impl.newBip86PublicStaticMethodApi(
        keyChainKind: keychain,
        publicKey: publicKey.asString(),
        network: network,
        fingerprint: fingerPrint,
      );
      return Descriptor._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Return the private version of the output descriptor if available, otherwise return the public version.
  Future<String> asStringPrivate() async {
    try {
      final res = await AgentDartFFI.impl
          .asStringPrivateStaticMethodApi(descriptor: _descriptorInstance!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Return the public version of the output descriptor.
  Future<String> asString() async {
    try {
      final res = await AgentDartFFI.impl
          .asStringStaticMethodApi(descriptor: _descriptorInstance!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<AddressInfo> deriveAddressAt(int index, Network network) async {
    try {
      final res = await AgentDartFFI.impl.deriveAddressAtStaticMethodApi(
        descriptor: _descriptorInstance!,
        index: index,
        network: network,
      );
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }
}

///An extended public key.
class DescriptorPublicKey {
  DescriptorPublicKey._(this._descriptorPublicKey);

  final String? _descriptorPublicKey;

  /// Get the public key as string.
  String asString() {
    return _descriptorPublicKey.toString();
  }

  ///Derive a public descriptor at a given path.
  Future<String> masterFingerprint() async {
    try {
      final res = await AgentDartFFI.impl.masterFinterprintStaticMethodApi(
        xpub: _descriptorPublicKey!,
      );
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Derive a public descriptor at a given path.
  Future<DescriptorPublicKey> derive(DerivationPath derivationPath) async {
    try {
      final res = await AgentDartFFI.impl.createDescriptorPublicStaticMethodApi(
        xpub: _descriptorPublicKey,
        path: derivationPath.path.toString(),
        derive: true,
      );
      return DescriptorPublicKey._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Extend the public descriptor with a custom path.
  Future<DescriptorPublicKey> extend(DerivationPath derivationPath) async {
    try {
      final res = await AgentDartFFI.impl.createDescriptorPublicStaticMethodApi(
        xpub: _descriptorPublicKey,
        path: derivationPath.path.toString(),
        derive: false,
      );
      return DescriptorPublicKey._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// [DescriptorPublicKey] constructor
  static Future<DescriptorPublicKey> fromString(String publicKey) async {
    try {
      final res = await AgentDartFFI.impl
          .descriptorPublicFromStringStaticMethodApi(publicKey: publicKey);
      return DescriptorPublicKey._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  @override
  String toString() {
    return asString();
  }
}

class DescriptorSecretKey {
  DescriptorSecretKey._(this._descriptorSecretKey);

  final String _descriptorSecretKey;
  DerivationPath? derivationPath;
  String? derivedPathPrefix;
  int? derivedIndex;

  ///Returns the public version of this key.
  ///
  /// If the key is an “XPrv”, the hardened derivation steps will be applied before converting it to a public key.
  Future<DescriptorPublicKey> asPublic() async {
    try {
      final xpub = await AgentDartFFI.impl
          .asPublicStaticMethodApi(secret: _descriptorSecretKey);
      return DescriptorPublicKey._(xpub);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Get the private key as string.
  String asString() {
    return _descriptorSecretKey;
  }

  /// [DescriptorSecretKey] constructor
  static Future<DescriptorSecretKey> create({
    required Network network,
    required Mnemonic mnemonic,
    String? password,
  }) async {
    try {
      final res = await AgentDartFFI.impl.createDescriptorSecretStaticMethodApi(
        network: network,
        mnemonic: mnemonic.asString(),
        password: password,
      );
      return DescriptorSecretKey._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  // static Future<DescriptorSecretKey> createDerivedKey({
  //   required Network network,
  //   required String path,
  //   required Mnemonic mnemonic,
  //   String? password,
  // }) async {
  //   try {
  //     final res = await AgentDartFFI.impl
  //         .createDerivedDescriptorSecretStaticMethodApi(
  //             network: network,
  //             mnemonic: mnemonic.asString(),
  //             path: path,
  //             password: password);
  //     print(res);
  //     return DescriptorSecretKey._(res);
  //   } on FfiException catch (e, s) {
  //     Error.throwWithStackTrace(configException(e.message), s);
  //   }
  // }

  /// Derived the `XPrv` using the derivation path
  Future<DescriptorSecretKey> deriveIndex(int index) async {
    try {
      derivationPath = await DerivationPath.create(
        path: '${derivedPathPrefix!}/$index',
      );
      final res = await AgentDartFFI.impl.deriveDescriptorSecretStaticMethodApi(
        secret: _descriptorSecretKey,
        path: derivationPath!.path.toString(),
      );
      final r = DescriptorSecretKey._(res);
      r.derivationPath = derivationPath;
      return r;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Derived the `XPrv` using the derivation path
  Future<DescriptorSecretKey> derive(DerivationPath derivationPath) async {
    try {
      final res = await AgentDartFFI.impl.deriveDescriptorSecretStaticMethodApi(
        secret: _descriptorSecretKey,
        path: derivationPath.path.toString(),
      );
      final r = DescriptorSecretKey._(res);
      r.derivationPath = derivationPath;
      return r;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Extends the “XPrv” using the derivation path
  Future<DescriptorSecretKey> extend(DerivationPath derivationPath) async {
    try {
      final res = await AgentDartFFI.impl.extendDescriptorSecretStaticMethodApi(
        secret: _descriptorSecretKey,
        path: derivationPath.path.toString(),
      );
      final r = DescriptorSecretKey._(res);
      r.derivationPath = derivationPath;
      return r;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// [DescriptorSecretKey] constructor
  static Future<DescriptorSecretKey> fromString(String secretKey) async {
    try {
      final res = await AgentDartFFI.impl
          .descriptorSecretFromStringStaticMethodApi(secret: secretKey);
      return DescriptorSecretKey._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Get the private key as bytes.
  Future<List<int>> secretBytes() async {
    try {
      final res = await AgentDartFFI.impl
          .asSecretBytesStaticMethodApi(secret: _descriptorSecretKey);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Get the private key as bytes.
  Future<String> getPubFromBytes(Uint8List bytes) async {
    try {
      final res = await AgentDartFFI.impl
          .getPubFromSecretBytesStaticMethodApi(bytes: bytes);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  @override
  String toString() {
    return asString();
  }
}

class FeeRate {
  FeeRate._(this._feeRate);

  final double _feeRate;

  double asSatPerVb() {
    return _feeRate;
  }
}

/// Mnemonic phrases are a human-readable version of the private keys.
/// Supported number of words are 12, 18, and 24.
class Mnemonic {
  Mnemonic._(this._mnemonic);

  final String? _mnemonic;

  /// Generates [Mnemonic] with given [WordCount]
  ///
  /// [Mnemonic] constructor
  static Future<Mnemonic> create(WordCount wordCount) async {
    try {
      final res = await AgentDartFFI.impl
          .generateSeedFromWordCountStaticMethodApi(wordCount: wordCount);
      return Mnemonic._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Returns [Mnemonic] as string
  String asString() {
    return _mnemonic.toString();
  }

  /// Create a new [Mnemonic] in the specified language from the given entropy.
  /// Entropy must be a multiple of 32 bits (4 bytes) and 128-256 bits in length.
  ///
  /// [Mnemonic] constructor
  static Future<Mnemonic> fromEntropy(typed_data.Uint8List entropy) async {
    try {
      final res = await AgentDartFFI.impl
          .generateSeedFromEntropyStaticMethodApi(entropy: entropy);
      return Mnemonic._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Parse a [Mnemonic] with given string
  ///
  /// [Mnemonic] constructor
  static Future<Mnemonic> fromString(String mnemonic) async {
    try {
      final res = await AgentDartFFI.impl
          .generateSeedFromStringStaticMethodApi(mnemonic: mnemonic);
      return Mnemonic._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  @override
  String toString() {
    return asString();
  }
}

///A Partially Signed Transaction
class PartiallySignedTransaction {
  PartiallySignedTransaction({required this.psbtBase64});

  final String psbtBase64;

  /// Combines this [PartiallySignedTransaction] with other PSBT as described by BIP 174.
  ///
  /// In accordance with BIP 174 this function is commutative i.e., `A.combine(B) == B.combine(A)`
  Future<PartiallySignedTransaction> combine(
    PartiallySignedTransaction other,
  ) async {
    try {
      final res = await AgentDartFFI.impl.combinePsbtStaticMethodApi(
        psbtStr: psbtBase64,
        other: other.psbtBase64,
      );
      return PartiallySignedTransaction(psbtBase64: res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Return the transaction as bytes.
  Future<Transaction> extractTx() async {
    try {
      final res =
          await AgentDartFFI.impl.extractTxStaticMethodApi(psbtStr: psbtBase64);
      return Transaction._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Return feeAmount
  Future<int?> feeAmount() async {
    try {
      final res = await AgentDartFFI.impl
          .psbtFeeAmountStaticMethodApi(psbtStr: psbtBase64);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Return Fee Rate
  Future<FeeRate?> feeRate() async {
    try {
      final res = await AgentDartFFI.impl
          .psbtFeeRateStaticMethodApi(psbtStr: psbtBase64);
      if (res == null) return null;
      return FeeRate._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Return txid as string
  Future<String> serialize() async {
    try {
      final res = await AgentDartFFI.impl
          .serializePsbtStaticMethodApi(psbtStr: psbtBase64);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<List<TxOut>> getPsbtInputs() async {
    try {
      final res =
          await AgentDartFFI.impl.getInputsStaticMethodApi(psbtStr: psbtBase64);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<String> jsonSerialize() async {
    try {
      final res = await AgentDartFFI.impl
          .jsonSerializeStaticMethodApi(psbtStr: psbtBase64);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  @override
  String toString() {
    return psbtBase64;
  }

  /// Returns the [PartiallySignedTransaction] transaction id
  Future<String> txId() async {
    try {
      final res =
          await AgentDartFFI.impl.psbtTxidStaticMethodApi(psbtStr: psbtBase64);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }
}

///Bitcoin script.
///
/// A list of instructions in a simple, Forth-like, stack-based programming language that Bitcoin uses.
///
/// See [Bitcoin Wiki: Script](https://en.bitcoin.it/wiki/Script) for more information.
class Script extends bridge.Script {
  Script._({required super.internal});

  /// [Script] constructor
  static Future<bridge.Script> create(
    typed_data.Uint8List rawOutputScript,
  ) async {
    try {
      final res = await AgentDartFFI.impl
          .createScriptStaticMethodApi(rawOutputScript: rawOutputScript);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }
}

///A bitcoin transaction.
class Transaction {
  Transaction._(this._tx);

  final String? _tx;

  ///  [Transaction] constructor
  static Future<Transaction> create({
    required List<int> transactionBytes,
  }) async {
    try {
      final tx = Uint8List.fromList(transactionBytes);
      final res =
          await AgentDartFFI.impl.createTransactionStaticMethodApi(tx: tx);
      return Transaction._(res);
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Return the transaction bytes, bitcoin consensus encoded.
  Future<List<int>> serialize() async {
    try {
      final res = await AgentDartFFI.impl.serializeTxStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<String> txid() async {
    try {
      final res = await AgentDartFFI.impl.txTxidStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<int> weight() async {
    try {
      final res = await AgentDartFFI.impl.weightStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<int> size() async {
    try {
      final res = await AgentDartFFI.impl.sizeStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<int> vsize() async {
    try {
      final res = await AgentDartFFI.impl.vsizeStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<bool> isCoinBase() async {
    try {
      final res = await AgentDartFFI.impl.isCoinBaseStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<bool> isExplicitlyRbf() async {
    try {
      final res =
          await AgentDartFFI.impl.isExplicitlyRbfStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<bool> isLockTimeEnabled() async {
    try {
      final res =
          await AgentDartFFI.impl.isLockTimeEnabledStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<int> version() async {
    try {
      final res = await AgentDartFFI.impl.versionStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<int> lockTime() async {
    try {
      final res = await AgentDartFFI.impl.lockTimeStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<List<TxIn>> input() async {
    try {
      final res = await AgentDartFFI.impl.inputStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<List<TxOut>> output() async {
    try {
      final res = await AgentDartFFI.impl.outputStaticMethodApi(tx: _tx!);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  @override
  String toString() {
    return _tx!;
  }
}

///A transaction builder
///
/// A TxBuilder is created by calling TxBuilder or BumpFeeTxBuilder on a wallet.
/// After assigning it, you set options on it until finally calling finish to consume the builder and generate the transaction.
class TxBuilder {
  final List<ScriptAmount> _recipients = [];
  final List<OutPoint> _utxos = [];
  final List<ForeignUtxo> _foreign_utxos = [];
  final List<OutPoint> _unSpendable = [];
  final List<OutPointExt> _txInputs = [];
  final List<OutPointExt> _txOutputs = [];
  final List<TxBytes> _txs = [];

  bool _manuallySelectedOnly = false;
  double? _feeRate;
  ChangeSpendPolicy _changeSpendPolicy = ChangeSpendPolicy.ChangeAllowed;
  int? _feeAbsolute;
  bool _drainWallet = false;
  bool _shuffleUtxos = false;
  bridge.Script? _drainTo;
  RbfValue? _rbfValue;
  typed_data.Uint8List _data = typed_data.Uint8List.fromList([]);

  ///Add data as an output, using OP_RETURN
  TxBuilder addData({required List<int> data}) {
    if (data.isEmpty) {
      throw const BdkException.unExpected('List must not be empty');
    }
    _data = typed_data.Uint8List.fromList(data);
    return this;
  }

  ///Add a recipient to the internal list
  TxBuilder addRecipient(bridge.Script script, int amount) {
    _recipients.add(ScriptAmount(script: script, amount: amount));
    return this;
  }

  ///Add a utxo to the internal list of unspendable utxos
  ///
  /// It’s important to note that the “must-be-spent” utxos added with TxBuilder().addUtxo have priority over this.
  /// See the docs of the two linked methods for more details.
  TxBuilder unSpendable(List<OutPoint> outpoints) {
    for (final e in outpoints) {
      _unSpendable.add(e);
    }
    return this;
  }

  ///Add a utxo to the internal list of utxos that must be spent
  ///
  /// These have priority over the “unspendable” utxos, meaning that if a utxo is present both in the “utxos” and the “unspendable” list, it will be spent.
  TxBuilder addTx(TxBytes tx) {
    _txs.add(tx);
    return this;
  }

  TxBuilder addTxs(
    List<TxBytes> txs,
  ) {
    for (final e in txs) {
      _txs.add(e);
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

  ///Add a utxo to the internal list of utxos that must be spent
  ///
  /// These have priority over the “unspendable” utxos, meaning that if a utxo is present both in the “utxos” and the “unspendable” list, it will be spent.
  TxBuilder addForeignUtxo(OutPointExt ext) {
    _foreign_utxos.add(
      ForeignUtxo(
        outpoint: OutPoint(txid: ext.txid, vout: ext.vout),
        txout: TxOutForeign(
          value: ext.value,
          scriptPubkey: ext.scriptPk,
        ),
      ),
    );
    return this;
  }

  TxBuilder addForeignUtxos(
    List<OutPointExt> outpoints,
  ) {
    for (final e in outpoints) {
      addForeignUtxo(e);
    }
    return this;
  }

  ///Add the list of outpoints to the internal list of UTXOs that must be spent.
  ///
  ///If an error occurs while adding any of the UTXOs then none of them are added and the error is returned.
  ///
  /// These have priority over the “unspendable” utxos, meaning that if a utxo is present both in the “utxos” and the “unspendable” list, it will be spent.
  TxBuilder addUtxos(
    List<OutPoint> outpoints,
  ) {
    for (final e in outpoints) {
      _utxos.add(e);
    }
    return this;
  }

  TxBuilder addInput(OutPointExt outpoint) {
    _txInputs.add(outpoint);
    return this;
  }

  TxBuilder addOutput(OutPointExt outpoint) {
    _txOutputs.add(outpoint);
    return this;
  }

  ///Do not spend change outputs
  ///
  /// This effectively adds all the change outputs to the “unspendable” list. See TxBuilder().addUtxos
  TxBuilder doNotSpendChange() {
    _changeSpendPolicy = ChangeSpendPolicy.ChangeForbidden;
    return this;
  }

  ///Spend all the available inputs. This respects filters like TxBuilder().unSpendable and the change policy.
  TxBuilder drainWallet() {
    _drainWallet = true;
    return this;
  }

  TxBuilder shuffleOutputs(bool shuffle) {
    _shuffleUtxos = shuffle;
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
  TxBuilder drainTo(bridge.Script script) {
    _drainTo = script;
    return this;
  }

  ///Enable signaling RBF with a specific nSequence value
  ///
  /// This can cause conflicts if the wallet’s descriptors contain an “older” (OP_CSV) operator and the given nsequence is lower than the CSV value.
  ///
  ///If the nsequence is higher than 0xFFFFFFFD an error will be thrown, since it would not be a valid nSequence to signal RBF.
  TxBuilder enableRbfWithSequence(int nSequence) {
    _rbfValue = RbfValue.value(nSequence);
    return this;
  }

  ///Enable signaling RBF
  ///
  /// This will use the default nSequence value of 0xFFFFFFFD.
  TxBuilder enableRbf() {
    _rbfValue = const RbfValue.rbfDefault();
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
    for (final e in _recipients) {
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
    _changeSpendPolicy = ChangeSpendPolicy.OnlyChange;
    return this;
  }

  Future<int?> calNetworkFee(Wallet wallet) async {
    final res = await _finish(wallet);
    return res.psbt.feeAmount();
  }

  Future<int> calFee(Wallet wallet) async {
    final res = await AgentDartFFI.impl.txCalFeeFinishStaticMethodApi(
      wallet: wallet._wallet,
      recipients: _recipients,
      foreignUtxos: _foreign_utxos,
      txs: _txs,
      unspendable: _unSpendable,
      manuallySelectedOnly: _manuallySelectedOnly,
      drainWallet: _drainWallet,
      rbf: _rbfValue,
      drainTo: _drainTo,
      feeAbsolute: _feeAbsolute,
      feeRate: _feeRate,
      data: _data,
      changePolicy: _changeSpendPolicy,
      shuffleUtxo: _shuffleUtxos,
    );
    return res;
  }

  int getTotalOutput() {
    var total = 0;
    for (final e in _txOutputs) {
      total += e.value;
    }
    return total;
  }

  int getTotalInput() {
    var total = 0;
    for (final e in _txInputs) {
      total += e.value;
    }
    return total;
  }

  int getUnspend() {
    return getTotalInput() - getTotalOutput();
  }

  Future<Transaction> _getTx(Wallet wallet) async {
    final res = await _finish(wallet);
    return res.psbt.extractTx();
  }

  Future<TxBuilderResult> _finish(Wallet wallet) async {
    return finish(wallet);
  }

  ///Finish building the transaction.
  ///
  /// Returns a [TxBuilderResult].

  Future<TxBuilderResult> finish(Wallet wallet) async {
    if (_recipients.isEmpty && _drainTo == null) {
      throw const BdkException.unExpected('No Recipients Added');
    }
    try {
      final res = await AgentDartFFI.impl.txBuilderFinishStaticMethodApi(
        wallet: wallet._wallet,
        recipients: _recipients,
        foreignUtxos: _foreign_utxos,
        unspendable: _unSpendable,
        manuallySelectedOnly: _manuallySelectedOnly,
        drainWallet: _drainWallet,
        rbf: _rbfValue,
        drainTo: _drainTo,
        feeAbsolute: _feeAbsolute,
        feeRate: _feeRate,
        data: _data,
        changePolicy: _changeSpendPolicy,
        shuffleUtxo: _shuffleUtxos,
        txs: _txs,
      );

      final psbt = await PartiallySignedTransaction(psbtBase64: res.field0);

      return TxBuilderResult(
        psbt: psbt,
        txDetails: res.field1,
        builder: this,
        txInputs: _txInputs,
        txOutputs: _txOutputs,
      );
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }
}

class InscriptionValue {
  const InscriptionValue({
    required this.inscriptionId,
    required this.outputValue,
  });

  final String inscriptionId;
  final int outputValue;
}

class OutPointExt extends OutPoint {
  const OutPointExt({
    required super.txid,
    required super.vout,
    required this.value,
    required this.scriptPk,
  });

  final int value;
  final String scriptPk;

  String get uniqueKey => '$txid:$vout';
}

class OutPointWithInscription extends OutPointExt {
  const OutPointWithInscription({
    this.inscriptions,
    required super.txid,
    required super.vout,
    required super.value,
    required super.scriptPk,
  });

  /// The referenced transaction's txid.
  final List<InscriptionValue>? inscriptions;

  Map<String, dynamic> toJson() => {
        'txid': txid,
        'vout': vout,
        'value': value,
        'scriptPk': scriptPk,
        'inscriptions': inscriptions?.map(
          (e) => {
            'inscriptionId': e.inscriptionId,
            'outputValue': e.outputValue,
          },
        )
      };
}

///The value returned from calling the .finish() method on the [TxBuilder] or [BumpFeeTxBuilder].
class TxBuilderResult {
  TxBuilderResult({
    required this.psbt,
    required this.txDetails,
    this.builder,
    this.bumpFeeBuilder,
    this.signed,
    List<OutPointExt>? txInputs,
    List<OutPointExt>? txOutputs,
  })  : _txInputs = List.from(txInputs ?? []),
        _txOutputs = List.from(txOutputs ?? []);

  final PartiallySignedTransaction psbt;

  ///The transaction details.
  ///
  final TransactionDetails txDetails;

  final TxBuilder? builder;
  final BumpFeeTxBuilder? bumpFeeBuilder;
  final List<OutPointExt> _txInputs;
  final List<OutPointExt> _txOutputs;

  bool? signed;

  int getTotalInput() {
    return _txInputs.fold(
      0,
      (pre, cur) => pre + cur.value,
    );
  }

  int getTotalOutput() {
    return _txOutputs.fold(
      0,
      (pre, cur) => pre + cur.value,
    );
  }

  Future<void> dumpTx({
    void Function(Object?)? logPrint = print,
  }) async {
    final tx = await psbt.extractTx();
    final size = Uint8List.fromList(await tx.serialize()).length;
    final feePaid = await psbt.feeAmount();
    final feeRate = (await psbt.feeRate())!.asSatPerVb();
    final inputs = await tx.input();
    final outputs = await tx.output();

    final inputStrings = <String>[];
    var totalInput = 0;
    for (int i = 0; i < _txInputs.length; i += 1) {
      final input = _txInputs[i];
      final found = inputs.firstWhereOrNull((e) {
        // print(e.previousOutput.txid);
        return e.previousOutput.txid == input.txid;
      });
      if (found != null) {
        totalInput += input.value;
        inputStrings.add('''
  #${i} ${input.value}
  lock-size: ${input.scriptPk.toU8a().length}
  via ${input.txid} [${input.vout}]
''');
      }
    }

    final outputString = <String>[];
    for (int i = 0; i < outputs.length; i += 1) {
      final output = outputs[i];
      outputString.add('''
  #${i} ${output.scriptPubkey.internal.toHex()} ${output.value}
''');
    }

    final totalOutput = outputs.fold(
      0,
      (previousValue, element) => previousValue + element.value,
    );

    logPrint?.call('''
==============================================================================================
Transaction Detail
  txid:     ${await tx.txid()}
  Size:     ${size}
  Fee Paid: ${feePaid}
  Fee Rate: ${feeRate} sat/B
  Detail:   ${inputs.length} Inputs, ${outputs.length} Outputs
----------------------------------------------------------------------------------------------
Inputs in Sats
${inputStrings.join('\n')}
  total: ${totalInput}          
----------------------------------------------------------------------------------------------
Outputs in Sats
${outputString.join("\n")}
  total:  ${totalOutput}
----------------------------------------------------------------------------------------------
Summary in Sats
  Inputs:   + ${totalInput}
  Outputs:  - ${totalOutput}
  fee:      - ${feePaid!}
  Remain:   ${totalOutput - feePaid}
==============================================================================================
    ''');
  }
}

/// A Bitcoin wallet.
///
/// The Wallet acts as a way of coherently interfacing with output descriptors and related transactions. Its main components are:
///
///     1. Output descriptors from which it can derive addresses.
///
///     2. A Database where it tracks transactions and utxos related to the descriptors.
///
///     3. Signers that can contribute signatures to addresses instantiated from the descriptors.
///
class Wallet {
  const Wallet._(
    this._wallet, {
    required this.descriptor,
    this.changeDescriptor,
    required this.network,
  });

  final WalletInstance _wallet;

  final Descriptor descriptor;
  final Descriptor? changeDescriptor;
  final Network network;

  ///  [Wallet] constructor
  static Future<Wallet> create({
    required Descriptor descriptor,
    Descriptor? changeDescriptor,
    required Network network,
    required DatabaseConfig databaseConfig,
  }) async {
    try {
      final res = await AgentDartFFI.impl.createWalletStaticMethodApi(
        descriptor: descriptor._descriptorInstance!,
        changeDescriptor: changeDescriptor?._descriptorInstance,
        network: network,
        databaseConfig: databaseConfig,
      );
      return Wallet._(
        res,
        descriptor: descriptor,
        changeDescriptor: changeDescriptor,
        network: network,
      );
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  Future<String> getPublicKey(int index) async {
    final k = await descriptor.descriptorSecretKey!.deriveIndex(index);
    final kBytes = Uint8List.fromList(await k.secretBytes());
    return k.getPubFromBytes(kBytes);
  }

  ///Return a derived address using the external descriptor, see [AddressIndex] for available address index selection strategies.
  /// If none of the keys in the descriptor are derivable (i.e. does not end with /*) then the same address will always be returned for any AddressIndex.
  Future<AddressInfo> getAddress({required AddressIndex addressIndex}) async {
    try {
      final res = await AgentDartFFI.impl.getAddressStaticMethodApi(
        wallet: _wallet,
        addressIndex: addressIndex,
      );
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  /// Return a derived address using the internal (change) descriptor.
  ///
  /// If the wallet doesn't have an internal descriptor it will use the external descriptor.
  ///
  /// see [AddressIndex] for available address index selection strategies. If none of the keys
  /// in the descriptor are derivable (i.e. does not end with /*) then the same address will always
  /// be returned for any [AddressIndex].
  Future<AddressInfo> getInternalAddress({
    required AddressIndex addressIndex,
  }) async {
    try {
      final res = await AgentDartFFI.impl.getInternalAddressStaticMethodApi(
        wallet: _wallet,
        addressIndex: addressIndex,
      );
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Return the [Balance], separated into available, trusted-pending, untrusted-pending and immature values.
  ///
  ///Note that this method only operates on the internal database, which first needs to be Wallet().sync manually.
  Future<Balance> getBalance() async {
    try {
      final res =
          await AgentDartFFI.impl.getBalanceStaticMethodApi(wallet: _wallet);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Get the Bitcoin network the wallet is using.
  // Future<Network> getNetwork() async {
  //   try {
  //     final res =
  //         await AgentDartFFI.impl.walletNetworkStaticMethodApi(wallet: _wallet);
  //     return res;
  //   } on FfiException catch (e, s) {
  //     Error.throwWithStackTrace(configException(e.message), s);
  //   }
  // }

  ///Return the list of unspent outputs of this wallet
  ///
  /// Note that this method only operates on the internal database, which first needs to be Wallet().sync manually.
  Future<List<LocalUtxo>> listUnspent() async {
    try {
      final res = await AgentDartFFI.impl
          .listUnspentOutputsStaticMethodApi(wallet: _wallet);
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Sync the internal database with the [Blockchain]
  Future<void> sync(Blockchain blockchain) async {
    try {
      await AgentDartFFI.impl.syncWalletStaticMethodApi(
        wallet: _wallet,
        blockchain: blockchain._blockchain,
      );
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Return an unsorted list of transactions made and received by the wallet
  Future<List<TransactionDetails>> listTransactions(bool includeRaw) async {
    try {
      final res = await AgentDartFFI.impl.getTransactionsStaticMethodApi(
        wallet: _wallet,
        includeRaw: includeRaw,
      );
      return res;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  ///Sign a transaction with all the wallet’s signers, in the order specified by every signer’s SignerOrdering
  ///
  /// Note that it can’t be guaranteed that every signers will follow the options, but the “software signers” (WIF keys and xprv) defined in this library will.
  Future<PartiallySignedTransaction> sign({
    required PartiallySignedTransaction psbt,
    SignOptions? signOptions,
  }) async {
    final sbt = await AgentDartFFI.impl.signStaticMethodApi(
      signOptions: signOptions,
      psbtStr: psbt.psbtBase64,
      wallet: _wallet,
    );
    if (sbt == null) {
      throw const BdkException.unExpected('Unable to sign transaction');
    }
    return PartiallySignedTransaction(psbtBase64: sbt);
  }

  Future<PartiallySignedTransaction> signWithHex({
    required String psbtHex,
    SignOptions? signOptions,
  }) async {
    final psbt = PartiallySignedTransaction(
      psbtBase64: isHex(psbtHex) ? base64Encode(psbtHex.toU8a()) : psbtHex,
    );
    final sbt = await AgentDartFFI.impl.signStaticMethodApi(
      signOptions: signOptions,
      psbtStr: psbt.psbtBase64,
      wallet: _wallet,
    );
    if (sbt == null) {
      throw const BdkException.unExpected('Unable to sign transaction');
    }
    return PartiallySignedTransaction(psbtBase64: sbt);
  }

  Future<Transaction> signToTx({
    required TxBuilderResult tbr,
    SignOptions? signOptions,
    void Function(Object?)? logPrint = print,
  }) async {
    await tbr.dumpTx(logPrint: logPrint);
    final res = await sign(psbt: tbr.psbt, signOptions: signOptions);
    final sbt = PartiallySignedTransaction(psbtBase64: res.psbtBase64);
    final signed = TxBuilderResult(
      psbt: sbt,
      txDetails: tbr.txDetails,
      signed: true,
    );
    return signed.psbt.extractTx();
  }

  Future<TxBuilderResult> signTBR({
    required TxBuilderResult tbr,
    SignOptions? signOptions,
    void Function(Object?)? logPrint = print,
  }) async {
    await tbr.dumpTx(logPrint: logPrint);
    final res = await sign(psbt: tbr.psbt, signOptions: signOptions);
    final sbt = PartiallySignedTransaction(psbtBase64: res.psbtBase64);
    final signed = TxBuilderResult(
      psbt: sbt,
      txDetails: tbr.txDetails,
      signed: true,
    );
    return signed;
  }

  Future<String> signToTxHex({
    required TxBuilderResult tbr,
    SignOptions? signOptions,
    void Function(Object?)? logPrint = print,
  }) async {
    final tx = await signToTx(
      tbr: tbr,
      signOptions: signOptions,
      logPrint: logPrint,
    );
    return Uint8List.fromList(await tx.serialize()).toHex();
  }

  Future<String> signMessage(
    String message, {
    bool toBase64 = true,
    bool useBip322 = false,
    WalletType walletType = WalletType.HD,
    int? index,
    required AddressType addressType,
  }) async {
    final k = walletType == WalletType.HD
        ? await descriptor.descriptorSecretKey!.deriveIndex(index!)
        : descriptor.descriptorSecretKey!;

    final kBytes = Uint8List.fromList(await k.secretBytes());

    if (!useBip322) {
      final res = await signSecp256k1WithRNG(messageHandler(message), kBytes);

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
        res = await AgentDartFFI.impl.bip322SignTaprootStaticMethodApi(
          secret: kBytes,
          message: message,
        );
      } else {
        res = await AgentDartFFI.impl.bip322SignSegwitStaticMethodApi(
          secret: kBytes,
          message: message,
        );
      }

      if (toBase64) {
        return res;
      } else {
        return base64Decode(res).toHex();
      }
    }
  }

  Uint8List messageHandler(String message) {
    final MAGIC_BYTES = 'Bitcoin Signed Message:\n'.plainToU8a();

    final prefix1 = BufferWriter.varintBufNum(MAGIC_BYTES.toU8a().byteLength)
        .buffer
        .asUint8List();
    final messageBuffer = message.plainToU8a();
    final prefix2 =
        BufferWriter.varintBufNum(messageBuffer.length).buffer.asUint8List();

    final buf = u8aConcat([prefix1, MAGIC_BYTES, prefix2, messageBuffer]);

    return sha256Hash(buf.buffer);
  }

  Future<String> signPsbt(
    String psbtHex, {
    SignOptions options = defaultSignOptions,
  }) async {
    try {
      final psbt = PartiallySignedTransaction(
        psbtBase64: isHex(psbtHex) ? base64Encode(psbtHex.toU8a()) : psbtHex,
      );
      final res = await sign(psbt: psbt, signOptions: options);
      return base64Decode(res.psbtBase64).toHex();
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }

  static Future<String> psbtToTxHex(String psbtHex) async {
    final psbt = PartiallySignedTransaction(
      psbtBase64: base64Encode(isHex(psbtHex) ? psbtHex.toU8a() : psbtHex),
    );
    final tx = await psbt.extractTx();
    return Uint8List.fromList(await tx.serialize()).toHex();
  }

  Future<List<String>> signPsbts(
    List<String> psbtHexs, {
    SignOptions options = defaultSignOptions,
  }) {
    return Future.wait(
      psbtHexs.map((hex) => signPsbt(hex, options: options)),
    );
  }

  Future<PSBTDetail> dumpPsbt(
    String psbtHex, {
    required String address,
  }) async {
    final psbt = PartiallySignedTransaction(
      psbtBase64: isHex(psbtHex)
          ? base64Encode(psbtHex.toU8a())
          : base64Encode(psbtHex),
    );
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
          value: element.value,
          isMine: addr == address ? true : false,
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
          value: element.value,
          isMine: addr == address ? true : false,
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

  Future<SignIdentity> getIdentity({
    WalletType walletType = WalletType.HD,
    int? index,
  }) async {
    final k = walletType == WalletType.HD
        ? await descriptor.descriptorSecretKey!.deriveIndex(index!)
        : descriptor.descriptorSecretKey!;

    final kBytes = Uint8List.fromList(await k.secretBytes());
    return Secp256k1KeyIdentity.fromSecretKey(kBytes);
  }

  Future<bool> cacheAddresses({required int cacheSize}) async {
    try {
      // final utxos = await ordService!.getUtxo(_selectedSigner.address);
      final ins = await AgentDartFFI.impl
          .cacheAddressStaticMethodApi(wallet: _wallet, cacheSize: cacheSize);
      return ins;
    } on FfiException catch (e, s) {
      Error.throwWithStackTrace(configException(e.message), s);
    }
  }
}

extension TxExt on TransactionDetails {
  Transaction? get transaction =>
      serializedTx == null ? null : Transaction._(serializedTx);
}

abstract class AddressTypeString {
  static const P2TR = 'p2tr';
  static const P2WPKH = 'p2wpkh';
  static const P2SH_P2WPKH = 'p2sh';
  static const P2PKH = 'p2pkh';
  static const P2PKHTR = 'p2pkhtr';
}

enum AddressType {
  P2TR('p2tr', 'Taproot', "m/86'/0'/0'/0/0"),
  P2WPKH('p2wpkh', 'Native Segwit', "m/84'/0'/0'/0/0"),
  P2SH_P2WPKH('p2sh', 'Nested Segwit', "m/49'/0'/0'/0/0"),
  P2PKH('p2pkh', 'Legacy', "m/44'/0'/0'/0/0"),
  P2PKHTR('p2pkhtr', 'Legacy Taproot', "m/44'/0'/0'/0/0"),
  ;

  const AddressType(this.raw, this.display, this.derivedPath);

  factory AddressType.fromRaw(String raw) {
    raw = raw.toLowerCase();
    final type = AddressType.values.firstWhereOrNull((e) => e.raw == raw);
    if (type == null) {
      throw Exception('AddressTypeExt.fromString: unknown address type');
    }
    return type;
  }

  factory AddressType.fromName(String name) {
    final type = AddressType.values.firstWhereOrNull((e) => e.name == name);
    if (type == null) {
      throw Exception('AddressTypeExt.fromString: unknown address type');
    }
    return type;
  }

  final String raw;
  final String display;
  final String derivedPath;
}
