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

  Map<String, dynamic> kdfParams = {'salt': salt, 'n': n, 'r': 8, 'p': 1, 'dklen': 32};

  List<int> encodedPassword = utf8.encode(passphrase);
  _KeyDerivator derivator = getDerivedKey(kdf, kdfParams);
  List<int> derivedKey = derivator.deriveKey(encodedPassword);

  List<int> ciphertextBytes = _encryptPrivateKey(
      derivator, Uint8List.fromList(encodedPassword), Uint8List.fromList(iv), privateKey);

  List<int> macBuffer =
      derivedKey.sublist(16, 32) + ciphertextBytes + iv + ALGO_IDENTIFIER.codeUnits;

  String mac = (SHA256().update(Uint8List.fromList(derivedKey)).update(macBuffer).digest().toHex());

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
  List<int> macBuffer = derivedKey.sublist(16, 32) + ciphertext + iv + ALGO_IDENTIFIER.codeUnits;

  String mac = (SHA256().update(Uint8List.fromList(derivedKey)).update(macBuffer).digest().toHex());

  String macString = keyStore['crypto']['mac'];

  Function eq = const ListEquality().equals;
  if (!eq(mac.toUpperCase().codeUnits, macString.toUpperCase().codeUnits)) {
    throw 'Decryption Failed';
  }

  var aesKey = derivedKey.sublist(0, 16);
  var encryptedPrivateKey = (keyStore["crypto"]["ciphertext"] as String).toU8a();

  var aes = _initCipher(false, aesKey, iv);

  var privateKeyByte = aes.process(encryptedPrivateKey);
  return privateKeyByte.toHex();
}
