import 'dart:typed_data';

import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typed_data/typed_data.dart';

void main() {
  cborTest();
}

void cborTest() {
  test('encode decode', () {
    var input = {
      'a': 1,
      'b': 'two',
      'c': Uint8List.fromList([3]),
      'd': {'four': 'four'},
      'e': Principal.fromHex('FfFfFfFfFfFfFfFfd7'),
      'f': Uint8List.fromList([]),
      'g': BigInt.parse('ffffffffffffffff', radix: 16),
    };

    final output = cborDecode<Map>(cborEncode(input));

    expect(blobToHex((output['c'] as Uint8Buffer).toU8a()),
        blobToHex(input['c'] as Uint8List));
    expect((output['e'] as Uint8Buffer).toHex().toUpperCase(),
        (input['e'] as Principal).toHex());
    expect(output['b'], input['b']);
    expect(output['a'], input['a']);
    expect(output['d'], input['d']);
    expect(output['g'], input['g']);
  });
  test('empty canister ID', () {
    final input = {
      'a': Principal.fromText('aaaaa-aa'),
    };

    final output = cborDecode<Map>(cborEncode(input));

    final inputA = input['a'] as Principal;
    final outputA = output['a'] as Uint8Buffer;

    expect((outputA).toHex(), (inputA).toHex());
    expect(Principal.fromUint8Array((outputA).toU8a()).toText(), 'aaaaa-aa');
  });
}
