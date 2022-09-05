import 'dart:ffi';
import 'dart:io' show Platform;
import 'ffi_bridge.dart';

const libName = 'agent_dart';
const androidLibName = 'lib$libName.so';

DynamicLibrary getDyLib() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open(androidLibName);
  }
  if (Platform.isIOS) {
    return DynamicLibrary.process();
  }

  if (Platform.isMacOS) {
    if (Platform.environment['FLUTTER_TEST'] != null) {
      return DynamicLibrary.open(
        'macos/cli/x86_64-apple-darwin/lib$libName.dylib',
      );
    }
    return DynamicLibrary.process();
  }
  if (Platform.isLinux) {
    if (Platform.environment['FLUTTER_TEST'] != null) {
      return DynamicLibrary.open('linux/lib$libName.so');
    }
    return DynamicLibrary.open('lib$libName.dylib');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('windows/$libName.dll');
  }
  return DynamicLibrary.open('rust/dylib/debug/lib$libName.dylib');
}

class AgentDartFFI {
  factory AgentDartFFI() => _instance;

  AgentDartFFI._() {
    _impl ??= AgentDartImpl(getDyLib());
  }

  AgentDartFFI._from(this._impl);

  factory AgentDartFFI.run() {
    return AgentDartFFI._from(AgentDartImpl(getDyLib()));
  }

  static AgentDartImpl get instance => AgentDartFFI()._impl!;
  static final AgentDartFFI _instance = AgentDartFFI._();

  AgentDartImpl? _impl;
}
