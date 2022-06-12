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
  return await dylib.aes128CtrEncrypt(
      req: AesEncryptReq(key: key, iv: iv, message: message.plainToU8a()));
}

Future<Uint8List> _dercryptPhraseAsync({
  required Uint8List key,
  required Uint8List iv,
  required Uint8List cipherText,
}) async {
  return await dylib.aes128CtrDecrypt(
      req: AesDecryptReq(key: key, iv: iv, cipherText: cipherText));
}
