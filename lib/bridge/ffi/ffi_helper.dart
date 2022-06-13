import 'dart:ffi';
import 'dart:io' show Platform;
import 'ffi_bridge.dart';

const libName = "agent_dart";
const androidlibName = "lib$libName.so";

DynamicLibrary getDyLib() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open(androidlibName);
  }
  if (Platform.isIOS) {
    return DynamicLibrary.process();
  }

  if (Platform.isMacOS) {
    if (Platform.environment["FLUTTER_TEST"] != null) {
      return DynamicLibrary.open(
          "macos/cli/x86_64-apple-darwin/lib$libName.dylib");
    }
    return DynamicLibrary.process();
  }
  if (Platform.isLinux) {
    if (Platform.environment["FLUTTER_TEST"] != null) {
      return DynamicLibrary.open("linux/lib$libName.so");
    }
    return DynamicLibrary.open("lib$libName.dylib");
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open("windows/$libName.dll");
  }
  return DynamicLibrary.open("rust/dylib/debug/lib$libName.dylib");
}

class AgentDartFFI {
  static AgentDartImpl get instance => AgentDartFFI()._impl!;
  AgentDartImpl? _impl;
  AgentDartFFI._from(this._impl);

  factory AgentDartFFI.run() {
    return AgentDartFFI._from(AgentDartImpl(getDyLib()));
  }

  factory AgentDartFFI() => _instance;

  AgentDartFFI._() {
    _impl ??= AgentDartImpl(getDyLib());
  }

  static late final AgentDartFFI _instance = AgentDartFFI._();
}
