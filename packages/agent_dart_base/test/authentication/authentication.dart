import 'dart:typed_data';

import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:test/test.dart';

Future<SignIdentity> createIdentity(int seed) async {
  final seed1 = List.filled(32, 0);
  seed1[0] = seed;
  return Ed25519KeyIdentity.generate(Uint8List.fromList(seed1));
}

void main() {
  authenticationTest();
}

void authenticationTest() {
  test('checks expiration', () async {
    final root = await createIdentity(0);
    final session = await createIdentity(1);
    final future = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch + 1000,
    );
    final past = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch - 1000,
    );

    // Create a valid delegation.
    expect(
      isDelegationValid(
        await DelegationChain.create(root, session.getPublicKey(), future),
        null,
      ),
      true,
    );
    expect(
      isDelegationValid(
        await DelegationChain.create(root, session.getPublicKey(), past),
        null,
      ),
      false,
    );
  });
}
