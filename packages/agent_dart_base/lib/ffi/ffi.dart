import 'package:agent_dart_ffi/agent_dart_ffi.dart';

import 'ffi_stub.dart'
    if (dart.library.io) 'ffi_io.dart'
    if (dart.library.html) 'ffi_web.dart';

AgentDart createLib() => createWrapper(getDynamicLibrary());

class AgentDartFFI {
  factory AgentDartFFI() => _instance;

  AgentDartFFI._();

  static final AgentDartFFI _instance = AgentDartFFI._();

  static AgentDartImpl get impl => _instance._impl;
  late final AgentDartImpl _impl = AgentDartImpl(getDynamicLibrary());
}
