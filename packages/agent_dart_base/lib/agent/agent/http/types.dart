import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:typed_data/typed_buffers.dart';

import '../../../principal/principal.dart';
import '../../types.dart';
import '../api.dart';
import 'transform.dart';

/// Replica read request type constants.
class ReadRequestType {
  const ReadRequestType._();

  static const typeQuery = 'query';
  static const readState = 'read_state';
}

/// Replica submit request type constants.
class SubmitRequestType {
  const SubmitRequestType._();

  static const call = 'call';
}

/// Replica endpoint path identifiers used by HTTP agent requests.
class Endpoint {
  const Endpoint._();

  static const query = 'read';
  static const readState = 'read_state';
  static const call = 'call';
}

/// Interface for values that can be serialized into agent request JSON maps.
mixin WithToJson {
  /// Converts this value to a JSON-like map.
  Map<String, dynamic> toJson();
}

/// Base request value for agent HTTP messages.
abstract class BaseRequest with WithToJson {
  /// Creates a base request.
  const BaseRequest();
}

/// Request body for `/read_state` calls.
class ReadStateRequest extends BaseRequest {
  /// Creates a read-state request body.
  const ReadStateRequest({
    this.paths,
    this.sender,
    this.ingressExpiry,
  });

  /// Certificate paths to read.
  final List<List<BinaryBlob>>? paths;

  /// Principal or raw bytes for the request sender.
  final Object? sender; //: Uint8Array | Principal;

  /// Ingress expiry timestamp.
  final Expiry? ingressExpiry;

  /// Replica request type.
  String get requestType => ReadRequestType.readState;

  @override
  Map<String, dynamic> toJson() {
    return {
      'request_type': requestType,
      'paths': paths,
      'sender': sender,
      'ingress_expiry': ingressExpiry,
    };
  }
}

/// Request body for update calls.
class CallRequest extends ReadStateRequest {
  /// Creates an update-call request body.
  CallRequest({
    required this.canisterId,
    required this.methodName,
    required this.arg,
    this.nonce,
    super.sender,
    super.ingressExpiry,
  });

  /// Target canister principal.
  final Principal canisterId;

  /// Canister method name.
  final String methodName;

  /// Candid-encoded argument bytes.
  final BinaryBlob arg;

  /// Optional request nonce.
  dynamic nonce;

  @override
  String get requestType => SubmitRequestType.call;

  @override
  Map<String, dynamic> toJson() {
    return {
      'request_type': requestType,
      'canister_id': canisterId,
      'method_name': methodName,
      'arg': arg,
      'nonce': nonce,
      'sender': sender,
      'ingress_expiry': ingressExpiry,
    };
  }
}

/// Request body for canister query calls.
class QueryRequest extends BaseRequest {
  /// Creates a query request body.
  const QueryRequest({
    required this.canisterId,
    required this.methodName,
    required this.arg,
    required this.sender,
    required this.ingressExpiry,
  });

  /// Target canister principal.
  final Principal canisterId;

  /// Canister method name.
  final String methodName;

  /// Candid-encoded argument bytes.
  final BinaryBlob arg;

  /// Principal or raw bytes for the request sender.
  final dynamic sender; //: Uint8Array | Principal;

  /// Ingress expiry timestamp.
  final Expiry ingressExpiry;

  /// Replica request type.
  String get requestType => ReadRequestType.typeQuery;

  @override
  Map<String, dynamic> toJson() {
    return {
      'request_type': requestType,
      'canister_id': canisterId,
      'method_name': methodName,
      'arg': arg,
      'sender': sender,
      'ingress_expiry': ingressExpiry,
    };
  }
}

/// Alias for read request bodies.
typedef ReadRequest = ReadStateRequest;

/// HTTP request wrapper used by the agent transform pipeline.
@immutable
abstract class HttpAgentBaseRequest<T extends WithToJson> extends BaseRequest {
  /// Creates an HTTP agent request wrapper.
  const HttpAgentBaseRequest({
    required this.request,
    required this.body,
    this.endpoint,
  });

  /// HTTP request metadata such as method and headers.
  final Map<String, dynamic> request;

  /// Request body payload.
  final T body;

  /// Agent endpoint identifier.
  final String? endpoint;

  @override
  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint,
      'body': body.toJson(),
      'request': {...request},
    };
  }
}

/// HTTP wrapper for submit/update requests.
@immutable
abstract class HttpAgentSubmitRequest
    extends HttpAgentBaseRequest<CallRequest> {
  /// Creates a submit request wrapper.
  const HttpAgentSubmitRequest({
    required super.request,
    required super.body,
    super.endpoint = Endpoint.call,
  });
}

/// HTTP wrapper for canister update-call requests.
class HttpAgentCallRequest extends HttpAgentSubmitRequest {
  /// Creates a call request wrapper.
  const HttpAgentCallRequest({
    required super.request,
    required super.body,
    super.endpoint = Endpoint.call,
  });
}

/// HTTP wrapper for query and read-state requests.
class HttpAgentQueryRequest extends HttpAgentBaseRequest<BaseRequest> {
  /// Creates a query request wrapper.
  const HttpAgentQueryRequest({
    required super.request,
    required super.body,
    super.endpoint = Endpoint.query,
  });
}

/// Unsigned envelope content.
@immutable
abstract class UnSigned<T> {
  /// Creates an unsigned envelope.
  const UnSigned({required this.content});

  /// Envelope payload.
  final T content;
}

/// Signed envelope content with sender key and signature bytes.
@immutable
abstract class Signed<T> extends UnSigned<T> {
  /// Creates a signed envelope.
  const Signed({
    required super.content,
    required this.senderPublicKey,
    required this.senderSignature,
  });

  /// Sender public key bytes.
  final BinaryBlob senderPublicKey;

  /// Sender signature bytes.
  final BinaryBlob senderSignature;
}

/// Agent request envelope type.
typedef Envelope<T> = UnSigned<T>;

/// Agent request type used by transform functions.
typedef HttpAgentRequest = HttpAgentBaseRequest;

/// Request transform function with an optional priority.
class HttpAgentRequestTransformFn {
  /// Creates a request transform.
  HttpAgentRequestTransformFn({required this.call, this.priority});

  /// Transform callback.
  final HttpAgentRequestTransformFnCall call;

  /// Transform priority. Higher-priority transforms run earlier.
  int? priority;
}

/// Signature for request transform callbacks.
typedef HttpAgentRequestTransformFnCall = Future<HttpAgentRequest?> Function(
  HttpAgentRequest args,
);

/// HTTP response body returned by the transport layer.
class HttpResponseBody extends ResponseBody {
  /// Creates an HTTP response body.
  const HttpResponseBody({
    super.ok,
    super.status,
    super.statusText,
    this.body,
    this.arrayBuffer,
  });

  /// Creates an HTTP response body from a JSON-like map.
  factory HttpResponseBody.fromJson(Map<String, dynamic> map) {
    return HttpResponseBody(
      arrayBuffer: map['arrayBuffer'],
      ok: map['ok'],
      status: map['status'],
      statusText: map['statusText'],
      body: map['body'],
    );
  }

  /// Response body as text, when available.
  final String? body;

  /// Response body as raw bytes, when available.
  final Uint8List? arrayBuffer;

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  /// Converts this response to a JSON-like map.
  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'status': status,
      'statusText': statusText,
      'body': body,
      'arrayBuffer': arrayBuffer,
    };
  }
}

/// Submit response returned by update-call requests.
class CallResponseBody extends SubmitResponse {
  /// Creates a call response body.
  CallResponseBody({
    bool? ok,
    int? status,
    String? statusText,
    String? body,
    Uint8List? arrayBuffer,
    super.requestId,
  }) : super(
          response: HttpResponseBody(
            arrayBuffer: arrayBuffer,
            status: status,
            statusText: statusText,
            body: body,
            ok: ok,
          ),
        );

  /// Creates a call response body from a JSON-like map.
  factory CallResponseBody.fromJson(Map<String, dynamic> map) {
    return CallResponseBody(
      arrayBuffer: map['arrayBuffer'],
      ok: map['ok'],
      status: map['status'] ?? map['statusCode'],
      statusText: map['statusText'],
      body: map['body'],
      requestId: map['requestId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ok': response?.ok,
      'status': response?.status,
      'statusCode': response?.status,
      'statusText': response?.statusText,
      'body': (response as HttpResponseBody).body,
      'arrayBuffer': (response as HttpResponseBody).arrayBuffer,
      'requestId': requestId,
    };
  }
}

/// Query response decoded from replica CBOR payloads.
class QueryResponseWithStatus extends QueryResponse {
  /// Creates a query response with status.
  const QueryResponseWithStatus({
    super.reply,
    super.rejectCode,
    super.rejectMessage,
    required super.status,
  });

  /// Creates a query response from a decoded CBOR map.
  factory QueryResponseWithStatus.fromJson(Map map) {
    Reply? reply;
    if (map['reply'] != null) {
      reply = Reply(
        (map['reply']['arg'] as Uint8Buffer).buffer.asUint8List(),
      );
    } else {
      reply = null;
    }
    return QueryResponseWithStatus(
      status: map['status'],
      rejectCode: map['reject_code'],
      rejectMessage: map['reject_message'],
      reply: reply,
    );
  }

  /// Converts this query response to a JSON-like map.
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'reply': {
        'arg': reply?.arg,
      },
      'rejected_code': rejectCode,
      'rejected_message': rejectMessage,
    };
  }
}
