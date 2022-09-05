import 'package:agent_dart/agent/agent.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/extension.dart';

export 'strategy.dart';

Future<BinaryBlob> pollForResponse(
  Agent agent,
  Principal canisterId,
  RequestId requestId,
  PollStrategy strategy,
) async {
  final path = [blobFromText('request_status'), requestId];
  final state = await agent.readState(
    canisterId,
    ReadStateOptions(paths: [path]),
    null,
  );
  final cert = Certificate(state, agent);
  final verified = await cert.verify();
  if (!verified) {
    throw 'Fail to verify certificate';
  }
  final maybeBuf = cert.lookup([...path, blobFromText('status').buffer]);
  // ignore: prefer_typing_uninitialized_variables
  var status;
  if (maybeBuf == null) {
    // Missing requestId means we need to wait
    status = RequestStatusResponseStatus.unknown;
  } else {
    status = maybeBuf.u8aToString();
  }

  switch (status) {
    case RequestStatusResponseStatus.replied:
      {
        return cert.lookup([...path, blobFromText('reply')]) as BinaryBlob;
      }

    case RequestStatusResponseStatus.received:
    case RequestStatusResponseStatus.unknown:
    case RequestStatusResponseStatus.processing:
      // Execute the polling strategy, then retry.
      await strategy(canisterId, requestId, status);
      return pollForResponse(agent, canisterId, requestId, strategy);

    case RequestStatusResponseStatus.rejected:
      {
        final rejectCode =
            cert.lookup([...path, blobFromText('reject_code')])!.u8aToString();
        final rejectMessage = cert
            .lookup([...path, blobFromText('reject_message')])!.u8aToString();
        throw PollingResponseRejectedException(
          requestId: requestIdToHex(requestId),
          status: status,
          rejectCode: rejectCode,
          rejectMessage: rejectMessage,
        );
      }

    case RequestStatusResponseStatus.done:
      // This is _technically_ not an error, but we still didn't see the `Replied` status so
      // we don't know the result and cannot decode it.
      throw PollingResponseDoneException(
        requestId: requestIdToHex(requestId),
        status: status,
      );
  }
  throw 'unreachable';
}

class PollingResponseException implements Exception {
  const PollingResponseException({
    required this.requestId,
    required this.status,
  });

  final String requestId;
  final String status;

  @override
  String toString() {
    return 'Call was $status:\n   Request ID: $requestId\n';
  }
}

class PollingResponseDoneException implements PollingResponseException {
  const PollingResponseDoneException({
    required this.requestId,
    required this.status,
  });

  @override
  final String requestId;
  @override
  final String status;

  @override
  String toString() {
    return 'Call was marked as $status but we never saw the reply:\n'
        '  Request ID: $requestId\n';
  }
}

class PollingResponseRejectedException implements PollingResponseException {
  const PollingResponseRejectedException({
    required this.requestId,
    required this.status,
    required this.rejectCode,
    required this.rejectMessage,
  });

  @override
  final String requestId;
  @override
  final String status;
  final String rejectCode;
  final String rejectMessage;

  @override
  String toString() {
    return 'Call was $status:\n'
        '   Request ID: $requestId\n'
        '  Reject code: $rejectCode\n'
        '   Reject msg: $rejectMessage\n';
  }
}
