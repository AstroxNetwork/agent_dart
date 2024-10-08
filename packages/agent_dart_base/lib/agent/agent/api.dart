import 'package:agent_dart_base/agent/auth.dart';
import 'package:agent_dart_base/agent/types.dart';
import 'package:agent_dart_base/principal/principal.dart';
import 'package:meta/meta.dart';

/// Codes used by the replica for rejecting a message.
/// See https://sdk.dfinity.org/docs/interface-spec/#reject-codes
/// for the interface spec.
@immutable
class ReplicaRejectCode {
  const ReplicaRejectCode._();

  static const sysFatal = 1;
  static const sysTransient = 2;
  static const destinationInvalid = 3;
  static const canisterReject = 4;
  static const canisterError = 5;
}

/// Options when doing a [Agent.readState] call.
@immutable
class ReadStateOptions {
  const ReadStateOptions({required this.paths});

  /// A list of paths to read the state of.
  final List<List<BinaryBlob>> paths;
}

/// type QueryResponse = QueryResponseReplied | QueryResponseRejected;
@immutable
class QueryResponseStatus {
  const QueryResponseStatus._();

  static const replied = 'replied';
  static const rejected = 'rejected';
}

@immutable
abstract class QueryResponseBase {
  const QueryResponseBase({required this.status});

  final String status;
}

@immutable
abstract class QueryResponse extends QueryResponseBase {
  const QueryResponse({
    this.reply,
    this.rejectCode,
    this.rejectMessage,
    required super.status,
  });

  final Reply? reply;
  final int? rejectCode;
  final String? rejectMessage;
}

@immutable
class Reply {
  const Reply(this.arg);

  final BinaryBlob? arg;
}

class QueryResponseReplied extends QueryResponseBase {
  const QueryResponseReplied({super.status = QueryResponseStatus.replied});
}

class QueryResponseRejected extends QueryResponseBase {
  const QueryResponseRejected({
    this.rejectCode,
    this.rejectMessage,
    super.status = QueryResponseStatus.rejected,
  });

  final int? rejectCode;
  final String? rejectMessage;
}

/// Options when doing a [Agent.query] call.
@immutable
class QueryFields {
  const QueryFields({required this.methodName, this.arg});

  /// The method name to call.
  final String methodName;

  /// A binary encoded argument. This is already encoded and will be sent as is.
  final BinaryBlob? arg;
}

/// Options when doing a [Agent.call] call.
@immutable
class CallOptions {
  const CallOptions({
    required this.methodName,
    required this.arg,
    this.effectiveCanisterId,
  });

  /// The method name to call.
  final String methodName;

  /// A binary encoded argument. This is already encoded and will be sent as is.
  final BinaryBlob arg;

  /// An effective canister ID, used for routing. This should only be mentioned
  /// if it's different from the canister ID.
  final Principal? effectiveCanisterId;
}

@immutable
abstract class ReadStateResponse {
  const ReadStateResponse({required this.certificate});

  final BinaryBlob certificate;
}

@immutable
abstract class ResponseBody {
  const ResponseBody({this.ok, this.status, this.statusText});

  final bool? ok;
  final int? status;
  final String? statusText;
}

@immutable
abstract class SubmitResponse {
  const SubmitResponse({this.requestId, this.response});

  final RequestId? requestId;
  final ResponseBody? response;

  Map<String, dynamic> toJson();
}

/// An Agent able to make calls and queries to a Replica.
abstract class Agent {
  BinaryBlob? rootKey;

  /// Returns the principal ID associated with this agent (by default). It only shows
  /// the principal of the default identity in the agent, which is the principal used
  /// when calls don't specify it.
  Future<Principal> getPrincipal();

  /// Send a read state query to the replica. This includes a list of paths to return,
  /// and will return a Certificate. This will only reject on communication errors,
  /// but the certificate might contain less information than requested.
  /// @param effectiveCanisterId A Canister ID related to this call.
  /// @param options The options for this call.
  Future<ReadStateResponse> readState(
    Principal effectiveCanisterId,
    ReadStateOptions options,
    Identity? identity,
  );

  Future<SubmitResponse> call(
    Principal canisterId,
    CallOptions fields,
    Identity? identity,
  );

  /// Query the status endpoint of the replica. This normally has a few fields that
  /// corresponds to the version of the replica, its root public key, and any other
  /// information made public.
  /// @returns A JsonObject that is essentially a record of fields from the status
  ///     endpoint.
  Future<Map> status();

  /// Send a query call to a canister. See
  /// [the interface spec](https://sdk.dfinity.org/docs/interface-spec/#http-query).
  /// @param canisterId The Principal of the Canister to send the query to. Sending a query to
  ///     the management canister is not supported (as it has no meaning from an agent).
  /// @param options Options to use to create and send the query.
  /// @returns The response from the replica. The Promise will only reject when the communication
  ///     failed. If the query itself failed but no protocol errors happened, the response will
  ///     be of type QueryResponseRejected.
  Future<QueryResponse> query(
    Principal canisterId,
    QueryFields options,
    Identity? identity,
  );

  /// By default, the agent is configured to talk to the main Internet Computer,
  /// and verifies responses using a hard-coded public key.
  ///
  /// This function will instruct the agent to ask the endpoint for its public
  /// key, and use that instead. This is required when talking to a local test
  /// instance, for example.
  ///
  /// Only use this when you are  _not_ talking to the main Internet Computer,
  /// otherwise you are prone to man-in-the-middle attacks! Do not call this
  /// function by default.
  Future<BinaryBlob> fetchRootKey();
}
