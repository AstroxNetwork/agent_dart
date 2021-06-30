import 'dart:convert';

import 'package:agent_dart/agent/crypto/keystore/api.dart';
import 'package:agent_dart/identity/identity.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/is.dart';
import 'package:agent_dart/wallet/keysmith.dart';
import 'package:agent_dart/wallet/rosetta.dart';
import 'package:agent_dart/wallet/types.dart';

import 'hashing.dart';

typedef SigningCallback = void Function([dynamic data]);

enum SignType { ecdsa, ed25519 }

abstract class Signer<T extends SignablePayload, R> {
  bool? get isLocked;
  Future<void>? unlock(String passphrase, {String? keystore});
  Future<void>? lock(String? passphrase);
  Future<R> sign(T payload, {SignType? signType = SignType.ed25519, SigningCallback? callback});
}

abstract class BaseSigner<T extends BaseAccount, R extends SignablePayload, E>
    extends Signer<R, E> {}

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
  String? _keystore;

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
    throw UnimplementedError();
  }

  @override
  ECKeys? getEcKeys() {
    return _ecKeys;
  }

  Future<void> lock(String? passphrase) async {
    _keystore = await encodePrivateKey(ecKeys!.ecPrivateKey!.toHex(), passphrase ?? "");
    _ecKeys = null;
    _identity = null;
    isLocked = true;
  }

  Future<void> unlock(String passphrase, {String? keystore}) async {
    try {
      if ((_keystore == null)) {
        if (keystore != null) {
          _keystore = keystore;
        } else {
          throw "keystore file is not found";
        }
      }
      final decryptedPrv = await decodePrivateKey(jsonDecode(_keystore!), passphrase);
      var newIcp = ICPAccount.fromPrivateKey(decryptedPrv);
      _ecKeys = newIcp._ecKeys;
      _identity = newIcp._identity;
      newIcp._ecKeys = null;
      newIcp._identity = null;
      isLocked = false;
    } catch (e) {
      throw "Cannot unlock account with password $passphrase and keystore $_keystore";
    }
  }
}

class ICPSigner
    extends BaseSigner<ICPAccount, ConstructionPayloadsResponse, CombineSignedTransactionResult> {
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
  Future<void>? lock(String? passphrase) async {
    await _acc.lock(passphrase);
  }

  @override
  Future<void>? unlock(String passphrase, {String? keystore}) async {
    await _acc.unlock(passphrase, keystore: keystore);
  }

  @override
  Future<CombineSignedTransactionResult> sign(ConstructionPayloadsResponse payload,
      {SignType? signType = SignType.ed25519, SigningCallback? callback}) async {
    try {
      if (signType == SignType.ed25519) {
        var res = await transferCombine(account.identity!, payload);
        return res;
      } else {
        throw "Signtype $signType is not supported";
      }
    } catch (e) {
      rethrow;
    }
  }
}
