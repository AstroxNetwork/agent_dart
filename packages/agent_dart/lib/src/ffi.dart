import 'package:agent_dart_ffi/agent_dart_ffi.dart';
import 'ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

AgentDart createLib() => createWrapper(createLibraryImpl());
