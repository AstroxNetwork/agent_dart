import 'dart:ffi';
import 'dart:io' show Platform;

import '../bridge_generated.dart';

const _lib = 'agent_dart';
const _package = _lib;

DynamicLibrary _getDynamicLibrary() {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_package.framework/$_package');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_lib.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_lib.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}

AgentDartImpl createAgentDartImpl() => AgentDartImpl(_getDynamicLibrary());
