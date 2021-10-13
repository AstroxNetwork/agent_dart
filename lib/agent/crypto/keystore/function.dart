part of 'key_store.dart';

// ignore: constant_identifier_names
const String ALGO_IDENTIFIER = 'aes-128-ctr';

Future<String> encrypt(String privateKey, String passphrase,
    [Map<String, dynamic>? options]) async {
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

Future<String> encryptPhrase(String phrase, String password,
    [Map<String, dynamic>? options]) async {
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
    Map<String, dynamic> keyStore, String passphrase) async {
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

Future<String> encodePrivateKey(String prvKey, String psw,
    [Map<String, dynamic>? options]) async {
  final response = ReceivePort();

  await Isolate.spawn(
    _encodePrivateKey,
    response.sendPort,
    onExit: response.sendPort,
  );

  final sendPort = await response.first as SendPort;
  final receivePort = ReceivePort();

  sendPort.send([prvKey, psw, options, receivePort.sendPort]);

  try {
    final result = await receivePort.first as String;
    response.close();
    return result;
  } catch (e) {
    rethrow;
  }
}

void _encodePrivateKey(SendPort initialReplyTo) {
  final port = ReceivePort();

  initialReplyTo.send(port.sendPort);

  port.listen((message) async {
    try {
      final prvKey = message[0] as String;
      final psw = message[1] as String;
      final options =
          message[2] != null ? message[2] as Map<String, dynamic> : null;
      final send = message.last as SendPort;
      final encrypted = await encrypt(prvKey, psw, options);

      send.send(encrypted);
    } catch (e) {
      rethrow;
    }
  });
}

Future<String> decodePrivateKey(
  Map<String, dynamic> keyStore,
  String psw,
) async {
  final response = ReceivePort();

  await Isolate.spawn(
    _decodePrivateKey,
    response.sendPort,
    onExit: response.sendPort,
    onError: response.sendPort,
  );

  final sendPort = await response.first as SendPort;
  final receivePort = ReceivePort();

  sendPort.send([keyStore, psw, receivePort.sendPort]);

  try {
    final result = await receivePort.first as String;

    response.close();
    return result;
  } catch (e) {
    rethrow;
  }
}

void _decodePrivateKey(SendPort initialReplyTo) {
  final port = ReceivePort();

  initialReplyTo.send(port.sendPort);

  port.listen((message) async {
    try {
      final send = message.last as SendPort;
      final keyStore = message[0] as Map<String, dynamic>;
      final psw = message[1] as String;

      var decrypted = await decrypt(keyStore, psw);
      send.send(decrypted);
    } catch (e) {
      rethrow;
    }
  });
}

Future<String> encodePhrase(String prvKey, String psw,
    [Map<String, dynamic>? options]) async {
  final response = ReceivePort();

  await Isolate.spawn(
    _encodePhrase,
    response.sendPort,
    onExit: response.sendPort,
  );

  final sendPort = await response.first as SendPort;
  final receivePort = ReceivePort();

  sendPort.send([prvKey, psw, options, receivePort.sendPort]);

  try {
    final result = await receivePort.first as String;
    response.close();
    return result;
  } catch (e) {
    rethrow;
  }
}

void _encodePhrase(SendPort initialReplyTo) {
  final port = ReceivePort();

  initialReplyTo.send(port.sendPort);

  port.listen((message) async {
    try {
      final prvKey = message[0] as String;
      final psw = message[1] as String;
      final options =
          message[2] != null ? message[2] as Map<String, dynamic> : null;
      final send = message.last as SendPort;
      final encrypted = await encryptPhrase(prvKey, psw, options);

      send.send(encrypted);
    } catch (e) {
      rethrow;
    }
  });
}

Future<String> decodePhrase(
  Map<String, dynamic> keyStore,
  String psw,
) async {
  final response = ReceivePort();

  await Isolate.spawn(
    _decodePhrase,
    response.sendPort,
    onExit: response.sendPort,
    onError: response.sendPort,
  );

  final sendPort = await response.first as SendPort;
  final receivePort = ReceivePort();

  sendPort.send([keyStore, psw, receivePort.sendPort]);

  try {
    final result = await receivePort.first as String;

    response.close();
    return result;
  } catch (e) {
    rethrow;
  }
}

void _decodePhrase(SendPort initialReplyTo) {
  final port = ReceivePort();

  initialReplyTo.send(port.sendPort);

  port.listen((message) async {
    try {
      final send = message.last as SendPort;
      final keyStore = message[0] as Map<String, dynamic>;
      final psw = message[1] as String;

      var decrypted = await decryptPhrase(keyStore, psw);

      send.send(decrypted);
    } catch (e) {
      rethrow;
    }
  });
}
