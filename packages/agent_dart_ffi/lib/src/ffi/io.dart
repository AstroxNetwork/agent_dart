import 'dart:ffi';

import 'package:agent_dart_ffi/src/bridge_generated.dart';

typedef ExternalLibrary = DynamicLibrary;

AgentDart createWrapperImpl(ExternalLibrary dylib) => AgentDartImpl(dylib);
