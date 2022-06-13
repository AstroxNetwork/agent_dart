part of 'key_store.dart';

/// getDerivedKey by ``kdf`` type
_KeyDerivator getDerivedKey(String kdf, Map<String, dynamic> params) {
  var salt = (params['salt'] as String).toU8a();
  if (kdf == 'pbkdf2') {
    var c = params['c'];
    var dklen = params['dklen'];
    return _PBDKDF2KeyDerivator(c, salt, dklen);
  } else if (kdf == 'scrypt') {
    var n = params['n'];
    var r = params['r'];
    var p = params['p'];
    var dklen = params['dklen'];
    return _ScryptKeyDerivator(dklen, n, r, p, salt);
  } else {
    throw ArgumentError('Only pbkdf2 and scrypt are supported');
  }
}

CTRStreamCipher _initCipher(bool forEncryption, List<int> key, List<int> iv) {
  return CTRStreamCipher(AESFastEngine())
    ..init(
        false,
        ParametersWithIV(
            KeyParameter(Uint8List.fromList(key)), Uint8List.fromList(iv)));
}

List<int> _encryptPrivateKey(_KeyDerivator _derivator, Uint8List _password,
    Uint8List _iv, String privateKey) {
  var derived = _derivator.deriveKey(_password);
  var aesKey = derived.sublist(0, 16);
  var aes = _initCipher(true, aesKey, _iv);
  return aes.process((privateKey).toU8a());
}

List<int> _encryptPhrase(_KeyDerivator _derivator, Uint8List _password,
    Uint8List _iv, String phrase) {
  var derived = _derivator.deriveKey(_password);
  var aesKey = derived.sublist(0, 16);
  var aes = _initCipher(true, aesKey, _iv);
  return aes.process(phrase.plainToU8a());
}

Future<Uint8List> _encryptPhraseAsync(
    {required Uint8List key,
    required Uint8List iv,
    required String message}) async {
  return await AgentDartFFI.instance.aes128CtrEncrypt(
      req: AesEncryptReq(key: key, iv: iv, message: message.plainToU8a()));
}

Future<Uint8List> _decryptPhraseAsync({
  required Uint8List key,
  required Uint8List iv,
  required Uint8List cipherText,
}) async {
  return await AgentDartFFI.instance.aes128CtrDecrypt(
      req: AesDecryptReq(key: key, iv: iv, cipherText: cipherText));
}

Future<NativeDeriveKeyResult> nativeDeriveKey(
    {required String kdf,
    required List<int> iv,
    required String? message,
    required Uint8List? useCipherText,
    required Map<String, dynamic> kdfParams,
    required String passphrase,
    required String salt}) async {
  final Uint8List derivedKey;
  final Uint8List leftBits;
  final Uint8List rightBits;

  if (kdf == 'scrypt') {
    final scryptKey = await AgentDartFFI.instance.scryptDeriveKey(
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
    final scryptKey = await AgentDartFFI.instance.pbkdf2DeriveKey(
        req: PBKDFDeriveReq(
            c: 262144, password: passphrase.plainToU8a(), salt: salt.toU8a()));
    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey =
        Uint8List.fromList([...scryptKey.leftBits, ...scryptKey.rightBits]);
  }

  List<int> cipherText = useCipherText != null
      ? useCipherText.toList()
      : await _encryptPhraseAsync(
          key: Uint8List.fromList(leftBits),
          iv: Uint8List.fromList(iv),
          message: message!);

  List<int> macBuffer = rightBits + cipherText + iv + ALGO_IDENTIFIER.codeUnits;

  String mac = (SHA256()
      .update(Uint8List.fromList(derivedKey))
      .update(macBuffer)
      .digest()
      .toHex());

  return NativeDeriveKeyResult(
      cipherText: cipherText,
      mac: mac,
      leftBits: leftBits,
      rightBits: rightBits,
      derivedKey: derivedKey);
}

class NativeDeriveKeyResult {
  final String mac;
  final List<int> cipherText;
  final Uint8List leftBits;
  final Uint8List rightBits;
  final Uint8List derivedKey;
  NativeDeriveKeyResult(
      {required this.mac,
      required this.cipherText,
      required this.leftBits,
      required this.rightBits,
      required this.derivedKey});
}
