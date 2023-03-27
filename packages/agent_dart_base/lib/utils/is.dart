import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';
import 'package:validators/validators.dart' as validators;

import '../principal/utils/get_crc.dart';
import 'u8a.dart';

bool isAscii(dynamic value) {
  return !u8aToU8a(value).any(
    (byte) => (byte >= 127) || (byte < 32 && ![9, 10, 13].contains(byte)),
  );
}

bool isHex(dynamic value, {int bits = -1, bool ignoreLength = false}) {
  if (value is! String) {
    return false;
  }
  if (value == '0x') {
    // Adapt Ethereum special cases.
    return true;
  }
  if (value.startsWith('0x')) {
    value = value.substring(2);
  }
  if (validators.isHexadecimal(value)) {
    if (bits != -1) {
      return value.length == (bits / 4).ceil();
    }
    return ignoreLength || value.length % 2 == 0;
  }
  return false;
}

bool isIP(String value, String type) {
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

bool isTestChain(String value) {
  return RegExp(r'(Development|(Local Testnet))$').hasMatch(value);
}

bool isUtf8(dynamic value) {
  if (value == null) {
    return false;
  }
  // Don't treat HEX as UTF-8.
  if (isHex(value)) {
    return false;
  }
  final u8a = u8aToU8a(value);
  final len = u8a.length;
  int i = 0;

  while (i < len) {
    if (u8a[i] <= 0x7F) /* 00..7F */ {
      i += 1;
    } else if (u8a[i] >= 0xC2 && u8a[i] <= 0xDF) /* C2..DF 80..BF */ {
      if (i + 1 < len) /* Expect a 2nd byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0xBF) {
          // After a first byte between C2 and DF, expecting a 2nd byte
          // between 80 and BF.
          // faultyBytes = 2;
          return false;
        }
      } else {
        // After a first byte between C2 and DF, expecting a 2nd byte.
        // faultyBytes = 1;
        return false;
      }

      i += 2;
    } else if (u8a[i] == 0xE0) /* E0 A0..BF 80..BF */ {
      if (i + 2 < len) /* Expect a 2nd and 3rd byte */ {
        if (u8a[i + 1] < 0xA0 || u8a[i + 1] > 0xBF) {
          // After a first byte of E0, expecting a 2nd byte between A0 and BF.
          // faultyBytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // After a first byte of E0, expecting a 3nd byte between 80 and BF.
          // faultyBytes = 3;
          return false;
        }
      } else {
        // After a first byte of E0, expecting two following bytes.
        // faultyBytes = 1;
        return false;
      }

      i += 3;
    } else if (u8a[i] >= 0xE1 && u8a[i] <= 0xEC) /* E1..EC 80..BF 80..BF */ {
      if (i + 2 < len) /* Expect a 2nd and 3rd byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0xBF) {
          // After a first byte between E1 and EC, expecting the 2nd byte
          // between 80 and BF.
          // faultyBytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // After a first byte between E1 and EC, expecting the 3rd byte
          // between 80 and BF.
          // faultyBytes = 3;
          return false;
        }
      } else {
        // After a first byte between E1 and EC, expecting two following bytes.
        // faultyBytes = 1;
        return false;
      }

      i += 3;
    } else if (u8a[i] == 0xED) /* ED 80..9F 80..BF */ {
      if (i + 2 < len) /* Expect a 2nd and 3rd byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0x9F) {
          // After a first byte of ED, expecting 2nd byte between 80 and 9F.
          // *faultyBytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // After a first byte of ED, expecting 3rd byte between 80 and BF.
          // *faultyBytes = 3;
          return false;
        }
      } else {
        // After a first byte of ED, expecting two following bytes.
        // *faultyBytes = 1;
        return false;
      }

      i += 3;
    } else if (u8a[i] >= 0xEE && u8a[i] <= 0xEF) /* EE..EF 80..BF 80..BF */ {
      if (i + 2 < len) /* Expect a 2nd and 3rd byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0xBF) {
          // After a first byte between EE and EF, expecting 2nd byte
          // between 80 and BF.
          // faultyBytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // After a first byte between EE and EF, expecting 3rd byte
          // between 80 and BF.
          // faultyBytes = 3;
          return false;
        }
      } else {
        // After a first byte between EE and EF, two following bytes.
        // faultyBytes = 1;
        return false;
      }

      i += 3;
    } else if (u8a[i] == 0xF0) /* F0 90..BF 80..BF 80..BF */ {
      if (i + 3 < len) /* Expect a 2nd, 3rd 3th byte */ {
        if (u8a[i + 1] < 0x90 || u8a[i + 1] > 0xBF) {
          // After a first byte of F0, expecting 2nd byte between 90 and BF.
          // faultyBytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // After a first byte of F0, expecting 3rd byte between 80 and BF.
          // faultyBytes = 3;
          return false;
        }

        if (u8a[i + 3] < 0x80 || u8a[i + 3] > 0xBF) {
          // After a first byte of F0, expecting 4th byte between 80 and BF.
          // faultyBytes = 4;
          return false;
        }
      } else {
        // After a first byte of F0, expecting three following bytes.
        // faultyBytes = 1;
        return false;
      }

      i += 4;
    } else if (u8a[i] >= 0xF1 &&
        u8a[i] <= 0xF3) /* F1..F3 80..BF 80..BF 80..BF */ {
      if (i + 3 < len) /* Expect a 2nd, 3rd 3th byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0xBF) {
          // After a first byte of F1, F2, or F3, expecting a 2nd byte
          // between 80 and BF.
          // faultyBytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // After a first byte of F1, F2, or F3, expecting a 3rd byte
          // between 80 and BF.
          // faultyBytes = 3;
          return false;
        }

        if (u8a[i + 3] < 0x80 || u8a[i + 3] > 0xBF) {
          // After a first byte of F1, F2, or F3, expecting a 4th byte
          // between 80 and BF.
          // faultyBytes = 4;
          return false;
        }
      } else {
        // After a first byte of F1, F2, or F3, expecting three following bytes.
        // faultyBytes = 1;
        return false;
      }

      i += 4;
    } else if (u8a[i] == 0xF4) /* F4 80..8F 80..BF 80..BF */ {
      if (i + 3 < len) /* Expect a 2nd, 3rd 3th byte */ {
        if (u8a[i + 1] < 0x80 || u8a[i + 1] > 0x8F) {
          // After a first byte of F4, expecting 2nd byte between 80 and 8F.
          // faultyBytes = 2;
          return false;
        }

        if (u8a[i + 2] < 0x80 || u8a[i + 2] > 0xBF) {
          // After a first byte of F4, expecting 3rd byte between 80 and BF.
          // faultyBytes = 3;
          return false;
        }

        if (u8a[i + 3] < 0x80 || u8a[i + 3] > 0xBF) {
          // After a first byte of F4, expecting 4th byte between 80 and BF.
          // faultyBytes = 4;
          return false;
        }
      } else {
        // After a first byte of F4, expecting three following bytes.
        // faultyBytes = 1;
        return false;
      }

      i += 4;
    } else {
      // *message = "Expecting bytes in the following ranges: 00..7F C2..F4.
      // faultyBytes = 1;
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

bool isAccountId(String str) {
  if (!isHex(str) || str.length != 64) {
    return false;
  }
  final fullBytes = str.toU8a();
  final view = ByteData(4);
  view.setUint32(0, getCrc32((fullBytes.sublist(4)).buffer));
  return fullBytes.sublist(0, 4).eq(view.buffer.asUint8List());
}
