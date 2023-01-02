import 'dart:typed_data';

import 'package:agent_dart/bridge/ffi/ffi.dart';
import 'package:agent_dart/identity/identity.dart';
import 'package:agent_dart/identity/secp256k1.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';

final ECCurve_secp256k1 secp256k1Params = ECCurve_secp256k1();

abstract class CoinType {
  static const icp = 223;
  static const eth = 60;
  static const btc = 0;
}

class ECKeys {
  const ECKeys({
    this.ecChainCode,
    this.ecPrivateKey,
    this.ecPublicKey,
    this.ecSchnorrPublicKey,
    this.ecCompressedPublicKey,
    this.extendedECPublicKey,
  });

  final Uint8List? ecChainCode;
  final Uint8List? ecPrivateKey;
  final Uint8List? ecPublicKey;
  final Uint8List? ecSchnorrPublicKey;
  final Uint8List? ecCompressedPublicKey;
  final String? extendedECPublicKey;

  Uint8List? get accountId =>
      ecPublicKey != null ? getAccountIdFromRawPublicKey(ecPublicKey!) : null;

  String? get ecPrincipal =>
      ecPublicKey != null ? getPrincipalFromECPublicKey(ecPublicKey!) : null;
}

String getPathWithCoinType({int coinType = CoinType.icp}) {
  return "m/44'/$coinType'/0'";
}

String generateMnemonic({int bitLength = 128}) {
  return bip39.generateMnemonic(strength: bitLength);
}

bool validateMnemonic(String mnemonic) {
  return bip39.validateMnemonic(mnemonic);
}

Uint8List mnemonicToSeed(String phrase, {String passphrase = ''}) {
  assert(validateMnemonic(phrase), 'Mnemonic phrases is not valid $phrase');
  return bip39.mnemonicToSeed(phrase, passphrase: passphrase);
}

String getPrincipalFromECPublicKey(Uint8List publicKey) {
  final secp256k1Pub = Secp256k1PublicKey.fromRaw(publicKey).toDer();
  final auth = Principal.selfAuthenticating(secp256k1Pub);
  return auth.toText();
}

Uint8List getAccountIdFromRawPublicKey(Uint8List publicKey) {
  final der = Secp256k1PublicKey.fromRaw(publicKey).toDer();
  return getAccountIdFromDerKey(der);
}

Uint8List getAccountIdFromEd25519PublicKey(Uint8List publicKey) {
  final der = Ed25519PublicKey.fromRaw(publicKey).toDer();
  return getAccountIdFromDerKey(der);
}

Uint8List getAccountIdFromDerKey(Uint8List der) {
  return Principal.selfAuthenticating(der).toAccountId();
}

Uint8List getAccountIdFromPrincipalID(String id) {
  return Principal.fromText(id).toAccountId();
}

ECKeys getECKeys(
  String mnemonic, {
  String passphrase = '',
  int index = 0,
  int coinType = CoinType.icp,
}) {
  assert(validateMnemonic(mnemonic), 'Mnemonic phrases is not valid $mnemonic');
  final seed = mnemonicToSeed(mnemonic, passphrase: passphrase);
  return ecKeysfromSeed(seed, index: index, coinType: coinType);
}

Future<ECKeys> getECKeysAsync(
  String phrase, {
  String passphrase = '',
  int index = 0,
  int coinType = CoinType.icp,
}) async {
  final basePath = getPathWithCoinType(coinType: coinType);
  final seed = await AgentDartFFI.impl.mnemonicPhraseToSeed(
    req: PhraseToSeedReq(phrase: phrase, password: passphrase),
  );

  final prv = await AgentDartFFI.impl.mnemonicSeedToKey(
    req: SeedToKeyReq(seed: seed, path: '$basePath/0/$index'),
  );
  final kp = await AgentDartFFI.impl.secp256K1FromSeed(
    req: Secp256k1FromSeedReq(seed: prv),
  );
  final kpSchnorr = await AgentDartFFI.impl.schnorrFromSeed(
    req: Secp256k1FromSeedReq(seed: prv),
  );
  return ECKeys(
    ecPrivateKey: prv,
    ecPublicKey: Secp256k1PublicKey.fromDer(kp.derEncodedPublicKey).toRaw(),
    ecSchnorrPublicKey:
        Secp256k1PublicKey.fromRaw(kpSchnorr.publicKeyHash).toRaw(),
  );
}

Future<ECKeys> getECkeyFromPrivateKey(Uint8List prv) async {
  final kp = await AgentDartFFI.impl.secp256K1FromSeed(
    req: Secp256k1FromSeedReq(seed: prv),
  );
  final kpSchnorr = await AgentDartFFI.impl.schnorrFromSeed(
    req: Secp256k1FromSeedReq(seed: prv),
  );
  return ECKeys(
    ecPrivateKey: prv,
    ecPublicKey: Secp256k1PublicKey.fromDer(kp.derEncodedPublicKey).toRaw(),
    ecSchnorrPublicKey:
        Secp256k1PublicKey.fromRaw(kpSchnorr.publicKeyHash).toRaw(),
  );
}

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

Uint8List? getPublicFromPrivateKey(
  Uint8List privateKey, [
  bool compress = false,
]) {
  final BigInt privateKeyNum = privateKey.toBn(endian: Endian.big);
  return getPublicFromPrivateKeyBigInt(privateKeyNum, compress);
}

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

Future<Uint8List> getDerFromFFI(Uint8List seed) async {
  final ffiIdentity = await AgentDartFFI.impl.secp256K1FromSeed(
    req: Secp256k1FromSeedReq(seed: seed),
  );
  return ffiIdentity.derEncodedPublicKey;
}

Future<Uint8List> getSchnorrPubFromFFI(Uint8List seed) async {
  final ffiIdentity = await AgentDartFFI.impl.schnorrFromSeed(
    req: Secp256k1FromSeedReq(seed: seed),
  );
  return ffiIdentity.publicKeyHash;
}
