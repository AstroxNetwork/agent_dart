import 'dart:typed_data';

import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/certificate.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:flutter_test/flutter_test.dart';

Uint8List label(String str) {
  return str.plainToU8a();
}

Uint8List pruned(String str) {
  return str.toU8a();
}

void main() {
  hashTest();
}

void hashTest() {
  test('hash tree', () async {
    final cborEncode =
        '8301830183024161830183018302417882034568656c6c6f810083024179820345776f726c6483024162820344676f6f648301830241638100830241648203476d6f726e696e67'
            .toU8a();
    final expected = [
      1,
      [
        1,
        [
          2,
          label('a'),
          [
            1,
            [
              1,
              [
                2,
                label('x'),
                [3, label('hello')]
              ],
              [0]
            ],
            [
              2,
              label('y'),
              [3, label('world')]
            ]
          ],
        ],
        [
          2,
          label('b'),
          [3, label('good')]
        ],
      ],
      [
        1,
        [
          2,
          label('c'),
          [0]
        ],
        [
          2,
          label('d'),
          [3, label('morning')]
        ]
      ],
    ];
    final tree = cborDecode(cborEncode);
    expect(tree, expected);

    expect(
      (await reconstruct(tree)),
      'eb5c5b2195e62d996b84c9bcc8259d19a83786a2f59e0878cec84c811f669aa0'
          .toU8a(),
    );
  });
  test('pruned hash tree', () async {
    const value =
        '83018301830241618301820458201b4feff9bef8131788b0c9dc6dbad6e81e524249c8'
        '79e9f10f71ce3749f5a63883024179820345776f726c6483024162820458207b32ac0c'
        '6ba8ce35ac82c255fc7906f7fc130dab2a090f80fe12f9c2cae83ba6830182045820ec'
        '8324b8a1f1ac16bd2e806edba78006479c9877fed4eb464a25485465af601d83024164'
        '8203476d6f726e696e67';
    final cborEncode = value.toU8a();
    final expected = [
      1,
      [
        1,
        [
          2,
          label('a'),
          [
            1,
            [
              4,
              pruned(
                '1b4feff9bef8131788b0c9dc6dbad6e81e524249c879e9f10f71ce3749f5a638',
              )
            ],
            [
              2,
              label('y'),
              [3, label('world')]
            ],
          ],
        ],
        [
          2,
          label('b'),
          [
            4,
            pruned(
              '7b32ac0c6ba8ce35ac82c255fc7906f7fc130dab2a090f80fe12f9c2cae83ba6',
            )
          ],
        ],
      ],
      [
        1,
        [
          4,
          pruned(
            'ec8324b8a1f1ac16bd2e806edba78006479c9877fed4eb464a25485465af601d',
          )
        ],
        [
          2,
          label('d'),
          [3, label('morning')]
        ],
      ],
    ];
    final tree = cborDecode(cborEncode);
    expect(tree, expected);
    expect(
      (await reconstruct(tree)),
      'eb5c5b2195e62d996b84c9bcc8259d19a83786a2f59e0878cec84c811f669aa0'
          .toU8a(),
    );
  });

  test('lookup', () {
    final tree = [
      1,
      [
        1,
        [
          2,
          label('a'),
          [
            1,
            [
              4,
              pruned(
                '1b4feff9bef8131788b0c9dc6dbad6e81e524249c879e9f10f71ce3749f5a638',
              )
            ],
            [
              2,
              label('y'),
              [3, label('world')]
            ],
          ],
        ],
        [
          2,
          label('b'),
          [
            4,
            pruned(
              '7b32ac0c6ba8ce35ac82c255fc7906f7fc130dab2a090f80fe12f9c2cae83ba6',
            )
          ],
        ],
      ],
      [
        1,
        [
          4,
          pruned(
            'ec8324b8a1f1ac16bd2e806edba78006479c9877fed4eb464a25485465af601d',
          )
        ],
        [
          2,
          label('d'),
          [3, label('morning')]
        ],
      ],
    ];
    expect(
      lookupPath([
        'a'.plainToU8a(useDartEncode: true),
        'a'.plainToU8a(useDartEncode: true)
      ], tree),
      null,
    );

    expect(
      lookupPath([
        'a'.plainToU8a(useDartEncode: true),
        'y'.plainToU8a(useDartEncode: true)
      ], tree),
      'world'.plainToU8a(useDartEncode: true),
    );
    expect(lookupPath(['aa'.plainToU8a(useDartEncode: true)], tree), null);
    expect(lookupPath(['ax'.plainToU8a(useDartEncode: true)], tree), null);
    expect(lookupPath(['b'.plainToU8a(useDartEncode: true)], tree), null);
    expect(lookupPath(['bb'.plainToU8a(useDartEncode: true)], tree), null);
    expect(
      lookupPath(['d'.plainToU8a(useDartEncode: true)], tree),
      'morning'.plainToU8a(useDartEncode: true),
    );
    expect(lookupPath(['e'.plainToU8a(useDartEncode: true)], tree), null);
  });
}
