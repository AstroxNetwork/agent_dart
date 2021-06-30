import 'dart:typed_data';

import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/authentication/authentication.dart';
import 'package:agent_dart/identity/delegation.dart';
import 'package:agent_dart/identity/identity.dart';
import 'package:flutter_test/flutter_test.dart';

SignIdentity createIdentity(int seed) {
  var seed1 = List.filled(32, 0);
  seed1[0] = seed;
  return Ed25519KeyIdentity.generate(Uint8List.fromList(seed1));
}

void main() {
  authenticationTest();
}

void authenticationTest() {
  test('checks expiration', () async {
    final root = createIdentity(0);
    final session = createIdentity(1);
    final future =
        DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + 1000);
    final past = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - 1000);

    // Create a valid delegation.
    expect(
        isDelegationValid(await DelegationChain.create(root, session.getPublicKey(), future), null),
        true);
    expect(
        isDelegationValid(await DelegationChain.create(root, session.getPublicKey(), past), null),
        false);
  });
}
