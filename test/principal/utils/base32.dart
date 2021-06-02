import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/principal/utils/base32.dart';
import 'package:agent_dart/principal/utils/u8a.dart';

void main() {
  base32Test();
}

void base32Test() {
  test('base32Decode', () {
    expect(decode('irswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb').toUtf8String(),
        "Decentralize everything!!");
  });

  test('base32Encode', () {
    expect(encode('Decentralize everything!!'.plainToU8a(useDartEncode: true)),
        'irswgzloorzgc3djpjssazlwmvzhs5dinfxgoijb');
  });
}
