import 'dart:async';

import 'package:agent_dart/agent/agent.dart';
import 'package:agent_dart/principal/principal.dart';

typedef PollStrategy = Future<void> Function(
    Principal canisterId, RequestId requestId, String status);
typedef PollStrategyFactory = PollStrategy Function();

typedef Predicate<T> = Future<T> Function(Principal canisterId, RequestId requestId, String status);

// ignore: constant_identifier_names
const FIVE_MINUTES_IN_MSEC = 5 * 60 * 1000;

PollStrategy defaultStrategy() {
  return chain([conditionalDelay(once(), 1000), backoff(1000, 1.2), timeout(FIVE_MINUTES_IN_MSEC)]);
}

Predicate<bool> once() {
  var first = true;
  return (Principal canisterId, RequestId requestId, String status) async {
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
    String status,
  ) async {
    if (await condition(canisterId, requestId, status)) {
      var c = Completer();
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
    String status,
  ) async {
    if (--attempts <= 0) {
      // ignore: prefer_adjacent_string_concatenation
      throw "Failed to retrieve a reply for request after $count attempts:\n"
              // ignore: prefer_adjacent_string_concatenation
              "  Request ID: ${requestIdToHex(requestId)}\n" +
          "  Request status: $status\n";
    }
  };
}

/// Throttle polling.
/// @param throttleInMsec Amount in millisecond to wait between each polling.
PollStrategy throttle(int throttleInMsec) {
  return (Principal canisterId, RequestId requestId, String status) async {
    var c = Completer();
    Future.delayed(Duration(milliseconds: throttleInMsec), c.complete);
    return c.future;
  };
}

PollStrategy timeout(int timeInMsec) {
  final end = DateTime.now().millisecondsSinceEpoch + timeInMsec;
  return (
    Principal canisterId,
    RequestId requestId,
    String status,
  ) async {
    if (DateTime.now().millisecondsSinceEpoch > end) {
      // ignore: prefer_adjacent_string_concatenation
      throw "Request timed out after $timeInMsec msec:\n"
              // ignore: prefer_adjacent_string_concatenation
              "  Request ID: ${requestIdToHex(requestId)}\n" +
          "  Request status: $status\n";
    }
  };
}

PollStrategy backoff(num startingThrottleInMsec, num backoffFactor) {
  num currentThrottling = startingThrottleInMsec;

  return (Principal canisterId, RequestId requestId, String status) {
    var c = Completer();
    Future.delayed(Duration(milliseconds: (currentThrottling).toInt()), () {
      currentThrottling *= backoffFactor;
      c.complete();
    });
    return c.future;
  };
}

PollStrategy chain(List<PollStrategy> strategies) {
  return (
    Principal canisterId,
    RequestId requestId,
    String status,
  ) async {
    for (var a in strategies) {
      await a(canisterId, requestId, status);
    }
  };
}
