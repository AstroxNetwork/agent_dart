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
  _KeyDerivator derivator = getDerivedKey(kdf, kdfParams);
  List<int> derivedKey = derivator.deriveKey(encodedPassword);

  List<int> ciphertextBytes = _encryptPrivateKey(derivator,
      Uint8List.fromList(encodedPassword), Uint8List.fromList(iv), privateKey);

  List<int> macBuffer = derivedKey.sublist(16, 32) +
      ciphertextBytes +
      iv +
      ALGO_IDENTIFIER.codeUnits;

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

  Map<String, dynamic> kdfparams = keyStore['crypto']['kdfparams'] is String
      ? json.decode(keyStore['crypto']['kdfparams'])
      : keyStore['crypto']['kdfparams'];
  var cipherparams = keyStore['crypto']["cipherparams"];
  Uint8List iv = (cipherparams["iv"] as String).toU8a();

  List<int> encodedPassword = utf8.encode(passphrase);
  _KeyDerivator derivator = getDerivedKey(kdf, kdfparams);
  List<int> derivedKey = derivator.deriveKey(encodedPassword);
  List<int> macBuffer =
      derivedKey.sublist(16, 32) + ciphertext + iv + ALGO_IDENTIFIER.codeUnits;

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

  var aesKey = derivedKey.sublist(0, 16);
  var encryptedPrivateKey =
      (keyStore["crypto"]["ciphertext"] as String).toU8a();

  var aes = _initCipher(false, aesKey, iv);

  var privateKeyByte = aes.process(encryptedPrivateKey);
  return privateKeyByte.toHex();
}

Future<String> encryptPhrase(
  String phrase,
  String password, [
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

  List<int> encodedPassword = utf8.encode(password);
  _KeyDerivator derivator = getDerivedKey(kdf, kdfParams);
  List<int> derivedKey = derivator.deriveKey(encodedPassword);

  List<int> ciphertextBytes = _encryptPhrase(derivator,
      Uint8List.fromList(encodedPassword), Uint8List.fromList(iv), phrase);

  List<int> macBuffer = derivedKey.sublist(16, 32) +
      ciphertextBytes +
      iv +
      ALGO_IDENTIFIER.codeUnits;

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

Future<String> decryptPhrase(
  Map<String, dynamic> keyStore,
  String passphrase,
) async {
  Uint8List ciphertext = (keyStore['crypto']['ciphertext'] as String).toU8a();
  String kdf = keyStore['crypto']['kdf'];

  Map<String, dynamic> kdfparams = keyStore['crypto']['kdfparams'] is String
      ? json.decode(keyStore['crypto']['kdfparams'])
      : keyStore['crypto']['kdfparams'];
  var cipherparams = keyStore['crypto']["cipherparams"];
  Uint8List iv = (cipherparams["iv"] as String).toU8a();

  List<int> encodedPassword = utf8.encode(passphrase);
  _KeyDerivator derivator = getDerivedKey(kdf, kdfparams);
  List<int> derivedKey = derivator.deriveKey(encodedPassword);
  List<int> macBuffer =
      derivedKey.sublist(16, 32) + ciphertext + iv + ALGO_IDENTIFIER.codeUnits;

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

  var aesKey = derivedKey.sublist(0, 16);
  var encryptedPhrase = (keyStore["crypto"]["ciphertext"] as String).toU8a();

  var aes = _initCipher(false, aesKey, iv);

  var privateKeyByte = aes.process(encryptedPhrase);
  return privateKeyByte.u8aToString();
}

Future<String> encodePrivateKey(
  String prvKey,
  String psw, [
  Map<String, dynamic>? options,
]) async {
  try {
    final response = ReceivePort();

    await Isolate.spawn(
      _encodePrivateKey,
      [response.sendPort, prvKey, psw, options],
    );

    return (await response.first) as String;
  } catch (e) {
    rethrow;
  }
}

Future<void> _encodePrivateKey(List<dynamic> args) async {
  try {
    SendPort responsePort = args[0];
    final prvKey = args[1] as String;
    final psw = args[2] as String;
    final options = args[3] != null ? args[3] as Map<String, dynamic> : null;
    final encrypted = await encrypt(prvKey, psw, options);
    Isolate.exit(responsePort, encrypted);
  } catch (e) {
    rethrow;
  }
}

Future<String> decodePrivateKey(
  Map<String, dynamic> keyStore,
  String psw,
) async {
  try {
    final response = ReceivePort();

    await Isolate.spawn(
      _decodePrivateKey,
      [response.sendPort, keyStore, psw],
    );

    final sendPort = await response.first as SendPort;
    final receivePort = ReceivePort();

    sendPort.send([keyStore, psw, receivePort.sendPort]);
    return (await response.first) as String;
  } catch (e) {
    rethrow;
  }
}

Future<void> _decodePrivateKey(List<dynamic> args) async {
  try {
    SendPort responsePort = args[0];
    final keyStore = args[1] as Map<String, dynamic>;
    final psw = args[2] as String;
    var decrypted = await decrypt(keyStore, psw);
    Isolate.exit(responsePort, decrypted);
  } catch (e) {
    rethrow;
  }
}

Future<String> encodePhrase(
  String prvKey,
  String psw, [
  Map<String, dynamic>? options,
]) async {
  final response = ReceivePort();
  try {
    await Isolate.spawn(
      _encodePhrase,
      [response.sendPort, prvKey, psw, options],
    );

    return (await response.first) as String;
  } catch (e) {
    rethrow;
  }
}

Future<void> _encodePhrase(List<dynamic> args) async {
  try {
    SendPort responsePort = args[0];
    final prvKey = args[1] as String;
    final psw = args[2] as String;
    final options = args[3] != null ? args[3] as Map<String, dynamic> : null;
    final encrypted = await encryptPhrase(prvKey, psw, options);
    Isolate.exit(responsePort, encrypted);
  } catch (e) {
    rethrow;
  }
}

Future<String> decodePhrase(
  Map<String, dynamic> keyStore,
  String psw,
) async {
  final response = ReceivePort();
  try {
    await Isolate.spawn(
      _decodePhrase,
      [response.sendPort, keyStore, psw],
    );

    return (await response.first) as String;
  } catch (e) {
    rethrow;
  }
}

Future<void> _decodePhrase(List<dynamic> args) async {
  try {
    SendPort responsePort = args[0];
    final keyStore = args[1] as Map<String, dynamic>;
    final psw = args[2] as String;
    final decrypted = await decryptPhrase(keyStore, psw);
    Isolate.exit(responsePort, decrypted);
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
  final kdfparams = Map<String, dynamic>.from(cborDecode(recover['kdfparams']));

  final List<int> encodedPassword = utf8.encode(password);
  final derivator = getDerivedKey(
      (Uint8List.fromList(recover['kdf'])).u8aToString(), kdfparams);
  final List<int> derivedKey = derivator.deriveKey(encodedPassword);
  final List<int> macBuffer =
      derivedKey.sublist(16, 32) + ciphertext + iv + ALGO_IDENTIFIER.codeUnits;

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

  final List<int> aesKey = derivedKey.sublist(0, 16);
  final Uint8List encryptedPhrase = Uint8List.fromList(recover['ciphertext']);

  final CTRStreamCipher aes = _initCipher(false, aesKey, iv);

  final Uint8List privateKeyByte = aes.process(encryptedPhrase);
  return privateKeyByte.u8aToString();
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
  final _KeyDerivator derivator = getDerivedKey(kdf, kdfParams);
  final List<int> derivedKey = derivator.deriveKey(encodedPassword);
  final List<int> ciphertextBytes = _encryptPhrase(
    derivator,
    Uint8List.fromList(encodedPassword),
    Uint8List.fromList(iv),
    phrase,
  );

  final List<int> macBuffer = derivedKey.sublist(16, 32) +
      ciphertextBytes +
      iv +
      ALGO_IDENTIFIER.codeUnits;

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
