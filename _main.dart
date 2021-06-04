// Copyright (c) 2021 suwei
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT
import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:cbor/cbor.dart' as cbor;
// import 'package:cbor/cbor.dart';
import 'package:typed_data/typed_data.dart';

main() async {
  // final seializer = initCborSerializer();
  final input = {
    "a": 1,
    "b": 'two',
    "c": BinaryBlob(Uint8List.fromList([3])),
    "d": {'four': 'four'},
    "e": Principal.fromHex('FfFfFfFfFfFfFfFfd7'),
    "f": BinaryBlob(Uint8List.fromList([])),
    "g": '0xffffffffffffffff'.hexToBn(),
    "h": [
      BinaryBlob(Uint8List.fromList([])),
      BinaryBlob(Uint8List.fromList([1, 2, 3])),
      {
        "a": {
          'four': [
            BinaryBlob(Uint8List.fromList([])),
            BinaryBlob(Uint8List.fromList([1, 2, 3]))
          ]
        },
        "b": [
          BinaryBlob(Uint8List.fromList([])),
          BinaryBlob(Uint8List.fromList([1, 2, 3]))
        ],
      }
    ]
  };

  final input2 = {
    "A": true,
    "B": false,
    "C": 123,
    "D": 'hello',
  };

  final serilizer = initCborSerializer();

  final result = cborEncode(serilizer, BinaryBlob(Uint8List.fromList([3])));

  print(Uint8List.fromList(result.buffer).toHex(include0x: false));
}

// class SelfDescribeEncoder extends cbor.Encoder {
//   SelfDescribeEncoder(cbor.Output out) : super(out) {
//     var valBuff = Uint8Buffer();
//     var hList = Uint8List.fromList([0xd9, 0xd9, 0xf7]);
//     valBuff.addAll(hList);
//     addBuilderOutput(valBuff);
//   }
// }
