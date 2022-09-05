part of 'key_store.dart';


const String _algoIdentifier = 'aes-128-ctr';

Future<String> encrypt(
  String privateKey,
  String passphrase, [
  Map<String, dynamic>? options,
]) async {
  Uint8List uuid = Uint8List(16);
  Uuid uuidParser = const Uuid()..v4buffer(uuid);

  String salt = randomAsHex(64);
  List<int> iv = randomAsU8a(16);
  String kdf = 'scrypt';
  int level = 8192;
  int n = kdf == 'pbkdf2' ? 262144 : level;
  if (options == null) {
    kdf = 'scrypt';
    level = 8192;
    n = kdf == 'pbkdf2' ? 262144 : level;
  } else {
    kdf = options['kdf'] is String ? options['kdf'] : 'scrypt';
    level = options['level'] is int ? options['level'] : 8192;
    n = kdf == 'pbkdf2' ? 262144 : level;
  }

  Map<String, dynamic> kdfParams = {
    'salt': salt,
    'n': n,
    'r': 8,
    'p': 1,
    'dklen': 32
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

  Map<String, dynamic> map = {
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
  String result = json.encode(map);
  return result;
}

Future<String> decrypt(Map<String, dynamic> keyStore, String passphrase) async {
  Uint8List ciphertext = (keyStore['crypto']['ciphertext'] as String).toU8a();
  String kdf = keyStore['crypto']['kdf'];

  Map<String, dynamic> kdfParams = keyStore['crypto']['kdfparams'] is String
      ? json.decode(keyStore['crypto']['kdfparams'])
      : keyStore['crypto']['kdfparams'];
  var cipherparams = keyStore['crypto']['cipherparams'];
  Uint8List iv = (cipherparams['iv'] as String).toU8a();

  final deriveKeyResult = await nativeDeriveKey(
    kdf: kdf,
    iv: iv,
    message: null,
    useCipherText: ciphertext,
    kdfParams: kdfParams,
    passphrase: passphrase,
    salt: (kdfParams['salt'] as String).replaceAll('0x', ''),
  );

  String macString = keyStore['crypto']['mac'];

  Function eq = const ListEquality().equals;
  if (!eq(
    deriveKeyResult.mac.toUpperCase().codeUnits,
    macString.toUpperCase().codeUnits,
  )) {
    throw 'Decryption Failed';
  }

  var encryptedPrivateKey =
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
  Uint8List uuid = Uint8List(16);
  Uuid uuidParser = const Uuid()..v4buffer(uuid);
  String salt = randomAsHex(64);
  //  String salt = Uint8List.fromList(List<int>.filled(32, 0)).toHex();
  List<int> iv = randomAsU8a(16);

  String kdf = 'scrypt';
  int level = 8192;
  int n = kdf == 'pbkdf2' ? 262144 : level;
  if (options == null) {
    kdf = 'scrypt';
    level = 8192;
    n = kdf == 'pbkdf2' ? 262144 : level;
  } else {
    kdf = options['kdf'] is String ? options['kdf'] : 'scrypt';
    level = options['level'] is int ? options['level'] : 8192;
    n = kdf == 'pbkdf2' ? 262144 : level;
  }

  Map<String, dynamic> kdfParams = {
    'salt': salt,
    'n': n,
    'r': 8,
    'p': 1,
    'dklen': 32
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

  Map<String, dynamic> map = {
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
  String result = json.encode(map);
  return result;
}

// Future<String> decryptPhrase(
//   Map<String, dynamic> keyStore,
//   String passphrase,
// ) async {
//   Uint8List ciphertext = (keyStore['crypto']['ciphertext'] as String).toU8a();
//   String kdf = keyStore['crypto']['kdf'];

//   Map<String, dynamic> kdfparams = keyStore['crypto']['kdfparams'] is String
//       ? json.decode(keyStore['crypto']['kdfparams'])
//       : keyStore['crypto']['kdfparams'];
//   var cipherparams = keyStore['crypto']["cipherparams"];
//   Uint8List iv = (cipherparams["iv"] as String).toU8a();

//   List<int> encodedPassword = utf8.encode(passphrase);
//   _KeyDerivator derivator = getDerivedKey(kdf, kdfparams);
//   List<int> derivedKey = derivator.deriveKey(encodedPassword);
//   List<int> macBuffer =
//       rightBits + ciphertext + iv + ALGO_IDENTIFIER.codeUnits;

//   String mac = (SHA256()
//       .update(Uint8List.fromList(derivedKey))
//       .update(macBuffer)
//       .digest()
//       .toHex());

//   String macString = keyStore['crypto']['mac'];

//   Function eq = const ListEquality().equals;
//   if (!eq(mac.toUpperCase().codeUnits, macString.toUpperCase().codeUnits)) {
//     throw 'Decryption Failed';
//   }

//   var aesKey = derivedKey.sublist(0, 16);
//   var encryptedPhrase = (keyStore["crypto"]["ciphertext"] as String).toU8a();

//   var aes = _initCipher(false, aesKey, iv);

//   var privateKeyByte = aes.process(encryptedPhrase);
//   return privateKeyByte.u8aToString();
// }

Future<String> decryptPhrase(
  Map<String, dynamic> keyStore,
  String passphrase,
) async {
  Uint8List ciphertext = (keyStore['crypto']['ciphertext'] as String).toU8a();
  String kdf = keyStore['crypto']['kdf'];

  Map<String, dynamic> kdfParams = keyStore['crypto']['kdfparams'] is String
      ? json.decode(keyStore['crypto']['kdfparams'])
      : keyStore['crypto']['kdfparams'];
  var cipherparams = keyStore['crypto']['cipherparams'];
  Uint8List iv = (cipherparams['iv'] as String).toU8a();

  final deriveKeyResult = await nativeDeriveKey(
    kdf: kdf,
    iv: iv,
    message: null,
    useCipherText: ciphertext,
    kdfParams: kdfParams,
    passphrase: passphrase,
    salt: (kdfParams['salt'] as String).replaceAll('0x', ''),
  );

  String macString = keyStore['crypto']['mac'];

  Function eq = const ListEquality().equals;
  if (!eq(
    deriveKeyResult.mac.toUpperCase().codeUnits,
    macString.toUpperCase().codeUnits,
  )) {
    throw 'Decryption Failed';
  }

  var encryptedPhrase = (keyStore['crypto']['ciphertext'] as String).toU8a();

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
]) async {
  try {
    return await encrypt(prvKey, psw, options);
  } catch (e) {
    rethrow;
  }
}

Future<String> decodePrivateKey(
  Map<String, dynamic> keyStore,
  String psw,
) async {
  try {
    return await decrypt(keyStore, psw);
  } catch (e) {
    rethrow;
  }
}

Future<String> encodePhrase(
  String prvKey,
  String psw, [
  Map<String, dynamic>? options,
]) async {
  try {
    return await encryptPhrase(prvKey, psw, options);
  } catch (e) {
    rethrow;
  }
}

Future<String> decodePhrase(
  Map<String, dynamic> keyStore,
  String psw,
) async {
  try {
    return await decryptPhrase(keyStore, psw);
  } catch (e) {
    rethrow;
  }
}

// interface PhraseCbor {
//   cipher: ArrayBuffer;
//   cipherparams: {
//     iv: ArrayBuffer;
//   };
//   ciphertext: ArrayBuffer;
//   kdf: ArrayBuffer;
//   kdfparams: ArrayBuffer;
//   mac: ArrayBuffer;
// }
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
    throw 'Decryption Failed';
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
  String kdf = 'scrypt';
  int level = 8192;
  int n = kdf == 'pbkdf2' ? 262144 : level;
  if (options == null) {
    kdf = 'scrypt';
    level = 8192;
    n = kdf == 'pbkdf2' ? 262144 : level;
  } else {
    kdf = options['kdf'] is String ? options['kdf'] : 'scrypt';
    level = options['level'] is int ? options['level'] : 8192;
    n = kdf == 'pbkdf2' ? 262144 : level;
  }

  final Map<String, dynamic> kdfParams = {
    'salt': salt,
    'n': n,
    'c': n,
    'r': 8,
    'p': 1,
    'dklen': 32
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
