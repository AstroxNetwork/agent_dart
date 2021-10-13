import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:typed_data/typed_buffers.dart';
import '../api.dart';
import 'transform.dart';

class ReadRequestType {
  // ignore: constant_identifier_names
  static const TypeQuery = 'query';
  // ignore: constant_identifier_names
  static const ReadState = 'read_state';
}

class SubmitRequestType {
  // ignore: constant_identifier_names
  static const Call = 'call';
}

class Endpoint {
  // ignore: constant_identifier_names
  static const Query = 'read';
  // ignore: constant_identifier_names
  static const ReadState = 'read_state';
  // ignore: constant_identifier_names
  static const Call = 'call';
}

abstract class WithToJson {
  Map<String, dynamic> toJson();
}

abstract class BaseRequest with WithToJson {}

class ReadStateRequest extends BaseRequest {
  // ignore: non_constant_identifier_names
  String request_type = ReadRequestType.ReadState;
  // ignore: non_constant_identifier_names
  List<List<BinaryBlob>>? paths;
  dynamic sender; //: Uint8Array | Principal;
  // ignore: non_constant_identifier_names
  Expiry? ingress_expiry;

  @override
  Map<String, dynamic> toJson() {
    return {
      "request_type": request_type,
      "paths": paths,
      "sender": sender,
      "ingress_expiry": ingress_expiry,
    };
  }
}

class CallRequest extends ReadStateRequest {
  // ignore: non_constant_identifier_names

  @override
  // ignore: non_constant_identifier_names
  final String request_type = SubmitRequestType.Call;
  // ignore: non_constant_identifier_names
  late Principal canister_id;
  // ignore: non_constant_identifier_names
  late String method_name;
  late BinaryBlob arg;

  dynamic nonce;

  @override
  Map<String, dynamic> toJson() {
    return {
      "request_type": request_type,
      "canister_id": canister_id,
      "method_name": method_name,
      "arg": arg,
      "nonce": nonce,
      "sender": sender,
      "ingress_expiry": ingress_expiry,
    };
  }
}

class QueryRequest extends BaseRequest {
  // ignore: non_constant_identifier_names
  late String request_type = ReadRequestType.TypeQuery;
  // ignore: non_constant_identifier_names
  late Principal canister_id;
  // ignore: non_constant_identifier_names
  late String method_name;
  late BinaryBlob arg;

  dynamic sender; //: Uint8Array | Principal;
  // ignore: non_constant_identifier_names
  late Expiry ingress_expiry;

  @override
  Map<String, dynamic> toJson() {
    return {
      "request_type": request_type,
      "canister_id": canister_id,
      "method_name": method_name,
      "arg": arg,
      "sender": sender,
      "ingress_expiry": ingress_expiry,
    };
  }
}

typedef ReadRequest = ReadStateRequest;

abstract class HttpAgentBaseRequest<T extends WithToJson> extends BaseRequest {
  String? endpoint;
  late dynamic request;
  late T body;
}

abstract class HttpAgentSubmitRequest
    extends HttpAgentBaseRequest<CallRequest> {
  @override
  // ignore: overridden_fields
  String? endpoint = Endpoint.Call;
  @override
  late CallRequest body; // CallRequest
}

class HttpAgentQueryRequest extends HttpAgentBaseRequest<BaseRequest> {
  @override
  // ignore: overridden_fields
  String? endpoint = Endpoint.Query;
  @override
  late BaseRequest body;

  @override
  Map<String, dynamic> toJson() {
    return {
      "endpoint": endpoint,
      "body": body.toJson(),
      "request": {...request as Map<String, dynamic>}
    };
  } // ReadRequest
}

abstract class UnSigned<T> {
  late T content;
}

abstract class Signed<T> extends UnSigned<T> {
  @override
  // ignore: overridden_fields
  late T content;
  // ignore: non_constant_identifier_names
  late BinaryBlob sender_pubkey;
  // ignore: non_constant_identifier_names
  late BinaryBlob sender_sig;
}

typedef Envelope<T> = UnSigned<T>;

typedef HttpAgentRequest = HttpAgentBaseRequest;

class HttpAgentRequestTransformFn {
  // ignore: non_constant_identifier_names
  late HttpAgentRequestTransformFnCall call;
  int? priority;
}

typedef HttpAgentRequestTransformFnCall = Future<HttpAgentRequest?> Function(
    HttpAgentRequest args);

class HttpResponseBody extends ResponseBody {
  @override
  late bool? ok;
  @override
  late int? status;
  @override
  late String? statusText;
  late String? body;
  late Uint8List? arrayBuffer;
  HttpResponseBody(
      {this.ok, this.status, this.statusText, this.body, this.arrayBuffer})
      : super();

  factory HttpResponseBody.fromJson(Map<String, dynamic> map) {
    return HttpResponseBody(
        arrayBuffer: map["arrayBuffer"],
        ok: map["ok"],
        status: map["status"],
        statusText: map["statusText"],
        body: map["body"]);
  }
  @override
  String toString() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      "ok": ok,
      "status": status,
      "statusText": statusText,
      "body": body,
      "arrayBuffer": arrayBuffer
    };
  }
}

class CallResponseBody extends SubmitResponse {
  @override
  RequestId? requestId;
  CallResponseBody(
      {bool? ok,
      int? status,
      String? statusText,
      String? body,
      Uint8List? arrayBuffer,
      this.requestId})
      : super() {
    response = HttpResponseBody(
        arrayBuffer: arrayBuffer,
        status: status,
        statusText: statusText,
        body: body,
        ok: ok);
  }
  factory CallResponseBody.fromJson(Map<String, dynamic> map) {
    return CallResponseBody(
        arrayBuffer: map["arrayBuffer"],
        ok: map["ok"],
        status: map["status"] ?? map["statusCode"],
        statusText: map["statusText"],
        body: map["body"],
        requestId: map["requestId"]);
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      "ok": response?.ok,
      "status": response?.status,
      "statusCode": response?.status,
      "statusText": response?.statusText,
      "body": (response as HttpResponseBody).body,
      "arrayBuffer": (response as HttpResponseBody).arrayBuffer,
      "requestId": requestId
    };
  }
}

class QueryResponseWithStatus extends QueryResponse {
  QueryResponseWithStatus();
  factory QueryResponseWithStatus.fromMap(Map map) {
    Reply? reply = Reply();
    if (map["reply"] != null) {
      reply.arg = (map["reply"]["arg"] as Uint8Buffer).buffer.asUint8List();
    } else {
      reply = null;
    }
    return QueryResponseWithStatus()
      ..status = map["status"]
      ..reject_code = map["reject_code"]
      ..reject_message = map["reject_message"]
      ..reply = reply;
  }
  toJson() {
    return {
      "status": status,
      "reply": {
        "arg": reply?.arg,
      },
      "rejected_code": reject_code,
      "rejected_message": reject_message
    };
  }
}
