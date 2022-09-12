import 'dart:typed_data';

const _alphabet = 'abcdefghijklmnopqrstuvwxyz234567';

String base32Encode(Uint8List input) {
  // How many bits will we skip from the first byte.
  int skip = 0;
  // 5 high bits, carry from one byte to the next.
  int bits = 0;

  // The output string in base32.
  var output = '';

  int encodeByte(int byte) {
    if (skip < 0) {
      // we have a carry from the previous byte
      bits |= byte >> -skip;
    } else {
      // no carry
      bits = (byte << skip) & 248;
    }

    if (skip > 3) {
      // Not enough data to produce a character, get us another one
      skip -= 8;
      return 1;
    }

    if (skip < 4) {
      // produce a character
      output += _alphabet[bits >> 3];
      skip += 5;
    }

    return 0;
  }

  for (int i = 0; i < input.length;) {
    i += encodeByte(input[i]);
  }

  return output + (skip < 0 ? _alphabet[bits >> 3] : '');
}

Uint8List base32Decode(String input) {
  // how many bits we have from the previous character.
  int skip = 0;
  // current byte we're producing.
  int byte = 0;

  final output = Uint8List(((input.length * 4) / 3).ceil() | 0);
  int o = 0;

  final Map<String, int> lookupTable = _alphabet.split('').fold({}, (p, e) {
    p[e] = _alphabet.indexOf(e);
    return p;
  });
  // Add aliases for rfc4648.
  lookupTable
    ..putIfAbsent('0', () => lookupTable['o']!)
    ..putIfAbsent('1', () => lookupTable['i']!);

  void decodeChar(String char) {
    // Consume a character from the stream, store
    // the output in this.output. As before, better
    // to use update().
    final found = lookupTable[char.toLowerCase()];
    assert(found != null, 'Invalid character: $char');
    var val = found!;
    // move to the high bits
    val <<= 3;
    // 32 bit shift?
    byte |= (val & 0xffffffff) >> skip;

    skip += 5;

    if (skip >= 8) {
      // We have enough bytes to produce an output
      output[o++] = byte;
      skip -= 8;

      if (skip > 0) {
        byte = (val << (5 - skip)) & 255;
      } else {
        byte = 0;
      }
    }
  }

  for (int i = 0; i < input.length; i += 1) {
    decodeChar(input[i]);
  }
  return output.sublist(0, o);
}
