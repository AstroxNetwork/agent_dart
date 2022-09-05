import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/wallet/hashing.dart';

import 'extension.dart';

class TooShortHrp implements Exception {
  @override
  String toString() => 'The human readable part should have non zero length.';
}

class TooLong implements Exception {
  TooLong(this.length);

  final int length;

  @override
  String toString() => 'The bech32 string is too long: $length (>90)';
}

class OutOfRangeHrpCharacters implements Exception {
  OutOfRangeHrpCharacters(this.hpr);

  final String hpr;

  @override
  String toString() =>
      'The human readable part contains invalid characters: $hpr';
}

class MixedCase implements Exception {
  MixedCase(this.hpr);

  final String hpr;

  @override
  String toString() =>
      'The human readable part is mixed case, should either be all lower or all upper case: $hpr';
}

class OutOfBoundChars implements Exception {
  OutOfBoundChars(this.char);

  final String char;

  @override
  String toString() => 'A character is undefined in bech32: $char';
}

class InvalidSeparator implements Exception {
  InvalidSeparator(this.pos);

  final int pos;

  @override
  String toString() => "separator '1' at invalid position: $pos";
}

class InvalidAddress implements Exception {
  @override
  String toString() => '';
}

class InvalidChecksum implements Exception {
  @override
  String toString() => 'Checksum verification failed';
}

class TooShortChecksum implements Exception {
  @override
  String toString() => 'Checksum is shorter than 6 characters';
}

class InvalidHrp implements Exception {
  @override
  String toString() => "Human readable part should be 'zil' or 'tzil'.";
}

class InvalidProgramLength implements Exception {
  InvalidProgramLength(this.reason);

  final String reason;

  @override
  String toString() => 'Program length is invalid: $reason';
}

class InvalidWitnessVersion implements Exception {
  InvalidWitnessVersion(this.version);

  final int version;

  @override
  String toString() => 'Witness version $version > 16';
}

class InvalidPadding implements Exception {
  InvalidPadding(this.reason);

  final String reason;

  @override
  String toString() => 'Invalid padding: $reason';
}

const Bech32Codec bech32 = Bech32Codec();

class Bech32Codec extends Codec<Bech32, String> {
  const Bech32Codec();

  @override
  Bech32Decoder get decoder => Bech32Decoder();

  @override
  Bech32Encoder get encoder => Bech32Encoder();

  @override
  String encode(Bech32 input) {
    return Bech32Encoder().convert(input);
  }

  @override
  Bech32 decode(String encoded) {
    return Bech32Decoder().convert(encoded);
  }
}

// This class converts a Bech32 class instance to a String.
class Bech32Encoder extends Converter<Bech32, String> with Bech32Validations {
  @override
  String convert(Bech32 input) {
    var hrp = input.hrp;
    final data = input.data;

    if (hrp.length +
            data.length +
            separator.length +
            Bech32Validations.checksumLength >
        Bech32Validations.maxInputLength) {
      throw TooLong(
        hrp.length + data.length + 1 + Bech32Validations.checksumLength,
      );
    }

    if (hrp.isEmpty) {
      throw TooShortHrp();
    }

    if (hasOutOfRangeHrpCharacters(hrp)) {
      throw OutOfRangeHrpCharacters(hrp);
    }

    if (isMixedCase(hrp)) {
      throw MixedCase(hrp);
    }

    hrp = hrp.toLowerCase();

    final checksummed = data + _createChecksum(hrp, data);

    if (hasOutOfBoundsChars(checksummed)) {
      throw OutOfBoundChars('<unknown>');
    }

    return hrp + separator + checksummed.map((i) => charset[i]).join();
  }
}

// This class converts a String to a Bech32 class instance.
class Bech32Decoder extends Converter<String, Bech32> with Bech32Validations {
  @override
  Bech32 convert(String input) {
    if (input.length > Bech32Validations.maxInputLength) {
      throw TooLong(input.length);
    }

    if (isMixedCase(input)) {
      throw MixedCase(input);
    }

    if (hasInvalidSeparator(input)) {
      throw InvalidSeparator(input.lastIndexOf(separator));
    }

    final separatorPosition = input.lastIndexOf(separator);

    if (isChecksumTooShort(separatorPosition, input)) {
      throw TooShortChecksum();
    }

    if (isHrpTooShort(separatorPosition)) {
      throw TooShortHrp();
    }

    input = input.toLowerCase();

    final hrp = input.substring(0, separatorPosition);
    final data = input.substring(
      separatorPosition + 1,
      input.length - Bech32Validations.checksumLength,
    );
    final checksum =
        input.substring(input.length - Bech32Validations.checksumLength);

    if (hasOutOfRangeHrpCharacters(hrp)) {
      throw OutOfRangeHrpCharacters(hrp);
    }

    final List<int> dataBytes = data.split('').map((c) {
      return charset.indexOf(c);
    }).toList();

    if (hasOutOfBoundsChars(dataBytes)) {
      throw OutOfBoundChars(data[dataBytes.indexOf(-1)]);
    }

    final List<int> checksumBytes = checksum.split('').map((c) {
      return charset.indexOf(c);
    }).toList();

    if (hasOutOfBoundsChars(checksumBytes)) {
      throw OutOfBoundChars(checksum[checksumBytes.indexOf(-1)]);
    }

    if (isInvalidChecksum(hrp, dataBytes, checksumBytes)) {
      throw InvalidChecksum();
    }

    return Bech32(hrp, dataBytes);
  }
}

/// Generic validations for Bech32 standard.
class Bech32Validations {
  static const int maxInputLength = 90;
  static const checksumLength = 6;

  // From the entire input subtract the hrp length, the separator and the required checksum length
  bool isChecksumTooShort(int separatorPosition, String input) {
    return (input.length - separatorPosition - 1 - checksumLength) < 0;
  }

  bool hasOutOfBoundsChars(List<int> data) {
    return data.any((c) => c == -1);
  }

  bool isHrpTooShort(int separatorPosition) {
    return separatorPosition == 0;
  }

  bool isInvalidChecksum(String hrp, List<int> data, List<int> checksum) {
    return !_verifyChecksum(hrp, data + checksum);
  }

  bool isMixedCase(String input) {
    return input.toLowerCase() != input && input.toUpperCase() != input;
  }

  bool hasInvalidSeparator(String bech32) {
    return bech32.lastIndexOf(separator) == -1;
  }

  bool hasOutOfRangeHrpCharacters(String hrp) {
    return hrp.codeUnits.any((c) => c < 33 || c > 126);
  }
}

class Bech32 {
  Bech32(this.hrp, this.data);

  final String hrp;
  final List<int> data;
}

const String separator = '1';

const List<String> charset = [
  'q',
  'p',
  'z',
  'r',
  'y',
  '9',
  'x',
  '8',
  'g',
  'f',
  '2',
  't',
  'v',
  'd',
  'w',
  '0',
  's',
  '3',
  'j',
  'n',
  '5',
  '4',
  'k',
  'h',
  'c',
  'e',
  '6',
  'm',
  'u',
  'a',
  '7',
  'l',
];

const List<int> generator = [
  0x3b6a57b2,
  0x26508e6d,
  0x1ea119fa,
  0x3d4233dd,
  0x2a1462b3,
];

int _polymod(List<int> values) {
  var chk = 1;
  for (final v in values) {
    final top = chk >> 25;
    chk = (chk & 0x1ffffff) << 5 ^ v;
    for (int i = 0; i < generator.length; i++) {
      if ((top >> i) & 1 == 1) {
        chk ^= generator[i];
      }
    }
  }

  return chk;
}

List<int> _hrpExpand(String hrp) {
  var result = hrp.codeUnits.map((c) => c >> 5).toList();
  result = result + [0];

  result = result + hrp.codeUnits.map((c) => c & 31).toList();

  return result;
}

bool _verifyChecksum(String hrp, List<int> dataIncludingChecksum) {
  return _polymod(_hrpExpand(hrp) + dataIncludingChecksum) == 1;
}

List<int> _createChecksum(String hrp, List<int> data) {
  final values = _hrpExpand(hrp) + data + [0, 0, 0, 0, 0, 0];
  final polymod = _polymod(values) ^ 1;

  final List<int> result = List.generate(6, (index) => 0);

  for (int i = 0; i < result.length; i++) {
    result[i] = (polymod >> (5 * (5 - i))) & 31;
  }
  return result;
}

List<int> _convertBits(List<int> data, int from, int to, {bool pad = true}) {
  var acc = 0;
  var bits = 0;
  final List<int> result = [];
  final maxv = (1 << to) - 1;

  for (final v in data) {
    if (v < 0 || (v >> from) != 0) {
      throw Exception();
    }
    acc = (acc << from) | v;
    bits += from;
    while (bits >= to) {
      bits -= to;
      result.add((acc >> bits) & maxv);
    }
  }

  if (pad) {
    if (bits > 0) {
      result.add((acc << (to - bits)) & maxv);
    }
  } else if (bits >= from) {
    throw InvalidPadding('illegal zero padding');
  } else if (((acc << (to - bits)) & maxv) != 0) {
    throw InvalidPadding('non zero');
  }

  return result;
}

const String _hrp = 'icp';

String toBech32Address(String address) {
  if (address.length == 64) {
    address = crc32Del(address.toU8a()).toHex();
  }
  final List<int> addrBz = _convertBits(
    address.toU8a(),
    8,
    5,
  );

  final b32Class = Bech32(_hrp, addrBz);

  return bech32.encode(b32Class);
}

String fromBech32Address(String address) {
  try {
    final Bech32 res = bech32.decode(address);
    final hrp = res.hrp;
    final data = res.data;

    if (hrp != _hrp) {
      throw InvalidHrp();
    }

    final List<int> buf = _convertBits(data, 5, 8, pad: false);
    return crc32Add(Uint8List.fromList(buf)).toHex();
  } catch (e) {
    rethrow;
  }
}
