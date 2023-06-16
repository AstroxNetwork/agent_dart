library key_store;

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:agent_dart_base/agent/cbor.dart';
import 'package:agent_dart_base/agent/crypto/random.dart';
import 'package:agent_dart_base/identity/p256.dart';
import 'package:agent_dart_base/identity/secp256k1.dart';
import 'package:agent_dart_base/principal/utils/sha256.dart';
import 'package:agent_dart_base/src/ffi/io.dart';
import 'package:agent_dart_base/utils/extension.dart';
import 'package:agent_dart_base/utils/u8a.dart';
import 'package:agent_dart_ffi/agent_dart_ffi.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:pointycastle/export.dart';
import 'package:uuid/uuid.dart';

part 'function.dart';
part 'key_derivator.dart';
part 'util.dart';

@immutable
abstract class KeyStore {
  const KeyStore();

  Map get keyStoreMap;
}
