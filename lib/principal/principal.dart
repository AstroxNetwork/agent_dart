import 'dart:typed_data';

import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/utils/extension.dart';

import 'utils/base32.dart';
import 'utils/get_crc.dart';
import 'utils/sha224.dart';

export 'utils/utils.dart';

const _suffixSelfAuthenticating = 2;
const _suffixAnonymous = 4;
const _maxLengthInBytes = 29;
const _typeOpaque = 1;

class Principal {
  const Principal(this._arr);

  factory Principal.selfAuthenticating(Uint8List publicKey) {
    final sha = sha224Hash(publicKey.buffer);
    final u8a = Uint8List.fromList([...sha, _suffixSelfAuthenticating]);
    return Principal(u8a);
  }

  factory Principal.anonymous() {
    return Principal(Uint8List.fromList([_suffixAnonymous]));
  }

  factory Principal.from(dynamic other) {
    if (other is String) {
      return Principal.fromText(other);
    } else if (other is Map<String, dynamic> && other['_isPrincipal'] == true) {
      return Principal(other['_arr']);
    } else if (other is Principal) {
      return Principal(other._arr);
    }
    throw FallThroughError();
  }

  factory Principal.create(int uSize, Uint8List data) {
    if (uSize > data.length) {
      throw RangeError.range(
        uSize,
        null,
        data.length,
        'size',
        'Size must within the data length',
      );
    }
    return Principal.fromBlob(data.sublist(0, uSize));
  }

  factory Principal.fromHex(String hex) {
    return Principal(_fromHexString(hex));
  }

  factory Principal.fromText(String text) {
    final canisterIdNoDash = text.toLowerCase().replaceAll('-', '');
    Uint8List arr = base32Decode(canisterIdNoDash);
    arr = arr.sublist(4, arr.length);
    final principal = Principal(arr);
    if (principal.toText() != text) {
      throw ArgumentError.value(
        text,
        'Principal',
        'Principal expected to be ${principal.toText()} but got',
      );
    }
    return principal;
  }

  factory Principal.fromBlob(BinaryBlob arr) {
    return Principal.fromUint8Array(arr);
  }

  factory Principal.fromUint8Array(Uint8List arr) {
    return Principal(arr);
  }

  final Uint8List _arr;

  bool isAnonymous() {
    return _arr.lengthInBytes == 1 && _arr[0] == _suffixAnonymous;
  }

  Uint8List toUint8List() => _arr;

  Uint8List toBlob() => toUint8List();

  String toHex() => _toHexString(_arr).toUpperCase();

  String toText() {
    final checksumArrayBuf = ByteData(4);
    checksumArrayBuf.setUint32(0, getCrc32(_arr.buffer));
    final checksum = checksumArrayBuf.buffer.asUint8List();
    final bytes = Uint8List.fromList(_arr);
    final array = Uint8List.fromList([...checksum, ...bytes]);
    final result = base32Encode(array);
    final reg = RegExp(r'.{1,5}');
    final matches = reg.allMatches(result);
    if (matches.isEmpty) {
      // This should only happen if there's no character, which is unreachable.
      throw StateError('No characters found.');
    }
    return matches.map((e) => e.group(0)).join('-');
  }

  Uint8List toAccountId({Uint8List? subAccount}) {
    if (subAccount != null && subAccount.length != 32) {
      throw ArgumentError.value(
        subAccount,
        'subAccount',
        'Sub-account address must be 32-bytes length',
      );
    }
    final hash = SHA224();
    hash.update('\x0Aaccount-id'.plainToU8a());
    hash.update(toBlob());
    hash.update(subAccount ?? Uint8List(32));
    final data = hash.digest();
    final view = ByteData(4);
    view.setUint32(0, getCrc32(data.buffer));
    final checksum = view.buffer.asUint8List();
    final bytes = Uint8List.fromList(data);
    return Uint8List.fromList([...checksum, ...bytes]);
  }

  @override
  String toString() => toText();

  String toJson() => toText();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Principal && _arr.eq(other._arr);

  @override
  int get hashCode => _arr.hashCode;
}

class CanisterId extends Principal {
  CanisterId(Principal pid) : super(pid.toBlob());

  factory CanisterId.fromU64(int val) {
    // It is important to use big endian here to ensure that the generated
    // `PrincipalId`s still maintain ordering.
    final data = List.generate(_maxLengthInBytes, (index) => 0);

    // Specify explicitly the length, so as to assert at compile time that a u64
    // takes exactly 8 bytes
    final valU8a = val.toU8a(bitLength: 64);

    data.replaceRange(0, 8, valU8a.sublist(0, 8));
    // Even though not defined in the interface spec, add another 0x1 to the array
    // to create a sub category that could be used in future.
    data[8] = 0x01;

    const blobLength = 8 + 1; // The U64 + The last 0x01.

    data[blobLength] = _typeOpaque;
    return CanisterId(
      Principal.create(blobLength + 1, Uint8List.fromList(data)),
    );
  }
}

Uint8List _fromHexString(String hexString) {
  return Uint8List.fromList(
    (RegExp(r'.{1,2}').allMatches(hexString).toList())
        .map<int>((byte) => int.parse(byte.group(0)!, radix: 16))
        .toList(),
  );
}

String _toHexString(Uint8List bytes) {
  return bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
}
