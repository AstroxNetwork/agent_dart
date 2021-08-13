import 'dart:typed_data';

import 'package:agent_dart/principal/utils/get_crc.dart';
import 'package:agent_dart/utils/u8a.dart';
// ignore: implementation_imports
import 'package:crypto/src/digest_sink.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:crypto/crypto.dart';
import 'package:typed_data/typed_buffers.dart';

Uint8List sha256Chunks(List<dynamic> chunks) {
  var ds = DigestSink();
  var sha = sha256.startChunkedConversion(ds);

  for (var chunk in chunks) {
    sha.add(chunk is ByteBuffer ? chunk.asInt8List() : chunk);
  }
  sha.close();
  return Uint8List.fromList(ds.value.bytes);
}

///
/// @param {object} update
/// @returns {object}
// ignore: non_constant_identifier_names
Map<String, dynamic> make_read_state_from_update(Map update) {
  return {
    "sender": update["sender"],
    "paths": [
      [("request_status".plainToU8a()), HttpCanisterUpdate_id(update)]
    ],
    "ingress_expiry": update["ingress_expiry"],
  };
}

///
/// @param {object} read_state
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List HttpReadState_representation_independent_hash(Map readState) {
  return hash_of_map({
    "request_type": "read_state",
    "ingress_expiry": readState["ingress_expiry"],
    "paths": readState["paths"],
    "sender": readState["sender"],
  });
}

// ignore: non_constant_identifier_names
final DOMAIN_IC_REQUEST = ("\x0Aic-request").plainToU8a();

///
/// @param {Buffer} message_id
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List make_sig_data(Uint8List messageId) {
  return u8aConcat([DOMAIN_IC_REQUEST, messageId]);
}

///
/// @param {object} update
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List HttpCanisterUpdate_id(Map update) {
  return HttpCanisterUpdate_representation_independent_hash(update);
}

///
/// @param {object} update
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List HttpCanisterUpdate_representation_independent_hash(Map update) {
  return hash_of_map({
    "request_type": "call",
    "canister_id": update["canister_id"],
    "method_name": update["method_name"],
    "arg": update["arg"],
    "ingress_expiry": update["ingress_expiry"],
    "sender": update["sender"],
  });
}

///
/// @param {object} map
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List hash_of_map(Map map) {
  var hashes = <Uint8List>[];

  for (var entry in map.entries) {
    hashes.add(hash_key_val(entry.key, entry.value));
  }

  return sha256Chunks(u8aSorted(hashes));
}

///
/// @param {string} key
/// @param {string|Buffer|BigInt} val
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List hash_key_val(dynamic key, dynamic val) {
  return u8aConcat([hash_string(key.toString()), hash_val(val)]);
}

///
/// @param {string|Buffer|BigInt} val
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List hash_val(dynamic val) {
  if (val is String) {
    return hash_string(val);
  }
  if (val is Uint8List || val is Uint8Buffer) {
    return hash_bytes(Uint8List.fromList(val));
  }
  if (val is BigInt) {
    return hash_U64(val);
  }
  if (val is num) {
    return hash_U64(BigInt.from(val));
  }
  if (val is List) {
    return hash_array(val);
  }
  if (val is Map) {
    return hash_of_map(val);
  }
  throw "hash_val($val) unsupported";
}

///
/// @param {string} value
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List hash_string(String value) {
  return sha256Chunks([value.plainToU8a().buffer]);
}

///
/// @param {Buffer} value
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List hash_bytes(Uint8List value) {
  return sha256Chunks([value.buffer]);
}

///
/// @param {BigInt} n
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List hash_U64(BigInt n) {
  // const buf = Buffer.allocUnsafe(10);
  var buf = Uint8List(10);
  var i = 0;
  while (true) {
    var byte = (n & BigInt.from(0x7f));
    n >>= BigInt.from(7).toInt();
    if (n == BigInt.zero) {
      buf[i] = byte.toInt();
      break;
    } else {
      buf[i] = byte.toInt() | 0x80;
      ++i;
    }
  }
  return hash_bytes(buf.sublist(0, i + 1));
}

///
/// @param {Array<any>} elements
/// @returns {Buffer}
// ignore: non_constant_identifier_names
Uint8List hash_array(List elements) {
  return sha256Chunks(elements.map(hash_val).toList());
}

/// Given an account address with a prepended big-endian CRC32 checksum, verify
/// the checksum and remove it.
/// @param {Buffer} buf
/// @returns {Buffer}
Uint8List crc32Del(Uint8List buf) {
  final res = buf.sublist(4);
  assert(getCrc32(res.buffer) == buf.buffer.asByteData().getUint32(0));
  return res;
}

/// Prepend a big-endian CRC32 checksum.
/// @param {Buffer} buf
/// @returns {Buffer}
Uint8List crc32Add(Uint8List buf) {
  final view = ByteData(4);
  view.setUint32(0, getCrc32(buf.buffer));
  final checksum = view.buffer.asUint8List();
  final bytes = Uint8List.fromList(buf);
  return Uint8List.fromList([...checksum, ...bytes]);
}
