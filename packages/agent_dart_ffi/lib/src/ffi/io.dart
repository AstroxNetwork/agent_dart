import 'dart:ffi';
import 'dart:io' show Platform;

import '../bridge_generated.dart';

const _lib = 'agent_dart';
const _package = _lib;

DynamicLibrary _getDynamicLibrary() {
  final libPath = switch (Platform.operatingSystem) {
    'macos' || 'ios' => '$_package.framework/$_package',
    'android' || 'linux' => 'lib$_lib.so',
    'windows' => '$_lib.dll',
    _ => throw UnsupportedError(
        'unsupported operating system ${Platform.operatingSystem}',
      ),
  };
  return DynamicLibrary.open(libPath);
}

AgentDartImpl createAgentDartImpl() => AgentDartImpl(_getDynamicLibrary());
