import 'dart:async';

import 'package:agent_dart_base/agent/agent.dart';
import 'package:agent_dart_base/principal/principal.dart';

typedef PollStrategyFactory = PollStrategy Function();
typedef PollStrategy = Future<void> Function(
  Principal canisterId,
  RequestId requestId,
  RequestStatusResponseStatus status,
);
typedef PollPredicate<T> = Future<T> Function(
  Principal canisterId,
  RequestId requestId,
  RequestStatusResponseStatus status,
);

PollStrategy defaultStrategy() {
  return chain([
    conditionalDelay(once(), 1000),
    backoff(1000, 1.2),
    timeout(5 * 60 * 1000)
  ]);
}

PollPredicate<bool> once() {
  bool first = true;
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) async {
    if (first) {
      first = false;
      return true;
    }
    return false;
  };
}

PollStrategy conditionalDelay(PollPredicate<bool> condition, int timeInMsec) {
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) async {
    if (await condition(canisterId, requestId, status)) {
      final c = Completer();
      Future.delayed(Duration(milliseconds: timeInMsec), c.complete);
      return c.future;
    }
  };
}

PollStrategy maxAttempts(int count) {
  int attempts = count;
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) async {
    if (--attempts <= 0) {
      throw Exception(
        'Failed to retrieve a reply for request after $count attempts:\n'
        '  Request ID: ${requestIdToHex(requestId)}\n'
        '  Request status: ${status.name}\n',
      );
    }
  };
}

/// Throttle polling.
/// @param throttleMilliseconds
/// - Amount in millisecond to wait between each polling.
PollStrategy throttle(int throttleMilliseconds) {
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) async {
    final c = Completer();
    Future.delayed(Duration(milliseconds: throttleMilliseconds), c.complete);
    return c.future;
  };
}

PollStrategy timeout(int milliseconds) {
  final end = DateTime.now().millisecondsSinceEpoch + milliseconds;
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) async {
    if (DateTime.now().millisecondsSinceEpoch > end) {
      throw TimeoutException(
        'Request timed out after $milliseconds milliseconds:\n'
        '  Request ID: ${requestIdToHex(requestId)}\n'
        '  Request status: $status\n',
        Duration(milliseconds: milliseconds),
      );
    }
  };
}

PollStrategy backoff(num startingThrottleInMsec, num backoffFactor) {
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) {
    final c = Completer();
    Future.delayed(Duration(milliseconds: startingThrottleInMsec.toInt()), () {
      startingThrottleInMsec *= backoffFactor;
      c.complete();
    });
    return c.future;
  };
}

PollStrategy chain(List<PollStrategy> strategies) {
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) async {
    for (final a in strategies) {
      await a(canisterId, requestId, status);
    }
  };
}
