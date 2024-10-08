import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart_base/agent/types.dart';
import 'package:agent_dart_base/principal/principal.dart';
import 'package:meta/meta.dart';
import 'package:typed_data/typed_buffers.dart';
import '../api.dart';
import 'transform.dart';

class ReadRequestType {
  const ReadRequestType._();

  static const typeQuery = 'query';
  static const readState = 'read_state';
}

class SubmitRequestType {
  const SubmitRequestType._();

  static const call = 'call';
}

class Endpoint {
  const Endpoint._();

  static const query = 'read';
  static const readState = 'read_state';
  static const call = 'call';
}

mixin WithToJson {
  Map<String, dynamic> toJson();
}

abstract class BaseRequest with WithToJson {
  const BaseRequest();
}

class ReadStateRequest extends BaseRequest {
  const ReadStateRequest({
    this.paths,
    this.sender,
    this.ingressExpiry,
  });

  final List<List<BinaryBlob>>? paths;
  final Object? sender; //: Uint8Array | Principal;
  final Expiry? ingressExpiry;

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

class CallRequest extends ReadStateRequest {
  CallRequest({
    required this.canisterId,
    required this.methodName,
    required this.arg,
    this.nonce,
    super.sender,
    super.ingressExpiry,
  });

  final Principal canisterId;
  final String methodName;
  final BinaryBlob arg;
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

class QueryRequest extends BaseRequest {
  const QueryRequest({
    required this.canisterId,
    required this.methodName,
    required this.arg,
    required this.sender,
    required this.ingressExpiry,
  });

  final Principal canisterId;
  final String methodName;
  final BinaryBlob arg;
  final dynamic sender; //: Uint8Array | Principal;
  final Expiry ingressExpiry;

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

typedef ReadRequest = ReadStateRequest;

@immutable
abstract class HttpAgentBaseRequest<T extends WithToJson> extends BaseRequest {
  const HttpAgentBaseRequest({
    required this.request,
    required this.body,
    this.endpoint,
  });

  final Map<String, dynamic> request;
  final T body;
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

@immutable
abstract class HttpAgentSubmitRequest
    extends HttpAgentBaseRequest<CallRequest> {
  const HttpAgentSubmitRequest({
    required super.request,
    required super.body,
    super.endpoint = Endpoint.call,
  });
}

class HttpAgentCallRequest extends HttpAgentSubmitRequest {
  const HttpAgentCallRequest({
    required super.request,
    required super.body,
    super.endpoint = Endpoint.call,
  });
}

class HttpAgentQueryRequest extends HttpAgentBaseRequest<BaseRequest> {
  const HttpAgentQueryRequest({
    required super.request,
    required super.body,
    super.endpoint = Endpoint.query,
  });
}

@immutable
abstract class UnSigned<T> {
  const UnSigned({required this.content});

  final T content;
}

@immutable
abstract class Signed<T> extends UnSigned<T> {
  const Signed({
    required super.content,
    required this.senderPublicKey,
    required this.senderSignature,
  });

  final BinaryBlob senderPublicKey;
  final BinaryBlob senderSignature;
}

typedef Envelope<T> = UnSigned<T>;

typedef HttpAgentRequest = HttpAgentBaseRequest;

class HttpAgentRequestTransformFn {
  HttpAgentRequestTransformFn({required this.call, this.priority});

  final HttpAgentRequestTransformFnCall call;
  int? priority;
}

typedef HttpAgentRequestTransformFnCall = Future<HttpAgentRequest?> Function(
  HttpAgentRequest args,
);

class HttpResponseBody extends ResponseBody {
  const HttpResponseBody({
    super.ok,
    super.status,
    super.statusText,
    this.body,
    this.arrayBuffer,
  });

  factory HttpResponseBody.fromJson(Map<String, dynamic> map) {
    return HttpResponseBody(
      arrayBuffer: map['arrayBuffer'],
      ok: map['ok'],
      status: map['status'],
      statusText: map['statusText'],
      body: map['body'],
    );
  }

  final String? body;
  final Uint8List? arrayBuffer;

  @override
  String toString() {
    return jsonEncode(toJson());
  }

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

class CallResponseBody extends SubmitResponse {
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

class QueryResponseWithStatus extends QueryResponse {
  const QueryResponseWithStatus({
    super.reply,
    super.rejectCode,
    super.rejectMessage,
    required super.status,
  });

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
