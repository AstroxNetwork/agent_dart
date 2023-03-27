import 'dart:ffi';

import 'package:agent_dart_base/src/ffi/io.dart';
import 'package:test/test.dart';
import 'dart:io' as io;

// import 'package:p4d_rust_binding/utils/utils.dart';
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

void matchFFI() {
  final architech = Abi.current().toString();
  final arr = architech.split('_');
  final os = arr[0];
  final arc = arr[1];
  const dyLib = 'libagent_dart.dylib';
  const dySo = 'libagent_dart.so';
  const dyDll = 'agent_dart.dll';
  var lib;
  switch (os) {
    case 'macos':
      {
        if (arc == 'arm64') {
          lib = '../../platform-build/dylib/aarch64-apple-darwin/$dyLib';
          break;
        } else {
          lib = '../../platform-build/dylib/x86_64-apple-darwin/$dyLib';
          break;
        }
      }
    case 'linux':
      {
        if (arc == 'arm64') {
          lib = '../../platform-build/dylib/aarch64-unknown-linux-gnu/$dyLib';
          break;
        } else {
          lib = '../../platform-build/dylib/x86_64-unknown-linux-gnu/$dySo';
          break;
        }
      }
    case 'windows':
      {
        if (arc == 'arm64') {
          lib = '../../platform-build/dylib/aarch64-pc-windows-msvc/$dyDll';
          break;
        } else {
          lib = '../../platform-build/dylib/x86_64-pc-windows-msvc/$dyDll';
          break;
        }
      }
    default:
      throw 'Unsupported OS: $os';
  }
  AgentDartFFI.dylib = lib;
}
