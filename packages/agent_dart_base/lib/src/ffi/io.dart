// lib/src/ffi/io.dart
import 'dart:ffi';
import 'dart:io';

import 'package:agent_dart_ffi/agent_dart_ffi.dart';

const libName = 'agent_dart';

DynamicLibrary createLibraryImpl() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('lib$libName.so');
  }
  if (Platform.isIOS || Platform.isMacOS) {
    return DynamicLibrary.process();
  }
  if (Platform.isLinux) {
    if (kReleaseMode) {
      return DynamicLibrary.open('lib$libName.dylib');
    }
    return DynamicLibrary.open(
      'linux/flutter/ephemeral/.plugin_symlinks/'
      'agent_dart/linux/'
      'linux-${Abi.current().architecture}/'
      '$libName.so',
    );
  }
  if (Platform.isWindows) {
    if (kReleaseMode) {
      return DynamicLibrary.open('$libName.dll');
    }
    return DynamicLibrary.open(
      'windows/flutter/ephemeral/.plugin_symlinks/'
      'agent_dart/windows/'
      'windows-${Abi.current().architecture}/'
      '$libName.dll',
    );
  }
  throw UnsupportedError('${Abi.current()} is not supported');
}

class AgentDartFFI {
  factory AgentDartFFI() => _instance;

  AgentDartFFI._();

  static final AgentDartFFI _instance = AgentDartFFI._();
  static String? dylib;

  static AgentDartImpl get impl => _instance._impl;
  late final AgentDartImpl _impl = AgentDartImpl(
    dylib == null ? createLibraryImpl() : DynamicLibrary.open(dylib!),
  );
}
