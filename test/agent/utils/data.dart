import 'package:agent_dart/agent/crypto/bls.dart';
import 'package:agent_dart/agent/crypto/data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agent_dart/utils/extension.dart';

void main() {
  dataTest();
}

void dataTest() {
  test('encyptData', () async {
    const toEncrypt = 'I have a secret';
    const password = 'very cool password';

    final encrypted = await encryptData(toEncrypt, password);
    print(encrypted);
    final decrypted = await decryptData(encrypted, password);
    print("\n $decrypted");
    // expect(await encryptData(toEncrypt, pass), true);
  });
}
