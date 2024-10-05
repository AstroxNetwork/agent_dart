import 'dart:typed_data';

import 'package:agent_dart/principal/principal.dart';
import 'package:flutter_test/flutter_test.dart';

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

    // ICRC-1
    expect(
      Principal.fromText(
        'k2t6j-2nvnp-4zjm3-25dtz-6xhaa-c7boj-5gayf-oj3xs-i43lp-teztq-6ae',
      ).toText(),
      'k2t6j-2nvnp-4zjm3-25dtz-6xhaa-c7boj-5gayf-oj3xs-i43lp-teztq-6ae',
    );
    expect(
      () => Principal.fromText(
        'k2t6j-2nvnp-4zjm3-25dtz-6xhaa-c7boj-5gayf-oj3xs-i43lp-teztq-6ae-q6bn32y.',
      ).toText(),
      throwsA(
        isError<ArgumentError>(
          'The representation is not canonical: '
          'default subaccount should be omitted.',
        ),
      ),
    );
    expect(
      Principal.fromText(
        'k2t6j-2nvnp-4zjm3-25dtz-6xhaa-c7boj-5gayf-oj3xs-i43lp-teztq-6ae-6cc627i.1',
      ).toText(),
      'k2t6j-2nvnp-4zjm3-25dtz-6xhaa-c7boj-5gayf-oj3xs-i43lp-teztq-6ae-6cc627i.1',
    );
    expect(
      () => Principal.fromText(
        'k2t6j-2nvnp-4zjm3-25dtz-6xhaa-c7boj-5gayf-oj3xs-i43lp-teztq-6ae-6cc627i.01',
      ).toText(),
      throwsA(
        isError<ArgumentError>(
          'The representation is not canonical: '
          'leading zeros are not allowed in subaccounts.',
        ),
      ),
    );
    expect(
      () => Principal.fromText(
        'k2t6j-2nvnp-4zjm3-25dtz-6xhaa-c7boj-5gayf-oj3xs-i43lp-teztq-6ae.1',
      ).toText(),
      throwsA(
        isError<ArgumentError>('Missing checksum'),
      ),
    );
    expect(
      Principal.fromText(
        'k2t6j-2nvnp-4zjm3-25dtz-6xhaa-c7boj-5gayf-oj3xs-i43lp-teztq-6ae-dfxgiyy'
        '.102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20',
      ).toText(),
      'k2t6j-2nvnp-4zjm3-25dtz-6xhaa-c7boj-5gayf-oj3xs-i43lp-teztq-6ae-dfxgiyy'
      '.102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20',
    );
    expect(
      Principal.fromText(
        'z4s7u-byaaa-aaaao-a3paa-cai-l435n4y'
        '.1de15338bedf41b306d4ef5615d1f94fd7b0474b9255690cbe78d2309f02',
      ).toText(),
      'z4s7u-byaaa-aaaao-a3paa-cai-l435n4y'
      '.1de15338bedf41b306d4ef5615d1f94fd7b0474b9255690cbe78d2309f02',
    );
    expect(
      Principal(
        Uint8List.fromList([0, 0, 0, 0, 0, 224, 17, 26, 1, 1]),
        subAccount: Uint8List(32),
      ).toText(),
      'lrllq-iqaaa-aaaah-acena-cai',
    );
  });

  test('errors out on invalid checksums', () {
    // These are taken from above with the first character changed to make an invalid crc32.
    expect(
      () => Principal.fromText('0chl6-4hpzw-vqaaa-aaaaa-c').toHex(),
      throwsA(
        isError<ArgumentError>(
          'The principal is expected to be 2chl6-4hpzw-vqaaa-aaaaa-c but got',
        ),
      ),
    );
    expect(
      () => Principal.fromText('0aaaa-aa').toHex(),
      throwsA(
        isError<ArgumentError>(
          'The principal is expected to be aaaaa-aa but got',
        ),
      ),
    );
    expect(
      () => Principal.fromText('0vxsx-fae').toHex(),
      throwsA(
        isError<ArgumentError>(
          'The principal is expected to be 2vxsx-fae but got',
        ),
      ),
    );
  });

  test('errors out on parsing invalid characters', () {
    expect(
      () => Principal.fromText('Hello world!'),
      throwsA(assertionThrowsContains('Invalid character')),
    );
  });
}
