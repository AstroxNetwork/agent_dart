library key_store;

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:agent_dart_ffi/agent_dart_ffi.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:pointycastle/export.dart';
import 'package:uuid/uuid.dart';

import '../../../identity/p256.dart';
import '../../../identity/secp256k1.dart';
import '../../../principal/utils/sha256.dart';
import '../../../utils/extension.dart';
import '../../../utils/u8a.dart';
import '../../cbor.dart';
import '../random.dart';

part 'function.dart';
part 'key_derivator.dart';
part 'util.dart';

@immutable
abstract class KeyStore {
  const KeyStore();

  Map get keyStoreMap;
}
