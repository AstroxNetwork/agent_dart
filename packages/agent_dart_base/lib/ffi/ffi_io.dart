import 'dart:ffi';
import 'dart:io' show Platform;

const _lib = 'agent_dart';
const _package = _lib;
final _dylib = Platform.isWindows ? '$_lib.dll' : 'lib$_lib.so';

DynamicLibrary getDynamicLibrary() {
  if (Platform.isIOS || Platform.isMacOS) {
    if (_kDebugMode) {
      return DynamicLibrary.open('$_package.framework/$_package');
    }
    return DynamicLibrary.executable();
  }
  return DynamicLibrary.open(_dylib);
}

const bool _kReleaseMode = bool.fromEnvironment('dart.vm.product');
const bool _kProfileMode = bool.fromEnvironment('dart.vm.profile');
const bool _kDebugMode = !_kReleaseMode && !_kProfileMode;
