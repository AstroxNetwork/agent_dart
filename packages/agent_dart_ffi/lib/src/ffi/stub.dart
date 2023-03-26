import 'package:agent_dart_ffi/src/bridge_generated.dart';

/// Represents the external library for agent_dart
///
/// Will be a DynamicLibrary for dart:io or WasmModule for dart:html
typedef ExternalLibrary = Object;

AgentDart createWrapperImpl(ExternalLibrary lib) => throw UnimplementedError();
