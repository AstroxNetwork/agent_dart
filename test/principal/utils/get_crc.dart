import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/principal/utils/get_crc.dart';

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
