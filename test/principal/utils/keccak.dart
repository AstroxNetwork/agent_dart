import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/utils/keccak.dart';
import 'package:agent_dart/agent_dart.dart';

void main() {
  keccak256Test();
}

void keccak256Test() {
  test('getCrc32', () async {
    expect((await keccak256("hello".plainToU8a())).toHex(),
        '1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8');
  });
}
