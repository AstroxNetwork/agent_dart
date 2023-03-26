import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/src/ffi/io.dart';
import 'package:agent_dart_ffi/agent_dart_ffi.dart';

class P256KeyPair extends KeyPair {
  const P256KeyPair({required super.publicKey, required super.secretKey});

  List<String> toJson() {
    return [publicKey.toDer().toHex(), secretKey.toHex()];
  }
}

typedef SigningFunc = Future<Uint8List> Function(
  Uint8List blob,
  Uint8List seed,
);

typedef VerifyFunc = Future<bool> Function(
  Uint8List blob,
  Uint8List signature,
  P256PublicKey publicKey,
);

class P256PublicKey implements PublicKey {
  P256PublicKey(this.rawKey) : assert(rawKey.isNotEmpty);

  factory P256PublicKey.fromRaw(BinaryBlob rawKey) {
    return P256PublicKey(rawKey);
  }

  factory P256PublicKey.fromDer(BinaryBlob derKey) {
    return P256PublicKey(P256PublicKey.derDecode(derKey));
  }

  factory P256PublicKey.from(PublicKey key) {
    return P256PublicKey.fromDer(key.toDer());
  }

  final BinaryBlob rawKey;
  late final derKey = P256PublicKey.derEncode(rawKey);

  static Uint8List derEncode(BinaryBlob publicKey) {
    return bytesWrapDer(publicKey, oidP256);
  }

  static Uint8List derDecode(BinaryBlob publicKey) {
    return bytesUnwrapDer(publicKey, oidP256);
  }

  @override
  Uint8List toDer() => derKey;

  Uint8List toRaw() => rawKey;
}

class P256Identity extends SignIdentity {
  P256Identity(
    PublicKey publicKey,
    this._privateKey,
  ) : _publicKey = P256PublicKey.from(publicKey);

  factory P256Identity.fromParsedJson(List<String> obj) {
    return P256Identity(
      P256PublicKey.fromRaw(blobFromHex(obj[0])),
      blobFromHex(obj[1]),
    );
  }

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

  static Future<P256Identity> fromSecretKey(Uint8List secretKey) async {
    final kp = await getECkeyFromPrivateKey(secretKey);
    final identity = P256Identity.fromKeyPair(
      kp.ecP256PublicKey!,
      kp.ecPrivateKey!,
    );
    return identity;
  }

  void setSigningFunc(SigningFunc func) {
    _signingFunc = func;
  }

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

Future<Uint8List> signP256Async(
  Uint8List blob,
  Uint8List seed,
) async {
  final result = await AgentDartFFI.impl.p256Sign(
    req: P256SignWithSeedReq(seed: seed, msg: blob),
  );
  return result.signature!;
}

Future<bool> verifyP256Async(
  Uint8List blob,
  Uint8List signature,
  P256PublicKey publicKey,
) async {
  final result = await AgentDartFFI.impl.p256Verify(
    req: P256VerifyReq(
      messageHash: blob,
      signatureBytes: signature,
      publicKeyBytes: publicKey.toDer(),
    ),
  );
  return result;
}
