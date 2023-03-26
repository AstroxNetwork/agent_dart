import 'package:flutter_test/flutter_test.dart';
// import 'package:p4d_rust_binding/utils/utils.dart';

Matcher assertionThrowsContains(String str) {
  return isAssertionError.having((e) => e.message, 'message', contains(str));
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
