import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'is.dart' as is_test;

void main() {
  ffiInit();
  is_test.main();

  test('Hex string to u8', () {
    final u8 = 'efcdab000000000001'.toU8a();
    expect(u8.length, equals(9));
    expect(u8.toString(), '[239, 205, 171, 0, 0, 0, 0, 0, 1]');
  });
}
