part of 'key_store.dart';

// ignore: constant_identifier_names
const String ALGO_IDENTIFIER = 'aes-128-ctr';

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

  List<int> encodedPassword = utf8.encode(passphrase);

  final Uint8List derivedKey;
  final Uint8List leftBits;
  final Uint8List rightBits;

  if (kdf == 'scrypt') {
    final scryptKey = await dylib.scryptDeriveKey(
        req: ScriptDeriveReq(
            n: kdfParams['n'],
            p: kdfParams['p'],
            r: kdfParams['r'],
            password: passphrase.plainToU8a(),
            salt: salt.toU8a()));

    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  } else {
    final scryptKey = await dylib.pbkdf2DeriveKey(
        req: PBKDFDeriveReq(
            c: 262144, password: passphrase.plainToU8a(), salt: salt.toU8a()));
    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  }

  List<int> ciphertextBytes = await _encryptPhraseAsync(
      key: Uint8List.fromList(leftBits),
      iv: Uint8List.fromList(iv),
      message: privateKey);

  List<int> macBuffer =
      rightBits + ciphertextBytes + iv + ALGO_IDENTIFIER.codeUnits;

  String mac = (SHA256()
      .update(Uint8List.fromList(derivedKey))
      .update(macBuffer)
      .digest()
      .toHex());

  Map<String, dynamic> map = {
    'crypto': {
      'cipher': 'aes-128-ctr',
      'cipherparams': {'iv': Uint8List.fromList(iv).toHex()},
      'ciphertext': Uint8List.fromList(ciphertextBytes).toHex(),
      'kdf': kdf,
      'kdfparams': kdfParams,
      'mac': mac,
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
  var cipherparams = keyStore['crypto']["cipherparams"];
  Uint8List iv = (cipherparams["iv"] as String).toU8a();

  List<int> encodedPassword = utf8.encode(passphrase);

  final Uint8List derivedKey;
  final Uint8List leftBits;
  final Uint8List rightBits;

  if (kdf == 'scrypt') {
    final scryptKey = await dylib.scryptDeriveKey(
        req: ScriptDeriveReq(
            n: kdfParams['n'],
            p: kdfParams['p'],
            r: kdfParams['r'],
            password: passphrase.plainToU8a(),
            salt: (kdfParams["salt"] as String).toU8a()));

    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  } else {
    final scryptKey = await dylib.pbkdf2DeriveKey(
        req: PBKDFDeriveReq(
            c: 262144,
            password: passphrase.plainToU8a(),
            salt: (kdfParams["salt"] as String).toU8a()));
    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  }
  // return (derivedKey.toHex());

  List<int> macBuffer = rightBits + ciphertext + iv + ALGO_IDENTIFIER.codeUnits;

  String mac = (SHA256()
      .update(Uint8List.fromList(derivedKey))
      .update(macBuffer)
      .digest()
      .toHex());

  String macString = keyStore['crypto']['mac'];

  Function eq = const ListEquality().equals;
  if (!eq(mac.toUpperCase().codeUnits, macString.toUpperCase().codeUnits)) {
    throw 'Decryption Failed';
  }

  var encryptedPrivateKey =
      (keyStore["crypto"]["ciphertext"] as String).toU8a();

  return (await _dercryptPhraseAsync(
          cipherText: encryptedPrivateKey, key: leftBits, iv: iv))
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

  List<int> encodedPassword = utf8.encode(password);

  final Uint8List derivedKey;
  final Uint8List leftBits;
  final Uint8List rightBits;

  if (kdf == 'scrypt') {
    final scryptKey = await dylib.scryptDeriveKey(
        req: ScriptDeriveReq(
            n: kdfParams['n'],
            p: kdfParams['p'],
            r: kdfParams['r'],
            password: password.plainToU8a(),
            salt: salt.toU8a()));

    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  } else {
    final scryptKey = await dylib.pbkdf2DeriveKey(
        req: PBKDFDeriveReq(
            c: 262144, password: password.plainToU8a(), salt: salt.toU8a()));
    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  }

  List<int> ciphertextBytes = await _encryptPhraseAsync(
      key: Uint8List.fromList(leftBits),
      iv: Uint8List.fromList(iv),
      message: phrase);

  List<int> macBuffer =
      rightBits + ciphertextBytes + iv + ALGO_IDENTIFIER.codeUnits;

  String mac = (SHA256()
      .update(Uint8List.fromList(derivedKey))
      .update(macBuffer)
      .digest()
      .toHex());

  Map<String, dynamic> map = {
    'crypto': {
      'cipher': 'aes-128-ctr',
      'cipherparams': {'iv': Uint8List.fromList(iv).toHex()},
      'ciphertext': Uint8List.fromList(ciphertextBytes).toHex(),
      'kdf': kdf,
      'kdfparams': kdfParams,
      'mac': mac,
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
  var cipherparams = keyStore['crypto']["cipherparams"];
  Uint8List iv = (cipherparams["iv"] as String).toU8a();

  List<int> encodedPassword = utf8.encode(passphrase);

  final Uint8List derivedKey;
  final Uint8List leftBits;
  final Uint8List rightBits;

  if (kdf == 'scrypt') {
    final scryptKey = await dylib.scryptDeriveKey(
        req: ScriptDeriveReq(
            n: kdfParams['n'],
            p: kdfParams['p'],
            r: kdfParams['r'],
            password: passphrase.plainToU8a(),
            salt: (kdfParams["salt"] as String).toU8a()));

    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  } else {
    final scryptKey = await dylib.pbkdf2DeriveKey(
        req: PBKDFDeriveReq(
            c: 262144,
            password: passphrase.plainToU8a(),
            salt: (kdfParams["salt"] as String).toU8a()));
    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  }
  // return (derivedKey.toHex());

  List<int> macBuffer = rightBits + ciphertext + iv + ALGO_IDENTIFIER.codeUnits;

  String mac = (SHA256()
      .update(Uint8List.fromList(derivedKey))
      .update(macBuffer)
      .digest()
      .toHex());

  String macString = keyStore['crypto']['mac'];

  Function eq = const ListEquality().equals;
  if (!eq(mac.toUpperCase().codeUnits, macString.toUpperCase().codeUnits)) {
    throw 'Decryption Failed';
  }

  var encryptedPhrase = (keyStore["crypto"]["ciphertext"] as String).toU8a();

  return (await _dercryptPhraseAsync(
          cipherText: encryptedPhrase, key: leftBits, iv: iv))
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
  final String kdf = Uint8List.fromList(recover["kdf"]).u8aToString();
  final List<int> encodedPassword = utf8.encode(password);
  final Uint8List derivedKey;
  final Uint8List leftBits;
  final Uint8List rightBits;

  if (kdf == 'scrypt') {
    final scryptKey = await dylib.scryptDeriveKey(
        req: ScriptDeriveReq(
            n: kdfParams['n'],
            p: kdfParams['p'],
            r: kdfParams['r'],
            password: password.plainToU8a(),
            salt: (kdfParams["salt"] as String).toU8a()));

    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  } else {
    final scryptKey = await dylib.pbkdf2DeriveKey(
        req: PBKDFDeriveReq(
            c: 262144,
            password: password.plainToU8a(),
            salt: (kdfParams["salt"] as String).toU8a()));
    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  }
  final List<int> macBuffer =
      rightBits + ciphertext + iv + ALGO_IDENTIFIER.codeUnits;

  final Uint8List mac = SHA256()
      .update(Uint8List.fromList(derivedKey))
      .update(macBuffer)
      .digest();

  final Uint8List macFromRecover =
      Uint8List.fromList(u8aToU8a((recover['mac'] as List).map((ele) {
    return int.parse(ele.toString());
  }).toList()));

  if (!u8aEq(mac, macFromRecover)) {
    throw 'Decryption Failed';
  }

  final Uint8List encryptedPhrase = Uint8List.fromList(recover['ciphertext']);

  return (await _dercryptPhraseAsync(
          cipherText: encryptedPhrase, key: leftBits, iv: iv))
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

  final List<int> encodedPassword = utf8.encode(password);
  final Uint8List derivedKey;
  final Uint8List leftBits;
  final Uint8List rightBits;

  if (kdf == 'scrypt') {
    final scryptKey = await dylib.scryptDeriveKey(
        req: ScriptDeriveReq(
            n: kdfParams['n'],
            p: kdfParams['p'],
            r: kdfParams['r'],
            password: password.plainToU8a(),
            salt: (kdfParams["salt"] as String).toU8a()));

    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  } else {
    final scryptKey = await dylib.pbkdf2DeriveKey(
        req: PBKDFDeriveReq(
            c: 262144,
            password: password.plainToU8a(),
            salt: (kdfParams["salt"] as String).toU8a()));
    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  }

  List<int> ciphertextBytes = await _encryptPhraseAsync(
      key: Uint8List.fromList(leftBits),
      iv: Uint8List.fromList(iv),
      message: phrase);

  final List<int> macBuffer =
      rightBits + ciphertextBytes + iv + ALGO_IDENTIFIER.codeUnits;

  final Uint8List mac = SHA256()
      .update(Uint8List.fromList(derivedKey))
      .update(macBuffer)
      .digest();

  return cborEncode({
    'ciphertext': ciphertextBytes,
    'cipherparams': {
      'iv': iv,
    },
    'cipher': ALGO_IDENTIFIER.plainToU8a(),
    'kdf': kdf.plainToU8a(),
    'kdfparams': cborEncode(kdfParams),
    'mac': mac,
  });
}
