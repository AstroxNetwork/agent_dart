import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/request_id.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/agent/utils/hash.dart';
import 'package:agent_dart/utils/extension.dart';

void main() {
  hashTest();
}

void hashTest() {
  test('IDL label', () async {
    testHashOfBlob(BinaryBlob input, String expected) async {
      final hashed = hash(input.buffer);
      final hex = blobToHex(hashed);
      expect(hex, expected);
    }

    testHashOfString(String input, String expected) async {
      final encoded = utf8.encode(input);
      testHashOfBlob(BinaryBlob(Uint8List.fromList(encoded)), expected);
    }

    await testHashOfString(
      'request_type',
      '769e6f87bdda39c859642b74ce9763cdd37cb1cd672733e8c54efaa33ab78af9',
    );
    await testHashOfString(
      'call',
      '7edb360f06acaef2cc80dba16cf563f199d347db4443da04da0c8173e3f9e4ed',
    );
    await testHashOfString(
      'callee', // The "canister_id" field was previously named "callee"
      '92ca4c0ced628df1e7b9f336416ead190bd0348615b6f71a64b21d1b68d4e7e2',
    );
    await testHashOfString(
      'canister_id',
      '0a3eb2ba16702a387e6321066dd952db7a31f9b5cc92981e0a92dd56802d3df9',
    );
    await testHashOfBlob(
      BinaryBlob(Uint8List.fromList([0, 0, 0, 0, 0, 0, 4, 210])),
      '4d8c47c3c1c837964011441882d745f7e92d10a40cef0520447c63029eafe396',
    );
    await testHashOfString(
      'method_name',
      '293536232cf9231c86002f4ee293176a0179c002daa9fc24be9bb51acdd642b6',
    );
    await testHashOfString(
      'hello',
      '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824',
    );
    await testHashOfString(
        'arg', 'b25f03dedd69be07f356a06fe35c1b0ddc0de77dcd9066c4be0c6bbde14b23ff');
    await testHashOfBlob(
      BinaryBlob(Uint8List.fromList([68, 73, 68, 76, 0, 253, 42])),
      '6c0b2ae49718f6995c02ac5700c9c789d7b7862a0d53e6d40a73f1fcd2f70189',
    );
  });

  test('requestIdOf', () async {
    final request = {
      "request_type": 'call',
      "method_name": 'hello',

      // 0x00000000000004D2
      // \x00\x00\x00\x00\x00\x00\x04\xD2
      // 0   0   0   0   0   0   4   210
      "canister_id": BinaryBlob(Uint8List.fromList([0, 0, 0, 0, 0, 0, 4, 210])),

      // DIDL\x00\xFD*
      // D   I   D   L   \x00  \253  *
      // 68  73  68  76  0     253   42
      "arg": BinaryBlob(Uint8List.fromList([68, 73, 68, 76, 0, 253, 42])),
    };

    final requestId = requestIdOf(request);

    expect(
      blobToHex(requestId),
      '8781291c347db32a9d8c10eb62b710fce5a93be676474c42babc74c51858f94b',
    );
  });
}
