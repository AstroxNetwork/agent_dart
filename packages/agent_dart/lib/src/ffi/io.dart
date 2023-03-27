// lib/src/ffi/io.dart
import 'dart:ffi';
import 'dart:io';

import 'package:agent_dart_ffi/agent_dart_ffi.dart';

const libName = 'agent_dart';
const dyLib = 'lib$libName.dylib';
const androidLibName = 'lib$libName.so';
const linuxLibName = 'lib$libName.so';

DynamicLibrary createLibraryImpl() {
  if (Platform.environment['FLUTTER_TEST'] == null) {
    if (Platform.isIOS || Platform.isMacOS) {
      return DynamicLibrary.executable();
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('$libName.dll');
    } else {
      return DynamicLibrary.open(androidLibName);
    }
  } else {
    if (Platform.isAndroid) {
      return DynamicLibrary.open(androidLibName);
    }
    if (Platform.isIOS) {
      return DynamicLibrary.executable();
    }

    if (Platform.isMacOS) {
      return DynamicLibrary.open(
        'target/x86_64-apple-darwin/release/$dyLib',
      );
    }
    if (Platform.isLinux) {
      return DynamicLibrary.open(
          'target/x86_64-unknown-linux-gnu/$linuxLibName');
    }
    if (Platform.isWindows) {
      return DynamicLibrary.open('$libName.dll');
    }
    return DynamicLibrary.open('target/x86_64-apple-darwin/release/$dyLib');
  }
}

class AgentDartFFI {
  factory AgentDartFFI() => _instance;

  AgentDartFFI._();

  static final AgentDartFFI _instance = AgentDartFFI._();
  static String? dylib;

  static AgentDartImpl get impl => _instance._impl;
  late final AgentDartImpl _impl = AgentDartImpl(
      dylib == null ? createLibraryImpl() : DynamicLibrary.open(dylib!));
}
