import 'dart:convert';
import 'dart:typed_data';

import '../agent/crypto/keystore/key_store.dart';
import '../identity/identity.dart';
import '../utils/extension.dart';

import 'keysmith.dart';
import 'rosetta.dart';
import 'types.dart';

/// Callback invoked with optional signing progress or result data.
typedef SigningCallback = void Function([dynamic data]);

/// Supported signature schemes for wallet payload signing.
enum SignType { ecdsa, ed25519 }

/// Source of imported wallet key material.
enum SourceType { ii, plug, keySmith, base }

/// [CurveType] is the type of cryptographic curve associated with a [WalletPublicKey].
///  * [secp256k1] SEC compressed - `33 bytes` (https://secg.org/sec1-v2.pdf#subsubsection.2.3.3)
///  * [ed25519]  `y (255-bits) || x-sign-bit (1-bit)` - `32 bytes` (https://ed25519.cr.yp.to/ed25519-20110926.pdf)
///  * [all] both above.
enum CurveType { secp256k1, ed25519, all }

/// Base interface for wallet signers.
abstract class Signer<T extends SignablePayload, R> {
  /// Creates a signer abstraction.
  const Signer();

  /// Whether the signer is currently locked.
  bool? get isLocked;

  /// Unlocks the signer using [passphrase] and an optional serialized keystore.
  Future<void>? unlock(String passphrase, {String? keystore});

  /// Locks the signer, optionally encrypting key material with [passphrase].
  Future<void>? lock(String? passphrase);

  /// Signs [payload] with the selected [signType].
  Future<R> sign(
    T payload, {
    SignType? signType = SignType.ed25519,
    SigningCallback? callback,
  });
}

/// Base signer tied to a concrete account and signable payload type.
abstract class BaseSigner<T extends BaseAccount, R extends SignablePayload, E>
    extends Signer<R, E> {
  /// Creates a base signer abstraction.
  const BaseSigner();
}

/// Base wallet account abstraction used by signers.
abstract class BaseAccount {
  /// Creates a base account abstraction.
  const BaseAccount();

  /// Returns the Ed25519 identity for this account, when available.
  Ed25519KeyIdentity? getIdentity();

  /// Returns the secp256k1 identity for this account, when available.
  Secp256k1KeyIdentity? getEcIdentity();

  /// Serializes this account.
  Map<String, dynamic> toJson();

  /// Returns derived elliptic-curve key material, when available.
  ECKeys? getEcKeys();
}

/// ICP wallet account backed by mnemonic or seed-derived identities.
class ICPAccount extends BaseAccount {
  /// Creates an ICP account container for [curveType].
  ICPAccount({this.curveType = CurveType.ed25519});

  bool isLocked = false;
  String? _keystore;
  String? _phrase;
  final CurveType curveType;

  Ed25519KeyIdentity? get identity => _identity;
  Ed25519KeyIdentity? _identity;

  Secp256k1KeyIdentity? get ecIdentity => _ecIdentity;
  Secp256k1KeyIdentity? _ecIdentity;

  ECKeys? get ecKeys => _ecKeys;
  ECKeys? _ecKeys;

  /// Creates an account from raw seed bytes.
  static Future<ICPAccount> fromSeed(
    Uint8List seed, {
    int? index,
    CurveType curveType = CurveType.ed25519,
  }) async {
    final ECKeys keys = ecKeysfromSeed(seed, index: index ?? 0);
    final Ed25519KeyIdentity? identity = curveType == CurveType.secp256k1
        ? null
        : await Ed25519KeyIdentity.generate(seed);
    final Secp256k1KeyIdentity? ecIdentity = curveType == CurveType.ed25519
        ? null
        : Secp256k1KeyIdentity.fromKeyPair(
            keys.ecPublicKey!,
            keys.ecPrivateKey!,
          );
    return ICPAccount(curveType: curveType)
      .._ecKeys = keys
      .._identity = identity
      .._ecIdentity = ecIdentity
      .._phrase = '';
  }

  /// Creates an account from a mnemonic phrase.
  static Future<ICPAccount> fromPhrase(
    String phrase, {
    String passphrase = '',
    int? index,
    List<int>? icPath = icBasePath,
    CurveType curveType = CurveType.ed25519,
  }) async {
    ECKeys? keys;
    Secp256k1KeyIdentity? ecIdentity;
    Ed25519KeyIdentity? identity;

    if (curveType == CurveType.secp256k1 || curveType == CurveType.all) {
      keys = await getECKeysAsync(
        phrase,
        passphrase: passphrase,
        index: index != null && index != hardened ? index : 0,
      );
      ecIdentity = Secp256k1KeyIdentity.fromKeyPair(
        keys.ecPublicKey!,
        keys.ecPrivateKey!,
      );
    }
    if (curveType == CurveType.ed25519 || curveType == CurveType.all) {
      final path = List<int>.from(icPath ?? icBasePath);
      identity = await fromMnemonicWithoutValidation(
        phrase,
        path,
        offset: index ?? hardened,
      );
    }
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

  /// Encrypts and clears in-memory key material.
  Future<void> lock(String? passphrase) async {
    _keystore = await encodePhrase(_phrase!, password: passphrase);
    _phrase = null;
    _ecKeys = null;
    _identity = null;
    _ecIdentity = null;
    isLocked = true;
  }

  /// Restores key material from the encrypted keystore.
  Future<void> unlock(String passphrase, {String? keystore}) async {
    try {
      if (_keystore == null) {
        if (keystore != null) {
          _keystore = keystore;
        } else {
          throw StateError('Keystore file is not found.');
        }
      }
      final phrase = await decodePhrase(jsonDecode(_keystore!), passphrase);
      final newIcp = await ICPAccount.fromPhrase(
        phrase,
        index: 0,
        curveType: curveType,
      );
      _phrase = phrase;
      _ecKeys = newIcp._ecKeys;
      _identity = newIcp._identity;
      _ecIdentity = newIcp._ecIdentity;
      newIcp._ecKeys = null;
      newIcp._identity = null;
    } finally {
      isLocked = false;
    }
  }
}

/// Signer for ICP Rosetta construction payloads.
class ICPSigner extends BaseSigner<ICPAccount, ConstructionPayloadsResponse,
    CombineSignedTransactionResult> {
  ICPSigner._();

  /// Creates a signer with a newly generated mnemonic phrase.
  static Future<ICPSigner> create({
    CurveType curveType = CurveType.ed25519,
  }) {
    return ICPSigner.fromPhrase(generateMnemonic(), curveType: curveType);
  }

  /// Creates a signer from an existing mnemonic phrase.
  static Future<ICPSigner> fromPhrase(
    String phrase, {
    String passphrase = '',
    int? index = 0,
    List<int>? icPath = icBasePath,
    CurveType curveType = CurveType.ed25519,
  }) async {
    final ICPAccount acc = await ICPAccount.fromPhrase(
      phrase,
      passphrase: passphrase,
      index: index,
      icPath: icPath,
      curveType: curveType,
    );
    return ICPSigner._()
      .._phrase = phrase
      .._index = index
      .._acc = acc;
  }

  /// Creates a signer from raw seed bytes.
  static Future<ICPSigner> fromSeed(
    Uint8List seed, {
    int? index = 0,
    CurveType curveType = CurveType.ed25519,
  }) async {
    final ICPAccount acc = await ICPAccount.fromSeed(
      seed,
      index: index,
      curveType: curveType,
    );
    return ICPSigner._()
      .._index = index
      .._acc = acc;
  }

  /// Imports a phrase using the derivation path for [sourceType].
  static Future<ICPSigner> importPhrase(
    String phrase, {
    int index = 0,
    SourceType sourceType = SourceType.ii,
    CurveType curveType = CurveType.ed25519,
  }) async {
    switch (sourceType) {
      case SourceType.ii:
        return (await ICPSigner.fromPhrase(
          phrase,
          index: hardened,
          icPath: icDerivationPath,
          curveType: curveType,
        ))
          ..setSourceType(SourceType.ii);
      case SourceType.keySmith:
        return (await ICPSigner.fromPhrase(
          phrase,
          index: index,
          icPath: icDerivationPath,
          curveType: curveType,
        ))
          ..setSourceType(SourceType.keySmith);
      case SourceType.plug:
        return (await ICPSigner.fromPhrase(
          phrase,
          index: index,
          icPath: icDerivationPath,
          curveType: curveType,
        ))
          ..setSourceType(SourceType.keySmith);
      case SourceType.base:
        return (await ICPSigner.fromPhrase(
          phrase,
          index: index,
          curveType: curveType,
        ))
          ..setSourceType(SourceType.base);
    }
  }

  /// Account used by this signer.
  ICPAccount get account => _acc;
  late ICPAccount _acc;

  String? _phrase;
  int? _index;
  SourceType? _sourceType;

  /// Source used to derive this signer's account.
  SourceType? get sourceType => _sourceType;

  /// Account index used during derivation.
  int? get index => _index;

  /// Whether this signer represents an HD account.
  bool get isHD => index == null;

  /// Raw Ed25519 public key as hex.
  String? get idPublicKey => account.identity?.getPublicKey().toRaw().toHex();

  /// DER-encoded Ed25519 public key as hex.
  String? get idPublicKeyDer =>
      account.identity?.getPublicKey().toDer().toHex();

  /// ICP account identifier for the Ed25519 identity.
  String? get idAddress => account.identity?.getAccountId().toHex();

  /// Raw secp256k1 public key as hex.
  String? get ecPublicKey => account.ecIdentity?.getPublicKey().toRaw().toHex();

  /// DER-encoded secp256k1 public key as hex.
  String? get ecPublicKeyDer =>
      account.ecIdentity?.getPublicKey().toDer().toHex();

  /// ICP account identifier for the secp256k1 identity.
  String? get ecAddress => account.ecIdentity?.getAccountId().toHex();

  /// Derives an additional HD account from the signer's phrase.
  Future<ICPAccount> hdCreate({
    String passphrase = '',
    int? index = 0,
    List<int>? icPath = icBasePath,
    CurveType curveType = CurveType.ed25519,
  }) {
    return ICPAccount.fromPhrase(
      _phrase!,
      passphrase: passphrase,
      index: _index!,
      icPath: icPath,
      curveType: curveType,
    );
  }

  /// Sets the phrase import source type.
  void setSourceType(SourceType type) {
    _sourceType = type;
  }

  @override
  bool? get isLocked => _acc.isLocked;

  @override
  Future<void> lock(String? passphrase) {
    return _acc.lock(passphrase);
  }

  @override
  Future<void> unlock(
    String passphrase, {
    String? keystore,
  }) {
    return _acc.unlock(passphrase, keystore: keystore);
  }

  @override
  Future<CombineSignedTransactionResult> sign(
    ConstructionPayloadsResponse payload, {
    SignType? signType = SignType.ed25519,
    SigningCallback? callback,
  }) async {
    if (signType == SignType.ed25519) {
      final res = await transferCombine(
        account.identity!,
        payload,
      );
      return res;
    }
    if (signType == SignType.ecdsa) {
      final res = await ecTransferCombine(
        account.ecIdentity!,
        payload,
      );
      return res;
    }
    throw UnsupportedError('Sign type $signType is not supported.');
  }
}
