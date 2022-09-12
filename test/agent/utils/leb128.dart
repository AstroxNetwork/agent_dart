import 'dart:typed_data';

import 'package:agent_dart/agent/utils/buffer_pipe.dart';
import 'package:agent_dart/agent/utils/leb128.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agent_dart/utils/extension.dart';

void main() {
  leb128Test();
}

void leb128Test() {
  test('leb', () {
    expect(lebEncode(0).toHex(), '00');
    expect(lebEncode(7).toHex(), '07');
    expect(lebEncode(127).toHex(), '7f');
    // expect(() => lebEncode(-1).toString('hex')).toThrow();
    expect(lebEncode(1).toHex(), '01');
    expect(lebEncode(624485).toHex(), 'e58e26');
    expect(
      lebEncode('0x1234567890abcdef1234567890abcdef'.hexToBn()).toHex(),
      'ef9baf8589cf959a92deb7de8a929eabb424',
    );
    expect(lebEncode(BigInt.from(2000000)).toHex(), '80897a');
    expect(
      lebEncode(BigInt.from(60000000000000000)).toHex(),
      '808098f4e9b5ca6a',
    );

    expect(lebDecode(BufferPipe<int>(Uint8List.fromList([0]))), BigInt.zero);
    expect(lebDecode(BufferPipe<int>(Uint8List.fromList([1]))), BigInt.one);
    expect(
      lebDecode(BufferPipe<int>(Uint8List.fromList([0xe5, 0x8e, 0x26]))),
      BigInt.from(624485),
    );
    expect(
      lebDecode(
        BufferPipe<int>('ef9baf8589cf959a92deb7de8a929eabb424'.toU8a()),
      ).toHex().hexStripPrefix(),
      '1234567890abcdef1234567890abcdef',
    );
  });

  test('sleb', () {
    expect(slebEncode(-1).toHex(), '7f');
    expect(slebEncode(-123456).toHex(), 'c0bb78');
    expect(slebEncode(42).toHex(), '2a');
    expect(
      slebEncode('0x1234567890abcdef1234567890abcdef'.hexToBn()).toHex(),
      'ef9baf8589cf959a92deb7de8a929eabb424',
    );
    expect(
      slebEncode(-'0x1234567890abcdef1234567890abcdef'.hexToBn()).toHex(),
      '91e4d0faf6b0eae5eda1c8a1f5ede1d4cb5b',
    );
    expect(
      slebEncode(BigInt.parse('2000000')).toHex(),
      '8089fa00',
    );
    expect(
      slebEncode(BigInt.parse('60000000000000000')).toHex(),
      '808098f4e9b5caea00',
    );

    expect(
      slebDecode(BufferPipe<int>(Uint8List.fromList([0x7f]))),
      BigInt.from(-1),
    );
    expect(
      slebDecode(BufferPipe<int>(Uint8List.fromList([0xc0, 0xbb, 0x78])))
          .toInt(),
      -123456,
    );
    expect(
      slebDecode(BufferPipe<int>(Uint8List.fromList([0x2a]))),
      BigInt.from(42),
    );
    expect(
      slebDecode(
        BufferPipe<int>(
          '91e4d0faf6b0eae5eda1c8a1f5ede1d4cb5b'.toU8a(),
        ),
      ).toRadixString(16),
      '-1234567890abcdef1234567890abcdef',
    );
    expect(
      slebDecode(BufferPipe<int>('808098f4e9b5caea00'.toU8a())).toString(),
      '60000000000000000',
    );
  });

  test('IntLE', () {
    expect(writeIntLE(42, 2).toHex(), '2a00');
    expect(writeIntLE(-42, 3).toHex(), 'd6ffff');
    expect(writeIntLE(1234567890, 5).toHex(), 'd202964900');
    expect(writeUIntLE(1234567890, 5).toHex(), 'd202964900');
    expect(writeIntLE(-1234567890, 5).toHex(), '2efd69b6ff');
    expect(
      readIntLE(BufferPipe<int>('d202964900'.toU8a()), 5).toString(),
      '1234567890',
    );
    expect(
      readUIntLE(BufferPipe<int>('d202964900'.toU8a()), 5).toString(),
      '1234567890',
    );
    expect(
      readIntLE(BufferPipe<int>('2efd69b6ff'.toU8a()), 5).toString(),
      '-1234567890',
    );
    expect(
      readIntLE(BufferPipe<int>('d6ffffffff'.toU8a()), 5).toString(),
      '-42',
    );
    expect(
      readUIntLE(BufferPipe<int>('d6ffffffff'.toU8a()), 5).toString(),
      '1099511627734',
    );
  });
}
