library key_store;

import 'dart:core';
import 'dart:convert';
import 'dart:typed_data';
import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/crypto/random.dart';
import 'package:agent_dart/bridge/ffi/ffi.dart' hide SHA256;
import 'package:agent_dart/principal/utils/sha256.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart' as pbkdf2;
import 'package:pointycastle/key_derivators/scrypt.dart' as scrypt;
import 'package:pointycastle/macs/hmac.dart';

part 'key_derivator.dart';

part 'function.dart';

part 'util.dart';

abstract class KeyStore {
  Map get keyStoreMap;
}
