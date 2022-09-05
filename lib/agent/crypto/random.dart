import 'dart:math';
import 'dart:typed_data';

import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/hex.dart';
import 'package:agent_dart/utils/number.dart';
import 'package:agent_dart/utils/u8a.dart';

// import 'package:laksadart/laksadart.dart';

const _defaultLength = 32;

final bn53 = BigInt.parse(
  '11111111111111111111111111111111111111111111111111111',
  radix: 2,
);

class DartRandom {
  DartRandom(this.dartRandom);

  Random dartRandom;

  String get algorithmName => 'DartRandom';

  BigInt nextBigInteger(int bitLength) {
    final int fullBytes = bitLength ~/ 8;

    /// var remainingBits = bitLength % 8;

    /// Generate a number from the full bytes. Then, prepend a smaller number
    /// covering the remaining bits.
    final BigInt main = bytesToInt(nextBytes(fullBytes));

    /// forcing remainingBits to be calculate with bitLength
    final int remainingBits = (bitLength - main.bitLength);
    final int additional = remainingBits < 4
        ? dartRandom.nextInt(pow(2, remainingBits).toInt())
        : remainingBits;
    final BigInt additionalBit = (BigInt.from(additional) << (fullBytes * 8));
    final BigInt result = main + additionalBit;
    return result;
  }

  Uint8List nextBytes(int count) {
    final Uint8List list = Uint8List(count);

    for (int i = 0; i < list.length; i++) {
      list[i] = nextUint8();
    }
    return list;
  }

  int nextUint16() => dartRandom.nextInt(pow(2, 32).toInt());

  int nextUint32() => dartRandom.nextInt(pow(2, 32).toInt());

  int nextUint8() => dartRandom.nextInt(pow(2, 8).toInt());
}

Uint8List getRandomValues([int length = _defaultLength]) {
  final DartRandom rn = DartRandom(Random.secure());
  var entropy = rn.nextBigInteger(length * 8).toRadixString(16);

  if (entropy.length > length * 2) {
    entropy = entropy.substring(0, length * 2);
  }

  var randomPers = rn.nextBigInteger((length) * 8).toRadixString(16);

  if (randomPers.length > (length) * 2) {
    randomPers = randomPers.substring(0, (length) * 2);
  }
  return randomPers.toU8a();
}

Uint8List randomAsU8a([int length = _defaultLength]) {
  return getRandomValues(length);
}

String randomAsHex([int length = 32]) {
  return u8aToHex(randomAsU8a(length));
}

int randomAsNumber() {
  return (hexToBn(randomAsHex(8)) & bn53).toInt();
}
