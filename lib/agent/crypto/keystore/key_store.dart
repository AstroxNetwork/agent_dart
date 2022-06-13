library key_store;

import 'dart:core';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:agent_dart/agent/crypto/keystore/api.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/bridge/ffi/ffi.dart' hide SHA256;
import 'package:agent_dart/principal/utils/sha256.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart' as pbkdf2;
import 'package:pointycastle/key_derivators/scrypt.dart' as scrypt;
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/stream/ctr.dart';

part 'key_derivator.dart';
part 'function.dart';
part 'util.dart';

abstract class KeyStore {
  Map get keyStoreMap;
}
