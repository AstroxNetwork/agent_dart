import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/bridge/ffi/ffi.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';

final ECCurve_secp256k1 params = ECCurve_secp256k1();

const icpPath = "m/44'/223'/0'";

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

@Deprecated('Use Principal.toAccountId instead')
Uint8List getAccountIdFromPrincipal(Principal principal) {
  return principal.toAccountId();
}

Uint8List getAccountIdFromDerKey(Uint8List der) {
  return Principal.selfAuthenticating(der).toAccountId();
}

Uint8List getAccountIdFromPrincipalID(String id) {
  return Principal.fromText(id).toAccountId();
}

ECKeys getECKeys(String mnemonic, {String passphase = '', int index = 0}) {
  assert(validateMnemonic(mnemonic), 'Mnemonic phrases is not valid $mnemonic');
  final seed = mnemonicToSeed(mnemonic, passphrase: passphase);
  return ecKeysfromSeed(seed, index: index);
}

Future<ECKeys> getECKeysAsync(
  String phrase, {
  String passphase = '',
  int index = 0,
}) async {
  final seed = await AgentDartFFI.instance.mnemonicPhraseToSeed(
    req: PhraseToSeedReq(phrase: phrase, password: passphase),
  );

  final prv = await AgentDartFFI.instance.mnemonicSeedToKey(
    req: SeedToKeyReq(seed: seed, path: '$icpPath/0/$index'),
  );
  final kp = await AgentDartFFI.instance.secp256K1FromSeed(
    req: Secp256k1FromSeedReq(seed: prv),
  );

  return ECKeys(
    ecPrivateKey: prv,
    ecPublicKey: Secp256k1PublicKey.fromDer(kp.derEncodedPublicKey).toRaw(),
  );
}

Future<ECKeys> getECkeyFromPrivateKey(Uint8List prv) async {
  final kp = await AgentDartFFI.instance
      .secp256K1FromSeed(req: Secp256k1FromSeedReq(seed: prv));
  return ECKeys(
    ecPrivateKey: prv,
    ecPublicKey: Secp256k1PublicKey.fromDer(kp.derEncodedPublicKey).toRaw(),
  );
}

ECKeys ecKeysfromSeed(Uint8List seed, {int index = 0}) {
  final node = bip32.BIP32.fromSeed(seed);

  var masterPrv = node.derivePath('$icpPath/0/$index');
  var masterPrvRaw = node.derivePath(icpPath);
  final xpub = masterPrvRaw.toBase58();

  final prv = masterPrv.privateKey;
  final pub = prv != null ? getPublicFromPrivateKey(prv, false) : null;
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
  BigInt privateKeyNum = privateKey.toBn(endian: Endian.big);

  return getPublicFromPrivateKeyBigInt(privateKeyNum, compress);
}

Uint8List? getPublicFromPrivateKeyBigInt(
  BigInt bigint, [
  bool compress = false,
]) {
  ECPoint? p = params.G * bigint;

  if (p != null) {
    return p.getEncoded(compress);
  } else {
    return null;
  }
}

Future<Uint8List> getDerFromFFI(Uint8List seed) async {
  final ffiIdentity = await AgentDartFFI.instance
      .secp256K1FromSeed(req: Secp256k1FromSeedReq(seed: seed));
  return ffiIdentity.derEncodedPublicKey;
}

class ECKeys {
  ECKeys({
    this.ecChainCode,
    this.ecPrivateKey,
    this.ecPublicKey,
    this.ecCompressedPublicKey,
    this.extendedECPublicKey,
  });

  Uint8List? ecChainCode;
  Uint8List? ecPrivateKey;
  Uint8List? ecPublicKey;
  Uint8List? ecCompressedPublicKey;

  Uint8List? get accountId =>
      ecPublicKey != null ? getAccountIdFromRawPublicKey(ecPublicKey!) : null;

  String? get ecPrincipal =>
      ecPublicKey != null ? getPrincipalFromECPublicKey(ecPublicKey!) : null;
  String? extendedECPublicKey;
}

class Secp256k1PublicKey implements PublicKey {
  Secp256k1PublicKey(this.rawKey);

  final BinaryBlob rawKey;
  late final derKey = Secp256k1PublicKey.derEncode(rawKey);

  static const rawKeyLength = 65;

  static final derPrefix = Uint8List.fromList([
    0x30,
    0x56,
    0x30,
    0x10,
    0x06,
    0x07,
    0x2a,
    0x86,
    0x48,
    0xce,
    0x3d,
    0x02,
    0x01,
    0x06,
    0x05,
    0x2b,
    0x81,
    0x04,
    0x00,
    0x0a,
    0x03,
    0x42,
    0x00, // no padding
  ]);

  static Secp256k1PublicKey fromRaw(BinaryBlob rawKey) {
    return Secp256k1PublicKey(rawKey);
  }

  static Secp256k1PublicKey fromDer(BinaryBlob derKey) {
    return Secp256k1PublicKey(Secp256k1PublicKey.derDecode(derKey));
  }

  static Secp256k1PublicKey from(PublicKey key) {
    return Secp256k1PublicKey.fromDer(key.toDer());
  }

  static Uint8List derEncode(BinaryBlob publicKey) {
    if (publicKey.byteLength != Secp256k1PublicKey.rawKeyLength) {
      final bl = publicKey.byteLength;
      throw 'secp256k1 public key must be '
          '${Secp256k1PublicKey.rawKeyLength} bytes long (is $bl)';
    }
    return Uint8List.fromList([
      ...Secp256k1PublicKey.derPrefix,
      ...Uint8List.fromList(publicKey),
    ]);
  }

  static Uint8List derDecode(BinaryBlob key) {
    final expectedLength =
        Secp256k1PublicKey.derPrefix.length + Secp256k1PublicKey.rawKeyLength;
    if (key.byteLength != expectedLength) {
      final bl = key.byteLength;
      throw 'secp256k1 DER-encoded public key '
          'must be $expectedLength bytes long (is $bl)';
    }
    final rawKey = key.sublist(Secp256k1PublicKey.derPrefix.length);
    if (!u8aEq(derEncode(rawKey), key)) {
      throw 'secp256k1 DER-encoded public key is invalid. '
          'A valid secp256k1 DER-encoded public key '
          'must have the following prefix: ${Secp256k1PublicKey.derPrefix}';
    }
    return rawKey;
  }

  @override
  Uint8List toDer() {
    return derKey;
  }

  Uint8List toRaw() {
    return rawKey;
  }
}
