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

typedef JsonableSecp256k1Identity = List<String>;

BigInt bytesToUnsignedInt(Uint8List bytes) {
  return p_utils.decodeBigIntWithSign(1, bytes);
}

// final ECDomainParameters params = ECCurve_secp256k1();
final BigInt _halfCurveOrder = params.n >> 1;

class Secp256k1KeyPair extends KeyPair {
  const Secp256k1KeyPair({required super.publicKey, required super.secretKey});

  List<String> toJson() {
    return [publicKey.toDer().toHex(), secretKey.toHex()];
  }
}

class Secp256k1KeyIdentity extends SignIdentity {
  // `fromRaw` and `fromDer` should be used for instantiation, not this constructor.
  Secp256k1KeyIdentity(
    PublicKey publicKey,
    this._privateKey,
  ) : _publicKey = Secp256k1PublicKey.from(publicKey);

  factory Secp256k1KeyIdentity.fromParsedJson(JsonableSecp256k1Identity obj) {
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
      throw 'Deserialization error: JSON must have at least 2 items.';
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
    throw 'Deserialization error: '
        'Invalid JSON type for string: ${jsonEncode(json)}';
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
  JsonableSecp256k1Identity toJSON() {
    return [blobToHex(_publicKey.toRaw()), blobToHex(_privateKey)];
  }

  /// Return a copy of the key pair.
  Secp256k1KeyPair getKeyPair() {
    return Secp256k1KeyPair(publicKey: _publicKey, secretKey: _privateKey);
  }

  /// Return the public key.
  @override
  Secp256k1PublicKey getPublicKey() {
    return _publicKey;
  }

  Uint8List get accountId => getAccountId();

  Uint8List getAccountId([Uint8List? subAccount]) {
    return Principal.selfAuthenticating(
      getPublicKey().toDer(),
    ).toAccountId(subAccount: subAccount);
  }

  /// Signs a blob of data, with this identity's private key.
  /// @param blob - challenge to sign with this identity's secretKey, producing a signature

  // @override
  // Future<Uint8List> sign(Uint8List blob) async {
  //   final digest = SHA256Digest();
  //   final signer = ECDSASigner(digest, HMac(digest, 64));

  //   final key = ECPrivateKey(bytesToUnsignedInt(_privateKey), params);

  //   signer.init(true, p_api.PrivateKeyParameter(key));
  //   var sig = signer.generateSignature(blob) as ECSignature;
  //   if (sig.s.compareTo(_halfCurveOrder) > 0) {
  //     final canonicalisedS = params.n - sig.s;
  //     sig = ECSignature(sig.r, canonicalisedS);
  //   }
  //   if (sig.r == sig.s) {
  //     return await sign(blob);
  //   }
  //   var rU8a = sig.r.toU8a();
  //   var sU8a = sig.s.toU8a();
  //   if (rU8a.length < 32) {
  //     rU8a = Uint8List.fromList([0, ...rU8a]);
  //   }
  //   if (sU8a.length < 32) {
  //     sU8a = Uint8List.fromList([0, ...sU8a]);
  //   }

  //   return u8aConcat([rU8a, sU8a]);
  // }
  @override
  Future<Uint8List> sign(Uint8List blob) {
    return signAsync(blob, _privateKey);
  }
}

Uint8List sign(String message, BinaryBlob secretKey) {
  final blob = message.plainToU8a(useDartEncode: true);
  final digest = SHA256Digest();
  final signer = ECDSASigner(digest, HMac(digest, 64));
  final key = ECPrivateKey(bytesToUnsignedInt(secretKey), params);

  signer.init(true, p_api.PrivateKeyParameter(key));
  var sig = signer.generateSignature(blob) as ECSignature;
  if (sig.s.compareTo(_halfCurveOrder) > 0) {
    final canonicalizedS = params.n - sig.s;
    sig = ECSignature(sig.r, canonicalizedS);
  }
  if (sig.r == sig.s) {
    return sign(message, secretKey);
  }
  var rU8a = sig.r.toU8a();
  var sU8a = sig.s.toU8a();
  if (rU8a.length < 32) {
    rU8a = Uint8List.fromList([0, ...rU8a]);
  }
  if (sU8a.length < 32) {
    sU8a = Uint8List.fromList([0, ...sU8a]);
  }

  return u8aConcat([rU8a, sU8a]);
}

Future<Uint8List> signAsync(
  Uint8List blob,
  Uint8List seed,
) async {
  final result = await AgentDartFFI.instance.secp256K1Sign(
    req: Secp256k1SignWithSeedReq(seed: seed, msg: blob),
  );
  return result.signature!;
}

bool verify(String message, Uint8List signature, Secp256k1PublicKey publicKey) {
  final blob = message.plainToU8a(useDartEncode: true);
  final digest = SHA256Digest();
  final signer = ECDSASigner(digest, HMac(digest, 64));
  final sig = ECSignature(
    signature.sublist(0, 32).toBn(endian: Endian.big),
    signature.sublist(32).toBn(endian: Endian.big),
  );
  final kpub = params.curve.decodePoint(publicKey.toRaw())!;
  final pub = ECPublicKey(kpub, params);
  signer.init(false, p_api.PublicKeyParameter(pub));
  return signer.verifySignature(blob, sig);
}

bool verifyBlob(
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
  final kpub = params.curve.decodePoint(publicKey.toRaw())!;
  final pub = ECPublicKey(kpub, params);
  signer.init(false, p_api.PublicKeyParameter(pub));
  return signer.verifySignature(blob, sig);
}
