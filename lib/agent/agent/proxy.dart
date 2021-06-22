import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/principal/principal.dart';

import 'api.dart';

class ProxyMessageKind {
  // ignore: constant_identifier_names
  static const Error = 'err';
  // ignore: constant_identifier_names
  static const GetPrincipal = 'gp';
  // ignore: constant_identifier_names
  static const GetPrincipalResponse = 'gpr';
  // ignore: constant_identifier_names
  static const Query = 'q';
  // ignore: constant_identifier_names
  static const QueryResponse = 'qr';
  // ignore: constant_identifier_names
  static const Call = 'c';
  // ignore: constant_identifier_names
  static const CallResponse = 'cr';
  // ignore: constant_identifier_names
  static const ReadState = 'rs';
  // ignore: constant_identifier_names
  static const ReadStateResponse = 'rsr';
  // ignore: constant_identifier_names
  static const Status = 's';
  // ignore: constant_identifier_names
  static const StatusResponse = 'sr';
}

abstract class ProxyMessageBase {
  late int? id;
  late String? type;
}

class ProxyMessage<T> extends ProxyMessageBase {
  dynamic error;
  T? response;
  List<dynamic>? args;

  Map<String, dynamic> toJson() {
    return {"id": id, "type": type, "response": response, "error": error, "args": args};
  }
}

class ProxyMessageError extends ProxyMessage {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.Error;
  @override
  dynamic error;
  ProxyMessageError();

  factory ProxyMessageError.fromJson(Map json) {
    return ProxyMessageError()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  }
}

class ProxyMessageGetPrincipal extends ProxyMessage {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.GetPrincipal;
  ProxyMessageGetPrincipal();

  factory ProxyMessageGetPrincipal.fromJson(Map json) {
    return ProxyMessageGetPrincipal()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  }
}

class ProxyMessageGetPrincipalResponse extends ProxyMessage<String> {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.GetPrincipalResponse;
  @override
  String? response;
  ProxyMessageGetPrincipalResponse();

  factory ProxyMessageGetPrincipalResponse.fromJson(Map json) {
    return ProxyMessageGetPrincipalResponse()
      ..id = json["id"] as int
      ..type = json["type"] as String
      ..response = json["response"] as String;
  }
}

class ProxyMessageQuery extends ProxyMessage {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.Query;
  @override
  // ignore: overridden_fields
  List<dynamic>? args; //: [string, QueryFields];
  ProxyMessageQuery();
  factory ProxyMessageQuery.fromJson(Map json) {
    return ProxyMessageQuery()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  }
}

class ProxyMessageQueryResponse extends ProxyMessage<QueryResponse> {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.QueryResponse;
  @override
  // ignore: overridden_fields
  QueryResponse? response;
  ProxyMessageQueryResponse();
  factory ProxyMessageQueryResponse.fromJson(Map json) {
    return ProxyMessageQueryResponse()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  }
}

class ProxyMessageCall extends ProxyMessage {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.Call;
  @override
  List<dynamic>? args;
  ProxyMessageCall();
  factory ProxyMessageCall.fromJson(Map json) {
    return ProxyMessageCall()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  } //: [string, CallOptions];
}

class ProxyMessageCallResponse extends ProxyMessage<SubmitResponse> {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.CallResponse;
  @override
  // ignore: overridden_fields
  SubmitResponse? response;
  ProxyMessageCallResponse();
  factory ProxyMessageCallResponse.fromJson(Map json) {
    return ProxyMessageCallResponse()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  }
}

class ProxyMessageReadState extends ProxyMessage {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.ReadState;
  @override
  // ignore: overridden_fields
  List<dynamic>? args;
  ProxyMessageReadState();
  factory ProxyMessageReadState.fromJson(Map json) {
    return ProxyMessageReadState()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  } //: [string, ReadStateOptions];
}

class ProxyMessageReadStateResponse extends ProxyMessage<ReadStateResponse> {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.ReadStateResponse;
  @override
  ReadStateResponse? response;
  ProxyMessageReadStateResponse();
  factory ProxyMessageReadStateResponse.fromJson(Map json) {
    return ProxyMessageReadStateResponse()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  }
}

class ProxyMessageStatus extends ProxyMessage {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.Status;
  ProxyMessageStatus();
  factory ProxyMessageStatus.fromJson(Map json) {
    return ProxyMessageStatus()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  }
}

class ProxyMessageStatusResponse extends ProxyMessage<Map> {
  @override
  // ignore: overridden_fields
  String? type = ProxyMessageKind.StatusResponse;
  @override
  // ignore: overridden_fields
  Map? response;
  ProxyMessageStatusResponse();
  factory ProxyMessageStatusResponse.fromJson(Map json) {
    return ProxyMessageStatusResponse()
      ..id = json["id"]
      ..type = json["type"]
      ..error = json["error"]
      ..response = json["response"]
      ..args = json["args"];
  }
}

class ProxyStubAgent {
  final void Function(ProxyMessage msg) _frontend;
  final Agent _agent;
  ProxyStubAgent(this._frontend, this._agent);

  void onmessage(ProxyMessage msg) {
    switch (msg.type) {
      case ProxyMessageKind.GetPrincipal:
        _agent.getPrincipal().then((response) {
          _frontend(ProxyMessageGetPrincipalResponse.fromJson({
            "id": msg.id,
            "type": ProxyMessageKind.GetPrincipalResponse,
            "response": response.toText(),
          }));
        });
        break;
      case ProxyMessageKind.Query:
        _agent.query(msg.args?[0], msg.args?[1], msg.args?[2]).then((response) {
          _frontend(ProxyMessageQueryResponse.fromJson({
            "id": msg.id,
            "type": ProxyMessageKind.QueryResponse,
            "response": response,
          }));
        });
        break;
      case ProxyMessageKind.Call:
        _agent.call(msg.args?[0], msg.args?[1], msg.args?[2]).then((response) {
          _frontend(ProxyMessageCallResponse.fromJson({
            "id": msg.id,
            "type": ProxyMessageKind.CallResponse,
            "response": response,
          }));
        });
        break;
      case ProxyMessageKind.ReadState:
        _agent.readState(msg.args?[0], msg.args?[1], msg.args?[2]).then((response) {
          _frontend(ProxyMessageReadStateResponse.fromJson({
            "id": msg.id,
            "type": ProxyMessageKind.ReadStateResponse,
            "response": response,
          }));
        });
        break;
      case ProxyMessageKind.Status:
        _agent.status().then((response) {
          _frontend(ProxyMessageStatusResponse.fromJson({
            "id": msg.id,
            "type": ProxyMessageKind.StatusResponse,
            "response": response,
          }));
        });
        break;

      default:
        throw "Invalid message received: ${jsonEncode(msg)}";
    }
  }
}

class ProxyAgent implements Agent {
  int _nextId = 0;
  final Map<int, Promise> _pendingCalls = <int, Promise>{};
  @override
  BinaryBlob? rootKey;

  final void Function(ProxyMessage msg) _backend;

  ProxyAgent(this._backend);

  void onmessage(ProxyMessage msg) {
    final id = msg.id;

    final maybePromise = _pendingCalls[id];
    if (maybePromise == null) {
      throw 'A proxy get the same message twice...';
    }
    _pendingCalls.remove(id);
    final resolve = maybePromise.resolve;
    final reject = maybePromise.reject;
    switch (msg.type) {
      case ProxyMessageKind.Error:
        return reject(msg.error);
      case ProxyMessageKind.GetPrincipalResponse:
      case ProxyMessageKind.CallResponse:
      case ProxyMessageKind.QueryResponse:
      case ProxyMessageKind.ReadStateResponse:
      case ProxyMessageKind.StatusResponse:
        return resolve(msg.response);
      default:
        throw "Invalid message being sent to ProxyAgent: ${jsonEncode(msg)}";
    }
  }

  @override
  Future<Principal> getPrincipal() async {
    return _sendAndWait(ProxyMessageGetPrincipal.fromJson({
      "id": _nextId++,
      "type": ProxyMessageKind.GetPrincipal,
    })).then((principal) {
      if (principal is! String) {
        throw 'Invalid principal received.';
      }
      return Principal.fromText(principal);
    });
  }

  @override
  Future<ReadStateResponse> readState(
      Principal canisterId, ReadStateOptions fields, Identity? identity) {
    return _sendAndWait(ProxyMessageReadStateResponse.fromJson({
      "id": _nextId++,
      "type": ProxyMessageKind.ReadState,
      "args": [canisterId is Principal ? canisterId.toString() : canisterId, fields],
    }));
  }

  @override
  Future<SubmitResponse> call(Principal canisterId, CallOptions fields, Identity? identity) {
    return _sendAndWait(ProxyMessageCallResponse.fromJson({
      "id": _nextId++,
      "type": ProxyMessageKind.Call,
      "args": [canisterId.toString(), fields],
    }));
  }

  @override
  Future<Map> status() {
    return _sendAndWait(ProxyMessageStatus.fromJson({
      "id": _nextId++,
      "type": ProxyMessageKind.Status,
    }));
  }

  @override
  Future<QueryResponse> query(Principal canisterId, QueryFields fields, Identity? identity) {
    return _sendAndWait(ProxyMessageQueryResponse.fromJson({
      "id": _nextId++,
      "type": ProxyMessageKind.Query,
      "args": [canisterId.toString(), fields],
    }));
  }

  Future<T> _sendAndWait<T>(ProxyMessage msg) async {
    // return new Promise((resolve, reject) => {
    //   this._pendingCalls.set(msg.id, [resolve, reject]);

    //   this._backend(msg);
    // });
    Completer<T> c = Completer<T>();
    var reject = c.completeError;
    var resolve = c.complete;
    _pendingCalls.putIfAbsent(msg.id!, () => Promise<T>(resolve, reject));
    _backend(msg);
    return c.future;
  }

  @override
  Future<BinaryBlob> fetchRootKey() async {
    // Hex-encoded version of the replica root key
    rootKey = blobFromUint8Array((await status())["root_key"] as Uint8List);
    return Future.value(rootKey);
  }
}

typedef PromiseResolve = Future Function(dynamic value);
typedef PromiseReject = Future Function(dynamic value);

class Promise<T> {
  void Function(Object, [StackTrace?]) reject;
  void Function([FutureOr<T>?]) resolve;
  Promise(this.resolve, this.reject);
}
