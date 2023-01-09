import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/bridge/ffi/ffi.dart';

class SchnorrKeyPair extends KeyPair {
  const SchnorrKeyPair({required super.publicKey, required super.secretKey});

  List<String> toJson() {
    return [publicKey.toDer().toHex(), secretKey.toHex()];
  }
}

class SchnorrPublicKey implements PublicKey {
  SchnorrPublicKey(this.rawKey);

  factory SchnorrPublicKey.fromRaw(BinaryBlob rawKey) {
    return SchnorrPublicKey(rawKey);
  }

  factory SchnorrPublicKey.fromDer(BinaryBlob derKey) {
    return SchnorrPublicKey(SchnorrPublicKey.derDecode(derKey));
  }

  factory SchnorrPublicKey.from(PublicKey key) {
    return SchnorrPublicKey.fromDer(key.toDer());
  }

  final BinaryBlob rawKey;
  late final derKey = SchnorrPublicKey.derEncode(rawKey);

  static Uint8List derEncode(BinaryBlob publicKey) {
    // BIP340 Schnorr scheme doesn't apply to ASN.1 standard, although other
    // form of oid existed, we just borrow secp256k1 as ref.
    // Since this protocol can not use on IC directly. We just want the function
    // works.
    return wrapDER(publicKey.buffer, oidSecp256k1);
  }

  static Uint8List derDecode(BinaryBlob publicKey) {
    return unwrapDER(publicKey.buffer, oidSecp256k1);
  }

  @override
  Uint8List toDer() => derKey;

  Uint8List toRaw() => rawKey;
}

class SchnorrIdentity extends SignIdentity {
  SchnorrIdentity(
    PublicKey publicKey,
    this._privateKey,
  ) : _publicKey = SchnorrPublicKey.from(publicKey);

  factory SchnorrIdentity.fromParsedJson(List<String> obj) {
    return SchnorrIdentity(
      SchnorrPublicKey.fromRaw(blobFromHex(obj[0])),
      blobFromHex(obj[1]),
    );
  }

  factory SchnorrIdentity.fromJSON(String json) {
    final parsed = jsonDecode(json);
    if (parsed is List) {
      if (parsed[0] is String && parsed[1] is String) {
        return SchnorrIdentity.fromParsedJson([parsed[0], parsed[1]]);
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
          ? SchnorrPublicKey.fromRaw(Uint8List.fromList(publicKey.data))
          : SchnorrPublicKey.fromDer(Uint8List.fromList(dashPublicKey.data));

      if (publicKey && secretKey && secretKey.data) {
        return SchnorrIdentity(pk, Uint8List.fromList(secretKey.data));
      }
      if (dashPublicKey && dashPrivateKey && dashPrivateKey.data) {
        return SchnorrIdentity(
          pk,
          Uint8List.fromList(dashPrivateKey.data),
        );
      }
    }
    throw ArgumentError.value(jsonEncode(json), 'json', 'Invalid json');
  }

  factory SchnorrIdentity.fromKeyPair(
    BinaryBlob publicKey,
    BinaryBlob privateKey,
  ) {
    return SchnorrIdentity(
      SchnorrPublicKey.fromRaw(publicKey),
      privateKey,
    );
  }

  final SchnorrPublicKey _publicKey;
  final BinaryBlob _privateKey;

  static Future<SchnorrIdentity> fromSecretKey(Uint8List secretKey) async {
    final kp = await getECkeyFromPrivateKey(secretKey);
    final identity = SchnorrIdentity.fromKeyPair(
      kp.ecSchnorrPublicKey!,
      kp.ecPrivateKey!,
    );
    return identity;
  }

  /// Serialize this key to JSON.
  List<String> toJson() {
    return [blobToHex(_publicKey.toRaw()), blobToHex(_privateKey)];
  }

  /// Return a copy of the key pair.
  SchnorrKeyPair getKeyPair() {
    return SchnorrKeyPair(publicKey: _publicKey, secretKey: _privateKey);
  }

  /// Return the public key.
  @override
  SchnorrPublicKey getPublicKey() => _publicKey;

  /// Signs a blob of data, with this identity's private key.
  /// [blob] is challenge to sign with this identity's secretKey,
  /// producing a signature.
  @override
  Future<Uint8List> sign(Uint8List blob) {
    return signSchnorrAsync(blob, _privateKey);
  }

  Future<bool> verify(Uint8List signature, Uint8List message) {
    return verifySchnorrAsync(
      message,
      signature,
      _publicKey,
    );
  }
}

Future<Uint8List> signSchnorrAsync(
  Uint8List blob,
  Uint8List seed, {
  Uint8List? auxRand,
}) async {
  final result = await AgentDartFFI.impl.schnorrSign(
    req: SchnorrSignWithSeedReq(seed: seed, msg: blob, auxRand: auxRand),
  );
  return result.signature!;
}

Future<bool> verifySchnorrAsync(
  Uint8List blob,
  Uint8List signature,
  SchnorrPublicKey publicKey,
) async {
  final result = await AgentDartFFI.impl.schnorrVerify(
    req: SchnorrVerifyReq(
      messageHash: blob,
      signatureBytes: signature,
      publicKeyBytes: publicKey.toRaw(),
    ),
  );
  return result;
}
