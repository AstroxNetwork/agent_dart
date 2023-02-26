part of 'key_store.dart';

const String _algoIdentifier = 'aes-128-ctr';

Future<String> encrypt(
  String privateKey,
  String passphrase, [
  Map<String, dynamic>? options,
]) async {
  final Uint8List uuid = Uint8List(16);
  final Uuid uuidParser = const Uuid()..v4buffer(uuid);

  final String salt = randomAsHex(64);
  final List<int> iv = randomAsU8a(16);
  final String kdf = options?['kdf'] is String ? options!['kdf'] : 'scrypt';
  final int level = options?['level'] is int ? options!['level'] : 8192;
  final int n = kdf == 'pbkdf2' ? 262144 : level;

  final Map<String, dynamic> kdfParams = {
    'salt': salt,
    'n': n,
    'r': 8,
    'p': 1,
    'dklen': 32,
  };

  final deriveKeyResult = await nativeDeriveKey(
    kdf: kdf,
    iv: iv,
    message: privateKey,
    useCipherText: null,
    kdfParams: kdfParams,
    passphrase: passphrase,
    salt: salt,
  );

  final Map<String, dynamic> map = {
    'crypto': {
      'cipher': 'aes-128-ctr',
      'cipherparams': {'iv': Uint8List.fromList(iv).toHex()},
      'ciphertext': Uint8List.fromList(deriveKeyResult.cipherText).toHex(),
      'kdf': kdf,
      'kdfparams': kdfParams,
      'mac': deriveKeyResult.mac,
    },
    'id': uuidParser.v4buffer(uuid),
    'version': 3,
  };
  final String result = json.encode(map);
  return result;
}

Future<String> decrypt(Map<String, dynamic> keyStore, String passphrase) async {
  final Uint8List ciphertext =
      (keyStore['crypto']['ciphertext'] as String).toU8a();
  final String kdf = keyStore['crypto']['kdf'];
  final Map<String, dynamic> kdfParams =
      keyStore['crypto']['kdfparams'] is String
          ? json.decode(keyStore['crypto']['kdfparams'])
          : keyStore['crypto']['kdfparams'];
  final cipherParams = keyStore['crypto']['cipherparams'];
  final Uint8List iv = (cipherParams['iv'] as String).toU8a();
  final deriveKeyResult = await nativeDeriveKey(
    kdf: kdf,
    iv: iv,
    message: null,
    useCipherText: ciphertext,
    kdfParams: kdfParams,
    passphrase: passphrase,
    salt: (kdfParams['salt'] as String).replaceAll('0x', ''),
  );
  final String macString = keyStore['crypto']['mac'];
  if (!const ListEquality().equals(
    deriveKeyResult.mac.toUpperCase().codeUnits,
    macString.toUpperCase().codeUnits,
  )) {
    throw StateError('Decryption failed.');
  }

  final encryptedPrivateKey =
      (keyStore['crypto']['ciphertext'] as String).toU8a();
  return (await _decryptPhraseAsync(
    cipherText: encryptedPrivateKey,
    key: deriveKeyResult.leftBits,
    iv: iv,
  ))
      .u8aToString();
}

Future<String> encryptPhrase(
  String phrase,
  String password, [
  Map<String, dynamic>? options,
]) async {
  final Uint8List uuid = Uint8List(16);
  final Uuid uuidParser = const Uuid()..v4buffer(uuid);
  final String salt = randomAsHex(64);
  final List<int> iv = randomAsU8a(16);

  final String kdf = options?['kdf'] is String ? options!['kdf'] : 'scrypt';
  final int level = options?['level'] is int ? options!['level'] : 8192;
  final int n = kdf == 'pbkdf2' ? 262144 : level;

  final Map<String, dynamic> kdfParams = {
    'salt': salt,
    'n': n,
    'r': 8,
    'p': 1,
    'dklen': 32,
  };

  final deriveKeyResult = await nativeDeriveKey(
    kdf: kdf,
    iv: iv,
    message: phrase,
    useCipherText: null,
    kdfParams: kdfParams,
    passphrase: password,
    salt: (kdfParams['salt'] as String).replaceAll('0x', ''),
  );

  final Map<String, dynamic> map = {
    'crypto': {
      'cipher': 'aes-128-ctr',
      'cipherparams': {'iv': Uint8List.fromList(iv).toHex()},
      'ciphertext': Uint8List.fromList(deriveKeyResult.cipherText).toHex(),
      'kdf': kdf,
      'kdfparams': kdfParams,
      'mac': deriveKeyResult.mac,
    },
    'id': uuidParser.v4buffer(uuid),
    'version': 3,
  };
  final String result = json.encode(map);
  return result;
}

Future<String> decryptPhrase(
  Map<String, dynamic> keyStore,
  String passphrase,
) async {
  final Uint8List ciphertext =
      (keyStore['crypto']['ciphertext'] as String).toU8a();
  final String kdf = keyStore['crypto']['kdf'];

  final Map<String, dynamic> kdfParams =
      keyStore['crypto']['kdfparams'] is String
          ? json.decode(keyStore['crypto']['kdfparams'])
          : keyStore['crypto']['kdfparams'];
  final cipherParams = keyStore['crypto']['cipherparams'];
  final Uint8List iv = (cipherParams['iv'] as String).toU8a();

  final deriveKeyResult = await nativeDeriveKey(
    kdf: kdf,
    iv: iv,
    message: null,
    useCipherText: ciphertext,
    kdfParams: kdfParams,
    passphrase: passphrase,
    salt: (kdfParams['salt'] as String).replaceAll('0x', ''),
  );

  final String macString = keyStore['crypto']['mac'];

  final Function eq = const ListEquality().equals;
  if (!eq(
    deriveKeyResult.mac.toUpperCase().codeUnits,
    macString.toUpperCase().codeUnits,
  )) {
    throw StateError('Decryption failed.');
  }

  final encryptedPhrase = (keyStore['crypto']['ciphertext'] as String).toU8a();

  return (await _decryptPhraseAsync(
    cipherText: encryptedPhrase,
    key: deriveKeyResult.leftBits,
    iv: iv,
  ))
      .u8aToString();
}

Future<String> encodePrivateKey(
  String prvKey,
  String psw, [
  Map<String, dynamic>? options,
]) {
  return encrypt(prvKey, psw, options);
}

Future<String> decodePrivateKey(
  Map<String, dynamic> keyStore,
  String psw,
) {
  return decrypt(keyStore, psw);
}

Future<String> encodePhrase(
  String prvKey,
  String psw, [
  Map<String, dynamic>? options,
]) {
  return encryptPhrase(prvKey, psw, options);
}

Future<String> decodePhrase(
  Map<String, dynamic> keyStore,
  String psw,
) {
  return decryptPhrase(keyStore, psw);
}

Future<String> decryptCborPhrase(List<int> bytes, String password) async {
  final recover = Map<String, dynamic>.from(cborDecode(bytes));
  final Uint8List ciphertext = Uint8List.fromList(recover['ciphertext']);

  final Uint8List iv = Uint8List.fromList(recover['cipherparams']['iv']);
  final kdfParams = Map<String, dynamic>.from(cborDecode(recover['kdfparams']));
  final String kdf = Uint8List.fromList(recover['kdf']).u8aToString();

  final deriveKeyResult = await nativeDeriveKey(
    kdf: kdf,
    iv: iv,
    message: null,
    useCipherText: ciphertext,
    kdfParams: kdfParams,
    passphrase: password,
    salt: (kdfParams['salt'] as String).replaceAll('0x', ''),
  );

  final Uint8List macFromRecover = Uint8List.fromList(
    u8aToU8a(
      (recover['mac'] as List).map((ele) {
        return int.parse(ele.toString());
      }).toList(),
    ),
  );

  if (!u8aEq(deriveKeyResult.mac.toU8a(), macFromRecover)) {
    throw StateError('decryption failed.');
  }

  final Uint8List encryptedPhrase = Uint8List.fromList(recover['ciphertext']);

  return (await _decryptPhraseAsync(
    cipherText: encryptedPhrase,
    key: deriveKeyResult.leftBits,
    iv: iv,
  ))
      .u8aToString();
}

Future<Uint8List> encryptCborPhrase(
  String phrase,
  String password, [
  Map<String, dynamic>? options,
]) async {
  final String salt = randomAsHex(64);
  final List<int> iv = randomAsU8a(16);
  final String kdf = options?['kdf'] is String ? options!['kdf'] : 'scrypt';
  final int level = options?['level'] is int ? options!['level'] : 8192;
  final int n = kdf == 'pbkdf2' ? 262144 : level;

  final Map<String, dynamic> kdfParams = {
    'salt': salt,
    'n': n,
    'c': n,
    'r': 8,
    'p': 1,
    'dklen': 32,
  };

  final deriveKeyResult = await nativeDeriveKey(
    kdf: kdf,
    iv: iv,
    message: phrase,
    useCipherText: null,
    kdfParams: kdfParams,
    passphrase: password,
    salt: salt,
  );

  return cborEncode({
    'ciphertext': deriveKeyResult.cipherText,
    'cipherparams': {'iv': iv},
    'cipher': _algoIdentifier.plainToU8a(),
    'kdf': kdf.plainToU8a(),
    'kdfparams': cborEncode(kdfParams),
    'mac': deriveKeyResult.mac.toU8a(),
  });
}

Future<EncryptMessageResponse> encryptMessage({
  required Secp256k1KeyIdentity identity,
  required Secp256k1PublicKey theirPublicKey,
  required String text,
}) async {
  final sharedPoint = await getECShareSecret(
    identity.getKeyPair().secretKey,
    theirPublicKey.toRaw(),
  );

  final sharedX = sharedPoint.sublist(0, 32);

  final List<int> iv = randomAsU8a(16);
  // randomAsU8a(16);

  final encryptedMessage256 = await _encryptPhraseAsync256(
    key: sharedX,
    iv: Uint8List.fromList(iv),
    message: text,
  );
  final encryptedMessage = base64Encode(encryptedMessage256);
  final ivBase64 = base64Encode(iv);

  return EncryptMessageResponse(
    content: '$encryptedMessage?iv=$ivBase64',
    tags: [
      ['p', theirPublicKey.toRaw().toHex()]
    ],
    kind: 4,
    createdAt: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
    pubKey: identity.getPublicKey().toRaw().toHex(),
  );
}

Future<E2EResponse> encryptP256Message({
  required P256Identity identity,
  required P256PublicKey theirPublicKey,
  required String text,
}) async {
  final sharedPoint = await getP256ShareSecret(
    identity.getKeyPair().secretKey,
    theirPublicKey.toRaw(),
  );

  final sharedX = sharedPoint.sublist(0, 32);

  final List<int> iv = randomAsU8a(16);
  // randomAsU8a(16);

  final encryptedMessage256 = await _encryptPhraseAsync256(
    key: sharedX,
    iv: Uint8List.fromList(iv),
    message: text,
  );
  final encryptedMessage = base64Encode(encryptedMessage256);
  final ivBase64 = base64Encode(iv);

  return E2EResponse(
    content: '$encryptedMessage?iv=$ivBase64',
    createdAt: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
    pubKey: identity.getPublicKey().toRaw().toHex(),
  );
}

Future<String> decryptMessage({
  required Secp256k1KeyIdentity identity,
  required Secp256k1PublicKey theirPublicKey,
  required String cipherText,
}) async {
  final arr = cipherText.split('?iv=');
  final emsg = arr[0];
  final iv = arr[1];

  final sharedPoint = await getECShareSecret(
    identity.getKeyPair().secretKey,
    theirPublicKey.toRaw(),
  );

  final sharedX = sharedPoint.sublist(0, 32);

  final decryptedMessage256 = await _decryptPhraseAsync256(
    key: sharedX,
    iv: base64Decode(iv),
    cipherText: base64Decode(emsg),
  );

  return decryptedMessage256.u8aToString();
}

Future<String> decryptP256Message({
  required P256Identity identity,
  required P256PublicKey theirPublicKey,
  required String cipherText,
}) async {
  final arr = cipherText.split('?iv=');
  final emsg = arr[0];
  final iv = arr[1];

  final sharedPoint = await getP256ShareSecret(
    identity.getKeyPair().secretKey,
    theirPublicKey.toRaw(),
  );

  final sharedX = sharedPoint.sublist(0, 32);

  final decryptedMessage256 = await _decryptPhraseAsync256(
    key: sharedX,
    iv: base64Decode(iv),
    cipherText: base64Decode(emsg),
  );

  return decryptedMessage256.u8aToString();
}

class EncryptMessageResponse {
  const EncryptMessageResponse({
    required this.pubKey,
    required this.createdAt,
    required this.kind,
    required this.tags,
    required this.content,
  });

  factory EncryptMessageResponse.fromJson(Map<String, dynamic> map) {
    return EncryptMessageResponse(
      content: map['content'],
      tags: map['tags'],
      kind: map['kind'],
      createdAt: map['create_at'],
      pubKey: map['pubkey'],
    );
  }

  final String pubKey;
  final int createdAt;
  final int kind;
  final List tags;
  final String content;

  Map<String, dynamic> toJson() => {
        'content': content,
        'tags': tags,
        'kind': kind,
        'created_at': createdAt,
        'pubkey': pubKey
      };
}

class E2EResponse {
  const E2EResponse({
    required this.pubKey,
    required this.createdAt,
    required this.content,
  });

  factory E2EResponse.fromJson(Map<String, dynamic> map) {
    return E2EResponse(
      content: map['content'],
      createdAt: map['create_at'],
      pubKey: map['pubkey'],
    );
  }

  final String pubKey;
  final int createdAt;
  final String content;

  Map<String, dynamic> toJson() =>
      {'content': content, 'created_at': createdAt, 'pubkey': pubKey};
}
