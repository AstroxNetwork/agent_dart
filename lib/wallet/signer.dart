import 'package:agent_dart/identity/identity.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/is.dart';
import 'package:agent_dart/wallet/keysmith.dart';
import 'package:agent_dart/wallet/types.dart';

import 'hashing.dart';

typedef SigningCallback = void Function([dynamic data]);

enum SignType { ecdsa, ed25519 }

abstract class Signer {
  bool? get isLocked;
  Future<void>? unlock();
  Future<void>? lock();
  Future<R> sign<T, R>(T payload,
      {SignType? signType = SignType.ed25519, SigningCallback? callback});
}

abstract class BaseSigner<T extends BaseAccount> extends Signer {}

// class ICPWallet with Signer {}

abstract class BaseAccount {
  Ed25519KeyIdentity? getIdentity();
  Map<String, dynamic> toJson();
  ECKeys? getEcKeys();
}

class ICPAccount extends BaseAccount {
  bool isLocked = false;
  Ed25519KeyIdentity? _identity;
  ECKeys? _ecKeys;
  Ed25519KeyIdentity? get identity => _identity;
  ECKeys? get ecKeys => _ecKeys;
  ECKeys? _lockedEcKeys;
  Ed25519KeyIdentity? _lockedIdentity;

  static ICPAccount fromPhrase(String phrase, {String passphase = "", int index = 0}) {
    ECKeys keys = getECKeys(phrase, passphase: passphase, index: index);

    Ed25519KeyIdentity identity = Ed25519KeyIdentity.generate(keys.ecPrivateKey);
    return ICPAccount()
      .._ecKeys = keys
      .._identity = identity;
  }

  static ICPAccount fromPrivateKey(String privateKey) {
    assert(isPrivateKey(privateKey), "$privateKey is not valid privateKey");
    final prv = privateKey.toU8a();
    final pub = getPublicFromPrivateKey(prv, false);
    final pubCompressed = getPublicFromPrivateKey(prv, true);

    var keys = ECKeys(
      ecPrivateKey: prv,
      ecPublicKey: pub,
      ecCompressedPublicKey: pubCompressed,
    );

    Ed25519KeyIdentity identity = Ed25519KeyIdentity.generate(prv);
    return ICPAccount()
      .._ecKeys = keys
      .._identity = identity;
  }

  ICPAccount() : super();

  @override
  Ed25519KeyIdentity? getIdentity() {
    return _identity;
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  ECKeys? getEcKeys() {
    return _ecKeys;
  }

  lock() {
    if (_ecKeys != null) {
      _lockedEcKeys = _ecKeys;
    }
    if (_identity != null) {
      _lockedIdentity = _identity;
    }
    _ecKeys = null;
    _identity = null;
    isLocked = true;
  }

  unlock() {
    if (_lockedEcKeys != null) {
      _ecKeys = _lockedEcKeys;
    }
    if (_lockedIdentity != null) {
      _identity = _lockedIdentity;
    }
    _lockedEcKeys = null;
    _lockedIdentity = null;
    isLocked = false;
  }
}

class ICPSigner implements BaseSigner<ICPAccount> {
  String? _phrase;
  int? _index;
  ICPAccount get account => _acc;
  int? get index => _index;
  bool get isHD => index == null;
  String? get idPublicKey => account.identity?.getPublicKey().toRaw().toHex();
  String? get idPublicKeyDer => account.identity?.getPublicKey().toDer().toHex();
  String? get idAddress => account.identity?.getAccountId().toHex();
  String? get idChecksumAddress => account.identity?.getAccountId() != null
      ? crc32Add(account.identity!.getAccountId()).toHex()
      : null;
  late ICPAccount _acc;
  ICPSigner.create() : this.fromPhrase(genrateMnemonic());

  ICPSigner.fromPhrase(String phrase, {String passphase = "", int index = 0}) {
    _phrase = phrase;
    _index ??= index;
    _acc = ICPAccount.fromPhrase(_phrase!, passphase: passphase, index: _index!);
  }

  ICPSigner.fromPrivatKey(String privateKey) {
    _acc = ICPAccount.fromPrivateKey(privateKey);
  }

  ICPAccount hdCreate({String passphase = "", int index = 0}) {
    return ICPAccount.fromPhrase(_phrase!, passphase: passphase, index: _index!);
  }

  @override
  bool? get isLocked => _acc.isLocked;

  @override
  Future<void>? lock() async {
    _acc.lock();
  }

  @override
  Future<void>? unlock() async {
    // TODO: implement unlock
    _acc.unlock();
  }

  @override
  Future<ConstructionCombineResponse>
      sign<ConstructionPayloadsResponse, ConstructionCombineResponse>(
          ConstructionPayloadsResponse payload,
          {SignType? signType = SignType.ed25519,
          SigningCallback? callback}) {
    // TODO: implement sign
    throw UnimplementedError();
  }
}
