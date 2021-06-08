import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/principal/utils/base32.dart';
import 'package:agent_dart/utils/extension.dart';
// ignore: library_prefixes
import 'package:agent_dart/candid/idl.dart';

void main() {
  idlTest();
}

testEncode(CType typ, dynamic val, String hex, String _str) {
  expect(IDL.encode([typ], [val]).buffer.toHex(include0x: false), hex);
}

testDecode(CType typ, dynamic val, String hex, String _str) {
  expect(IDL.decode([typ], hex.toU8a())[0], val);
}

test_(CType typ, dynamic val, String hex, String _str) {
  testEncode(typ, val, hex, _str);
  testDecode(typ, val, hex, _str);
}

void idlTest() {
  test('IDL encoding (text)', () {
    // print(Int8List.fromList([1]).buffer.asUint8List());
    // Record
    // test_(IDL.Bool, true, '4449444c00017e01', 'true');
    // test_(IDL.Bool, false, '4449444c00017e00', 'false');
    // test_(IDL.Null, null, '4449444c00017f', 'Null value');
    // test_(IDL.Int, BigInt.zero, '4449444c00017c00', 'Int');
    // test_(IDL.Int, BigInt.from(42), '4449444c00017c2a', 'Int');
    // test_(IDL.Int, BigInt.from(1234567890), '4449444c00017cd285d8cc04', 'Positive Int');
    // test_(
    //   IDL.Int,
    //   BigInt.parse('60000000000000000'),
    //   '4449444c00017c808098f4e9b5caea00',
    //   'Positive BigInt',
    // );
    // test_(IDL.Int, BigInt.from(-1234567890), '4449444c00017caefaa7b37b', 'Negative Int');

    // test_(IDL.Nat, BigInt.from(42), '4449444c00017d2a', 'Nat');
    // test_(IDL.Nat, BigInt.from(0), '4449444c00017d00', 'Nat of 0');
    // test_(IDL.Nat, BigInt.from(1234567890), '4449444c00017dd285d8cc04', 'Positive Nat');
    // test_(IDL.Nat, BigInt.parse('60000000000000000'), '4449444c00017d808098f4e9b5ca6a',
    //     'Positive BigInt');

    // test_(IDL.Float64, 3, '4449444c0001720000000000000840', 'Float');
    // test_(IDL.Float64, 6, '4449444c0001720000000000001840', 'Float');
    // test_(IDL.Float64, 0.5, '4449444c000172000000000000e03f', 'Float');

    // test_(IDL.Float64, double.infinity, '4449444c000172000000000000f07f', '+infinity');
    // test_(IDL.Float64, double.negativeInfinity, '4449444c000172000000000000f0ff', '-infinity');

    // test_(IDL.Float64, double.maxFinite, '4449444c000172ffffffffffffef7f', '-max_value');
    // test_(IDL.Float64, double.minPositive, '4449444c0001720100000000000000', '-min_value');

    // test_(IDL.Int8, 0, '4449444c00017700', 'Int8');
    // test_(IDL.Int8, -1, '4449444c000177ff', 'Int8');
    // test_(IDL.Int8, 42, '4449444c0001772a', 'Int8');
    // test_(IDL.Int8, 127, '4449444c0001777f', 'Int8');
    // test_(IDL.Int8, -128, '4449444c00017780', 'Int8');
    // test_(IDL.Int32, 42, '4449444c0001752a000000', 'Int32');
    // test_(IDL.Int32, -42, '4449444c000175d6ffffff', 'Negative Int32');
    // test_(IDL.Int32, 1234567890, '4449444c000175d2029649', 'Positive Int32');
    // test_(IDL.Int32, -1234567890, '4449444c0001752efd69b6', 'Negative Int32');
    // test_(IDL.Int32, -0x7fffffff, '4449444c00017501000080', 'Negative Int32');
    // test_(IDL.Int32, 0x7fffffff, '4449444c000175ffffff7f', 'Positive Int32');
    // test_(IDL.Int64, BigInt.from(42), '4449444c0001742a00000000000000', 'Int64');
    // test_(IDL.Int64, BigInt.from(-42), '4449444c000174d6ffffffffffffff', 'Int64');
    // test_(IDL.Int64, BigInt.from(1234567890), '4449444c000174d202964900000000', 'Positive Int64');
    // test_(IDL.Nat8, 42, '4449444c00017b2a', 'Nat8');
    // test_(IDL.Nat8, 0, '4449444c00017b00', 'Nat8');
    // test_(IDL.Nat8, 255, '4449444c00017bff', 'Nat8');
    // test_(IDL.Nat32, 0, '4449444c00017900000000', 'Nat32');
    // test_(IDL.Nat32, 42, '4449444c0001792a000000', 'Nat32');
    // test_(IDL.Nat32, 0xffffffff, '4449444c000179ffffffff', 'Nat32');
    // test_(IDL.Nat64, BigInt.from(1234567890), '4449444c000178d202964900000000', 'Positive Nat64');

    test_(IDL.Record({}), {}, '4449444c016c000100', 'Empty record');
    test_(
      IDL.Record({"foo": IDL.Text, "bar": IDL.Int, "baz": IDL.Int}),
      {"foo": '💩', "bar": BigInt.from(42), "baz": BigInt.from(0)},
      '4449444c016c03d3e3aa027cdbe3aa027c868eb7027101002a0004f09f92a9',
      'Record',
    );

    test_(
      IDL.Record({"foo": IDL.Text, "bar": IDL.Int}),
      {"foo": '💩', "bar": BigInt.from(42)},
      '4449444c016c02d3e3aa027c868eb7027101002a04f09f92a9',
      'Record',
    );

    test_(
      IDL.Vec(IDL.Int),
      [0, 1, 2, 3].map((x) => BigInt.from(x)).toList(),
      '4449444c016d7c01000400010203',
      'Array of Ints',
    );

    test_(IDL.Tuple([IDL.Int8, IDL.Bool]), [42, true], '4449444c016c020077017e01002a01', 'Tuple');

    test_(
      IDL.Tuple([
        IDL.Tuple([IDL.Int8, IDL.Bool]),
        IDL.Record({"_0_": IDL.Int8, "_1_": IDL.Bool})
      ]),
      [
        [42, true],
        {"_0_": 42, "_1_": true}
      ],
      '4449444c026c020077017e6c020000010001012a012a01',
      'Tuple and Record',
    );

    // only support key as String
    test_(
      IDL.Record({"_2_": IDL.Int8, "2": IDL.Bool}),
      {"_2_": 42, "2": true},
      '4449444c016c020277327e01002a01',
      'Mixed record',
    );
    test_(
      IDL.Record({}),
      {},
      '4449444c016c000100',
      'Mixed record',
    );
  });
}
