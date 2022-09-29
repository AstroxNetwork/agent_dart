library key_store;

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/agent/crypto/random.dart';
import 'package:agent_dart/bridge/ffi/ffi.dart' hide SHA256;
import 'package:agent_dart/principal/utils/sha256.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/u8a.dart';
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
