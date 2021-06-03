import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/principal/utils/base32.dart';
import 'package:agent_dart/utils/extension.dart';

void main() {
  base32Test();
}

void base32Test() {
  test('base32Decode', () {
    expect(decode('irswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb').u8aToString(),
        "Decentralize everything!!");
  });

  test('base32Encode', () {
    expect(encode('Decentralize everything!!'.plainToU8a(useDartEncode: true)),
        'irswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb');
  });
}
