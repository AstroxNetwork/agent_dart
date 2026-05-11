import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart_ffi/agent_dart_ffi.dart';

import '../agent/auth.dart';
import '../agent/types.dart';
import '../utils/extension.dart';
import '../wallet/keysmith.dart';
import 'der.dart';

/// A P-256 key pair containing public and private key material.
class P256KeyPair extends KeyPair {
  /// Creates a P-256 key pair.
  const P256KeyPair({required super.publicKey, required super.secretKey});

  /// Serializes the key pair as `[publicKeyDerHex, secretKeyHex]`.
  List<String> toJson() {
    return [publicKey.toDer().toHex(), secretKey.toHex()];
  }
}

/// Callback used to sign P-256 message bytes.
typedef SigningFunc = Future<Uint8List> Function(
  Uint8List blob,
  Uint8List seed,
);

/// Callback used to verify a P-256 signature.
typedef VerifyFunc = Future<bool> Function(
  Uint8List blob,
  Uint8List signature,
  P256PublicKey publicKey,
);

/// A P-256 public key that can be encoded for IC request signing.
class P256PublicKey implements PublicKey {
  /// Creates a public key from raw P-256 key bytes.
  P256PublicKey(this.rawKey) : assert(rawKey.isNotEmpty);

  /// Creates a public key from raw P-256 key bytes.
  factory P256PublicKey.fromRaw(BinaryBlob rawKey) {
    return P256PublicKey(rawKey);
  }

  /// Creates a public key from DER-encoded P-256 key bytes.
  factory P256PublicKey.fromDer(BinaryBlob derKey) {
    return P256PublicKey(P256PublicKey.derDecode(derKey));
  }

  /// Creates a P-256 public key from another [PublicKey].
  factory P256PublicKey.from(PublicKey key) {
    return P256PublicKey.fromDer(key.toDer());
  }

  /// Raw P-256 public key bytes.
  final BinaryBlob rawKey;

  /// DER-encoded form of [rawKey].
  late final derKey = P256PublicKey.derEncode(rawKey);

  /// DER-encodes a raw P-256 [publicKey].
  static Uint8List derEncode(BinaryBlob publicKey) {
    return bytesWrapDer(publicKey, oidP256);
  }

  /// Decodes a DER-encoded P-256 [publicKey].
  static Uint8List derDecode(BinaryBlob publicKey) {
    return bytesUnwrapDer(publicKey, oidP256);
  }

  /// Returns the DER encoding of this public key.
  @override
  Uint8List toDer() => derKey;

  /// Returns the raw P-256 public key bytes.
  Uint8List toRaw() => rawKey;
}

/// A signing identity backed by a P-256 private key.
class P256Identity extends SignIdentity {
  /// Creates a P-256 identity from a public key and private key bytes.
  P256Identity(
    PublicKey publicKey,
    this._privateKey,
  ) : _publicKey = P256PublicKey.from(publicKey);

  /// Restores an identity from a parsed `[publicKeyHex, privateKeyHex]` list.
  factory P256Identity.fromParsedJson(List<String> obj) {
    return P256Identity(
      P256PublicKey.fromRaw(blobFromHex(obj[0])),
      blobFromHex(obj[1]),
    );
  }

  /// Restores a P-256 identity from JSON.
  factory P256Identity.fromJSON(String json) {
    final parsed = jsonDecode(json);
    if (parsed is List) {
      if (parsed[0] is String && parsed[1] is String) {
        return P256Identity.fromParsedJson([parsed[0], parsed[1]]);
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
          ? P256PublicKey.fromRaw(Uint8List.fromList(publicKey.data))
          : P256PublicKey.fromDer(Uint8List.fromList(dashPublicKey.data));

      if (publicKey && secretKey && secretKey.data) {
        return P256Identity(pk, Uint8List.fromList(secretKey.data));
      }
      if (dashPublicKey && dashPrivateKey && dashPrivateKey.data) {
        return P256Identity(
          pk,
          Uint8List.fromList(dashPrivateKey.data),
        );
      }
    }
    throw ArgumentError.value(jsonEncode(json), 'json', 'Invalid json');
  }

  /// Creates an identity from raw public and private key bytes.
  factory P256Identity.fromKeyPair(
    BinaryBlob publicKey,
    BinaryBlob privateKey,
  ) {
    return P256Identity(
      P256PublicKey.fromRaw(publicKey),
      privateKey,
    );
  }

  final P256PublicKey _publicKey;
  final BinaryBlob _privateKey;
  SigningFunc? _signingFunc;
  VerifyFunc? _verifyFunc;

  /// Derives a P-256 identity from a raw [secretKey].
  static Future<P256Identity> fromSecretKey(Uint8List secretKey) async {
    final kp = await getECkeyFromPrivateKey(secretKey);
    final identity = P256Identity.fromKeyPair(
      kp.ecP256PublicKey!,
      kp.ecPrivateKey!,
    );
    return identity;
  }

  /// Overrides the default signing implementation.
  void setSigningFunc(SigningFunc func) {
    _signingFunc = func;
  }

  /// Overrides the default verification implementation.
  void setVerifyFunc(VerifyFunc func) {
    _verifyFunc = func;
  }

  /// Serialize this key to JSON.
  List<String> toJson() {
    return [blobToHex(_publicKey.toRaw()), blobToHex(_privateKey)];
  }

  /// Return a copy of the key pair.
  P256KeyPair getKeyPair() {
    return P256KeyPair(publicKey: _publicKey, secretKey: _privateKey);
  }

  /// Return the public key.
  @override
  P256PublicKey getPublicKey() => _publicKey;

  /// Signs a blob of data, with this identity's private key.
  /// [blob] is challenge to sign with this identity's secretKey,
  /// producing a signature.
  @override
  Future<Uint8List> sign(Uint8List blob) {
    if (_signingFunc != null) {
      return _signingFunc!(blob, _privateKey);
    }
    return signP256Async(blob, _privateKey);
  }

  /// Verifies [signature] against [message].
  Future<bool> verify(Uint8List signature, Uint8List message) {
    if (_verifyFunc != null) {
      return _verifyFunc!(
        message,
        signature,
        _publicKey,
      );
    }
    return verifyP256Async(
      message,
      signature,
      _publicKey,
    );
  }
}

/// Signs [blob] with a P-256 private [seed].
Future<Uint8List> signP256Async(
  Uint8List blob,
  Uint8List seed,
) async {
  final result = await p256Sign(
    req: P256SignWithSeedReq(seed: seed, msg: blob),
  );
  return result.signature!;
}

/// Verifies a P-256 [signature] for [blob] and [publicKey].
Future<bool> verifyP256Async(
  Uint8List blob,
  Uint8List signature,
  P256PublicKey publicKey,
) async {
  final result = await p256Verify(
    req: P256VerifyReq(
      messageHash: blob,
      signatureBytes: signature,
      publicKeyBytes: publicKey.toDer(),
    ),
  );
  return result;
}
