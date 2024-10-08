import 'package:agent_dart_base/principal/utils/base32.dart';
import 'package:agent_dart_base/utils/extension.dart';
import 'package:test/test.dart';

void main() {
  base32Test();
}

void base32Test() {
  test('base32Decode', () {
    expect(
      base32Decode('irswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb').u8aToString(),
      'Decentralize everything!!',
    );
  });

  test('base32Encode', () {
    expect(
      base32Encode(
        'Decentralize everything!!'.plainToU8a(useDartEncode: true),
      ),
      'irswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb',
    );
  });
}