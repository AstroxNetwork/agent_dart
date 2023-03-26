library key_store;

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/crypto/random.dart';
import 'package:agent_dart/src/ffi/io.dart' hide SHA256;
import 'package:agent_dart/identity/p256.dart';
import 'package:agent_dart/identity/secp256k1.dart';
import 'package:agent_dart/principal/utils/sha256.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:agent_dart_ffi/agent_dart_ffi.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:pointycastle/export.dart';
import 'package:uuid/uuid.dart';

part 'key_derivator.dart';

part 'function.dart';

part 'util.dart';

@immutable
abstract class KeyStore {
  const KeyStore();

  Map get keyStoreMap;
}
