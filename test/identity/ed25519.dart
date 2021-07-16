import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/identity/ed25519.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:agent_dart/utils/extension.dart';

void main() {
  ed25519Test();
}

void ed25519Test() {
  final testVectors = [
    [
      'B3997656BA51FF6DA37B61D8D549EC80717266ECF48FB5DA52B654412634844C',
      '302A300506032B6570032100B3997656BA51FF6DA37B61D8D549EC80717266ECF48FB5DA52B654412634844C',
    ],
    [
      'A5AFB5FEB6DFB6DDF5DD6563856FFF5484F5FE304391D9ED06697861F220C610',
      '302A300506032B6570032100A5AFB5FEB6DFB6DDF5DD6563856FFF5484F5FE304391D9ED06697861F220C610',
    ],
    [
      'C8413108F121CB794A10804D15F613E40ECC7C78A4EC567040DDF78467C71DFF',
      '302A300506032B6570032100C8413108F121CB794A10804D15F613E40ECC7C78A4EC567040DDF78467C71DFF',
    ],
  ];

  const testVectorsSLIP10 = [
    {
      "seed": "000102030405060708090a0b0c0d0e0f",
      "privateKey": "2b4be7f19ee27bbf30c667b642d5f4aa69fd169872f8fc3059c08ebae2eb19e7",
      "publicKey": "a4b2856bfec510abab89753fac1ac0e1112364e7d250545963f135f2a33188ed",
    },
    {
      "seed": "000102030405060708090a0b0c0d0e0f",
      "privateKey": "68e0fe46dfb67e368c75379acec591dad19df3cde26e63b93a8e704f1dade7a3",
      "publicKey": "8c8a13df77a28f3445213a0f432fde644acaa215fc72dcdf300d5efaa85d350c",
      "derivationPath": [0],
    },
    {
      "seed": "000102030405060708090a0b0c0d0e0f",
      "privateKey": "b1d0bad404bf35da785a64ca1ac54b2617211d2777696fbffaf208f746ae84f2",
      "publicKey": "1932a5270f335bed617d5b935c80aedb1a35bd9fc1e31acafd5372c30f5c1187",
      "derivationPath": [0, 1],
    },
    {
      "seed": "000102030405060708090a0b0c0d0e0f",
      "privateKey": "92a5b23c0b8a99e37d07df3fb9966917f5d06e02ddbd909c7e184371463e9fc9",
      "publicKey": "ae98736566d30ed0e9d2f4486a64bc95740d89c7db33f52121f8ea8f76ff0fc1",
      "derivationPath": [0, 1, 2],
    },
    {
      "seed": "000102030405060708090a0b0c0d0e0f",
      "privateKey": "30d1dc7e5fc04c31219ab25a27ae00b50f6fd66622f6e9c913253d6511d1e662",
      "publicKey": "8abae2d66361c879b900d204ad2cc4984fa2aa344dd7ddc46007329ac76c429c",
      "derivationPath": [0, 1, 2, 2],
    },
    {
      "seed": "000102030405060708090a0b0c0d0e0f",
      "privateKey": "8f94d394a8e8fd6b1bc2f3f49f5c47e385281d5c17e65324b0f62483e37e8793",
      "publicKey": "3c24da049451555d51a7014a37337aa4e12d41e485abccfa46b47dfb2af54b7a",
      "derivationPath": [0, 1, 2, 2, 1000000000],
    },
  ];
  test('DER encoding of ED25519 keys', () async {
    for (var pair in testVectors) {
      final publicKey = Ed25519PublicKey.fromRaw(blobFromHex(pair[0]));
      final expectedDerPublicKey = blobFromHex(pair[1]);
      expect(publicKey.toDer(), expectedDerPublicKey);
    }
  });

  test('DER decoding of ED25519 keys', () async {
    for (var pair in testVectors) {
      final derPublicKey = blobFromHex(pair[1]);
      final expectedPublicKey = blobFromHex(pair[0]);
      expect(Ed25519PublicKey.fromDer(derPublicKey).toRaw(), expectedPublicKey);
    }
  });

  // test('DER encoding of invalid keys', () async {
  //   expect(() {
  //     Ed25519PublicKey.fromRaw(blobFromUint8Array(Buffer.alloc(31, 0))).toDer();
  //   }).toThrow();
  //   expect(() {
  //     Ed25519PublicKey.fromRaw(blobFromUint8Array(Buffer.alloc(31, 0))).toDer();
  //   }).toThrow();
  // });

  // test('DER decoding of invalid keys', () async {
  //   // Too short.
  //   expect(() {
  //     Ed25519PublicKey.fromDer(
  //       blobFromHex(
  //         '302A300506032B6570032100B3997656BA51FF6DA37B61D8D549EC80717266ECF48FB5DA52B65441263484',
  //       ),
  //     );
  //   }).toThrow();
  //   // Too long.
  //   expect(() {
  //     Ed25519PublicKey.fromDer(
  //       blobFromHex(
  //         '302A300506032B6570032100B3997656BA51FF6DA37B61D8D549EC8071726' +
  //             '6ECF48FB5DA52B654412634844C00',
  //       ),
  //     );
  //   }).toThrow();

  //   // Invalid DER-encoding.
  //   expect(() {
  //     Ed25519PublicKey.fromDer(
  //       blobFromHex(
  //         '002A300506032B6570032100B3997656BA51FF6DA37B61D8D549EC80717266ECF48FB5DA52B654412634844C',
  //       ),
  //     );
  //   }).toThrow();
  // });

  // test('fails with improper seed', () {
  //   expect(() => Ed25519KeyIdentity.generate(Uint8List.fromList(new Array(31).fill(0)))).toThrow();
  //   expect(() => Ed25519KeyIdentity.generate(Uint8List.fromList(new Array(33).fill(0)))).toThrow();
  // });

  test('can encode and decode to/from JSON', () async {
    final seed = List.filled(32, 0);
    final key = Ed25519KeyIdentity.generate(Uint8List.fromList(seed));

    final json = jsonEncode(key.getKeyPair());
    final key2 = Ed25519KeyIdentity.fromJSON(json);
    expect(key.toJSON(), key2.toJSON());
  });

  test('can encode and decode to/from JSON (backward compatibility)', () async {
    final seed = List.filled(32, 0);
    final key = Ed25519KeyIdentity.generate(Uint8List.fromList(seed));

    // This is the JSON that was generated by the first version.
    final json = jsonEncode({
      "publicKey": blobFromHex('3b6a27bcceb6a42d62a3a8d02a6f0d73653215771de243a63ac048a18b59da29'),
      "secretKey": blobFromHex(
        // ignore: prefer_adjacent_string_concatenation
        '0000000000000000000000000000000000000000000000000000000000000000' +
            '3b6a27bcceb6a42d62a3a8d02a6f0d73653215771de243a63ac048a18b59da29',
      ),
    });

    final key2 = Ed25519KeyIdentity.fromJSON(json);
    expect(key.toJSON(), key2.toJSON());
  });

  test("derive Ed25519 via SLIP 0010", () {
    for (var testVector in testVectorsSLIP10) {
      final seedBlob = blobFromHex(testVector["seed"] as String);
      final expectedPrivateKey = blobFromHex(testVector["privateKey"] as String);
      final expectedPublicKey = blobFromHex(testVector["publicKey"] as String);

      var identity = fromSeedWithSlip0010(seedBlob, testVector["derivationPath"] as List<int>?);

      final keyPair = identity.getKeyPair();

      expect(keyPair.secretKey.sublist(0, 32), expectedPrivateKey);
      expect(keyPair.publicKey.toDer().toHex(),
          Ed25519PublicKey.fromRaw(expectedPublicKey).toDer().toHex());
    }
  });
}
