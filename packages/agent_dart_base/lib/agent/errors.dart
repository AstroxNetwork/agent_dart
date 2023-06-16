import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';

/// An fetch error when using agent to make HTTP/S requests.
class AgentFetchError extends Error {
  /// Creates an agent error with the provided [message].
  AgentFetchError({this.statusCode, this.statusText, this.body});

  final Object? statusCode;
  final Object? statusText;
  final Object? body;

  @override
  String toString() {
    if (statusCode == null && statusText == null && body == null) {
      return 'Agent failed';
    }
    final b = body;
    return 'Agent failed: Server returned an error:\n'
        '  Code: $statusCode ($statusText)\n'
        '  Body: ${b is Uint8List ? b.u8aToString() : b}\n';
  }
}

class UnreachableError extends Error {}
