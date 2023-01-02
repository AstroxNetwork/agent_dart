import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/bridge/ffi/ffi.dart';
import 'package:pointycastle/api.dart' as p_api;
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';

// ignore: implementation_imports
import 'package:pointycastle/src/utils.dart' as p_utils;

BigInt _bytesToUnsignedInt(Uint8List bytes) {
  return p_utils.decodeBigIntWithSign(1, bytes);
}

// final ECDomainParameters params = ECCurve_secp256k1();
final BigInt _halfCurveOrder = secp256k1Params.n >> 1;

class Secp256k1KeyPair extends KeyPair {
  const Secp256k1KeyPair({required super.publicKey, required super.secretKey});

  List<String> toJson() {
    return [publicKey.toDer().toHex(), secretKey.toHex()];
  }
}

class Secp256k1KeyIdentity extends SignIdentity {
  /// [Secp256k1KeyIdentity.fromRaw] and [Secp256k1KeyIdentity.fromDer]
  /// should not be used for instantiation in this constructor.
  Secp256k1KeyIdentity(
    PublicKey publicKey,
    this._privateKey,
  ) : _publicKey = Secp256k1PublicKey.from(publicKey);

  factory Secp256k1KeyIdentity.fromParsedJson(List<String> obj) {
    return Secp256k1KeyIdentity(
      Secp256k1PublicKey.fromRaw(blobFromHex(obj[0])),
      blobFromHex(obj[1]),
    );
  }

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

class Secp256k1PublicKey implements PublicKey {
  Secp256k1PublicKey(this.rawKey);

  factory Secp256k1PublicKey.fromRaw(BinaryBlob rawKey) {
    return Secp256k1PublicKey(rawKey);
  }

  factory Secp256k1PublicKey.fromDer(BinaryBlob derKey) {
    return Secp256k1PublicKey(Secp256k1PublicKey.derDecode(derKey));
  }

  factory Secp256k1PublicKey.from(PublicKey key) {
    return Secp256k1PublicKey.fromDer(key.toDer());
  }

  final BinaryBlob rawKey;
  late final derKey = Secp256k1PublicKey.derEncode(rawKey);

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

  static Uint8List derEncode(BinaryBlob publicKey) {
    return Uint8List.fromList([
      ...Secp256k1PublicKey.derPrefix,
      ...Uint8List.fromList(publicKey),
    ]);
  }

  static Uint8List derDecode(BinaryBlob publicKey) {
    final rawKey = publicKey.sublist(Secp256k1PublicKey.derPrefix.length);
    if (!u8aEq(derEncode(rawKey), publicKey)) {
      throw StateError('Expected prefix ${Secp256k1PublicKey.derPrefix}.');
    }
    return rawKey;
  }

  @override
  Uint8List toDer() => derKey;

  Uint8List toRaw() => rawKey;
}

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

Future<Uint8List> signSecp256k1Async(Uint8List blob, Uint8List seed) async {
  final result = await AgentDartFFI.impl.secp256K1Sign(
    req: Secp256k1SignWithSeedReq(seed: seed, msg: blob),
  );
  return result.signature!;
}

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

Future<Uint8List> getECShareSecret(
  Uint8List privateKey,
  Uint8List rawPublicKey,
) async {
  final result = await AgentDartFFI.impl.secp256K1GetSharedSecret(
    req: Secp256k1ShareSecretReq(
      seed: privateKey,
      publicKeyRawBytes: rawPublicKey,
    ),
  );
  return result;
}
