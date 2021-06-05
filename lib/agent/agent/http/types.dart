import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/utils/extension.dart';
import 'transform.dart';

class ReadRequestType {
  // ignore: constant_identifier_names
  static const TypeQuery = 'query';
  // ignore: constant_identifier_names
  static const ReadState = 'read_state';
}

class SubmitRequestType {
  // ignore: constant_identifier_names
  static const Call = 'Call';
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
  late List<List<BinaryBlob>> paths;
  dynamic sender; //: Uint8Array | Principal;
  // ignore: non_constant_identifier_names
  late Expiry ingress_expiry;

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

  final String request_type = SubmitRequestType.Call;
  // ignore: non_constant_identifier_names
  late Principal canister_id;
  // ignore: non_constant_identifier_names
  late String method_name;
  late BinaryBlob arg;

  dynamic sender; //: Uint8Array | Principal;
  // ignore: non_constant_identifier_names
  late Expiry ingress_expiry;
  late dynamic nonce;

  @override
  Map<String, dynamic> toJson() {
    return {
      "request_type": request_type,
      "canister_id": canister_id,
      "method_name": method_name,
      "arg": arg.buffer,
      "sender": sender,
      "ingress_expiry": ingress_expiry,
      "nonce": nonce
    };
  }
}

class QueryRequest extends BaseRequest {
  final String request_type = ReadRequestType.TypeQuery;
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
    // TODO: implement toJson
    return {
      "request_type": request_type,
      "canister_id": canister_id,
      "method_name": method_name,
      "arg": arg.buffer,
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

abstract class HttpAgentSubmitRequest extends HttpAgentBaseRequest<CallRequest> {
  @override
  // ignore: overridden_fields
  String? endpoint = Endpoint.Call;
  @override
  late CallRequest body; // CallRequest
}

abstract class HttpAgentQueryRequest extends HttpAgentBaseRequest<ReadRequest> {
  @override
  // ignore: overridden_fields
  String? endpoint = Endpoint.Query;
  @override
  late ReadRequest body; // ReadRequest
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

abstract class HttpAgentRequestTransformFn {
  // ignore: non_constant_identifier_names
  late HttpAgentRequestTransformFnCall call;
  int? priority;
}

typedef HttpAgentRequestTransformFnCall = Future<HttpAgentRequest?> Function(HttpAgentRequest args);
