import 'dart:typed_data';

bool bufEquals(ByteBuffer b1, ByteBuffer b2) {
  if (b1.lengthInBytes != b2.lengthInBytes) return false;
  final u1 = Uint8List.fromList(b1.asUint8List());
  final u2 = Uint8List.fromList(b2.asUint8List());
  for (int i = 0; i < u1.length; i++) {
    if (u1[i] != u2[i]) {
      return false;
    }
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
  }
  throw RangeError.range(len, null, 0xffffff, 'length', 'Length is too long');
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
  }
  throw RangeError.range(len, null, 0xffffff, 'length', 'Length is too long');
}

int decodeLenBytes(Uint8List buf, int offset) {
  if (buf[offset] < 0x80) {
    return 1;
  }
  if (buf[offset] == 0x80) {
    throw ArgumentError.value(buf[offset], 'length', 'Invalid length');
  }
  if (buf[offset] == 0x81) {
    return 2;
  }
  if (buf[offset] == 0x82) {
    return 3;
  }
  if (buf[offset] == 0x83) {
    return 4;
  }
  throw RangeError.range(
    buf[offset],
    null,
    0xffffff,
    'length',
    'Length is too long',
  );
}

/// A DER encoded `SEQUENCE(OID)` for DER-encoded-COSE.
final oisCOSEDer = Uint8List.fromList([
  ...[0x30, 0x0c], // SEQUENCE
  ...[0x06, 0x0a], // OID with 10 bytes
  ...[
    0x2b,
    0x06,
    0x01,
    0x04,
    0x01,
    0x83,
    0xb8,
    0x43,
    0x01,
    0x01,
  ], // DER encoded COSE.
]);

/// A DER encoded `SEQUENCE(OID)` for the Ed25519 algorithm.
final oidEd25519 = Uint8List.fromList([
  ...[0x30, 0x05], // SEQUENCE
  ...[0x06, 0x03], // OID with 3 bytes
  ...[0x2b, 0x65, 0x70], // id-Ed25519 OID
]);

final canisterCOSEDer = Uint8List.fromList([
  ...[0x30, 0x0c], // SEQUENCE
  ...[0x06, 0x0a], // OID with 10 bytes
  ...[
    0x2b,
    0x06,
    0x01,
    0x04,
    0x01,
    0x83,
    0xb8,
    0x43,
    0x01,
    0x02, // canister signature tag
  ], // DER encoded COSE.
]);

// 1.2.840.10045.3
final oidP256 = Uint8List.fromList([
  ...[0x30, 0x13], // SEQUENCE
  ...[0x06, 0x08], // OID with 8 bytes
  ...[
    0x2a,
    0x86,
    0x48,
    0xce,
    0x3d,
    0x03,
    0x01,
    0x07,
  ]
]);

/// Wraps the given [payload] in a DER encoding tagged with the given encoded
/// [oid] like so: `SEQUENCE(oid, BITSTRING(payload))`
///
/// [payload] is the payload to encode as the bit string.
/// [oid] is the DER encoded (SEQUENCE wrapped) OID to tag the [payload] with.
Uint8List wrapDER(ByteBuffer payload, Uint8List oid) {
  // The header needs to include the unused bit count byte in its length.
  final bitStringHeaderLength = 2 + encodeLenBytes(payload.lengthInBytes + 1);
  final len = oid.lengthInBytes + bitStringHeaderLength + payload.lengthInBytes;
  int offset = 0;
  final buf = Uint8List(1 + encodeLenBytes(len) + len);
  // Sequence.
  buf[offset++] = 0x30;
  // Sequence Length.
  offset += encodeLen(buf, offset, len);
  // OID.
  buf.setAll(offset, oid);
  offset += oid.lengthInBytes;
  // Bit String Header.
  buf[offset++] = 0x03;
  offset += encodeLen(buf, offset, payload.lengthInBytes + 1);
  // 0 padding.
  buf[offset++] = 0x00;
  buf.setAll(offset, Uint8List.fromList(payload.asUint8List()));
  return buf;
}

/// Extracts a payload from the given `derEncoded` data, and checks that it was
/// tagged with the given `oid`.
///
/// `derEncoded = SEQUENCE(oid, BITSTRING(payload))`
///
/// [derEncoded] is the DER encoded and tagged data.
/// [oid] is the DER encoded (and SEQUENCE wrapped!) expected OID
Uint8List unwrapDER(ByteBuffer derEncoded, Uint8List oid) {
  int offset = 0;
  final buf = Uint8List.fromList(derEncoded.asUint8List());

  check(int expected, String name) {
    if (buf[offset] != expected) {
      throw ArgumentError.value(
        buf[offset],
        name,
        'Expected $expected for $name but got',
      );
    }
    offset++;
  }

  check(0x30, 'sequence');
  offset += decodeLenBytes(buf, offset);
  if (!bufEquals(
    buf.sublist(offset, offset + oid.lengthInBytes).buffer,
    oid.buffer,
  )) {
    throw StateError('Not the expecting OID.');
  }
  offset += oid.lengthInBytes;
  check(0x03, 'bit string');
  offset += decodeLenBytes(buf, offset);
  check(0x00, '0 padding');
  return buf.sublist(offset);
}
