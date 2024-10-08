import 'dart:typed_data';

import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
// ignore: library_prefixes

void main() {
  idlTest();
}

void testEncode(CType type, dynamic val, String hex, String str) {
  expect(IDL.encode([type], [val]).toHex(), hex);
}

void testDecode(CType type, dynamic val, String hex, String str) {
  expect(IDL.decode([type], hex.toU8a())[0], val);
}

void testArg(CType type, dynamic val, String hex, String str) {
  testEncode(type, val, hex, str);
  testDecode(type, val, hex, str);
}

void testArgs(List<CType> types, List vals, String hex, String str) {
  expect(IDL.encode(types, vals), hex.toU8a());
  expect(IDL.decode(types, hex.toU8a()), vals);
}

void idlTest() {
  test('IDL encoding (magic number)', () {
    // Wrong magic number
    expect(
      () => IDL.decode([IDL.Nat], '2a'.toU8a()),
      throwsA(
        isError<RangeError>(
          'Message length is smaller than the magic number',
        ),
      ),
    );
    expect(
      () => IDL.decode([IDL.Nat], '4449444d2a'.toU8a()),
      throwsA(
        isError<StateError>('Wrong magic number: DIDM.'),
      ),
    );
  });

  test('IDL encoding (empty)', () {
    // Empty
    expect(
      () => IDL.encode([IDL.Empty], [null]),
      throwsA(isError<ArgumentError>()),
    );
    expect(
      () => IDL.decode([IDL.Empty], '4449444c00016f'.toU8a()),
      throwsA(
        isError<UnsupportedError>('Empty cannot appear as an output.'),
      ),
    );
  });

  test('IDL encoding (null)', () {
    // Null
    testArg(IDL.Null, null, '4449444c00017f', 'Null value');
  });

  test('IDL encoding (text)', () {
    // Text
    testArg(
      IDL.Text,
      'Hi ☃\n',
      '4449444c00017107486920e298830a',
      'Text with unicode',
    );
    testArg(
      IDL.Opt(IDL.Text),
      ['Hi ☃\n'],
      '4449444c016e7101000107486920e298830a',
      'Nested text with unicode',
    );
    expect(
      () => IDL.encode([IDL.Text], [0]),
      throwsA(isError<ArgumentError>()),
    );
    expect(
      () => IDL.encode([IDL.Text], [null]),
      throwsA(isError<ArgumentError>()),
    );
    expect(
      () => IDL.decode(
        [IDL.Vec(IDL.Nat8)],
        '4449444c00017107486920e298830a'.toU8a(),
      ),
      throwsA(isError<TypeError>()),
    );
  });

  test('IDL encoding (int)', () {
    // Int
    testArg(IDL.Int, BigInt.from(0), '4449444c00017c00', 'Int');
    testArg(IDL.Int, BigInt.from(42), '4449444c00017c2a', 'Int');
    testArg(
      IDL.Int,
      BigInt.from(1234567890),
      '4449444c00017cd285d8cc04',
      'Positive Int',
    );
    testArg(
      IDL.Int,
      BigInt.parse('60000000000000000'),
      '4449444c00017c808098f4e9b5caea00',
      'Positive BigInt',
    );
    testArg(
      IDL.Int,
      BigInt.from(-1234567890),
      '4449444c00017caefaa7b37b',
      'Negative Int',
    );
    testArg(
      IDL.Opt(IDL.Int),
      [BigInt.from(42)],
      '4449444c016e7c0100012a',
      'Nested Int',
    );
    testEncode(
      IDL.Opt(IDL.Int),
      [42],
      '4449444c016e7c0100012a',
      'Nested Int (number)',
    );
    expect(
      () => IDL.decode([IDL.Int], '4449444c00017d2a'.toU8a()),
      throwsA(isError<TypeError>()),
    );
  });

  test('IDL encoding (nat)', () {
    // Nat
    testArg(IDL.Nat, BigInt.from(42), '4449444c00017d2a', 'Nat');
    testArg(IDL.Nat, BigInt.from(0), '4449444c00017d00', 'Nat of 0');
    testArg(
      IDL.Nat,
      BigInt.from(1234567890),
      '4449444c00017dd285d8cc04',
      'Positive Nat',
    );
    testArg(
      IDL.Nat,
      BigInt.parse('60000000000000000'),
      '4449444c00017d808098f4e9b5ca6a',
      'Positive BigInt',
    );
    testEncode(
      IDL.Opt(IDL.Nat),
      [BigInt.from(42)],
      '4449444c016e7d0100012a',
      'Nested Nat (number)',
    );
    expect(
      () => IDL.encode([IDL.Nat], [-1]),
      throwsA(isError<ArgumentError>()),
    );
  });

  test('IDL encoding (float64)', () {
    // Float64
    testArg(IDL.Float64, 3, '4449444c0001720000000000000840', 'Float');
    testArg(IDL.Float64, 6, '4449444c0001720000000000001840', 'Float');
    testArg(IDL.Float64, 0.5, '4449444c000172000000000000e03f', 'Float');
    // test_(IDL.Float64, Number.NaN, '4449444c000172010000000000f07f', 'NaN');
    testArg(
      IDL.Float64,
      double.infinity,
      '4449444c000172000000000000f07f',
      '+infinity',
    );
    testArg(
      IDL.Float64,
      double.negativeInfinity,
      '4449444c000172000000000000f0ff',
      '-infinity',
    );
    // test_(IDL.Float64, 4.94065645841247E-324, '4449444c000172000000000000b03c', 'eps');
    testArg(
      IDL.Float64,
      double.minPositive,
      '4449444c0001720100000000000000',
      'min_value',
    );
    testArg(
      IDL.Float64,
      double.maxFinite,
      '4449444c000172ffffffffffffef7f',
      'max_value',
    );
    // test_(IDL.Float64, (-(2 ^ 53 - 1)).toDouble(), '4449444c000172ffffffffffff3fc3',
    //     'min_safe_integer');
    // test_(
    //     IDL.Float64, (2 ^ 53 - 1).toDouble(), '4449444c000172ffffffffffff3f43', 'max_safe_integer');
  });

  test('IDL encoding (fixed-width number)', () {
    // Fixed-width number
    testArg(IDL.Int8, 0, '4449444c00017700', 'Int8');
    testArg(IDL.Int8, -1, '4449444c000177ff', 'Int8');
    testArg(IDL.Int8, 42, '4449444c0001772a', 'Int8');
    testArg(IDL.Int8, 127, '4449444c0001777f', 'Int8');
    testArg(IDL.Int8, -128, '4449444c00017780', 'Int8');
    testArg(IDL.Int32, 42, '4449444c0001752a000000', 'Int32');
    testArg(IDL.Int32, -42, '4449444c000175d6ffffff', 'Negative Int32');
    testArg(IDL.Int32, 1234567890, '4449444c000175d2029649', 'Positive Int32');
    testArg(IDL.Int32, -1234567890, '4449444c0001752efd69b6', 'Negative Int32');
    testArg(IDL.Int32, -0x7fffffff, '4449444c00017501000080', 'Negative Int32');
    testArg(IDL.Int32, 0x7fffffff, '4449444c000175ffffff7f', 'Positive Int32');
    testArg(
      IDL.Int64,
      BigInt.from(42),
      '4449444c0001742a00000000000000',
      'Int64',
    );
    testArg(
      IDL.Int64,
      BigInt.from(-42),
      '4449444c000174d6ffffffffffffff',
      'Int64',
    );
    testArg(
      IDL.Int64,
      BigInt.from(1234567890),
      '4449444c000174d202964900000000',
      'Positive Int64',
    );
    testArg(IDL.Nat8, 42, '4449444c00017b2a', 'Nat8');
    testArg(IDL.Nat8, 0, '4449444c00017b00', 'Nat8');
    testArg(IDL.Nat8, 255, '4449444c00017bff', 'Nat8');
    testArg(IDL.Nat32, 0, '4449444c00017900000000', 'Nat32');
    testArg(IDL.Nat32, 42, '4449444c0001792a000000', 'Nat32');
    testArg(IDL.Nat32, 0xffffffff, '4449444c000179ffffffff', 'Nat32');
    testArg(
      IDL.Nat64,
      BigInt.from(1234567890),
      '4449444c000178d202964900000000',
      'Positive Nat64',
    );
    expect(
      () => IDL.encode([IDL.Nat32], [-42]),
      throwsA(isError<ArgumentError>()),
    );
    expect(
      () => IDL.encode([IDL.Int8], [256]),
      throwsA(isError<ArgumentError>()),
    );
    expect(
      () => IDL.encode([IDL.Int32], [0xffffffff]),
      throwsA(isError<ArgumentError>()),
    );
  });

  test('IDL encoding (tuple)', () {
    // Tuple
    testArg(
      IDL.Tuple([IDL.Int, IDL.Text]),
      [BigInt.from(42), '💩'],
      '4449444c016c02007c017101002a04f09f92a9',
      'Pairs',
    );
    expect(
      () => IDL.encode([
        IDL.Tuple([IDL.Int, IDL.Text]),
      ], [
        [0],
      ]),
      throwsA(isError<ArgumentError>()),
    );
  });

  test('IDL encoding (arraybuffer)', () {
    testArg(
      IDL.Vec(IDL.Nat8),
      Uint8List.fromList([0, 1, 2, 3]),
      '4449444c016d7b01000400010203',
      'Array of Nat8s',
    );
    testArg(
      IDL.Vec(IDL.Int8),
      Int8List.fromList([0, 1, 2, 3]),
      '4449444c016d7701000400010203',
      'Array of Int8s',
    );
    testArg(
      IDL.Vec(IDL.Int16),
      Int16List.fromList([0, 1, 2, 3, 32767, -1]),
      '4449444c016d760100060000010002000300ff7fffff',
      'Array of Int16s',
    );
    testArg(
      IDL.Vec(IDL.Nat64),
      <BigInt>[
        BigInt.from(0),
        BigInt.from(1),
        BigInt.from(1) << 60,
        BigInt.from(13),
      ],
      '4449444c016d780100040000000000000000010000000000000000000000000000100d00000000000000',
      'Array of Nat64s',
    );
    IDL.encode([IDL.Vec(IDL.Nat8)], [Uint8List.fromList([])]);
    IDL.encode([IDL.Vec(IDL.Nat8)], [Uint8List.fromList(List.filled(100, 42))]);
    IDL.encode(
      [IDL.Vec(IDL.Nat16)],
      [Uint16List.fromList(List.filled(200, 42))],
    );
  });

  test('IDL encoding (array)', () {
    // Array
    testArg(
      IDL.Vec(IDL.Int),
      [0, 1, 2, 3].map((x) => BigInt.from(x)).toList(),
      '4449444c016d7c01000400010203',
      'Array of Ints',
    );
    expect(
      () => IDL.encode([IDL.Vec(IDL.Int)], [BigInt.from(0)]),
      throwsA(isError<ArgumentError>()),
    );
    expect(
      () => IDL.encode([
        IDL.Vec(IDL.Int),
      ], [
        ['fail'],
      ]),
      throwsA(isError<ArgumentError>()),
    );
  });

  test('IDL encoding (array + tuples)', () {
    // Array of Tuple
    testArg(
      IDL.Vec(IDL.Tuple([IDL.Int, IDL.Text])),
      [
        [BigInt.from(42), 'text'],
      ],
      '4449444c026c02007c01716d000101012a0474657874',
      'Arr of Tuple',
    );

    // Nested Tuples
    testArg(
      IDL.Tuple([
        IDL.Tuple([
          IDL.Tuple([
            IDL.Tuple([IDL.Null]),
          ]),
        ]),
      ]),
      [
        [
          [
            [null],
          ]
        ]
      ],
      '4449444c046c01007f6c0100006c0100016c0100020103',
      'Nested Tuples',
    );
  });

  test('IDL encoding (record)', () {
    // Record
    testArg(IDL.Record({}), {}, '4449444c016c000100', 'Empty record');
    expect(
      () => IDL.encode([
        IDL.Record({'a': IDL.Text}),
      ], [
        {'b': 'b'},
      ]),
      throwsA(isError<StateError>("Record is missing the key 'a'.")),
    );

    // Test that additional keys are ignored
    testEncode(
      IDL.Record({
        'foo': IDL.Text,
        'bar': IDL.Int,
      }),
      {'foo': '💩', 'bar': BigInt.from(42), 'baz': BigInt.from(0)},
      '4449444c016c02d3e3aa027c868eb7027101002a04f09f92a9',
      'Record',
    );
    testEncode(
      IDL.Record({'foo': IDL.Text, 'bar': IDL.Int}),
      {'foo': '💩', 'bar': BigInt.from(42)},
      '4449444c016c02d3e3aa027c868eb7027101002a04f09f92a9',
      'Record',
    );

    final foobar = FooBar.fromJson({'foo': '💩', 'bar': BigInt.from(42)});
    final encode = IDL.encode([
      IDL.Opt(IDL.Record({'foo': IDL.Text, 'bar': IDL.Int})),
    ], [
      [foobar],
    ]);
    final decode = IDL.decode(
      [
        IDL.Opt(IDL.Record({'foo': IDL.Text, 'bar': IDL.Int})),
      ],
      encode,
    );
    final newFoobar = FooBar.fromJson((decode.first as List).first);
    expect(foobar, newFoobar);
  });

  test('IDL decoding (skip fields)', () {
    testDecode(
      IDL.Record({'foo': IDL.Text, 'bar': IDL.Int}),
      {'foo': '💩', 'bar': BigInt.from(42)},
      '4449444c016c04017f027ed3e3aa027c868eb702710100012a04f09f92a9',
      'ignore record fields',
    );
    testDecode(
      IDL.Variant({'ok': IDL.Text, 'err': IDL.Text}),
      {'ok': 'good'},
      '4449444c016b03017e9cc20171e58eb4027101000104676f6f64',
      'adjust variant index',
    );
    final recordType = IDL.Record({'foo': IDL.Int32, 'bar': IDL.Bool});
    final recordValue = {'foo': 42, 'bar': true};
    testArg(
      IDL.Record({
        'foo': IDL.Int32,
        'bar': recordType,
        'baz': recordType,
        'bib': recordType,
      }),
      {'foo': 42, 'bar': recordValue, 'baz': recordValue, 'bib': recordValue},
      '4449444c026c02d3e3aa027e868eb702756c04d3e3aa0200dbe3aa0200bbf1aa0200868eb702750101012a000000012a000000012a0000002a000000',
      'nested record',
    );
    testDecode(
      IDL.Record({
        'baz': IDL.Record({'foo': IDL.Int32}),
      }),
      {
        'baz': {'foo': 42},
      },
      '4449444c026c02d3e3aa027e868eb702756c04d3e3aa0200dbe3aa0200bbf1aa0200868eb702750101012a000000012a000000012a0000002a000000',
      'skip nested fields',
    );
  });

  test('IDL encoding (numbered record)', () {
    // Record
    testArg(
      IDL.Record({'_0_': IDL.Int8, '_1_': IDL.Bool}),
      {'_0_': 42, '_1_': true},
      '4449444c016c020077017e01002a01',
      'Numbered record',
    );
    // Test Tuple and numbered record are exact the same
    testArg(
      IDL.Tuple([IDL.Int8, IDL.Bool]),
      [42, true],
      '4449444c016c020077017e01002a01',
      'Tuple',
    );
    testArg(
      IDL.Tuple([
        IDL.Tuple([IDL.Int8, IDL.Bool]),
        IDL.Record({'_0_': IDL.Int8, '_1_': IDL.Bool}),
      ]),
      [
        [42, true],
        {'_0_': 42, '_1_': true},
      ],
      '4449444c026c020077017e6c020000010001012a012a01',
      'Tuple and Record',
    );
    testArg(
      IDL.Record({'_2_': IDL.Int8, '2': IDL.Bool}),
      {'_2_': 42, '2': true},
      '4449444c016c020277327e01002a01',
      'Mixed record',
    );
  });

  test('IDL encoding (bool)', () {
    // Bool
    testArg(IDL.Bool, true, '4449444c00017e01', 'true');
    testArg(IDL.Bool, false, '4449444c00017e00', 'false');
    expect(
      () => IDL.encode([IDL.Bool], [0]),
      throwsA(isError<ArgumentError>()),
    );
    expect(
      () => IDL.encode([IDL.Bool], ['false']),
      throwsA(isError<ArgumentError>()),
    );
  });

  test('IDL encoding (principal)', () {
    // Principal
    testArg(
      IDL.Principal,
      Principal.fromText('w7x7r-cok77-xa'),
      '4449444c0001680103caffee',
      'principal',
    );
    testArg(
      IDL.Principal,
      Principal.fromText('2chl6-4hpzw-vqaaa-aaaaa-c'),
      '4449444c0001680109efcdab000000000001',
      'principal',
    );
    expect(
      () => IDL.encode([IDL.Principal], ['w7x7r-cok77-xa']),
      throwsA(isError<ArgumentError>()),
    );
    expect(
      () => IDL.decode([IDL.Principal], '4449444c00016803caffee'.toU8a()),
      throwsA(isError<ArgumentError>('Cannot decode principal 03.')),
    );
  });

  test('IDL encoding (function)', () {
    // Function
    testArg(
      IDL.Func([IDL.Text], [IDL.Nat], []),
      [Principal.fromText('w7x7r-cok77-xa'), 'foo'],
      '4449444c016a0171017d000100010103caffee03666f6f',
      'function',
    );
    testArg(
      IDL.Func([IDL.Text], [IDL.Nat], ['query']),
      [Principal.fromText('w7x7r-cok77-xa'), 'foo'],
      '4449444c016a0171017d01010100010103caffee03666f6f',
      'query function',
    );
    testArg(
      IDL.Func([IDL.Text], [IDL.Nat], ['composite_query']),
      [Principal.fromText('w7x7r-cok77-xa'), 'foo'],
      '4449444c016a0171017d01030100010103caffee03666f6f',
      'composite_query function',
    );
  });

  test('IDL encoding (service)', () {
    // Service
    testArg(
      IDL.Service({
        'foo': IDL.Func([IDL.Text], [IDL.Nat], []),
      }),
      Principal.fromText('w7x7r-cok77-xa'),
      '4449444c026a0171017d00690103666f6f0001010103caffee',
      'service',
    );
    testArg(
      IDL.Service({
        'foo': IDL.Func([IDL.Text], [IDL.Nat], ['query']),
      }),
      Principal.fromText('w7x7r-cok77-xa'),
      '4449444c026a0171017d0101690103666f6f0001010103caffee',
      'service',
    );
    testArg(
      IDL.Service({
        'foo': IDL.Func([IDL.Text], [IDL.Nat], []),
        'foo2': IDL.Func([IDL.Text], [IDL.Nat], []),
      }),
      Principal.fromText('w7x7r-cok77-xa'),
      '4449444c026a0171017d00690203666f6f0004666f6f320001010103caffee',
      'service',
    );
    testArg(
      IDL.Service({
        'foo': IDL.Func([IDL.Text], [IDL.Nat], ['composite_query']),
      }),
      Principal.fromText('w7x7r-cok77-xa'),
      '4449444c026a0171017d0103690103666f6f0001010103caffee',
      'service',
    );
  });

  test('IDL encoding (variants)', () {
    // Variants

    final result = IDL.Variant({'ok': IDL.Text, 'err': IDL.Text});
    testArg(
      result,
      {'ok': 'good'},
      '4449444c016b029cc20171e58eb4027101000004676f6f64',
      'Result ok',
    );
    testArg(
      result,
      {'err': 'uhoh'},
      '4449444c016b029cc20171e58eb402710100010475686f68',
      'Result err',
    );
    expect(
      () => IDL.encode([result], [{}]),
      throwsA(isError<ArgumentError>()),
    );
    expect(
      () => IDL.encode([
        result,
      ], [
        {'ok': 'ok', 'err': 'err'},
      ]),
      throwsA(isError<ArgumentError>()),
    );

    // Test that nullary constructors work as expected
    testArg(
      IDL.Variant({'foo': IDL.Null}),
      {'foo': null},
      '4449444c016b01868eb7027f010000',
      'Nullary constructor in variant',
    );

    // Test that Empty within variants works as expected
    testArg(
      IDL.Variant({'ok': IDL.Text, 'err': IDL.Empty}),
      {'ok': 'good'},
      '4449444c016b029cc20171e58eb4026f01000004676f6f64',
      'Empty within variants',
    );
    expect(
      () => IDL.encode([
        IDL.Variant({'ok': IDL.Text, 'err': IDL.Empty}),
      ], [
        {'err': 'uhoh'},
      ]),
      throwsA(isError<ArgumentError>()),
    );

    // Test for option
    testArg(IDL.Opt(IDL.Nat), [], '4449444c016e7d010000', 'None option');
    testArg(
      IDL.Opt(IDL.Nat),
      [BigInt.from(1)],
      '4449444c016e7d01000101',
      'Some option',
    );
    testArg(
      IDL.Opt(IDL.Opt(IDL.Nat)),
      [
        [BigInt.from(1)],
      ],
      '4449444c026e7d6e000101010101',
      'Nested option',
    );
    testArg(
      IDL.Opt(IDL.Opt(IDL.Null)),
      [
        [null],
      ],
      '4449444c026e7f6e0001010101',
      'Null option',
    );

    // Type description sharing
    testArg(
      IDL.Tuple([
        IDL.Vec(IDL.Int),
        IDL.Vec(IDL.Nat),
        IDL.Vec(IDL.Int),
        IDL.Vec(IDL.Nat),
      ]),
      [[], [], [], []],
      '4449444c036d7c6d7d6c040000010102000301010200000000',
      'Type sharing',
    );
  });

  test('IDL encoding (rec)', () {
    // Test for recursive types

    final list = IDL.Rec();
    expect(
      () => IDL.encode([list], [[]]),
      throwsA(isError<StateError>('Recursive type uninitialized.')),
    );
    list.fill(IDL.Opt(IDL.Record({'head': IDL.Int, 'tail': list})));
    testArg(
      list,
      [],
      '4449444c026e016c02a0d2aca8047c90eddae70400010000',
      'Empty list',
    );
    testArg(
      list,
      [
        {
          'head': BigInt.from(1),
          'tail': [
            {'head': BigInt.from(2), 'tail': []},
          ],
        }
      ],
      '4449444c026e016c02a0d2aca8047c90eddae7040001000101010200',
      'List',
    );

    // Mutual recursion

    final list1 = IDL.Rec();

    final list2 = IDL.Rec();
    list1.fill(IDL.Opt(list2));
    list2.fill(IDL.Record({'head': IDL.Int, 'tail': list1}));
    testArg(
      list1,
      [],
      '4449444c026e016c02a0d2aca8047c90eddae70400010000',
      'Empty list',
    );
    testArg(
      list1,
      [
        {
          'head': BigInt.from(1),
          'tail': [
            {'head': BigInt.from(2), 'tail': []},
          ],
        }
      ],
      '4449444c026e016c02a0d2aca8047c90eddae7040001000101010200',
      'List',
    );
  });

  test('IDL encoding (multiple arguments)', () {
    final result = IDL.Variant({'ok': IDL.Text, 'err': IDL.Text});
    // Test for multiple arguments
    testArgs(
      [IDL.Nat, IDL.Opt(IDL.Text), result],
      [
        BigInt.from(42),
        ['test'],
        {'ok': 'good'},
      ],
      '4449444c026e716b029cc20171e58eb40271037d00012a0104746573740004676f6f64',
      'Multiple arguments',
    );
    testArgs([], [], '4449444c0000', 'empty args');
  });
}

class FooBar {
  const FooBar({
    required this.foo,
    required this.bar,
  });

  factory FooBar.fromJson(
    Map<dynamic, dynamic> map,
  ) {
    return FooBar(
      foo: map['foo'],
      bar: map['bar'],
    );
  }

  final String foo;
  final BigInt bar;

  static final RecordClass idl = IDL.Record(
    <String, dynamic>{
      'foo': IDL.Text,
      'bar': IDL.Int,
    },
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'foo': foo,
      'bar': bar,
    }..removeWhere((String key, dynamic value) {
        return value == null;
      });
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FooBar &&
          runtimeType == other.runtimeType &&
          foo == other.foo &&
          bar == other.bar;

  @override
  int get hashCode => foo.hashCode ^ bar.hashCode;
}
