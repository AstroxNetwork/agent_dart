import 'package:validators/validators.dart' as validators;

import 'dart:typed_data';

import 'u8a.dart';

bool isAscii(dynamic value) {
  return value != null
      ? !u8aToU8a(value).any(
          (byte) => (byte >= 127) || (byte < 32 && ![9, 10, 13].contains(byte)),
        )
      : isString(value);
}

bool isString(dynamic value) {
  return value is String;
}

bool isBigInt(dynamic value) {
  return value is BigInt;
}

bool isBn(dynamic value) {
  return isBigInt(value);
}

bool isBoolean(dynamic value) {
  return value is bool;
}

bool isBuffer(dynamic value) {
  return value is ByteBuffer;
}

bool isError(dynamic value) {
  return value is Error;
}

bool isFunction(dynamic value) {
  return value is Function;
}

bool isHex(dynamic value, [int bitLength = -1, bool ignoreLength = false]) {
  final reg = RegExp(r'^0x[a-fA-F\d]+$');
  final isValidHex = value == '0x' ||
      (isString(value) && reg.allMatches(value.toString()).isNotEmpty);
  if (isValidHex && bitLength != -1) {
    return (value as String).length == (2 + (bitLength / 4).ceil());
  }

  return isValidHex && (ignoreLength || ((value as String).length % 2 == 0));
}

bool isHexString(String str) {
  final result = str.startsWith(RegExp(r'0x', caseSensitive: false))
      ? str.substring(2)
      : str;
  return validators.matches(result, '^[0-9a-fA-F]{${result.length}}');
}

bool isHexadecimal(String str) {
  return validators.isHexadecimal(str);
}

bool isIp(String value, String type) {
  final typeInt = type == 'v4'
      ? 4
      : type == 'v6'
          ? 6
          : 0;

  return validators.isIP(value, typeInt);
}

bool isJsonObject(dynamic value) {
  return validators.isJSON(value);
}

bool isNull(dynamic value) {
  return value == null;
}

bool isNumber(dynamic value) {
  return value is num;
}

bool isObject(dynamic value) {
  return value is Map;
}

abstract class Observable {
  Function? next;
}

bool isObservable(dynamic value) {
  return isFunction((value as Observable).next);
}

bool isTestChain(String value) {
  return RegExp(r'/(Development|Local Testnet)\$/').hasMatch(value);
}

bool isU8a(dynamic value) {
  return value is Uint8List;
}

bool isUtf8(dynamic value) {
  if (value == null) {
    return isString(value);
  }
  // dont see hex as utf8
  if (isHex(value)) {
    return false;
  }

  final u8a = u8aToU8a(value);
  final len = u8a.length;
  var i = 0;

  while (i < len) {
    if (u8a[i] <= 0x7F) /* 00..7F */ {
      i += 1;
    } else if (u8a[i] >= 0xC2 && u8a[i] <= 0xDF) /* C2..DF 80..BF */ {
      if (i + 1 < len) /* Expect a 2nd byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0xBF) {
          // *message = "After a first byte between C2 and DF, expecting a 2nd byte between 80 and BF";
          // *faulty_bytes = 2;
          return false;
        }
      } else {
        // *message = "After a first byte between C2 and DF, expecting a 2nd byte.";
        // *faulty_bytes = 1;
        return false;
      }

      i += 2;
    } else if (u8a[i] == 0xE0) /* E0 A0..BF 80..BF */ {
      if (i + 2 < len) /* Expect a 2nd and 3rd byte */ {
        if (u8a[i + 1] < 0xA0 || u8a[i + 1] > 0xBF) {
          // *message = "After a first byte of E0, expecting a 2nd byte between A0 and BF.";
          // *faulty_bytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // *message = "After a first byte of E0, expecting a 3nd byte between 80 and BF.";
          // *faulty_bytes = 3;
          return false;
        }
      } else {
        // *message = "After a first byte of E0, expecting two following bytes.";
        // *faulty_bytes = 1;
        return false;
      }

      i += 3;
    } else if (u8a[i] >= 0xE1 && u8a[i] <= 0xEC) /* E1..EC 80..BF 80..BF */ {
      if (i + 2 < len) /* Expect a 2nd and 3rd byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0xBF) {
          // *message = "After a first byte between E1 and EC, expecting the 2nd byte between 80 and BF.";
          // *faulty_bytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // *message = "After a first byte between E1 and EC, expecting the 3rd byte between 80 and BF.";
          // *faulty_bytes = 3;
          return false;
        }
      } else {
        // *message = "After a first byte between E1 and EC, expecting two following bytes.";
        // *faulty_bytes = 1;
        return false;
      }

      i += 3;
    } else if (u8a[i] == 0xED) /* ED 80..9F 80..BF */ {
      if (i + 2 < len) /* Expect a 2nd and 3rd byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0x9F) {
          // *message = "After a first byte of ED, expecting 2nd byte between 80 and 9F.";
          // *faulty_bytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // *message = "After a first byte of ED, expecting 3rd byte between 80 and BF.";
          // *faulty_bytes = 3;
          return false;
        }
      } else {
        // *message = "After a first byte of ED, expecting two following bytes.";
        // *faulty_bytes = 1;
        return false;
      }

      i += 3;
    } else if (u8a[i] >= 0xEE && u8a[i] <= 0xEF) /* EE..EF 80..BF 80..BF */ {
      if (i + 2 < len) /* Expect a 2nd and 3rd byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0xBF) {
          // *message = "After a first byte between EE and EF, expecting 2nd byte between 80 and BF.";
          // *faulty_bytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // *message = "After a first byte between EE and EF, expecting 3rd byte between 80 and BF.";
          // *faulty_bytes = 3;
          return false;
        }
      } else {
        // *message = "After a first byte between EE and EF, two following bytes.";
        // *faulty_bytes = 1;
        return false;
      }

      i += 3;
    } else if (u8a[i] == 0xF0) /* F0 90..BF 80..BF 80..BF */ {
      if (i + 3 < len) /* Expect a 2nd, 3rd 3th byte */ {
        if (u8a[i + 1] < 0x90 || u8a[i + 1] > 0xBF) {
          // *message = "After a first byte of F0, expecting 2nd byte between 90 and BF.";
          // *faulty_bytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // *message = "After a first byte of F0, expecting 3rd byte between 80 and BF.";
          // *faulty_bytes = 3;
          return false;
        }

        if (u8a[i + 3] < 0x80 || u8a[i + 3] > 0xBF) {
          // *message = "After a first byte of F0, expecting 4th byte between 80 and BF.";
          // *faulty_bytes = 4;
          return false;
        }
      } else {
        // *message = "After a first byte of F0, expecting three following bytes.";
        // *faulty_bytes = 1;
        return false;
      }

      i += 4;
    } else if (u8a[i] >= 0xF1 &&
        u8a[i] <= 0xF3) /* F1..F3 80..BF 80..BF 80..BF */ {
      if (i + 3 < len) /* Expect a 2nd, 3rd 3th byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0xBF) {
          // *message = "After a first byte of F1, F2, or F3, expecting a 2nd byte between 80 and BF.";
          // *faulty_bytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // *message = "After a first byte of F1, F2, or F3, expecting a 3rd byte between 80 and BF.";
          // *faulty_bytes = 3;
          return false;
        }

        if (u8a[i + 3] < 0x80 || u8a[i + 3] > 0xBF) {
          // *message = "After a first byte of F1, F2, or F3, expecting a 4th byte between 80 and BF.";
          // *faulty_bytes = 4;
          return false;
        }
      } else {
        // *message = "After a first byte of F1, F2, or F3, expecting three following bytes.";
        // *faulty_bytes = 1;
        return false;
      }

      i += 4;
    } else if (u8a[i] == 0xF4) /* F4 80..8F 80..BF 80..BF */ {
      if (i + 3 < len) /* Expect a 2nd, 3rd 3th byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0x8F) {
          // *message = "After a first byte of F4, expecting 2nd byte between 80 and 8F.";
          // *faulty_bytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // *message = "After a first byte of F4, expecting 3rd byte between 80 and BF.";
          // *faulty_bytes = 3;
          return false;
        }

        if (u8a[i + 3] < 0x80 || u8a[i + 3] > 0xBF) {
          // *message = "After a first byte of F4, expecting 4th byte between 80 and BF.";
          // *faulty_bytes = 4;
          return false;
        }
      } else {
        // *message = "After a first byte of F4, expecting three following bytes.";
        // *faulty_bytes = 1;
        return false;
      }

      i += 4;
    } else {
      // *message = "Expecting bytes in the following ranges: 00..7F C2..F4.";
      // *faulty_bytes = 1;
      return false;
    }
  }

  return true;
}

bool isUrl(String url) {
  return validators.isURL(url);
}

bool isByteString(String byStr, {required int length}) {
  final str = byStr.startsWith(RegExp(r'0x', caseSensitive: false))
      ? byStr.substring(2)
      : byStr;
  return validators.matches(str, '^[0-9a-fA-F]{$length}') &&
      validators.isLength(str, length, length);
}

bool isAddress(String str) {
  return isByteString(str, length: 40);
}

bool isPrivateKey(String str) {
  return isByteString(str, length: 64);
}

bool isPublicKey(String str) {
  return isByteString(str, length: 66);
}

bool isSignature(String str) {
  return isByteString(str, length: 128);
}

bool isBech32(String str) {
  return validators.matches(str, 'zil1[qpzry9x8gf2tvdw0s3jn54khce6mua7l]{38}');
}
