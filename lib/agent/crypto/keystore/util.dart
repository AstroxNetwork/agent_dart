part of 'key_store.dart';

/// getDerivedKey by ``kdf`` type
KeyDerivator getDerivedKey(String kdf, Map<String, dynamic> params) {
  final salt = (params['salt'] as String).toU8a();
  if (kdf == 'pbkdf2') {
    final c = params['c'];
    final dklen = params['dklen'];
    return _PBDKDF2KeyDerivator(c, salt, dklen);
  } else if (kdf == 'scrypt') {
    final n = params['n'];
    final r = params['r'];
    final p = params['p'];
    final dklen = params['dklen'];
    return _ScryptKeyDerivator(dklen, n, r, p, salt);
  } else {
    throw UnsupportedError('Only pbkdf2 and scrypt are supported.');
  }
}

Future<Uint8List> _encryptPhraseAsync({
  required Uint8List key,
  required Uint8List iv,
  required String message,
}) {
  return AgentDartFFI.impl.aes128CtrEncrypt(
    req: AesEncryptReq(key: key, iv: iv, message: message.plainToU8a()),
  );
}

Future<Uint8List> _encryptPhraseAsync256({
  required Uint8List key,
  required Uint8List iv,
  required String message,
}) {
  return AgentDartFFI.impl.aes256GcmEncrypt(
    req: AesEncryptReq(key: key, iv: iv, message: message.plainToU8a()),
  );
}

Future<Uint8List> _decryptPhraseAsync({
  required Uint8List key,
  required Uint8List iv,
  required Uint8List cipherText,
}) {
  return AgentDartFFI.impl.aes128CtrDecrypt(
    req: AesDecryptReq(key: key, iv: iv, cipherText: cipherText),
  );
}

Future<Uint8List> _decryptPhraseAsync256({
  required Uint8List key,
  required Uint8List iv,
  required Uint8List cipherText,
}) {
  return AgentDartFFI.impl.aes256GcmDecrypt(
    req: AesDecryptReq(key: key, iv: iv, cipherText: cipherText),
  );
}

Future<NativeDeriveKeyResult> nativeDeriveKey({
  required String kdf,
  required List<int> iv,
  required String? message,
  required Uint8List? useCipherText,
  required Map<String, dynamic> kdfParams,
  required String salt,
  String passphrase = '',
}) async {
  final Uint8List derivedKey;
  final Uint8List leftBits;
  final Uint8List rightBits;

  if (kdf == 'scrypt') {
    final scryptKey = await AgentDartFFI.impl.scryptDeriveKey(
      req: ScriptDeriveReq(
        n: kdfParams['n'],
        p: kdfParams['p'],
        r: kdfParams['r'],
        salt: salt.toU8a(),
        password: passphrase.plainToU8a(),
      ),
    );

    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey = Uint8List.fromList(
      [...scryptKey.leftBits, ...scryptKey.rightBits],
    );
  } else {
    final scryptKey = await AgentDartFFI.impl.pbkdf2DeriveKey(
      req: PBKDFDeriveReq(
        c: 262144,
        password: passphrase.plainToU8a(),
        salt: salt.toU8a(),
      ),
    );
    leftBits = scryptKey.leftBits;
    rightBits = scryptKey.rightBits;
    derivedKey = Uint8List.fromList(
      [...scryptKey.leftBits, ...scryptKey.rightBits],
    );
  }

  final List<int> cipherText = useCipherText?.toList() ??
      await _encryptPhraseAsync(
        key: Uint8List.fromList(leftBits),
        iv: Uint8List.fromList(iv),
        message: message!,
      );

  final List<int> macBuffer =
      rightBits + cipherText + iv + _algoIdentifier.codeUnits;

  final String mac = SHA256()
      .update(Uint8List.fromList(derivedKey))
      .update(macBuffer)
      .digest()
      .toHex();

  return NativeDeriveKeyResult(
    cipherText: cipherText,
    mac: mac,
    leftBits: leftBits,
    rightBits: rightBits,
    derivedKey: derivedKey,
  );
}

class NativeDeriveKeyResult {
  const NativeDeriveKeyResult({
    required this.mac,
    required this.cipherText,
    required this.leftBits,
    required this.rightBits,
    required this.derivedKey,
  });

  final String mac;
  final List<int> cipherText;
  final Uint8List leftBits;
  final Uint8List rightBits;
  final Uint8List derivedKey;
}
