import 'dart:ffi';
import 'dart:io' show Platform;
// import 'package:args/args.dart';

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
    if (Platform.environment["_"] == null ||
        (Platform.environment["_"] != null &&
            Platform.environment["FLUTTER_ENGINE_SWITCH_1"] != null)) {
      return DynamicLibrary.process();
    }
    return DynamicLibrary.open("macos/cli/x86_64-apple-darwin/lib$libName.dylib");
  }
  if (Platform.isLinux) {
    if (Platform.environment["_"] == null ||
        (Platform.environment["_"] != null &&
            Platform.environment["FLUTTER_ENGINE_SWITCH_1"] != null)) {
      return DynamicLibrary.open("lib$libName.dylib");
    }
    return DynamicLibrary.open("linux/lib$libName.so");
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open("windows/$libName.dll");
  }
  return DynamicLibrary.open("rust/dylib/debug/lib$libName.dylib");
}

final dylib = getDyLib();

