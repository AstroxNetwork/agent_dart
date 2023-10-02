import 'dart:ffi' show Abi, DynamicLibrary;
import 'dart:io' show Platform;
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

import 'ffi_bridge.dart';

const String _libBase = 'agent_dart';

final DynamicLibrary _dylib = () {
  final isFlutterTest = Platform.environment['FLUTTER_TEST'] != null;
  if (isFlutterTest) {
    if (Platform.isMacOS) {
      final abi = Abi.current() == Abi.macosArm64
          ? 'aarch64-apple-darwin'
          : 'x86_64-apple-darwin';
      return DynamicLibrary.open('macos/cli/$abi/lib$_libBase.dylib');
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('linux/lib$_libBase.so');
    }
  }
  return loadLibForFlutter(
    Platform.isWindows ? '$_libBase.dll' : 'lib$_libBase.so',
  );
}();

class AgentDartFFI {
  factory AgentDartFFI() => _instance;

  AgentDartFFI._();

  static final AgentDartFFI _instance = AgentDartFFI._();

  static AgentDartImpl get impl => _instance._impl;
  late final AgentDartImpl _impl = AgentDartImpl(_dylib);
}
