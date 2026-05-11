import 'dart:async';

import '../../principal/principal.dart';
import '../agent.dart';

/// Creates a polling strategy for update-call response polling.
typedef PollStrategyFactory = PollStrategy Function();

/// Strategy invoked between read-state polling attempts.
typedef PollStrategy = Future<void> Function(
  Principal canisterId,
  RequestId requestId,
  RequestStatusResponseStatus status,
);
/// Predicate used by conditional polling strategies.
typedef PollPredicate<T> = Future<T> Function(
  Principal canisterId,
  RequestId requestId,
  RequestStatusResponseStatus status,
);

/// Default polling strategy used for update calls.
///
/// It waits once, then applies a small backoff until the default timeout.
PollStrategy defaultStrategy() {
  return chain([
    conditionalDelay(once(), 1000),
    backoff(1000, 1.2),
    timeout(defaultExpireInDuration),
  ]);
}

/// Returns true only for the first invocation.
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

/// Delays polling by [timeInMsec] when [condition] returns true.
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

/// Fails polling after [count] attempts.
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
PollStrategy throttlePolling(int throttleMilliseconds) {
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

/// Fails polling after [duration] has elapsed.
PollStrategy timeout(Duration duration) {
  final end = DateTime.now().add(duration);
  return (
    Principal canisterId,
    RequestId requestId,
    RequestStatusResponseStatus status,
  ) async {
    if (DateTime.now().isAfter(end)) {
      throw TimeoutException(
        'Request timed out after $duration:\n'
        '  Request ID: ${requestIdToHex(requestId)}\n'
        '  Request status: $status\n',
        duration,
      );
    }
  };
}

/// Delays polling with multiplicative backoff.
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

/// Runs [strategies] in sequence for each polling attempt.
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
