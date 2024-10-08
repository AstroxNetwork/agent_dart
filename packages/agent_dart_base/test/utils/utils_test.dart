import 'package:agent_dart_base/utils/extension.dart';
import 'package:test/test.dart';

import 'is.dart' as is_test;

void main() {
  is_test.main();

  test('Hex string to u8', () {
    final u8 = 'efcdab000000000001'.toU8a();
    expect(u8.length, equals(9));
    expect(u8.toString(), '[239, 205, 171, 0, 0, 0, 0, 0, 1]');
  });
}
