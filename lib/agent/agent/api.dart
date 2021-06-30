import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/principal/principal.dart';

/// Codes used by the replica for rejecting a message.
/// See {@link https://sdk.dfinity.org/docs/interface-spec/#reject-codes | the interface spec}.
class ReplicaRejectCode {
  // ignore: constant_identifier_names
  static const SysFatal = 1;
  // ignore: constant_identifier_names
  static const SysTransient = 2;
  // ignore: constant_identifier_names
  static const DestinationInvalid = 3;
  // ignore: constant_identifier_names
  static const CanisterReject = 4;
  // ignore: constant_identifier_names
  static const CanisterError = 5;
}

/// Options when doing a {@link Agent.readState} call.
class ReadStateOptions {
  /// A list of paths to read the state of.
  late List<List<BinaryBlob>> paths;
}

// export type QueryResponse = QueryResponseReplied | QueryResponseRejected;

class QueryResponseStatus {
  // ignore: constant_identifier_names
  static const Replied = 'replied';
  // ignore: constant_identifier_names
  static const Rejected = 'rejected';
}

abstract class QueryResponseBase {
  late String status;
}

abstract class QueryResponse extends QueryResponseBase {
  Reply? reply;
  // ignore: non_constant_identifier_names
  int? reject_code;
  // ignore: non_constant_identifier_names
  String? reject_message;
}

class Reply {
  BinaryBlob? arg;
}

class QueryResponseReplied extends QueryResponseBase {
  @override
  // ignore: overridden_fields
  final String status = QueryResponseStatus.Replied;
  Reply? reply;
}

class QueryResponseRejected extends QueryResponseBase {
  @override
  // ignore: overridden_fields
  final String status = QueryResponseStatus.Rejected;
  // ignore: non_constant_identifier_names
  int? reject_code;
  // ignore: non_constant_identifier_names
  String? reject_message;
}

/// Options when doing a {@link Agent.query} call.
class QueryFields {
  /// The method name to call.
  late String methodName;

  /// A binary encoded argument. This is already encoded and will be sent as is.
  late BinaryBlob? arg;
}

/// Options when doing a {@link Agent.call} call.
class CallOptions {
  /// The method name to call.
  late String methodName;

  /// A binary encoded argument. This is already encoded and will be sent as is.
  late BinaryBlob arg;

  /// An effective canister ID, used for routing. This should only be mentioned if
  /// it's different from the canister ID.
  Principal? effectiveCanisterId;
}

abstract class ReadStateResponse {
  late BinaryBlob certificate;
}

abstract class ResponseBody {
  bool? ok;
  int? status;
  String? statusText;
}

abstract class SubmitResponse {
  RequestId? requestId;
  ResponseBody? response;
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
      Principal effectiveCanisterId, ReadStateOptions options, Identity? identity);

  Future<SubmitResponse> call(Principal canisterId, CallOptions fields, Identity? identity);

  /// Query the status endpoint of the replica. This normally has a few fields that
  /// corresponds to the version of the replica, its root public key, and any other
  /// information made public.
  /// @returns A JsonObject that is essentially a record of fields from the status
  ///     endpoint.
  Future<Map> status();

  /// Send a query call to a canister. See
  /// {@link https://sdk.dfinity.org/docs/interface-spec/#http-query | the interface spec}.
  /// @param canisterId The Principal of the Canister to send the query to. Sending a query to
  ///     the management canister is not supported (as it has no meaning from an agent).
  /// @param options Options to use to create and send the query.
  /// @returns The response from the replica. The Promise will only reject when the communication
  ///     failed. If the query itself failed but no protocol errors happened, the response will
  ///     be of type QueryResponseRejected.
  Future<QueryResponse> query(Principal canisterId, QueryFields options, Identity? identity);

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
