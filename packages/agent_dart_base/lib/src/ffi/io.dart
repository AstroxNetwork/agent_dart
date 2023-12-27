import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:agent_dart_base/agent_dart_base.dart' show AgentDartImpl;

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

  static AgentDartImpl get impl => _instance._impl;
  late final AgentDartImpl _impl = AgentDartImpl(createLibraryImpl());
}

extension AbiExtension on Abi {
  String get architecture => toString().split('_').last;

  String get os => toString().split('_').first;
}
