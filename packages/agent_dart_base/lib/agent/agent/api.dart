import 'package:meta/meta.dart';

import '../../principal/principal.dart';
import '../auth.dart';
import '../types.dart';

/// Codes used by the replica for rejecting a message.
/// See https://sdk.dfinity.org/docs/interface-spec/#reject-codes
/// for the interface spec.
@immutable
class ReplicaRejectCode {
  /// Creates a namespace for replica reject code constants.
  const ReplicaRejectCode._();

  /// System fatal reject code.
  static const sysFatal = 1;

  /// System transient reject code.
  static const sysTransient = 2;

  /// Destination invalid reject code.
  static const destinationInvalid = 3;

  /// Canister reject code.
  static const canisterReject = 4;

  /// Canister error reject code.
  static const canisterError = 5;
}

/// Options when doing a [Agent.readState] call.
@immutable
class ReadStateOptions {
  /// Creates read-state options for [paths].
  const ReadStateOptions({required this.paths});

  /// A list of paths to read the state of.
  final List<List<BinaryBlob>> paths;
}

/// type QueryResponse = QueryResponseReplied | QueryResponseRejected;
@immutable
class QueryResponseStatus {
  /// Creates a namespace for query response status constants.
  const QueryResponseStatus._();

  /// Query replied successfully.
  static const replied = 'replied';

  /// Query was rejected by the replica or canister.
  static const rejected = 'rejected';
}

/// Base type for query responses.
@immutable
abstract class QueryResponseBase {
  /// Creates a query response base value.
  const QueryResponseBase({required this.status});

  /// Query response status.
  final String status;
}

/// Query response containing either a reply or rejection details.
@immutable
abstract class QueryResponse extends QueryResponseBase {
  /// Creates a query response.
  const QueryResponse({
    this.reply,
    this.rejectCode,
    this.rejectMessage,
    required super.status,
  });

  /// Successful reply payload, when available.
  final Reply? reply;

  /// Replica reject code, when rejected.
  final int? rejectCode;

  /// Human-readable rejection message, when rejected.
  final String? rejectMessage;
}

/// Successful query reply payload.
@immutable
class Reply {
  /// Creates a reply with raw argument bytes.
  const Reply(this.arg);

  /// Candid-encoded reply argument bytes.
  final BinaryBlob? arg;
}

/// Query response for a successful reply.
class QueryResponseReplied extends QueryResponseBase {
  /// Creates a replied query response.
  const QueryResponseReplied({super.status = QueryResponseStatus.replied});
}

/// Query response for a rejection.
class QueryResponseRejected extends QueryResponseBase {
  /// Creates a rejected query response.
  const QueryResponseRejected({
    this.rejectCode,
    this.rejectMessage,
    super.status = QueryResponseStatus.rejected,
  });

  /// Replica reject code.
  final int? rejectCode;

  /// Human-readable rejection message.
  final String? rejectMessage;
}

/// Options when doing a [Agent.query] call.
@immutable
class QueryFields {
  /// Creates query call fields.
  const QueryFields({required this.methodName, this.arg});

  /// The method name to call.
  final String methodName;

  /// A binary encoded argument. This is already encoded and will be sent as is.
  final BinaryBlob? arg;
}

/// Options when doing a [Agent.call] call.
@immutable
class CallOptions {
  /// Creates update-call options.
  const CallOptions({
    required this.methodName,
    required this.arg,
    this.effectiveCanisterId,
    this.callSync = true,
  });

  /// The method name to call.
  final String methodName;

  /// A binary encoded argument. This is already encoded and will be sent as is.
  final BinaryBlob arg;

  /// An effective canister ID, used for routing. This should only be mentioned
  /// if it's different from the canister ID.
  final Principal? effectiveCanisterId;

  /// Whether to call the endpoint synchronously.
  final bool callSync;
}

/// Certificate response returned by read-state calls.
@immutable
abstract class ReadStateResponse {
  /// Creates a read-state response.
  const ReadStateResponse({required this.certificate});

  /// CBOR-encoded certificate bytes.
  final BinaryBlob certificate;
}

/// Base HTTP response metadata.
@immutable
abstract class ResponseBody {
  /// Creates response metadata.
  const ResponseBody({this.ok, this.status, this.statusText});

  /// Whether the HTTP request succeeded.
  final bool? ok;

  /// HTTP status code.
  final int? status;

  /// HTTP status text.
  final String? statusText;
}

/// Response returned after submitting an update call.
@immutable
abstract class SubmitResponse {
  /// Creates a submit response.
  const SubmitResponse({this.requestId, this.response});

  /// Request ID for the submitted call.
  final RequestId? requestId;

  /// HTTP response metadata and body.
  final ResponseBody? response;

  /// Converts this response to a JSON-like map.
  Map<String, dynamic> toJson();
}

/// An Agent able to make calls and queries to a Replica.
abstract class Agent {
  /// Root key used to verify certificate responses.
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

  /// Submits an update call request to a canister.
  Future<SubmitResponse> callRequest(
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
