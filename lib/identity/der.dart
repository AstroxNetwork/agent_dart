import 'dart:typed_data';

import 'package:typed_data/typed_buffers.dart';

bool bufEquals(ByteBuffer b1, ByteBuffer b2) {
  if (b1.lengthInBytes != b2.lengthInBytes) return false;
  final u1 = Uint8List.fromList(b1.asUint8List());
  final u2 = Uint8List.fromList(b2.asUint8List());
  for (var i = 0; i < u1.length; i++) {
    if (u1[i] != u2[i]) return false;
  }
  return true;
}

int encodeLenBytes(int len) {
  if (len <= 0x7f) {
    return 1;
  } else if (len <= 0xff) {
    return 2;
  } else if (len <= 0xffff) {
    return 3;
  } else if (len <= 0xffffff) {
    return 4;
  } else {
    throw 'Length too long (> 4 bytes)';
  }
}

int encodeLen(Uint8List buf, int offset, int len) {
  if (len <= 0x7f) {
    buf[offset] = len;
    return 1;
  } else if (len <= 0xff) {
    buf[offset] = 0x81;
    buf[offset + 1] = len;
    return 2;
  } else if (len <= 0xffff) {
    buf[offset] = 0x82;
    buf[offset + 1] = len >> 8;
    buf[offset + 2] = len;
    return 3;
  } else if (len <= 0xffffff) {
    buf[offset] = 0x83;
    buf[offset + 1] = len >> 16;
    buf[offset + 2] = len >> 8;
    buf[offset + 3] = len;
    return 4;
  } else {
    throw 'Length too long (> 4 bytes)';
  }
}

int decodeLenBytes(Uint8List buf, int offset) {
  if (buf[offset] < 0x80) return 1;
  if (buf[offset] == 0x80) throw 'Invalid length 0';
  if (buf[offset] == 0x81) return 2;
  if (buf[offset] == 0x82) return 3;
  if (buf[offset] == 0x83) return 4;
  throw 'Length too long (> 4 bytes)';
}

/// A DER encoded `SEQUENCE(OID)` for DER-encoded-COSE
final DER_COSE_OID = Uint8List.fromList([
  ...[0x30, 0x0c], // SEQUENCE
  ...[0x06, 0x0a], // OID with 10 bytes
  ...[0x2b, 0x06, 0x01, 0x04, 0x01, 0x83, 0xb8, 0x43, 0x01, 0x01], // DER encoded COSE
]);

/// A DER encoded `SEQUENCE(OID)` for the Ed25519 algorithm
final ED25519_OID = Uint8List.fromList([
  ...[0x30, 0x05], // SEQUENCE
  ...[0x06, 0x03], // OID with 3 bytes
  ...[0x2b, 0x65, 0x70], // id-Ed25519 OID
]);

/// Wraps the given `payload` in a DER encoding tagged with the given encoded `oid` like so:
/// `SEQUENCE(oid, BITSTRING(payload))`
///
/// @param paylod The payload to encode as the bit string
/// @param oid The DER encoded (and SEQUENCE wrapped!) OID to tag the payload with
Uint8List wrapDER(ByteBuffer payload, Uint8List oid) {
  // The Bit String header needs to include the unused bit count byte in its length
  final bitStringHeaderLength = 2 + encodeLenBytes(payload.lengthInBytes + 1);
  final len = oid.lengthInBytes + bitStringHeaderLength + payload.lengthInBytes;
  var offset = 0;
  final buf = Uint8List(1 + encodeLenBytes(len) + len);
  // Sequence
  buf[offset++] = 0x30;
  // Sequence Length
  offset += encodeLen(buf, offset, len);

  // OID

  buf.setAll(offset, oid);
  offset += oid.lengthInBytes;

  // Bit String Header
  buf[offset++] = 0x03;
  offset += encodeLen(buf, offset, payload.lengthInBytes + 1);
  // 0 padding
  buf[offset++] = 0x00;
  buf.setAll(offset, Uint8List.fromList(payload.asUint8List()));

  return buf;
}

/// Extracts a payload from the given `derEncoded` data, and checks that it was tagged with the given `oid`.
///
/// `derEncoded = SEQUENCE(oid, BITSTRING(payload))`
///
/// @param derEncoded The DER encoded and tagged data
/// @param oid The DER encoded (and SEQUENCE wrapped!) expected OID
/// @returns The unwrapped payload
Uint8List unwrapDER(ByteBuffer derEncoded, Uint8List oid) {
  var offset = 0;

  final buf = Uint8List.fromList(derEncoded.asUint8List());
  check(int n, String msg) {
    if (buf[offset++] != n) throw 'Expected: ' + msg;
  }

  check(0x30, 'sequence');
  offset += decodeLenBytes(buf, offset);

  if (!bufEquals(buf.sublist(offset, offset + oid.lengthInBytes).buffer, oid.buffer)) {
    throw 'Not the expected OID.';
  }
  offset += oid.lengthInBytes;

  check(0x03, 'bit string');
  offset += decodeLenBytes(buf, offset);
  check(0x00, '0 padding');
  return buf.sublist(offset);
}
