import 'dart:convert';
import 'dart:typed_data';
import 'package:pinenacl/ed25519.dart';
import 'package:agent_dart/agent/auth.dart' as auth;
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:agent_dart/utils/extension.dart';

typedef JsonnableEd25519KeyIdentity = List<String>;

class Ed25519KeyPair implements auth.KeyPair {
  @override
  BinaryBlob secretKey;
  @override
  auth.PublicKey publicKey;
  Ed25519KeyPair(this.publicKey, this.secretKey);

  toJson() {
    return [
      publicKey.toDer().buffer.toHex(include0x: false),
      secretKey.buffer.toHex(include0x: false)
    ];
  }
}

class Ed25519PublicKey implements auth.PublicKey {
  static Ed25519PublicKey from(auth.PublicKey key) {
    return Ed25519PublicKey.fromDer(key.toDer());
  }

  static Ed25519PublicKey fromRaw(BinaryBlob rawKey) {
    return Ed25519PublicKey(rawKey);
  }

  static Ed25519PublicKey fromDer(BinaryBlob derKey) {
    return Ed25519PublicKey(Ed25519PublicKey.derDecode(derKey));
  }

  // The length of Ed25519 public keys is always 32 bytes.
  static int RAW_KEY_LENGTH = 32;

  // Adding this prefix to a raw public key is sufficient to DER-encode it.
  // See https://github.com/dfinity/agent-js/issues/42#issuecomment-716356288
  // ignore: non_constant_identifier_names
  static Uint8List DER_PREFIX = Uint8List.fromList([
    ...[48, 42], // SEQUENCE
    ...[48, 5], // SEQUENCE
    ...[6, 3], // OBJECT
    ...[43, 101, 112], // Ed25519 OID
    ...[3], // OBJECT
    ...[Ed25519PublicKey.RAW_KEY_LENGTH + 1], // BIT STRING
    ...[0], // 'no padding'
  ]);

  static DerEncodedBlob derEncode(BinaryBlob publicKey) {
    if (publicKey.byteLength != Ed25519PublicKey.RAW_KEY_LENGTH) {
      final bl = publicKey.byteLength;
      throw "ed25519 public key must be ${Ed25519PublicKey.RAW_KEY_LENGTH} bytes long (is ${bl})";
    }

    // https://github.com/dfinity/agent-js/issues/42#issuecomment-716356288
    final derPublicKey = Uint8List.fromList([
      ...Ed25519PublicKey.DER_PREFIX,
      ...publicKey.buffer,
    ]);

    return derBlobFromBlob(blobFromUint8Array(derPublicKey));
  }

  static BinaryBlob derDecode(BinaryBlob key) {
    final expectedLength = Ed25519PublicKey.DER_PREFIX.length + Ed25519PublicKey.RAW_KEY_LENGTH;
    if (key.byteLength != expectedLength) {
      final bl = key.byteLength;
      throw "Ed25519 DER-encoded public key must be $expectedLength bytes long (is $bl)";
    }

    final rawKey = blobFromUint8Array(key.buffer.sublist(Ed25519PublicKey.DER_PREFIX.length));
    if (!u8aEq((Ed25519PublicKey.derEncode(rawKey)).buffer, key.buffer)) {
      throw 'Ed25519 DER-encoded public key is invalid. A valid Ed25519 DER-encoded public key ' +
          "must have the following prefix: ${Ed25519PublicKey.DER_PREFIX}";
    }

    return rawKey;
  }

  late BinaryBlob rawKey;
  late DerEncodedBlob derKey;

  // `fromRaw` and `fromDer` should be used for instantiation, not this constructor.
  Ed25519PublicKey(this.rawKey) {
    derKey = Ed25519PublicKey.derEncode(rawKey);
  }

  @override
  DerEncodedBlob toDer() {
    return derKey;
  }

  BinaryBlob toRaw() {
    return rawKey;
  }
}

class Ed25519KeyIdentity extends auth.SignIdentity {
  static Ed25519KeyIdentity generate(Uint8List? seed) {
    if (seed != null && seed.length != 32) {
      throw 'Ed25519 Seed needs to be 32 bytes long.';
    }

    Uint8List publicKey;
    Uint8List secretKey;

    var kp = seed == null ? SigningKey.generate() : SigningKey.fromSeed(seed);

    publicKey = kp.publicKey.buffer.asUint8List();
    secretKey = kp.asTypedList;

    return Ed25519KeyIdentity(
      Ed25519PublicKey.fromRaw(blobFromUint8Array(publicKey)),
      blobFromUint8Array(secretKey),
    );
  }

  static Ed25519KeyIdentity fromParsedJson(JsonnableEd25519KeyIdentity obj) {
    return Ed25519KeyIdentity(
      Ed25519PublicKey.fromDer(blobFromHex(obj[0])),
      blobFromHex(obj[1]),
    );
  }

  static Ed25519KeyIdentity fromJSON(String json) {
    final parsed = jsonDecode(json);

    if ((parsed is List)) {
      if (parsed[0] is String && parsed[1] is String) {
        return Ed25519KeyIdentity.fromParsedJson([parsed[0], parsed[1]]);
      } else {
        throw 'Deserialization error: JSON must have at least 2 items.';
      }
    } else if (parsed is Map) {
      final reParsed = Map<String, List>.from(jsonDecode(json));
      var publicKey = reParsed["publicKey"];
      var _publicKey = reParsed["_publicKey"];
      var secretKey = reParsed["secretKey"];
      var _privateKey = reParsed["_privateKey"];

      final pk = publicKey != null
          ? Ed25519PublicKey.fromRaw(
              blobFromUint8Array(Uint8List.fromList(List<int>.from(publicKey))))
          : Ed25519PublicKey.fromDer(
              blobFromUint8Array(Uint8List.fromList(List<int>.from(_publicKey!))));

      if (publicKey != null && secretKey != null) {
        return Ed25519KeyIdentity(
            pk, blobFromUint8Array(Uint8List.fromList(List<int>.from(secretKey))));
      } else if (_publicKey != null && _privateKey != null) {
        return Ed25519KeyIdentity(
            pk, blobFromUint8Array(Uint8List.fromList(List<int>.from(_privateKey))));
      }
    }
    throw 'Deserialization error: Invalid JSON type for string: ${jsonEncode(json)}';
  }

  static Ed25519KeyIdentity fromKeyPair(BinaryBlob publicKey, BinaryBlob privateKey) {
    return Ed25519KeyIdentity(Ed25519PublicKey.fromRaw(publicKey), privateKey);
  }

  static Ed25519KeyIdentity fromSecretKey(Uint8List secretKey) {
    final keyPair = SigningKey.fromValidBytes(secretKey);
    final identity = Ed25519KeyIdentity.fromKeyPair(
      blobFromUint8Array(keyPair.publicKey.asTypedList),
      blobFromUint8Array(keyPair.verifyKey.asTypedList),
    );
    return identity;
  }

  late final Ed25519PublicKey _publicKey;
  late final BinaryBlob _privateKey;
  late final SigningKey _sk;

  // `fromRaw` and `fromDer` should be used for instantiation, not this constructor.
  Ed25519KeyIdentity(auth.PublicKey publicKey, this._privateKey) : super() {
    _publicKey = Ed25519PublicKey.from(publicKey);
    _sk = SigningKey.fromValidBytes(_privateKey.buffer);
  }

  /// Serialize this key to JSON.
  JsonnableEd25519KeyIdentity toJSON() {
    return [blobToHex(_publicKey.toDer()), blobToHex(_privateKey)];
  }

  /// Return a copy of the key pair.
  auth.KeyPair getKeyPair() {
    return Ed25519KeyPair(_publicKey, blobFromUint8Array(_privateKey.buffer));
  }

  /// Return the public key.
  @override
  auth.PublicKey getPublicKey() {
    return _publicKey;
  }

  /// Signs a blob of data, with this identity's private key.
  /// @param challenge - challenge to sign with this identity's secretKey, producing a signature
  Future<BinaryBlob> sign(dynamic challenge) {
    final blob = challenge is BinaryBlob
        ? blobFromBuffer(challenge.buffer.buffer)
        : blobFromUint8Array(challenge as Uint8List);
    return Future.value(blobFromUint8Array(_sk.sign(blob.buffer).asTypedList));
  }
}
