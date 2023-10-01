import 'dart:ffi';
import 'dart:io' show Platform;
import 'ffi_bridge.dart';

DynamicLibrary createLibraryImpl() {
  const base = 'agent_dart';

  if (Platform.isIOS || Platform.isMacOS) {
    return DynamicLibrary.executable();
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('windows/$base.dll');
  } else {
    return DynamicLibrary.open('lib$base.so');
  }
}

class AgentDartFFI {
  factory AgentDartFFI() => _instance;

  AgentDartFFI._();

  static final AgentDartFFI _instance = AgentDartFFI._();

  static AgentDartImpl get impl => _instance._impl;
  late final AgentDartImpl _impl = AgentDartImpl(createLibraryImpl());
}
