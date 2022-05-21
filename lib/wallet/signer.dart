import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/crypto/keystore/api.dart';
import 'package:agent_dart/identity/identity.dart';
import 'package:agent_dart/identity/secp256k1.dart';
import 'package:agent_dart/utils/extension.dart';

import 'hashing.dart';
import 'keysmith.dart';
import 'rosetta.dart';
import 'types.dart';

typedef SigningCallback = void Function([dynamic data]);

enum SignType {
  ecdsa,
  ed25519,
}

enum SourceType {
  II,
  Plug,
  Keysmith,
  Base,
}

enum CurveType {
  secp256k1,
  ed25519,
  all,
}

abstract class Signer<T extends SignablePayload, R> {
  bool? get isLocked;

  Future<void>? unlock(
    String passphrase, {
    String? keystore,
  });

  Future<void>? lock(String? passphrase);

  Future<R> sign(
    T payload, {
    SignType? signType = SignType.ed25519,
    SigningCallback? callback,
  });
}

abstract class BaseSigner<T extends BaseAccount, R extends SignablePayload, E>
    extends Signer<R, E> {}

// class ICPWallet with Signer {}

abstract class BaseAccount {
  Ed25519KeyIdentity? getIdentity();

  Secp256k1KeyIdentity? getEcIdentity();

  Map<String, dynamic> toJson();

  ECKeys? getEcKeys();
}

class ICPAccount extends BaseAccount {
  ICPAccount({
    CurveType curveType = CurveType.ed25519,
  })  : _curveType = curveType,
        super();

  factory ICPAccount.fromSeed(
    Uint8List seed, {
    int? index,
    CurveType curveType = CurveType.ed25519,
  }) {
    ECKeys keys = fromSeed(seed, index: index ?? 0);
    Ed25519KeyIdentity? identity = curveType == CurveType.secp256k1
        ? null
        : Ed25519KeyIdentity.generate(seed);
    Secp256k1KeyIdentity? ecIdentity = curveType == CurveType.ed25519
        ? null
        : Secp256k1KeyIdentity.fromSecretKey(keys.ecPrivateKey!);
    return ICPAccount(curveType: curveType)
      .._ecKeys = keys
      .._identity = identity
      .._ecIdentity = ecIdentity
      .._phrase = '';
  }

  bool isLocked = false;
  String? _keystore;
  String? _phrase;
  final CurveType _curveType;

  Ed25519KeyIdentity? get identity => _identity;
  Ed25519KeyIdentity? _identity;

  Secp256k1KeyIdentity? get ecIdentity => _ecIdentity;
  Secp256k1KeyIdentity? _ecIdentity;

  ECKeys? get ecKeys => _ecKeys;
  ECKeys? _ecKeys;

  static ICPAccount fromPhrase(
    String phrase, {
    String passphase = "",
    int? index,
    List<int>? icPath = IC_BASE_PATH,
    CurveType curveType = CurveType.ed25519,
  }) {
    ECKeys? keys = curveType == CurveType.ed25519
        ? null
        : getECKeys(phrase,
            passphase: passphase,
            index: index != null
                ? index != HARDENED
                    ? index
                    : 0
                : 0);

    var path = List<int>.from(icPath ?? IC_BASE_PATH);

    Ed25519KeyIdentity? identity = curveType == CurveType.secp256k1
        ? null
        : fromMnemonicWithoutValidation(
            phrase,
            path,
            offset: index ?? HARDENED,
          );
    Secp256k1KeyIdentity? ecIdentity = curveType == CurveType.ed25519
        ? null
        : Secp256k1KeyIdentity.fromSecretKey(keys!.ecPrivateKey!);
    return ICPAccount(curveType: curveType)
      .._ecKeys = keys
      .._identity = identity
      .._ecIdentity = ecIdentity
      .._phrase = phrase;
  }

  @override
  Ed25519KeyIdentity? getIdentity() => _identity;

  @override
  Secp256k1KeyIdentity? getEcIdentity() => _ecIdentity;

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  ECKeys? getEcKeys() => _ecKeys;

  Future<void> lock(String? passphrase) async {
    _keystore = await encodePhrase(_phrase!, passphrase ?? "");
    _phrase = null;
    _ecKeys = null;
    _identity = null;
    _ecIdentity = null;
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
      final phrase = await decodePhrase(
        jsonDecode(_keystore!),
        passphrase,
      );
      var newIcp = ICPAccount.fromPhrase(
        phrase,
        index: 0,
        icPath: IC_BASE_PATH,
        curveType: _curveType,
      );
      _phrase = phrase;
      _ecKeys = newIcp._ecKeys;
      _identity = newIcp._identity;
      _ecIdentity = newIcp._ecIdentity;
      newIcp._ecKeys = null;
      newIcp._identity = null;
      isLocked = false;
    } catch (e) {
      throw "Cannot unlock account with password $passphrase "
          "and keystore $_keystore";
    }
  }
}

class ICPSigner extends BaseSigner<ICPAccount, ConstructionPayloadsResponse,
    CombineSignedTransactionResult> {
  ICPSigner.create({
    CurveType curveType = CurveType.ed25519,
  }) : this.fromPhrase(generateMnemonic(), curveType: curveType);

  ICPSigner.fromPhrase(
    String phrase, {
    String passphase = "",
    int? index = 0,
    List<int>? icPath = IC_BASE_PATH,
    CurveType curveType = CurveType.ed25519,
  }) {
    _phrase = phrase;
    _index ??= index;
    _acc = ICPAccount.fromPhrase(
      _phrase!,
      passphase: passphase,
      index: _index!,
      icPath: icPath,
      curveType: curveType,
    );
  }

  ICPSigner.fromSeed(
    Uint8List seed, {
    int? index = 0,
    CurveType curveType = CurveType.ed25519,
  }) {
    _index ??= index;
    _acc = ICPAccount.fromSeed(seed, index: index, curveType: curveType);
  }

  factory ICPSigner.importPhrase(
    String phrase, {
    int index = 0,
    SourceType sourceType = SourceType.II,
    CurveType curveType = CurveType.ed25519,
  }) {
    switch (sourceType) {
      case SourceType.II:
        return ICPSigner.fromPhrase(
          phrase,
          index: HARDENED,
          icPath: IC_DERIVATION_PATH,
        )..setSourceType(SourceType.II);
      case SourceType.Keysmith:
        return ICPSigner.fromPhrase(
          phrase,
          index: index,
          icPath: IC_DERIVATION_PATH,
        )..setSourceType(SourceType.Keysmith);
      case SourceType.Plug:
        return ICPSigner.fromPhrase(
          phrase,
          index: index,
          icPath: IC_DERIVATION_PATH,
        )..setSourceType(SourceType.Keysmith);
      case SourceType.Base:
        return ICPSigner.fromPhrase(
          phrase,
          index: index,
          icPath: IC_BASE_PATH,
        )..setSourceType(SourceType.Base);
      default:
        return ICPSigner.fromPhrase(
          phrase,
          index: HARDENED,
          icPath: IC_DERIVATION_PATH,
        )..setSourceType(SourceType.II);
    }
  }

  ICPAccount get account => _acc;
  late ICPAccount _acc;

  String? _phrase;
  int? _index;
  SourceType? _sourceType;

  SourceType? get sourceType => _sourceType;

  int? get index => _index;

  bool get isHD => index == null;

  String? get idPublicKey => account.identity?.getPublicKey().toRaw().toHex();

  String? get idPublicKeyDer =>
      account.identity?.getPublicKey().toDer().toHex();

  String? get idAddress => account.identity?.getAccountId().toHex();

  String? get idChecksumAddress => account.identity?.getAccountId() != null
      ? crc32Add(account.identity!.getAccountId()).toHex()
      : null;

  String? get ecPublicKey => account.ecIdentity?.getPublicKey().toRaw().toHex();

  String? get ecPublicKeyDer =>
      account.ecIdentity?.getPublicKey().toDer().toHex();

  String? get ecAddress => account.ecIdentity?.getAccountId().toHex();

  String? get ecChecksumAddress => account.ecIdentity?.getAccountId() != null
      ? crc32Add(account.ecIdentity!.getAccountId()).toHex()
      : null;

  ICPAccount hdCreate({
    String passphase = "",
    int? index = 0,
    List<int>? icPath = IC_BASE_PATH,
    CurveType curveType = CurveType.ed25519,
  }) {
    return ICPAccount.fromPhrase(
      _phrase!,
      passphase: passphase,
      index: _index!,
      icPath: icPath,
      curveType: curveType,
    );
  }

  void setSourceType(SourceType type) {
    _sourceType = type;
  }

  @override
  bool? get isLocked => _acc.isLocked;

  @override
  Future<void>? lock(String? passphrase) async {
    await _acc.lock(passphrase);
  }

  @override
  Future<void>? unlock(
    String passphrase, {
    String? keystore,
  }) async {
    await _acc.unlock(
      passphrase,
      keystore: keystore,
    );
  }

  @override
  Future<CombineSignedTransactionResult> sign(
    ConstructionPayloadsResponse payload, {
    SignType? signType = SignType.ed25519,
    SigningCallback? callback,
  }) async {
    try {
      if (signType == SignType.ed25519) {
        var res = await transferCombine(
          account.identity!,
          payload,
        );
        return res;
      }
      if (signType == SignType.ecdsa) {
        var res = await ecTransferCombine(
          account.ecIdentity!,
          payload,
        );
        return res;
      } else {
        throw "Signtype $signType is not supported";
      }
    } catch (e) {
      rethrow;
    }
  }
}
