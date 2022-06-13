import 'dart:convert';
import 'dart:typed_data';
import 'package:agent_dart/agent_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:agent_dart/agent/auth.dart' as auth;

import '../bridge/ffi/ffi.dart';

typedef JsonnableEd25519KeyIdentity = List<String>;

class Ed25519KeyPair implements auth.KeyPair {
  @override
  BinaryBlob secretKey;
  @override
  auth.PublicKey publicKey;
  Ed25519KeyPair(this.publicKey, this.secretKey);

  toJson() {
    return [
      publicKey.toDer().toHex(include0x: false),
      secretKey.toHex(include0x: false)
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
  // ignore: non_constant_identifier_names
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
    return wrapDER(publicKey.buffer, ED25519_OID);
  }

  static BinaryBlob derDecode(BinaryBlob key) {
    final unwrapped = unwrapDER(key.buffer, ED25519_OID);
    if (unwrapped.length != RAW_KEY_LENGTH) {
      throw 'An Ed25519 public key must be exactly 32bytes long';
    }

    return unwrapped;
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
  static Future<Ed25519KeyIdentity> generate(Uint8List? seed) async {
    if (seed != null && seed.length != 32) {
      throw 'Ed25519 Seed needs to be 32 bytes long.';
    }

    Uint8List publicKey;
    Uint8List secretKey; // seed itself

    var kp = seed == null
        ? await AgentDartFFI.instance
            .ed25519FromSeed(req: ED25519FromSeedReq(seed: getRandomValues(32)))
        : await AgentDartFFI.instance
            .ed25519FromSeed(req: ED25519FromSeedReq(seed: seed));

    publicKey = kp.publicKey;
    secretKey = kp.seed;

    return Ed25519KeyIdentity(
      Ed25519PublicKey.fromRaw(publicKey),
      secretKey,
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
              Uint8List.fromList(List<int>.from(publicKey)))
          : Ed25519PublicKey.fromDer(
              Uint8List.fromList(List<int>.from(_publicKey!)));

      if (publicKey != null && secretKey != null) {
        return Ed25519KeyIdentity(
            pk, Uint8List.fromList(List<int>.from(secretKey)));
      } else if (_publicKey != null && _privateKey != null) {
        return Ed25519KeyIdentity(
            pk, Uint8List.fromList(List<int>.from(_privateKey)));
      }
    }
    throw 'Deserialization error: Invalid JSON type for string: ${jsonEncode(json)}';
  }

  static Ed25519KeyIdentity fromKeyPair(
      BinaryBlob publicKey, BinaryBlob privateKey) {
    return Ed25519KeyIdentity(Ed25519PublicKey.fromRaw(publicKey), privateKey);
  }

  static Future<Ed25519KeyIdentityRecoveredFromII> recoverFromIISeedPhrase(
      String phrase) async {
    try {
      var userNumber = extractUserNumber(phrase);
      var mne = dropLeadingUserNumber(phrase);
      var identity = await fromMnemonicWithoutValidation(
        mne,
        IC_DERIVATION_PATH,
      );
      return Ed25519KeyIdentityRecoveredFromII(
        userNumber: userNumber,
        identity: identity,
      );
    } catch (e) {
      rethrow;
    }
  }

  late final Ed25519PublicKey _publicKey;
  late final BinaryBlob _seed;

  // `fromRaw` and `fromDer` should be used for instantiation, not this constructor.
  Ed25519KeyIdentity(auth.PublicKey publicKey, this._seed) : super() {
    _publicKey = Ed25519PublicKey.from(publicKey);
  }

  /// Serialize this key to JSON.
  JsonnableEd25519KeyIdentity toJSON() {
    return [blobToHex(_publicKey.toDer()), blobToHex(_seed)];
  }

  /// Return a copy of the key pair.
  auth.KeyPair getKeyPair() {
    return Ed25519KeyPair(_publicKey, _seed);
  }

  /// Return the public key.
  @override
  Ed25519PublicKey getPublicKey() {
    return _publicKey;
  }

  /// Signs a blob of data, with this identity's private key.
  /// @param challenge - challenge to sign with this identity's secretKey, producing a signature
  @override
  Future<BinaryBlob> sign(dynamic challenge) async {
    final blob = challenge is BinaryBlob
        ? challenge
        : blobFromBuffer(challenge as ByteBuffer);
    return await AgentDartFFI.instance
        .ed25519Sign(req: ED25519SignReq(seed: _seed, message: blob));
  }

  Future<bool> verify(Uint8List signature, Uint8List message) async {
    return await AgentDartFFI.instance.ed25519Verify(
        req: ED25519VerifyReq(
            message: message, sig: signature, pubKey: _publicKey.toRaw()));
  }

  Uint8List get accountId => getAccountId();
  Uint8List getAccountId([Uint8List? subAccount]) {
    if (subAccount != null && subAccount.length != 32) {
      throw "Unacceptable sub account";
    }
    final der = getPublicKey().toDer();
    final hash = SHA224();
    hash.update(('\x0Aaccount-id').plainToU8a());
    hash.update(Principal.selfAuthenticating(der).toBlob());
    hash.update(subAccount ?? Uint8List(32));
    final data = hash.digest();
    final view = ByteData(4);
    view.setUint32(0, getCrc32(data.buffer));
    final checksum = view.buffer.asUint8List();
    final bytes = Uint8List.fromList(data);
    return Uint8List.fromList([...checksum, ...bytes]);
  }
}

class Ed25519KeyIdentityRecoveredFromII {
  final BigInt? userNumber;
  final Ed25519KeyIdentity identity;
  Ed25519KeyIdentityRecoveredFromII({required this.identity, this.userNumber});
}

///
/// The following part is ported from InternetIdentity service. It's main purpose is to `recover` an identity that registered.
/// These truths are covered.
/// - It generates masterseed using Bip39 and sha512
/// - Then use derivationPath matches to m/44'/223’/0’/0’/0'
/// - Then use Ed25519KeyIdentity.to generate a new identity.
/// - Internet Identity service then use the generated identity as a binding to originial identity.
/// - So the phrases that generated can be saved to a new location, then combined with a device number to recover

// ignore: constant_identifier_names
const HARDENED = 0x80000000;
// ignore: constant_identifier_names
const IC_BASE_PATH = [
  44,
  223,
  0,
];
// ignore: constant_identifier_names
const IC_DERIVATION_PATH = [44, 223, 0, 0, 0];

/// Create an Ed25519 based on a mnemonic phrase according to SLIP 0010:
/// https://github.com/satoshilabs/slips/blob/master/slip-0010.md
///
/// NOTE: This method derives an identity even if the mnemonic is invalid. It's
/// the responsibility of the caller to validate the mnemonic before calling this method.
///
/// @param mnemonic A BIP-39 mnemonic.
/// @param derivationPath an array that is always interpreted as a hardened path.
/// e.g. to generate m/44'/223’/0’/0’/0' the derivation path should be [44, 223, 0, 0, 0]
/// @param skipValidation if true, validation checks on the mnemonics are skipped.
Future<Ed25519KeyIdentity> fromMnemonicWithoutValidation(
    String mnemonic, List<int>? derivationPath,
    {int offset = HARDENED}) async {
  derivationPath ??= [];
  final seed = await AgentDartFFI.instance.mnemonicPhraseToSeed(
      req: PhraseToSeedReq(phrase: mnemonic, password: ''));
  return fromSeedWithSlip0010(seed, derivationPath, offset: offset);
}

/// Create an Ed25519 according to SLIP 0010:
/// https://github.com/satoshilabs/slips/blob/master/slip-0010.md
///
/// The derivation path is an array that is always interpreted as a hardened path.
/// e.g. to generate m/44'/223’/0’/0’/0' the derivation path should be [44, 223, 0, 0, 0]
Future<Ed25519KeyIdentity> fromSeedWithSlip0010(
    Uint8List masterSeed, List<int>? derivationPath,
    {int offset = HARDENED}) {
  var chainSet = generateMasterKey(masterSeed);
  var slipSeed = chainSet.first;
  var chainCode = chainSet.last;

  derivationPath ??= [];

  for (var i = 0; i < derivationPath.length; i++) {
    var newSet = derive(slipSeed, chainCode, derivationPath[i] | offset);
    slipSeed = newSet.first;
    chainCode = newSet.last;
  }
  return Ed25519KeyIdentity.generate(slipSeed);
}

Set<Uint8List> generateMasterKey(Uint8List seed) {
  var hmacSha512 = Hmac(
      sha512, 'ed25519 seed'.plainToU8a(useDartEncode: true)); // HMAC-SHA512
  var h = hmacSha512.convert(seed);
  final slipSeed = Uint8List.fromList(h.bytes.sublist(0, 32));
  final chainCode = Uint8List.fromList(h.bytes.sublist(32));
  return {slipSeed, chainCode};
}

Set<Uint8List> derive(Uint8List parentKey, Uint8List parentChaincode, int i) {
  // From the spec: Data = 0x00 || ser256(kpar) || ser32(i)
  final data = Uint8List.fromList([0, ...parentKey, ...toBigEndianArray(i)]);

  final hmacSha512 = Hmac(sha512, parentChaincode);

  final h = hmacSha512.convert(data);

  final slipSeed = Uint8List.fromList(h.bytes.sublist(0, 32));
  final chainCode = Uint8List.fromList(h.bytes.sublist(32));

  return {slipSeed, chainCode};
}

// Converts a 32-bit unsigned integer to a big endian byte array.
Uint8List toBigEndianArray(int n) {
  final byteArray = Uint8List.fromList([0, 0, 0, 0]);
  for (var i = byteArray.length - 1; i >= 0; i--) {
    final byte = n & 0xff;
    byteArray[i] = byte;
    n = ((n - byte) ~/ 256).toInt();
  }
  return byteArray;
}

String dropLeadingUserNumber(String s) {
  final i = s.indexOf(" ");
  if (i != -1 && parseUserNumber(s.substring(0, i)) != null) {
    return s.substring(i + 1);
  } else {
    return s;
  }
}

// BigInt parses various things we do not want to allow, like:
// - BigInt(whitespace) == 0
// - Hex/Octal formatted numbers
// - Scientific notation
// So we check that the user has entered a sequence of digits only,
// before attempting to parse
BigInt? parseUserNumber(String s) {
  try {
    return BigInt.tryParse(s, radix: 10);
  } catch (e) {
    return null;
  }
}

BigInt? extractUserNumber(String s) {
  final i = s.indexOf(" ");
  if (i != -1 && parseUserNumber(s.substring(0, i)) != null) {
    return parseUserNumber(s.substring(0, i));
  } else {
    return null;
  }
}
