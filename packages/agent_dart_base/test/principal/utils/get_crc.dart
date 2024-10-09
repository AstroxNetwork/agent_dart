import 'dart:typed_data';

import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:test/test.dart';

void main() {
  getCrc32Test();
}

void getCrc32Test() {
  test('getCrc32', () {
    expect(getCrc32(Uint8List.fromList([]).buffer), 0);
    expect(getCrc32(Uint8List.fromList([1, 2, 3]).buffer), 0x55bc801d);
    expect(
      getCrc32(Uint8List.fromList([100, 99, 98, 1, 2, 3]).buffer),
      0xc7e787f5,
    );
  });
}
