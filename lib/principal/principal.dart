import 'dart:typed_data';

import 'package:agent_dart/utils/extension.dart';

import '../agent/errors.dart';
import 'utils/base32.dart';
import 'utils/get_crc.dart';
import 'utils/sha224.dart';

export 'utils/utils.dart';

const _suffixSelfAuthenticating = 2;
const _suffixAnonymous = 4;
const _maxLengthInBytes = 29;
const _typeOpaque = 1;

class Principal {
  const Principal(
    this._arr, {
    Uint8List? subAccount,
  })  : assert(subAccount == null || subAccount.length == 32),
        _subAccount = subAccount;

  factory Principal.selfAuthenticating(Uint8List publicKey) {
    final sha = sha224Hash(publicKey.buffer);
    final u8a = Uint8List.fromList([...sha, _suffixSelfAuthenticating]);
    return Principal(u8a);
  }

  factory Principal.anonymous() {
    return Principal(Uint8List.fromList([_suffixAnonymous]));
  }

  factory Principal.from(Object? other) {
    if (other is String) {
      return Principal.fromText(other);
    } else if (other is Map<String, dynamic> && other['_isPrincipal'] == true) {
      return Principal(other['_arr'], subAccount: other['_subAccount']);
    } else if (other is Principal) {
      return Principal(other._arr, subAccount: other._subAccount);
    }
    throw UnreachableError();
  }

  factory Principal.create(int uSize, Uint8List data, Uint8List? subAccount) {
    if (uSize > data.length) {
      throw RangeError.range(
        uSize,
        null,
        data.length,
        'size',
        'Size must within the data length',
      );
    }
    return Principal(data.sublist(0, uSize), subAccount: subAccount);
  }

  factory Principal.fromHex(String hex, {String? subAccountHex}) {
    if (hex.isEmpty) {
      return Principal(Uint8List(0));
    }
    if (subAccountHex == null || subAccountHex.isEmpty) {
      subAccountHex = null;
    } else if (subAccountHex.startsWith('0')) {
      throw ArgumentError.value(
        subAccountHex,
        'subAccountHex',
        'The representation is not canonical: '
            'leading zeros are not allowed in subaccounts.',
      );
    }
    return Principal(
      hex.toU8a(),
      subAccount: subAccountHex?.padLeft(64, '0').toU8a(),
    );
  }

  factory Principal.fromText(String text) {
    if (text.endsWith('.')) {
      throw ArgumentError(
        'The representation is not canonical: '
        'default subaccount should be omitted.',
      );
    }
    final paths = text.split('.');
    final String? subAccountHex;
    if (paths.length > 1) {
      subAccountHex = paths.last;
    } else {
      subAccountHex = null;
    }
    if (subAccountHex != null && subAccountHex.startsWith('0')) {
      throw ArgumentError.value(
        subAccountHex,
        'subAccount',
        'The representation is not canonical: '
            'leading zeros are not allowed in subaccounts.',
      );
    }
    String prePrincipal = paths.first;
    // Removes the checksum if sub-account is valid.
    if (subAccountHex != null) {
      final list = prePrincipal.split('-');
      final checksum = list.removeLast();
      // Checksum is 7 digits.
      if (checksum.length != 7) {
        throw ArgumentError.value(
          prePrincipal,
          'principal',
          'Missing checksum',
        );
      }
      prePrincipal = list.join('-');
    }
    final canisterIdNoDash = prePrincipal.toLowerCase().replaceAll('-', '');
    Uint8List arr = base32Decode(canisterIdNoDash);
    arr = arr.sublist(4, arr.length);
    final subAccount = subAccountHex?.padLeft(64, '0').toU8a();
    final principal = Principal(arr, subAccount: subAccount);
    if (principal.toText() != text) {
      throw ArgumentError.value(
        text,
        'principal',
        'The principal is expected to be ${principal.toText()} but got',
      );
    }
    return principal;
  }

  final Uint8List _arr;
  final Uint8List? _subAccount;

  bool isAnonymous() {
    return _arr.lengthInBytes == 1 && _arr[0] == _suffixAnonymous;
  }

  Uint8List toUint8List() => _arr;

  String toHex() => _toHexString(_arr).toUpperCase();

  String toText() {
    final checksum = _getChecksum(_arr.buffer);
    final bytes = Uint8List.fromList(_arr);
    final array = Uint8List.fromList([...checksum, ...bytes]);
    final result = base32Encode(array);
    final reg = RegExp(r'.{1,5}');
    final matches = reg.allMatches(result);
    if (matches.isEmpty) {
      // This should only happen if there's no character, which is unreachable.
      throw StateError('No characters found.');
    }
    final buffer = StringBuffer(matches.map((e) => e.group(0)).join('-'));
    if (_subAccount != null) {
      final checksum = base32Encode(
        _getChecksum(Uint8List.fromList(_arr + _subAccount!).buffer),
      );
      buffer.write('-$checksum');
      int i = 0;
      while (_subAccount![i] == 0 && i < _subAccount!.length) {
        i++;
      }
      final subAccount = _subAccount!.sublist(i, _subAccount!.length);
      if (subAccount.isNotEmpty) {
        buffer.write('.');
        buffer.write(subAccount.toHex().replaceFirst('0', ''));
      }
    }
    return buffer.toString();
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
    hash.update(toUint8List());
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
      identical(this, other) ||
      other is Principal &&
          _arr.eq(other._arr) &&
          (_subAccount?.eq(other._subAccount ?? Uint8List(0)) ??
              _subAccount == null && other._subAccount == null);

  @override
  int get hashCode => Object.hash(_arr, _subAccount);
}

class CanisterId extends Principal {
  CanisterId(Principal pid) : super(pid.toUint8List());

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
      Principal.create(blobLength + 1, Uint8List.fromList(data), null),
    );
  }
}

Uint8List _getChecksum(ByteBuffer buffer) {
  final checksumArrayBuf = ByteData(4);
  checksumArrayBuf.setUint32(0, getCrc32(buffer));
  final checksum = checksumArrayBuf.buffer.asUint8List();
  return checksum;
}

String _toHexString(Uint8List bytes) {
  return bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
}
