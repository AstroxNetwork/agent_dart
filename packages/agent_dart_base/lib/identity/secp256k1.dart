import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart_ffi/agent_dart_ffi.dart';
import 'package:pointycastle/api.dart' as p_api;
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
// ignore: implementation_imports
import 'package:pointycastle/src/utils.dart' as p_utils;

import '../agent/auth.dart';
import '../agent/types.dart';
import '../utils/extension.dart';
import '../utils/u8a.dart';
import '../wallet/keysmith.dart';
import 'der.dart';

BigInt _bytesToUnsignedInt(Uint8List bytes) {
  return p_utils.decodeBigIntWithSign(1, bytes);
}

// final ECDomainParameters params = ECCurve_secp256k1();
final BigInt _halfCurveOrder = secp256k1Params.n >> 1;

/// A secp256k1 key pair containing public and private key material.
class Secp256k1KeyPair extends KeyPair {
  /// Creates a secp256k1 key pair.
  const Secp256k1KeyPair({required super.publicKey, required super.secretKey});

  /// Serializes the key pair as `[publicKeyDerHex, secretKeyHex]`.
  List<String> toJson() {
    return [publicKey.toDer().toHex(), secretKey.toHex()];
  }
}

/// A signing identity backed by a secp256k1 private key.
class Secp256k1KeyIdentity extends SignIdentity {
  /// [Secp256k1KeyIdentity.fromRaw] and [Secp256k1KeyIdentity.fromDer]
  /// should not be used for instantiation in this constructor.
  Secp256k1KeyIdentity(
    PublicKey publicKey,
    this._privateKey,
  ) : _publicKey = Secp256k1PublicKey.from(publicKey);

  /// Restores an identity from a parsed `[publicKeyHex, privateKeyHex]` list.
  factory Secp256k1KeyIdentity.fromParsedJson(List<String> obj) {
    return Secp256k1KeyIdentity(
      Secp256k1PublicKey.fromRaw(blobFromHex(obj[0])),
      blobFromHex(obj[1]),
    );
  }

  /// Restores a secp256k1 identity from JSON.
  factory Secp256k1KeyIdentity.fromJSON(String json) {
    final parsed = jsonDecode(json);
    if (parsed is List) {
      if (parsed[0] is String && parsed[1] is String) {
        return Secp256k1KeyIdentity.fromParsedJson([parsed[0], parsed[1]]);
      }
      throw ArgumentError.value(
        json,
        'json',
        'JSON must have at least 2 elements',
      );
    } else if (parsed is Map) {
      final publicKey = parsed['publicKey'];
      final dashPublicKey = parsed['_publicKey'];
      final secretKey = parsed['secretKey'];
      final dashPrivateKey = parsed['_privateKey'];
      final pk = publicKey != null
          ? Secp256k1PublicKey.fromRaw(Uint8List.fromList(publicKey.data))
          : Secp256k1PublicKey.fromDer(Uint8List.fromList(dashPublicKey.data));

      if (publicKey && secretKey && secretKey.data) {
        return Secp256k1KeyIdentity(pk, Uint8List.fromList(secretKey.data));
      }
      if (dashPublicKey && dashPrivateKey && dashPrivateKey.data) {
        return Secp256k1KeyIdentity(
          pk,
          Uint8List.fromList(dashPrivateKey.data),
        );
      }
    }
    throw ArgumentError.value(jsonEncode(json), 'json', 'Invalid json');
  }

  /// Creates an identity from raw public and private key bytes.
  factory Secp256k1KeyIdentity.fromKeyPair(
    BinaryBlob publicKey,
    BinaryBlob privateKey,
  ) {
    return Secp256k1KeyIdentity(
      Secp256k1PublicKey.fromRaw(publicKey),
      privateKey,
    );
  }

  final Secp256k1PublicKey _publicKey;
  final BinaryBlob _privateKey;

  /// Derives a secp256k1 identity from a raw [secretKey].
  static Future<Secp256k1KeyIdentity> fromSecretKey(Uint8List secretKey) async {
    final kp = await getECkeyFromPrivateKey(secretKey);
    final identity = Secp256k1KeyIdentity.fromKeyPair(
      kp.ecPublicKey!,
      kp.ecPrivateKey!,
    );
    return identity;
  }

  /// Serialize this key to JSON.
  List<String> toJson() {
    return [blobToHex(_publicKey.toRaw()), blobToHex(_privateKey)];
  }

  /// Return a copy of the key pair.
  Secp256k1KeyPair getKeyPair() {
    return Secp256k1KeyPair(publicKey: _publicKey, secretKey: _privateKey);
  }

  /// Return the public key.
  @override
  Secp256k1PublicKey getPublicKey() => _publicKey;

  /// Signs a blob of data, with this identity's private key.
  /// [blob] is challenge to sign with this identity's secretKey,
  /// producing a signature.
  @override
  Future<Uint8List> sign(Uint8List blob) {
    return signSecp256k1Async(blob, _privateKey);
  }
}

/// A secp256k1 public key that can be encoded for IC request signing.
class Secp256k1PublicKey implements PublicKey {
  /// Creates a public key from raw secp256k1 key bytes.
  Secp256k1PublicKey(this.rawKey);

  /// Creates a public key from raw secp256k1 key bytes.
  factory Secp256k1PublicKey.fromRaw(BinaryBlob rawKey) {
    return Secp256k1PublicKey(rawKey);
  }

  /// Creates a public key from DER-encoded secp256k1 key bytes.
  factory Secp256k1PublicKey.fromDer(BinaryBlob derKey) {
    return Secp256k1PublicKey(Secp256k1PublicKey.derDecode(derKey));
  }

  /// Creates a secp256k1 public key from another [PublicKey].
  factory Secp256k1PublicKey.from(PublicKey key) {
    return Secp256k1PublicKey.fromDer(key.toDer());
  }

  /// Raw secp256k1 public key bytes.
  final BinaryBlob rawKey;

  /// DER-encoded form of [rawKey].
  late final derKey = Secp256k1PublicKey.derEncode(rawKey);

  /// DER-encodes a raw secp256k1 [publicKey].
  static Uint8List derEncode(BinaryBlob publicKey) {
    return bytesWrapDer(publicKey, oidSecp256k1);
  }

  /// Decodes a DER-encoded secp256k1 [publicKey].
  static Uint8List derDecode(BinaryBlob publicKey) {
    return bytesUnwrapDer(publicKey, oidSecp256k1);
  }

  /// Returns the DER encoding of this public key.
  @override
  Uint8List toDer() => derKey;

  /// Returns the raw secp256k1 public key bytes.
  Uint8List toRaw() => rawKey;
}

/// Signs [message] with [secretKey] using deterministic ECDSA over secp256k1.
Uint8List signSecp256k1(String message, BinaryBlob secretKey) {
  final blob = message.plainToU8a(useDartEncode: true);
  final digest = SHA256Digest();
  final signer = ECDSASigner(digest, HMac(digest, 64));
  final key = ECPrivateKey(_bytesToUnsignedInt(secretKey), secp256k1Params);

  signer.init(true, p_api.PrivateKeyParameter(key));
  ECSignature sig = signer.generateSignature(blob) as ECSignature;
  if (sig.s.compareTo(_halfCurveOrder) > 0) {
    final canonicalizedS = secp256k1Params.n - sig.s;
    sig = ECSignature(sig.r, canonicalizedS);
  }
  if (sig.r == sig.s) {
    return signSecp256k1(message, secretKey);
  }
  Uint8List rU8a = sig.r.toU8a();
  Uint8List sU8a = sig.s.toU8a();
  if (rU8a.length < 32) {
    rU8a = Uint8List.fromList([0, ...rU8a]);
  }
  if (sU8a.length < 32) {
    sU8a = Uint8List.fromList([0, ...sU8a]);
  }
  return u8aConcat([rU8a, sU8a]);
}

/// Signs [blob] with a secp256k1 private [seed].
Future<Uint8List> signSecp256k1Async(Uint8List blob, Uint8List seed) async {
  final result = await secp256K1Sign(
    req: Secp256k1SignWithSeedReq(seed: seed, msg: blob),
  );
  return result.signature!;
}

/// Creates a recoverable secp256k1 signature for [blob].
Future<Uint8List> signSecp256k1Recoverable(
  Uint8List blob,
  Uint8List seed,
) async {
  final result = await secp256K1SignRecoverable(
    req: Secp256k1SignWithSeedReq(seed: seed, msg: blob),
  );
  return result.signature!;
}

/// Signs [blob] with secp256k1 using RNG-backed signing.
Future<Uint8List> signSecp256k1WithRNG(Uint8List blob, Uint8List bytes) async {
  final result = await secp256K1SignWithRng(
    req: Secp256k1SignWithRngReq(privateBytes: bytes, msg: blob),
  );

  return result.signature!;
}

/// Verifies a secp256k1 [signature] for [message] and [publicKey].
bool verifySecp256k1(
  String message,
  Uint8List signature,
  Secp256k1PublicKey publicKey,
) {
  final blob = message.plainToU8a(useDartEncode: true);
  final digest = SHA256Digest();
  final signer = ECDSASigner(digest, HMac(digest, 64));
  final sig = ECSignature(
    signature.sublist(0, 32).toBn(endian: Endian.big),
    signature.sublist(32).toBn(endian: Endian.big),
  );
  final kpub = secp256k1Params.curve.decodePoint(publicKey.toRaw())!;
  final pub = ECPublicKey(kpub, secp256k1Params);
  signer.init(false, p_api.PublicKeyParameter(pub));
  return signer.verifySignature(blob, sig);
}

/// Verifies a secp256k1 [signature] for precomputed message bytes.
bool verifySecp256k1Blob(
  Uint8List blob,
  Uint8List signature,
  Secp256k1PublicKey publicKey,
) {
  final digest = SHA256Digest();
  final signer = ECDSASigner(digest, HMac(digest, 64));
  final sig = ECSignature(
    signature.sublist(0, 32).toBn(endian: Endian.big),
    signature.sublist(32).toBn(endian: Endian.big),
  );
  final kpub = secp256k1Params.curve.decodePoint(publicKey.toRaw())!;
  final pub = ECPublicKey(kpub, secp256k1Params);
  signer.init(false, p_api.PublicKeyParameter(pub));
  return signer.verifySignature(blob, sig);
}

/// Recovers a secp256k1 public key from a prehashed message and signature.
Future<Uint8List> recoverSecp256k1PubKey(
  Uint8List preHashedMessage,
  Uint8List signature,
) async {
  final result = await secp256K1Recover(
    req: Secp256k1RecoverReq(
      messagePreHashed: preHashedMessage,
      signatureBytes: signature,
    ),
  );
  return result;
}

/// Computes a secp256k1 ECDH shared secret.
Future<Uint8List> getECShareSecret(
  Uint8List privateKey,
  Uint8List rawPublicKey,
) async {
  final result = await secp256K1GetSharedSecret(
    req: Secp256k1ShareSecretReq(
      seed: privateKey,
      publicKeyRawBytes: rawPublicKey,
    ),
  );
  return result;
}

/// Computes a P-256 ECDH shared secret.
Future<Uint8List> getP256ShareSecret(
  Uint8List privateKey,
  Uint8List rawPublicKey,
) async {
  final result = await p256GetSharedSecret(
    req: P256ShareSecretReq(
      seed: privateKey,
      publicKeyRawBytes: rawPublicKey,
    ),
  );
  return result;
}
