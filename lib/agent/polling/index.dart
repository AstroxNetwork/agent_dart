export 'strategy.dart';

import 'package:agent_dart/agent/agent.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/principal/principal.dart';

Future<BinaryBlob> pollForResponse(
  Agent agent,
  Principal canisterId,
  RequestId requestId,
  PollStrategy strategy,
) async {
  final path = [blobFromText('request_status'), requestId];
  final state = await agent.readState(canisterId, ReadStateOptions()..paths = [path], null);
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
    status = RequestStatusResponseStatus.Unknown;
  } else {
    status = maybeBuf.u8aToString();
  }

  switch (status) {
    case RequestStatusResponseStatus.Replied:
      {
        return cert.lookup([...path, blobFromText('reply')]) as BinaryBlob;
      }

    case RequestStatusResponseStatus.Received:
    case RequestStatusResponseStatus.Unknown:
    case RequestStatusResponseStatus.Processing:
      // Execute the polling strategy, then retry.
      await strategy(canisterId, requestId, status);
      return pollForResponse(agent, canisterId, requestId, strategy);

    case RequestStatusResponseStatus.Rejected:
      {
        final rejectCode = cert.lookup([...path, blobFromText('reject_code')])!.toString();
        final rejectMessage = cert.lookup([...path, blobFromText('reject_message')])!.toString();
        // ignore: prefer_adjacent_string_concatenation
        throw "Call was rejected:\n" "  Request ID: ${requestIdToHex(requestId)}\n" +
            "  Reject code: $rejectCode\n" +
            "  Reject text: $rejectMessage\n";
      }

    case RequestStatusResponseStatus.Done:
      // This is _technically_ not an error, but we still didn't see the `Replied` status so
      // we don't know the result and cannot decode it.
      throw "Call was marked as done but we never saw the reply:\n"
          "  Request ID: ${requestIdToHex(requestId)}\n";
  }
  throw 'unreachable';
}
