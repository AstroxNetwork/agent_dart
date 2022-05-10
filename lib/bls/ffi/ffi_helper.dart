import 'dart:ffi';
import 'dart:io' show Platform;

const String libName = 'lib_agent_dart';
final DynamicLibrary dylib = getDyLib();

DynamicLibrary getDyLib() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('$libName.so');
  }
  if (Platform.isIOS) {
    return DynamicLibrary.process();
  }
  if (Platform.isMacOS) {
    if (Platform.environment['_'] == null ||
        (Platform.environment['_'] != null &&
            Platform.environment['FLUTTER_ENGINE_SWITCH_1'] != null)) {
      return DynamicLibrary.process();
    }
    return DynamicLibrary.open(
      'macos/cli/x86_64-apple-darwin/$libName.dylib',
    );
  }
  if (Platform.isLinux) {
    if (Platform.environment['_'] == null ||
        (Platform.environment['_'] != null &&
            Platform.environment['FLUTTER_ENGINE_SWITCH_1'] != null)) {
      return DynamicLibrary.open('$libName.dylib');
    }
    return DynamicLibrary.open('linux/$libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('windows/$libName.dll');
  }
  return DynamicLibrary.open('rust/dylib/debug/$libName.dylib');
}
