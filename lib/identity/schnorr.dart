import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/bridge/ffi/ffi.dart';
import 'package:agent_dart/identity/secp256k1.dart';

class SchnorrKeyPair extends KeyPair {
  const SchnorrKeyPair({required super.publicKey, required super.secretKey});

  List<String> toJson() {
    return [publicKey.toDer().toHex(), secretKey.toHex()];
  }
}

class SchnorrIdentity extends SignIdentity {
  SchnorrIdentity(
    PublicKey publicKey,
    this._privateKey,
  ) : _publicKey = Secp256k1PublicKey.from(publicKey);

  factory SchnorrIdentity.fromParsedJson(List<String> obj) {
    return SchnorrIdentity(
      Secp256k1PublicKey.fromRaw(blobFromHex(obj[0])),
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
          ? Secp256k1PublicKey.fromRaw(Uint8List.fromList(publicKey.data))
          : Secp256k1PublicKey.fromDer(Uint8List.fromList(dashPublicKey.data));

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
      Secp256k1PublicKey.fromRaw(publicKey),
      privateKey,
    );
  }

  final Secp256k1PublicKey _publicKey;
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
  Secp256k1PublicKey getPublicKey() => _publicKey;

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
  Secp256k1PublicKey publicKey,
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
