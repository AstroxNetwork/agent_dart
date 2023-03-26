import 'package:agent_dart_ffi/src/bridge_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

typedef ExternalLibrary = WasmModule;

AgentDart createWrapperImpl(ExternalLibrary module) =>
    AgentDartImpl.wasm(module);
