import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:pointycastle/api.dart' as p_api;
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/ecc/ecc_fp.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
// ignore: implementation_imports
import 'package:pointycastle/src/utils.dart' as p_utils;

typedef JsonableSecp256k1Identity = List<String>;

BigInt bytesToUnsignedInt(Uint8List bytes) {
  return p_utils.decodeBigIntWithSign(1, bytes);
}

// final BigInt _halfCurveOrder = params.n >> 1;

class Secp256k1KeyPair implements KeyPair {
  @override
  BinaryBlob secretKey;
  @override
  PublicKey publicKey;
  Secp256k1KeyPair(this.publicKey, this.secretKey);

  toJson() {
    return [publicKey.toDer().toHex(include0x: false), secretKey.toHex(include0x: false)];
  }
}

class Secp256k1KeyIdentity extends SignIdentity {
  static Secp256k1KeyIdentity fromParsedJson(JsonableSecp256k1Identity obj) {
    return Secp256k1KeyIdentity(
        Secp256k1PublicKey.fromRaw(blobFromHex(obj[0])), blobFromHex(obj[1]));
  }

  static Secp256k1KeyIdentity fromJSON(String json) {
    final parsed = jsonDecode(json);
    if (parsed is List) {
      if (parsed[0] is String && parsed[1] is String) {
        return fromParsedJson([parsed[0], parsed[1]]);
      }
      throw 'Deserialization error: JSON must have at least 2 items.';
    } else if (parsed is Map) {
      var publicKey = parsed["publicKey"];
      var _publicKey = parsed["_publicKey"];
      var secretKey = parsed["secretKey"];
      var _privateKey = parsed["_privateKey"];
      final pk = publicKey != null
          ? Secp256k1PublicKey.fromRaw(blobFromUint8Array(Uint8List.fromList(publicKey.data)))
          : Secp256k1PublicKey.fromDer(blobFromUint8Array(Uint8List.fromList(_publicKey.data)));

      if (publicKey && secretKey && secretKey.data) {
        return Secp256k1KeyIdentity(pk, blobFromUint8Array(Uint8List.fromList(secretKey.data)));
      }
      if (_publicKey && _privateKey && _privateKey.data) {
        return Secp256k1KeyIdentity(pk, blobFromUint8Array(Uint8List.fromList(_privateKey.data)));
      }
    }
    throw "Deserialization error: Invalid JSON type for string: ${jsonEncode(json)}";
  }

  static Secp256k1KeyIdentity fromKeyPair(BinaryBlob publicKey, BinaryBlob privateKey) {
    return Secp256k1KeyIdentity(Secp256k1PublicKey.fromRaw(publicKey), privateKey);
  }

  static Secp256k1KeyIdentity fromSecretKey(Uint8List secretKey) {
    try {
      final publicKey = getPublicFromPrivateKey(Uint8List.fromList(secretKey), false);
      final identity = Secp256k1KeyIdentity.fromKeyPair(
          blobFromUint8Array(publicKey!), blobFromUint8Array(Uint8List.fromList(secretKey)));
      return identity;
    } catch (e) {
      rethrow;
    }
  }

  late final Secp256k1PublicKey _publicKey;
  late final BinaryBlob _privateKey;

  // `fromRaw` and `fromDer` should be used for instantiation, not this constructor.
  Secp256k1KeyIdentity(PublicKey publicKey, this._privateKey) : super() {
    _publicKey = Secp256k1PublicKey.from(publicKey);
  }

  /// Serialize this key to JSON.
  JsonableSecp256k1Identity toJSON() {
    return [blobToHex(_publicKey.toRaw()), blobToHex(_privateKey)];
  }

  /// Return a copy of the key pair.
  Secp256k1KeyPair getKeyPair() {
    return Secp256k1KeyPair(_publicKey, blobFromUint8Array(Uint8List.fromList(_privateKey)));
  }

  /// Return the public key.
  @override
  Secp256k1PublicKey getPublicKey() {
    return _publicKey;
  }

  Uint8List get accountId => getAccountId();
  Uint8List getAccountId() {
    final der = getPublicKey().toDer();
    final hash = SHA224();
    hash.update(('\x0Aaccount-id').plainToU8a());
    hash.update(Principal.selfAuthenticating(der).toBlob());
    hash.update(Uint8List(32));
    final data = hash.digest();
    // without checksum?
    return Uint8List.fromList(data);
  }

  /// Signs a blob of data, with this identity's private key.
  /// @param blob - challenge to sign with this identity's secretKey, producing a signature

  @override
  Future<Uint8List> sign(Uint8List blob) async {
    final digest = SHA256Digest();
    final signer = ECDSASigner(digest, HMac(digest, 64));

    final key = ECPrivateKey(bytesToUnsignedInt(_privateKey), params);

    signer.init(true, p_api.PrivateKeyParameter(key));
    var sig = signer.generateSignature(blob) as ECSignature;
    var signature = u8aConcat([sig.r.toU8a(), sig.s.toU8a()]);
    if (signature.length == 63) {
      signature = u8aConcat([
        Uint8List.fromList([0, 0]),
        signature
      ]);
    }
    return signature;
  }
}

Uint8List sign(String message, BinaryBlob secretKey) {
  final blob = message.plainToU8a(useDartEncode: true);
  final digest = SHA256Digest();
  final signer = ECDSASigner(digest, HMac(digest, 64));
  final key = ECPrivateKey(bytesToUnsignedInt(secretKey), params);

  signer.init(true, p_api.PrivateKeyParameter(key));
  var sig = signer.generateSignature(blob) as ECSignature;
  var signature = u8aConcat([sig.r.toU8a(), sig.s.toU8a()]);
  if (signature.length == 63) {
    signature = u8aConcat([
      Uint8List.fromList([0, 0]),
      signature
    ]);
  }
  return signature;
}

bool verify(String message, Uint8List signature, Secp256k1PublicKey publicKey) {
  final blob = message.plainToU8a(useDartEncode: true);
  final digest = SHA256Digest();
  final signer = ECDSASigner(digest, HMac(digest, 64));

  var sig = ECSignature(signature.sublist(0, 32).toBn(endian: Endian.big),
      signature.sublist(32).toBn(endian: Endian.big));

  var kpub = params.curve.decodePoint(publicKey.toRaw())!;

  var pub = ECPublicKey(kpub, params);

  signer.init(false, p_api.PublicKeyParameter(pub));

  return signer.verifySignature(blob, sig);
}

bool verifyBlob(Uint8List blob, Uint8List signature, Secp256k1PublicKey publicKey) {
  final digest = SHA256Digest();
  final signer = ECDSASigner(digest, HMac(digest, 64));

  var sig = ECSignature(signature.sublist(0, 32).toBn(endian: Endian.big),
      signature.sublist(32).toBn(endian: Endian.big));

  var kpub = params.curve.decodePoint(publicKey.toRaw())!;

  var pub = ECPublicKey(kpub, params);

  signer.init(false, p_api.PublicKeyParameter(pub));

  return signer.verifySignature(blob, sig);
}
