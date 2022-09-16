import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/is.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Hex string to u8', () {
    final u8 = 'efcdab000000000001'.toU8a();
    expect(u8.length, equals(9));
    expect(u8.toString(), '[239, 205, 171, 0, 0, 0, 0, 0, 1]');
  });

  test('test isAccountId', () {
    final aid = Principal.fromText('snnxh-zyaaa-aaaah-abrfq-cai').toAccountId();
    expect(isAccountId(aid.toHex()), true);
    // length dont match
    expect(
      isAccountId('6202e688b3aae334a9c7ad11ed2e7c41a89b940b81bad4b3d95b2d49d0'),
      false,
    );
    // not hex
    expect(isAccountId('hello: i am dump string'), false);

    // not matching checksum
    expect(
      isAccountId(
        '6202e688b3aae334a9c7ad11ed2e7c41a89b940b81bad4b00000000000000000',
      ),
      false,
    );
  });
}
