import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/auth.dart' as auth;
import 'package:agent_dart/agent_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import '../bridge/ffi/ffi.dart';

@immutable
class Ed25519KeyPair extends auth.KeyPair {
  const Ed25519KeyPair({required super.publicKey, required super.secretKey});

  List<String> toJson() {
    return [publicKey.toDer().toHex(), secretKey.toHex()];
  }
}

class Ed25519PublicKey implements auth.PublicKey {
  /// [Ed25519PublicKey.fromRaw] and [Ed25519PublicKey.fromDer] should not be
  /// used for instantiation in this constructor.
  Ed25519PublicKey(this.rawKey);

  factory Ed25519PublicKey.from(auth.PublicKey key) {
    return Ed25519PublicKey.fromDer(key.toDer());
  }

  factory Ed25519PublicKey.fromRaw(BinaryBlob rawKey) {
    return Ed25519PublicKey(rawKey);
  }

  factory Ed25519PublicKey.fromDer(BinaryBlob derKey) {
    return Ed25519PublicKey(Ed25519PublicKey.derDecode(derKey));
  }

  final BinaryBlob rawKey;
  late final DerEncodedBlob derKey = Ed25519PublicKey.derEncode(rawKey);

  /// The length of Ed25519 public keys is always 32 bytes.
  static int rawKeyLength = 32;

  /// Adding this prefix to a raw public key is sufficient to DER-encode it.
  /// See https://github.com/dfinity/agent-js/issues/42#issuecomment-716356288
  static final Uint8List derPrefix = Uint8List.fromList([
    ...[48, 42], // SEQUENCE
    ...[48, 5], // SEQUENCE
    ...[6, 3], // OBJECT
    ...[43, 101, 112], // Ed25519 OID
    ...[3], // OBJECT
    ...[Ed25519PublicKey.rawKeyLength + 1], // BIT STRING
    ...[0], // 'no padding'
  ]);

  static DerEncodedBlob derEncode(BinaryBlob publicKey) {
    return wrapDER(publicKey.buffer, oidEd25519);
  }

  static BinaryBlob derDecode(BinaryBlob key) {
    final unwrapped = unwrapDER(key.buffer, oidEd25519);
    if (unwrapped.length != rawKeyLength) {
      throw RangeError.value(
        unwrapped.length,
        'Expected $rawKeyLength-bytes long '
        'but got ${unwrapped.length}',
      );
    }
    return unwrapped;
  }

  @override
  DerEncodedBlob toDer() => derKey;

  BinaryBlob toRaw() => rawKey;
}

class Ed25519KeyIdentity extends auth.SignIdentity {
  /// [Ed25519PublicKey.fromRaw] and [Ed25519PublicKey.fromDer] should not be
  /// used for instantiation in this constructor.
  Ed25519KeyIdentity(
    auth.PublicKey publicKey,
    this._seed,
  ) : _publicKey = Ed25519PublicKey.from(publicKey);

  factory Ed25519KeyIdentity.fromKeyPair(
    BinaryBlob publicKey,
    BinaryBlob privateKey,
  ) {
    return Ed25519KeyIdentity(Ed25519PublicKey.fromRaw(publicKey), privateKey);
  }

  factory Ed25519KeyIdentity.fromJSON(String json) {
    final parsed = jsonDecode(json);
    if (parsed is List) {
      if (parsed[0] is String && parsed[1] is String) {
        return Ed25519KeyIdentity.fromParsedJson([parsed[0], parsed[1]]);
      }
      throw ArgumentError.value(
        json,
        'json',
        'JSON must have at least 2 elements',
      );
    }
    if (parsed is Map) {
      final reParsed = jsonDecode(json);
      final publicKey = reParsed['publicKey']?.cast<int>();
      final dashPublicKey = reParsed['_publicKey']?.cast<int>();
      final secretKey = reParsed['secretKey']?.cast<int>();
      final dashPrivateKey = reParsed['_privateKey']?.cast<int>();

      final pk = publicKey != null
          ? Ed25519PublicKey.fromRaw(Uint8List.fromList(publicKey))
          : Ed25519PublicKey.fromDer(Uint8List.fromList(dashPublicKey!));

      if (publicKey != null && secretKey != null) {
        return Ed25519KeyIdentity(
          pk,
          Uint8List.fromList(secretKey),
        );
      }
      if (dashPublicKey != null && dashPrivateKey != null) {
        return Ed25519KeyIdentity(
          pk,
          Uint8List.fromList(dashPrivateKey),
        );
      }
    }
    throw ArgumentError.value(jsonEncode(json), 'json', 'Invalid json');
  }

  factory Ed25519KeyIdentity.fromParsedJson(List<String> obj) {
    return Ed25519KeyIdentity(
      Ed25519PublicKey.fromDer(blobFromHex(obj[0])),
      blobFromHex(obj[1]),
    );
  }

  static Future<Ed25519KeyIdentity> generate(Uint8List? seed) async {
    if (seed != null && seed.length != 32) {
      throw RangeError.value(seed.length, 'Expected 32-bytes long but got');
    }

    final Uint8List publicKey;
    final Uint8List secretKey; // Seed itself.
    final kp = await AgentDartFFI.impl.ed25519FromSeed(
      req: ED25519FromSeedReq(seed: seed ?? getRandomValues()),
    );
    publicKey = kp.publicKey;
    secretKey = kp.seed;
    return Ed25519KeyIdentity(Ed25519PublicKey.fromRaw(publicKey), secretKey);
  }

  static Future<Ed25519KeyIdentityRecoveredFromII> recoverFromIISeedPhrase(
    String phrase,
  ) async {
    final userNumber = extractUserNumber(phrase);
    final mne = dropLeadingUserNumber(phrase);
    final identity = await fromMnemonicWithoutValidation(
      mne,
      icDerivationPath,
    );
    return Ed25519KeyIdentityRecoveredFromII(
      userNumber: userNumber,
      identity: identity,
    );
  }

  final Ed25519PublicKey _publicKey;
  final BinaryBlob _seed;

  /// Serialize this key to JSON.
  List<String> toJson() {
    return [blobToHex(_publicKey.toDer()), blobToHex(_seed)];
  }

  /// Return a copy of the key pair.
  auth.KeyPair getKeyPair() {
    return Ed25519KeyPair(publicKey: _publicKey, secretKey: _seed);
  }

  /// Return the public key.
  @override
  Ed25519PublicKey getPublicKey() => _publicKey;

  /// Signs a blob of data, with this identity's private key.
  /// @param challenge - challenge to sign with this identity's secretKey, producing a signature
  @override
  Future<BinaryBlob> sign(dynamic challenge) {
    final blob = challenge is BinaryBlob
        ? challenge
        : blobFromBuffer(challenge as ByteBuffer);
    return AgentDartFFI.impl.ed25519Sign(
      req: ED25519SignReq(seed: _seed, message: blob),
    );
  }

  Future<bool> verify(Uint8List signature, Uint8List message) {
    return AgentDartFFI.impl.ed25519Verify(
      req: ED25519VerifyReq(
        message: message,
        sig: signature,
        pubKey: _publicKey.toRaw(),
      ),
    );
  }
}

class Ed25519KeyIdentityRecoveredFromII {
  const Ed25519KeyIdentityRecoveredFromII({
    required this.identity,
    this.userNumber,
  });

  final BigInt? userNumber;
  final Ed25519KeyIdentity identity;
}

/// The following part is ported from InternetIdentity service.
/// It's main purpose is to `recover` an identity that registered.
/// These truths are covered.
///
/// It generates master-seed using Bip39 and sha512. Then use [icDerivationPath]
/// matches to m/44'/223’/0’/0’/0'. Then use [Ed25519KeyIdentity.generate] to
/// generate a new identity. Internet Identity service then use the
/// generated identity as a binding to original identity. So the phrases that
/// generated can be saved to a new location, then combined with a device number
/// to recover.
const hardened = 0x80000000;
const icBasePath = [44, 223, 0];
const icDerivationPath = [44, 223, 0, 0, 0];

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
  String mnemonic,
  List<int>? derivationPath, {
  int offset = hardened,
}) async {
  derivationPath ??= [];
  final seed = await AgentDartFFI.impl.mnemonicPhraseToSeed(
    req: PhraseToSeedReq(phrase: mnemonic, password: ''),
  );
  return fromSeedWithSlip0010(seed, derivationPath, offset: offset);
}

/// Create an Ed25519 according to SLIP 0010:
/// https://github.com/satoshilabs/slips/blob/master/slip-0010.md
///
/// The derivation path is an array that always interpreted as a hardened path.
/// e.g. to generate m/44'/223’/0’/0’/0' the derivation path should be
/// [44, 223, 0, 0, 0].
Future<Ed25519KeyIdentity> fromSeedWithSlip0010(
  Uint8List masterSeed,
  List<int>? derivationPath, {
  int offset = hardened,
}) {
  final chainSet = generateMasterKey(masterSeed);
  Uint8List slipSeed = chainSet.first;
  Uint8List chainCode = chainSet.last;
  derivationPath ??= [];
  for (int i = 0; i < derivationPath.length; i++) {
    final newSet = derive(slipSeed, chainCode, derivationPath[i] | offset);
    slipSeed = newSet.first;
    chainCode = newSet.last;
  }
  return Ed25519KeyIdentity.generate(slipSeed);
}

Set<Uint8List> generateMasterKey(Uint8List seed) {
  final hmacSha512 = Hmac(
    sha512,
    'ed25519 seed'.plainToU8a(useDartEncode: true),
  ); // HMAC-SHA512
  final h = hmacSha512.convert(seed);
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

/// Converts a 32-bit unsigned integer to a big endian byte array.
Uint8List toBigEndianArray(int n) {
  final byteArray = Uint8List.fromList([0, 0, 0, 0]);
  for (int i = byteArray.length - 1; i >= 0; i--) {
    final byte = n & 0xff;
    byteArray[i] = byte;
    n = ((n - byte) ~/ 256).toInt();
  }
  return byteArray;
}

String dropLeadingUserNumber(String s) {
  final i = s.indexOf(' ');
  if (i != -1 && parseUserNumber(s.substring(0, i)) != null) {
    return s.substring(i + 1);
  } else {
    return s;
  }
}

/// BigInt parses various things we do not want to allow, like:
///  - BigInt(whitespace) == 0
///  - Hex/Octal formatted numbers
///  - Scientific notation
/// So we check that the user has entered a sequence of digits only,
/// before attempting to parse.
BigInt? parseUserNumber(String s) {
  return BigInt.tryParse(s, radix: 10);
}

BigInt? extractUserNumber(String s) {
  final i = s.indexOf(' ');
  if (i != -1) {
    return parseUserNumber(s.substring(0, i));
  } else {
    return null;
  }
}
