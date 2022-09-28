import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/is.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  isTest();
}

void isTest() {
  test('isHex', () {
    const testNum = '1234abcd';
    expect(isHex('0x'), true); // true
    expect(isHex('0x$testNum'), true); // true
    expect(isHex('0x${testNum}0'), false); // false
    expect(isHex('0x${testNum.toUpperCase()}'), true); // true
    expect(isHex(testNum), false); // false
    expect(isHex(false), false); // false
    expect(isHex('0x1234', 16), true); // true
    expect(isHex('0x1234', 8), false); // false
    expect(isHex('1234'), false); // false
    // print("\n");
  });

  test('isJsonObject', () {
    const jsonObject = {
      'Test': '1234',
      'NestedTest': {'Test': '5678'}
    };
    expect(isJsonObject('{}'), true); // true
    expect(isJsonObject(jsonEncode(jsonObject)), true); // true
    expect(isJsonObject(123), false); // false
    expect(isJsonObject(null), false); // false
    expect(isJsonObject('asdfasdf'), false); // false
    expect(isJsonObject("{'abc','def'}"), false); // false
    // print("\n");
  });

  test('testChain', () {
    expect(isTestChain('Development'), true);
    expect(isTestChain('Local Testnet'), true);

    const invalidTestModeChainSpecs = [
      'dev',
      'local',
      'development',
      'PoC-1 Testnet',
      'Staging Testnet',
      'future PoC-2 Testnet',
      'a pocadot?',
    ];
    for (final s in invalidTestModeChainSpecs) {
      expect(isTestChain(s), false);
    }
    // print("\n");
  });

  test('isUtf8', () {
    expect(isUtf8('Hello\tWorld!\n\rTesting'), true); // true
    expect(isUtf8(Uint8List.fromList([0x31, 0x32, 0x20, 10])), true); // true
    expect(isUtf8(''), true); // true
    expect(isUtf8([]), true); // true
    expect(isUtf8('Приветствую, ми'), true); // true
    expect(isUtf8('你好'), true); // true
    expect(
      isUtf8(
        '0x7f07b1f87709608bee603bbc79a0dfc29cd315c1351a83aa31adf7458d7d3003',
      ),
      false,
    ); // false
    // print("\n");
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
