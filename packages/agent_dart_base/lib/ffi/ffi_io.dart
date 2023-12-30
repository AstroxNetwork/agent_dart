import 'dart:ffi';
import 'dart:io' show Platform;

const libName = 'agent_dart';

DynamicLibrary createLibraryImpl() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('lib$libName.so');
  }
  if (Platform.isIOS || Platform.isMacOS) {
    if (_kDebugMode) {
      return DynamicLibrary.open('agent_dart.framework/agent_dart');
    }
    return DynamicLibrary.process();
  }
  if (Platform.isLinux) {
    if (_kDebugMode) {
      return DynamicLibrary.open('lib$libName.so');
    }
    return DynamicLibrary.open('lib$libName.dylib');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$libName.dll');
  }
  throw UnsupportedError('${Abi.current()} is not supported');
}

const bool _kReleaseMode = bool.fromEnvironment('dart.vm.product');
const bool _kProfileMode = bool.fromEnvironment('dart.vm.profile');
const bool _kDebugMode = !_kReleaseMode && !_kProfileMode;
