import 'dart:typed_data';

import 'package:agent_dart_base/agent/crypto/index.dart';
import 'package:agent_dart_base/principal/principal.dart';
import 'package:test/test.dart';
import 'package:agent_dart_base/utils/extension.dart';
import '../test_utils.dart';

void main() {
  principalTest();
}

void principalTest() {
  test('encodes properly', () {
    expect(
      Principal.fromHex('efcdab000000000001').toText(),
      '2chl6-4hpzw-vqaaa-aaaaa-c',
    );
    expect(Principal.fromHex('').toText(), 'aaaaa-aa');
    expect(Principal.anonymous().toText(), '2vxsx-fae');
  });

  test('parses properly', () {
    expect(
      Principal.fromText('2chl6-4hpzw-vqaaa-aaaaa-c').toHex(),
      'EFCDAB000000000001',
    );
    expect(Principal.fromText('aaaaa-aa').toHex(), '');
    expect(Principal.fromText('2vxsx-fae').toHex(), '04');
    expect(Principal.fromText('2vxsx-fae').isAnonymous(), true);
  });

  test('errors out on invalid checksums', () {
    // These are taken from above with the first character changed to make an invalid crc32.
    expect(
      () => Principal.fromText('0chl6-4hpzw-vqaaa-aaaaa-c').toHex(),
      throwsA(
        isError<ArgumentError>(
          'Principal expected to be 2chl6-4hpzw-vqaaa-aaaaa-c but got',
        ),
      ),
    );
    expect(
      () => Principal.fromText('0aaaa-aa').toHex(),
      throwsA(
        isError<ArgumentError>('Principal expected to be aaaaa-aa but got'),
      ),
    );
    expect(
      () => Principal.fromText('0vxsx-fae').toHex(),
      throwsA(
        isError<ArgumentError>('Principal expected to be 2vxsx-fae but got'),
      ),
    );
  });

  test('errors out on parsing invalid characters', () {
    expect(
      () => Principal.fromText('Hello world!'),
      throwsA(assertionThrowsContains('Invalid character')),
    );
  });
  test('ddd', () {
    final ddd = Principal.fromText('f3nhr-bmaaa-aaaaa-qaayq-cai');
    print(ddd.toUint8List());
    final first = Principal.fromText('rwlgt-iiaaa-aaaaa-aaaaa-cai');
    print(first.toUint8List());
    final ttt = Principal.fromText('2gyec-vyaaa-aaaah-acmua-cai');
    print(ttt.toUint8List());

    final ss = Principal.fromText("3ejs3-eaaaa-aaaag-qbl2a-cai").toAccountId(
        subAccount: fromPrincipal(Principal.fromText(
            "idbjp-7cvie-zfmuk-rphe5-sic4b-is6i5-edoui-by4kc-pemjv-lsgyg-gqe")));

    print(ss.toHex());
  });
}

Uint8List fromPrincipal(Principal principal) {
  final bytes = Uint8List(32)..fillRange(0, 32, 0);

  final principalBytes = principal.toUint8List();
  bytes[0] = principalBytes.length;

  for (var i = 0; i < principalBytes.length; i++) {
    bytes[1 + i] = principalBytes[i];
  }

  return bytes;
}
