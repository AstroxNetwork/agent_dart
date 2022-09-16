import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/principal/principal.dart';

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
}
