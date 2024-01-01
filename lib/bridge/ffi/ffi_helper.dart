import 'dart:ffi' show Abi, DynamicLibrary;
import 'dart:io' show Platform;

import 'ffi_bridge.dart';

const _lib = 'agent_dart';
const _package = _lib;

final DynamicLibrary _dylib = () {
  final isFlutterTest = Platform.environment['FLUTTER_TEST'] != null;
  if (isFlutterTest) {
    if (Platform.isMacOS) {
      final abi = Abi.current() == Abi.macosArm64
          ? 'aarch64-apple-darwin'
          : 'x86_64-apple-darwin';
      return DynamicLibrary.open('macos/cli/$abi/lib$_lib.dylib');
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('linux/lib$_lib.so');
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('windows/$_lib.dll');
    }
    throw UnsupportedError(
      'unsupported testing operating system ${Platform.operatingSystem}',
    );
  }

  final libPath = switch (Platform.operatingSystem) {
    'macos' || 'ios' => '$_package.framework/$_package',
    'android' || 'linux' => 'lib$_lib.so',
    'windows' => '$_lib.dll',
    _ => throw UnsupportedError(
        'unsupported operating system ${Platform.operatingSystem}',
      ),
  };
  return DynamicLibrary.open(libPath);
}();

class AgentDartFFI {
  factory AgentDartFFI() => _instance;

  AgentDartFFI._();

  static final AgentDartFFI _instance = AgentDartFFI._();

  static AgentDartImpl get impl => _instance._impl;
  late final AgentDartImpl _impl = AgentDartImpl(_dylib);
}
