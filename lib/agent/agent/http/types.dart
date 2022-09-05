import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/principal/principal.dart';
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

abstract class WithToJson {
  Map<String, dynamic> toJson();
}

abstract class BaseRequest with WithToJson {}

class ReadStateRequest extends BaseRequest {
  String get requestType => ReadRequestType.readState;
  List<List<BinaryBlob>>? paths;
  dynamic sender; //: Uint8Array | Principal;
  Expiry? ingressExpiry;

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
  @override
  String get requestType => SubmitRequestType.call;
  late Principal canisterId;
  late String methodName;
  late BinaryBlob arg;
  dynamic nonce;

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
  String get requestType => ReadRequestType.typeQuery;
  late Principal canisterId;
  late String methodName;
  late BinaryBlob arg;
  dynamic sender; //: Uint8Array | Principal;
  late Expiry ingressExpiry;

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

abstract class HttpAgentBaseRequest<T extends WithToJson> extends BaseRequest {
  HttpAgentBaseRequest({this.endpoint});

  String? endpoint;

  late dynamic request;
  late T body;
}

abstract class HttpAgentSubmitRequest
    extends HttpAgentBaseRequest<CallRequest> {
  HttpAgentSubmitRequest({super.endpoint = Endpoint.call});
}

class HttpAgentQueryRequest extends HttpAgentBaseRequest<BaseRequest> {
  @override
  String? get endpoint => Endpoint.query;

  @override
  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint,
      'body': body.toJson(),
      'request': {...request as Map<String, dynamic>}
    };
  } // ReadRequest
}

abstract class UnSigned<T> {
  late T content;
}

abstract class Signed<T> extends UnSigned<T> {
  late BinaryBlob senderPublicKey;
  late BinaryBlob senderSignature;
}

typedef Envelope<T> = UnSigned<T>;

typedef HttpAgentRequest = HttpAgentBaseRequest;

class HttpAgentRequestTransformFn {
  late HttpAgentRequestTransformFnCall call;
  int? priority;
}

typedef HttpAgentRequestTransformFnCall = Future<HttpAgentRequest?> Function(
  HttpAgentRequest args,
);

class HttpResponseBody extends ResponseBody {
  HttpResponseBody({
    bool? ok,
    int? status,
    String? statusText,
    this.body,
    this.arrayBuffer,
  }) : super(ok: ok, status: status, statusText: statusText);

  factory HttpResponseBody.fromJson(Map<String, dynamic> map) {
    return HttpResponseBody(
      arrayBuffer: map['arrayBuffer'],
      ok: map['ok'],
      status: map['status'],
      statusText: map['statusText'],
      body: map['body'],
    );
  }

  late String? body;
  late Uint8List? arrayBuffer;

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
      'arrayBuffer': arrayBuffer
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

  factory QueryResponseWithStatus.fromMap(Map map) {
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
      'rejected_message': rejectMessage
    };
  }
}
