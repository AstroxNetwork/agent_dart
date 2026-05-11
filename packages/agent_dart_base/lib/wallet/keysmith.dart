import 'dart:typed_data';

import 'package:agent_dart_ffi/agent_dart_ffi.dart' as ffi;
import 'package:bip32_plus/bip32_plus.dart' as bip32;
import 'package:bip39_mnemonic/bip39_mnemonic.dart' as bip39;
import 'package:pointycastle/ecc/api.dart' show ECPoint;
import 'package:pointycastle/ecc/curves/secp256k1.dart' show ECCurve_secp256k1;

import '../../identity/identity.dart';
import '../../principal/principal.dart';
import '../../utils/extension.dart';

/// Shared secp256k1 curve parameters used for key derivation and signatures.
final secp256k1Params = ECCurve_secp256k1();

/// BIP-44 coin type constants used by key derivation helpers.
abstract class CoinType {
  /// Internet Computer coin type.
  static const icp = 223;

  /// Ethereum coin type.
  static const eth = 60;

  /// Bitcoin coin type.
  static const btc = 0;
}

/// Derived elliptic-curve key material.
class ECKeys {
  /// Creates a derived key container.
  const ECKeys({
    this.ecChainCode,
    this.ecPrivateKey,
    this.ecPublicKey,
    this.ecSchnorrPublicKey,
    this.ecP256PublicKey,
    this.ecCompressedPublicKey,
    this.extendedECPublicKey,
  });

  /// Chain code for extended key derivation.
  final Uint8List? ecChainCode;

  /// Raw private key bytes.
  final Uint8List? ecPrivateKey;

  /// Raw secp256k1 public key bytes.
  final Uint8List? ecPublicKey;

  /// Raw P-256 public key bytes.
  final Uint8List? ecP256PublicKey;

  /// Raw Schnorr public key bytes.
  final Uint8List? ecSchnorrPublicKey;

  /// Compressed secp256k1 public key bytes.
  final Uint8List? ecCompressedPublicKey;

  /// Extended public key in base58 form.
  final String? extendedECPublicKey;

  /// ICP account identifier derived from [ecPublicKey].
  Uint8List? get accountId =>
      ecPublicKey != null ? getAccountIdFromRawPublicKey(ecPublicKey!) : null;

  /// Self-authenticating principal derived from [ecPublicKey].
  String? get ecPrincipal =>
      ecPublicKey != null ? getPrincipalFromECPublicKey(ecPublicKey!) : null;
}

/// Returns the base BIP-44 derivation path for [coinType].
String getPathWithCoinType({
  int coinType = CoinType.icp,
}) {
  return "m/44'/$coinType'/0'";
}

/// Generates a BIP-39 mnemonic phrase.
String generateMnemonic({
  bip39.Language language = bip39.Language.english,
  String passphrase = '',
  int bitLength = 128,
}) {
  final mnemonic = bip39.Mnemonic.generate(
    language,
    passphrase: passphrase,
    entropyLength: bitLength,
  );
  return mnemonic.sentence;
}

/// Validates a BIP-39 mnemonic phrase.
bool validateMnemonic(
  String value, {
  bip39.Language language = bip39.Language.english,
  String passphrase = '',
}) {
  try {
    bip39.Mnemonic.fromSentence(
      value,
      language,
      passphrase: passphrase,
    );
    return true;
  } catch (e) {
    return false;
  }
}

/// Converts a BIP-39 [phrase] into seed bytes.
Uint8List mnemonicToSeed(
  String phrase, {
  bip39.Language language = bip39.Language.english,
  String passphrase = '',
}) {
  assert(validateMnemonic(phrase), 'Mnemonic phrases is not valid $phrase');
  final mnemonic = bip39.Mnemonic.fromSentence(
    phrase,
    language,
    passphrase: passphrase,
  );
  return Uint8List.fromList(mnemonic.seed);
}

/// Derives an IC principal from a raw secp256k1 [publicKey].
String getPrincipalFromECPublicKey(Uint8List publicKey) {
  final secp256k1Pub = Secp256k1PublicKey.fromRaw(publicKey).toDer();
  final auth = Principal.selfAuthenticating(secp256k1Pub);
  return auth.toText();
}

/// Derives an ICP account identifier from a raw secp256k1 [publicKey].
Uint8List getAccountIdFromRawPublicKey(Uint8List publicKey) {
  final der = Secp256k1PublicKey.fromRaw(publicKey).toDer();
  return getAccountIdFromDerKey(der);
}

/// Derives an ICP account identifier from a raw Ed25519 [publicKey].
Uint8List getAccountIdFromEd25519PublicKey(Uint8List publicKey) {
  final der = Ed25519PublicKey.fromRaw(publicKey).toDer();
  return getAccountIdFromDerKey(der);
}

/// Derives an ICP account identifier from a DER-encoded public key.
Uint8List getAccountIdFromDerKey(Uint8List der) {
  return Principal.selfAuthenticating(der).toAccountId();
}

/// Derives an ICP account identifier from a principal text [id].
Uint8List getAccountIdFromPrincipalID(String id) {
  return Principal.fromText(id).toAccountId();
}

/// Derives secp256k1 key material from a mnemonic phrase.
ECKeys getECKeys(
  String mnemonic, {
  bip39.Language language = bip39.Language.english,
  String passphrase = '',
  int index = 0,
  int coinType = CoinType.icp,
}) {
  assert(
    validateMnemonic(mnemonic, language: language, passphrase: passphrase),
    'Mnemonic phrases is not valid $mnemonic',
  );
  final seed = mnemonicToSeed(
    mnemonic,
    language: language,
    passphrase: passphrase,
  );
  return ecKeysfromSeed(seed, index: index, coinType: coinType);
}

/// Derives secp256k1, Schnorr, and P-256 key material from a phrase.
Future<ECKeys> getECKeysAsync(
  String phrase, {
  String passphrase = '',
  int index = 0,
  int coinType = CoinType.icp,
}) async {
  final basePath = getPathWithCoinType(coinType: coinType);
  final seed = await ffi.mnemonicPhraseToSeed(
    req: ffi.PhraseToSeedReq(phrase: phrase, password: passphrase),
  );

  final prv = await ffi.mnemonicSeedToKey(
    req: ffi.SeedToKeyReq(seed: seed, path: '$basePath/0/$index'),
  );
  final kp = await ffi.secp256K1FromSeed(
    req: ffi.Secp256k1FromSeedReq(seed: prv),
  );
  final kpSchnorr = await ffi.schnorrFromSeed(
    req: ffi.SchnorrFromSeedReq(seed: prv),
  );
  final kpP256 = await ffi.p256FromSeed(
    req: ffi.P256FromSeedReq(seed: prv),
  );
  return ECKeys(
    ecPrivateKey: prv,
    ecPublicKey: Secp256k1PublicKey.fromDer(kp.derEncodedPublicKey).toRaw(),
    ecSchnorrPublicKey:
        SchnorrPublicKey.fromRaw(kpSchnorr.publicKeyHash).toRaw(),
    ecP256PublicKey: P256PublicKey.fromDer(kpP256.derEncodedPublicKey).toRaw(),
  );
}

/// Derives public keys for multiple curves from a raw private key.
Future<ECKeys> getECkeyFromPrivateKey(Uint8List prv) async {
  final kp = await ffi.secp256K1FromSeed(
    req: ffi.Secp256k1FromSeedReq(seed: prv),
  );
  final kpSchnorr = await ffi.schnorrFromSeed(
    req: ffi.SchnorrFromSeedReq(seed: prv),
  );
  final kpP256 = await ffi.p256FromSeed(
    req: ffi.P256FromSeedReq(seed: prv),
  );

  return ECKeys(
    ecPrivateKey: prv,
    ecPublicKey: Secp256k1PublicKey.fromDer(kp.derEncodedPublicKey).toRaw(),
    ecSchnorrPublicKey:
        Secp256k1PublicKey.fromRaw(kpSchnorr.publicKeyHash).toRaw(),
    ecP256PublicKey: P256PublicKey.fromDer(kpP256.derEncodedPublicKey).toRaw(),
  );
}

/// Derives secp256k1 keys from raw BIP-39 seed bytes.
ECKeys ecKeysfromSeed(
  Uint8List seed, {
  int index = 0,
  int coinType = CoinType.icp,
}) {
  final basePath = getPathWithCoinType(coinType: coinType);
  final node = bip32.BIP32.fromSeed(seed);

  final masterPrv = node.derivePath('$basePath/0/$index');
  final masterPrvRaw = node.derivePath(basePath);
  final xpub = masterPrvRaw.toBase58();

  final prv = masterPrv.privateKey;
  final pub = prv != null ? getPublicFromPrivateKey(prv) : null;
  final pubCompressed = prv != null ? getPublicFromPrivateKey(prv, true) : null;

  return ECKeys(
    ecPrivateKey: prv,
    ecPublicKey: pub,
    ecCompressedPublicKey: pubCompressed,
    extendedECPublicKey: xpub,
  );
}

/// Derives a public key from a secp256k1 [privateKey].
Uint8List? getPublicFromPrivateKey(
  Uint8List privateKey, [
  bool compress = false,
]) {
  final BigInt privateKeyNum = privateKey.toBn(endian: Endian.big);
  return getPublicFromPrivateKeyBigInt(privateKeyNum, compress);
}

/// Derives a public key from a secp256k1 private key integer.
Uint8List? getPublicFromPrivateKeyBigInt(
  BigInt bigint, [
  bool compress = false,
]) {
  final ECPoint? p = secp256k1Params.G * bigint;
  if (p != null) {
    return p.getEncoded(compress);
  } else {
    return null;
  }
}

/// Derives a DER-encoded secp256k1 public key via the native FFI bridge.
Future<Uint8List> getDerFromFFI(Uint8List seed) async {
  final ffiIdentity = await ffi.secp256K1FromSeed(
    req: ffi.Secp256k1FromSeedReq(seed: seed),
  );
  return ffiIdentity.derEncodedPublicKey;
}

/// Derives a Schnorr public key via the native FFI bridge.
Future<Uint8List> getSchnorrPubFromFFI(Uint8List seed) async {
  final ffiIdentity = await ffi.schnorrFromSeed(
    req: ffi.SchnorrFromSeedReq(seed: seed),
  );
  return ffiIdentity.publicKeyHash;
}

/// Derives a DER-encoded P-256 public key via the native FFI bridge.
Future<Uint8List> getP256DerPubFromFFI(Uint8List seed) async {
  final ffiIdentity = await ffi.p256FromSeed(
    req: ffi.P256FromSeedReq(seed: seed),
  );
  return ffiIdentity.derEncodedPublicKey;
}
