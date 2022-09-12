import 'dart:async';

import 'package:agent_dart/agent/agent.dart';
import 'package:agent_dart/principal/principal.dart';

typedef PollStrategyFactory = PollStrategy Function();
typedef PollStrategy = Future<void> Function(
  Principal canisterId,
  RequestId requestId,
  RequestStatusResponseStatus status,
);
typedef Predicate<T> = Future<T> Function(
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

Predicate<bool> once() {
  var first = true;
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

PollStrategy conditionalDelay(Predicate<bool> condition, int timeInMsec) {
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
  var attempts = count;
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) async {
    if (--attempts <= 0) {
      throw 'Failed to retrieve a reply for request after $count attempts:\n'
          '  Request ID: ${requestIdToHex(requestId)}\n'
          '  Request status: ${status.name}\n';
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

PollStrategy timeout(int timeInMilliseconds) {
  final end = DateTime.now().millisecondsSinceEpoch + timeInMilliseconds;
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) async {
    if (DateTime.now().millisecondsSinceEpoch > end) {
      throw 'Request timed out after $timeInMilliseconds msec:\n'
          '  Request ID: ${requestIdToHex(requestId)}\n'
          '  Request status: $status\n';
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
