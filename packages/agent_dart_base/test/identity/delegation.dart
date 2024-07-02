import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart_base/agent/agent.dart';
import 'package:agent_dart_base/identity/delegation.dart';
import 'package:agent_dart_base/identity/ed25519.dart';
import 'package:agent_dart_base/principal/principal.dart';
import 'package:agent_dart_base/utils/extension.dart';
import 'package:test/test.dart';
import '../test_utils.dart';

Future<SignIdentity> createIdentity(int seed) {
  final s = Uint8List.fromList([seed, ...List.filled(31, 0)]);
  return Ed25519KeyIdentity.generate(s);
}

// BinaryBlob h(String text) {
//   return blobFromHex(text.codeUnits.);
// }
void main() {
  ffiInit();
  // matchFFI();
  delegationTest();
}

void delegationTest() {
  test('delegation signs with proper keys (3)', () async {
    final root = await createIdentity(2);
    final middle = await createIdentity(1);
    final bottom = await createIdentity(0);

    final rootToMiddle = await DelegationChain.create(
      root,
      middle.getPublicKey(),
      DateTime.fromMillisecondsSinceEpoch(1609459200000),
    );
    final middleToBottom = await DelegationChain.create(
      middle,
      bottom.getPublicKey(),
      DateTime.fromMillisecondsSinceEpoch(1609459200000),
      previous: rootToMiddle,
    );

    final result = {
      'delegations': [
        {
          'delegation': {
            'expiration': BigInt.parse('1609459200000000000').toHex(),
            'pubkey':
                '302A300506032B6570032100CECC1507DC1DDD7295951C290888F095ADB9044D1B73D696E6DF065D683BD4FC'
                    .toLowerCase(),
          },
          'signature':
              'B106D135E5AD7459DC67DB68A4946FDBE603E650DF4035957DB7F0FB54E7467BB463116A2AD025E1887CD1F29025E0F3607B09924ABBBBEBFAF921B675C8FF08'
                  .toLowerCase(),
        },
        {
          'delegation': {
            'expiration': BigInt.parse('1609459200000000000').toHex(),
            'pubkey':
                '302A300506032B65700321003B6A27BCCEB6A42D62A3A8D02A6F0D73653215771DE243A63AC048A18B59DA29'
                    .toLowerCase(),
          },
          'signature':
              '5E40F3D171E499A691092E5B961B5447921091BCF8C6409CB5641541F4DC1390F501C5DFB16B10DF29D429CD153B9E396AF4E883ED3CFA090D28E214DB14C308'
                  .toLowerCase(),
        },
      ],
      'publicKey':
          '302A300506032B65700321006B79C57E6A095239282C04818E96112F3F03A4001BA97A564C23852A3F1EA5FC'
              .toLowerCase(),
    };
    expect(middleToBottom.toJson(), result);
  });
  test('DelegationChain can be serialized to and from JSON', () async {
    final root = await createIdentity(2);
    final middle = await createIdentity(1);
    final bottom = await createIdentity(0);

    final rootToMiddle = await DelegationChain.create(
      root,
      middle.getPublicKey(),
      DateTime.fromMillisecondsSinceEpoch(1609459200000),
      targets: [Principal.fromText('jyi7r-7aaaa-aaaab-aaabq-cai')],
    );
    final middleToBottom = await DelegationChain.create(
      middle,
      bottom.getPublicKey(),
      DateTime.fromMillisecondsSinceEpoch(1609459200000),
      previous: rootToMiddle,
      targets: [Principal.fromText('u76ha-lyaaa-aaaab-aacha-cai')],
    );

    final rootToMiddleJson = jsonEncode(rootToMiddle.toJson());

    // print(rootToMiddleJson);
    // All strings in the JSON should be hex so it is clear how to decode this as different versions of `toJson` evolve.
    final revived = jsonDecode(
      rootToMiddleJson,
      reviver: (key, value) {
        if (value is String) {
          final byte = BigInt.tryParse(value, radix: 16);
          if (byte == null) {
            throw StateError('expected hex string but got $value.');
          }
        }
        return value;
      },
    );

    final rootToMiddleActual = DelegationChain.fromJSON(revived);

    expect(rootToMiddleActual.toJson(), rootToMiddle.toJson());

    final middleToBottomJson = jsonEncode(middleToBottom.toJson());
    final middleToBottomActual = DelegationChain.fromJSON(middleToBottomJson);
    expect(middleToBottomActual.toJson(), middleToBottom.toJson());
  });
}
