import 'dart:ffi';
import 'dart:io' show Platform;
import 'bridge_generated.dart';

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

final dylib = AgentDartImpl(getDyLib());
