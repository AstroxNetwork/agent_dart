import 'dart:ffi';

import 'package:agent_dart_ffi/agent_dart_ffi.dart';
import 'package:test/test.dart';

Future<void> ffiInit() async {
  // ignore: invalid_use_of_internal_member
  if (AgentDart.instance.initialized) {
    return;
  }
  final [os, arch] = Abi.current().toString().split('_');
  final libName = switch ((os, arch)) {
    ('macos', _) || ('linux', 'arm64') => 'libagent_dart.dylib',
    ('linux', _) => 'libagent_dart.so',
    ('windows', _) => 'agent_dart.dll',
    _ => throw UnsupportedError('$os $arch is not a supported platform.'),
  };
  return AgentDart.init(
    externalLibrary: ExternalLibrary.open('../../target/debug/$libName'),
  );
}

const isAssertionError = TypeMatcher<AssertionError>();

Matcher assertionThrowsContains(String str) {
  return isAssertionError.having((e) => e.toString(), 'message', contains(str));
}

Matcher rangeThrowsContains(String str) {
  return isRangeError.having((e) => e.end, 'end', contains(str));
}

ErrorMessageMatcher<T> isError<T extends Error>([String? message]) =>
    ErrorMessageMatcher<T>(message);

class ErrorMessageMatcher<T extends Error> extends TypeMatcher<T> {
  const ErrorMessageMatcher([String? message]) : _message = message;

  final String? _message;

  @override
  bool matches(Object? item, Map matchState) =>
      item is T && (_message == null || (item as dynamic).message == _message);
}
