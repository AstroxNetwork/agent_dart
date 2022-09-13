import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/principal/principal.dart';

import 'api.dart';

class ProxyMessageKind {
  const ProxyMessageKind._();

  static const error = 'err';
  static const getPrincipal = 'gp';
  static const getPrincipalResponse = 'gpr';
  static const query = 'q';
  static const queryResponse = 'qr';
  static const call = 'c';
  static const callResponse = 'cr';
  static const readState = 'rs';
  static const readStateResponse = 'rsr';
  static const status = 's';
  static const statusResponse = 'sr';
}

abstract class ProxyMessageBase {
  const ProxyMessageBase({this.id, this.type});

  final int? id;
  final String? type;
}

class ProxyMessage<T> extends ProxyMessageBase {
  const ProxyMessage({
    this.error,
    this.response,
    this.args,
    super.id,
    super.type,
  });

  final dynamic error;
  final T? response;
  final List<dynamic>? args;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'response': response,
      'error': error,
      'args': args,
    };
  }
}

class ProxyMessageError<T> extends ProxyMessage<T> {
  const ProxyMessageError({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.error,
  });

  factory ProxyMessageError.fromJson(Map json) {
    return ProxyMessageError(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageGetPrincipal extends ProxyMessage {
  const ProxyMessageGetPrincipal({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.getPrincipal,
  });

  factory ProxyMessageGetPrincipal.fromJson(Map json) {
    return ProxyMessageGetPrincipal(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageGetPrincipalResponse extends ProxyMessage<String> {
  const ProxyMessageGetPrincipalResponse({
    super.response,
    super.id,
    super.type = ProxyMessageKind.getPrincipalResponse,
  });

  factory ProxyMessageGetPrincipalResponse.fromJson(Map json) {
    return ProxyMessageGetPrincipalResponse(
      response: json['response'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageQuery extends ProxyMessage {
  //: [string, QueryFields];
  const ProxyMessageQuery({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.query,
  });

  factory ProxyMessageQuery.fromJson(Map json) {
    return ProxyMessageQuery(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageQueryResponse extends ProxyMessage<QueryResponse> {
  const ProxyMessageQueryResponse({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.queryResponse,
  });

  factory ProxyMessageQueryResponse.fromJson(Map json) {
    return ProxyMessageQueryResponse(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageCall extends ProxyMessage {
  const ProxyMessageCall({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.call,
  });

  factory ProxyMessageCall.fromJson(Map json) {
    return ProxyMessageCall(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageCallResponse extends ProxyMessage<SubmitResponse> {
  const ProxyMessageCallResponse({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.callResponse,
  });

  factory ProxyMessageCallResponse.fromJson(Map json) {
    return ProxyMessageCallResponse(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageReadState extends ProxyMessage {
  const ProxyMessageReadState({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.readState,
  });

  factory ProxyMessageReadState.fromJson(Map json) {
    return ProxyMessageReadState(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageReadStateResponse extends ProxyMessage<ReadStateResponse> {
  const ProxyMessageReadStateResponse({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.readStateResponse,
  });

  factory ProxyMessageReadStateResponse.fromJson(Map json) {
    return ProxyMessageReadStateResponse(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageStatus extends ProxyMessage {
  const ProxyMessageStatus({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.status,
  });

  factory ProxyMessageStatus.fromJson(Map json) {
    return ProxyMessageStatus(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyMessageStatusResponse extends ProxyMessage<Map> {
  const ProxyMessageStatusResponse({
    super.error,
    super.response,
    super.args,
    super.id,
    super.type = ProxyMessageKind.statusResponse,
  });

  factory ProxyMessageStatusResponse.fromJson(Map json) {
    return ProxyMessageStatusResponse(
      error: json['error'],
      response: json['response'],
      args: json['args'],
      id: json['id'],
      type: json['type'],
    );
  }
}

class ProxyStubAgent {
  const ProxyStubAgent(this._frontend, this._agent);

  final void Function(ProxyMessage msg) _frontend;
  final Agent _agent;

  void onmessage(ProxyMessage msg) {
    switch (msg.type) {
      case ProxyMessageKind.getPrincipal:
        _agent.getPrincipal().then((response) {
          _frontend(
            ProxyMessageGetPrincipalResponse.fromJson({
              'id': msg.id,
              'type': ProxyMessageKind.getPrincipalResponse,
              'response': response.toText(),
            }),
          );
        });
        break;
      case ProxyMessageKind.query:
        _agent.query(msg.args?[0], msg.args?[1], msg.args?[2]).then((response) {
          _frontend(
            ProxyMessageQueryResponse.fromJson({
              'id': msg.id,
              'type': ProxyMessageKind.queryResponse,
              'response': response,
            }),
          );
        });
        break;
      case ProxyMessageKind.call:
        _agent.call(msg.args?[0], msg.args?[1], msg.args?[2]).then((response) {
          _frontend(
            ProxyMessageCallResponse.fromJson({
              'id': msg.id,
              'type': ProxyMessageKind.callResponse,
              'response': response,
            }),
          );
        });
        break;
      case ProxyMessageKind.readState:
        _agent
            .readState(msg.args?[0], msg.args?[1], msg.args?[2])
            .then((response) {
          _frontend(
            ProxyMessageReadStateResponse.fromJson({
              'id': msg.id,
              'type': ProxyMessageKind.readStateResponse,
              'response': response,
            }),
          );
        });
        break;
      case ProxyMessageKind.status:
        _agent.status().then((response) {
          _frontend(
            ProxyMessageStatusResponse.fromJson({
              'id': msg.id,
              'type': ProxyMessageKind.statusResponse,
              'response': response,
            }),
          );
        });
        break;
      default:
        throw UnsupportedError('Message received: ${jsonEncode(msg)}.');
    }
  }
}

class ProxyAgent implements Agent {
  ProxyAgent(this._backend);

  final void Function(ProxyMessage msg) _backend;

  final Map<int, _Promise> _pendingCalls = <int, _Promise>{};
  int _nextId = 0;

  @override
  BinaryBlob? rootKey;

  void onmessage(ProxyMessage msg) {
    final id = msg.id;

    final maybePromise = _pendingCalls[id];
    if (maybePromise == null) {
      throw StateError('Proxy $id got the same message twice.');
    }
    _pendingCalls.remove(id);
    final resolve = maybePromise.resolve;
    final reject = maybePromise.reject;
    switch (msg.type) {
      case ProxyMessageKind.error:
        return reject(msg.error);
      case ProxyMessageKind.getPrincipalResponse:
      case ProxyMessageKind.callResponse:
      case ProxyMessageKind.queryResponse:
      case ProxyMessageKind.readStateResponse:
      case ProxyMessageKind.statusResponse:
        return resolve(msg.response);
      default:
        throw UnsupportedError(
          'Invalid message being sent to ProxyAgent: ${jsonEncode(msg)}.',
        );
    }
  }

  @override
  Future<Principal> getPrincipal() async {
    return _sendAndWait(
      ProxyMessageGetPrincipal.fromJson({
        'id': _nextId++,
        'type': ProxyMessageKind.getPrincipal,
      }),
    ).then((principal) {
      if (principal is! String) {
        throw ArgumentError.value(
          principal,
          'Principal',
          'Invalid principal received',
        );
      }
      return Principal.fromText(principal);
    });
  }

  @override
  Future<ReadStateResponse> readState(
    Principal canisterId,
    ReadStateOptions fields,
    Identity? identity,
  ) {
    return _sendAndWait(
      ProxyMessageReadStateResponse.fromJson({
        'id': _nextId++,
        'type': ProxyMessageKind.readState,
        'args': [canisterId.toString(), fields],
      }),
    );
  }

  @override
  Future<SubmitResponse> call(
    Principal canisterId,
    CallOptions fields,
    Identity? identity,
  ) {
    return _sendAndWait(
      ProxyMessageCallResponse.fromJson({
        'id': _nextId++,
        'type': ProxyMessageKind.call,
        'args': [canisterId.toString(), fields],
      }),
    );
  }

  @override
  Future<Map> status() {
    return _sendAndWait(
      ProxyMessageStatus.fromJson({
        'id': _nextId++,
        'type': ProxyMessageKind.status,
      }),
    );
  }

  @override
  Future<QueryResponse> query(
    Principal canisterId,
    QueryFields fields,
    Identity? identity,
  ) {
    return _sendAndWait(
      ProxyMessageQueryResponse.fromJson({
        'id': _nextId++,
        'type': ProxyMessageKind.query,
        'args': [canisterId.toString(), fields],
      }),
    );
  }

  Future<T> _sendAndWait<T>(ProxyMessage msg) async {
    final Completer<T> c = Completer<T>();
    final reject = c.completeError;
    final resolve = c.complete;
    _pendingCalls.putIfAbsent(msg.id!, () => _Promise<T>(resolve, reject));
    _backend(msg);
    return c.future;
  }

  @override
  Future<BinaryBlob> fetchRootKey() async {
    // Hex-encoded version of the replica root key.
    rootKey = (await status())['root_key'] as Uint8List;
    return Future.value(rootKey);
  }
}

class _Promise<T> {
  const _Promise(this.resolve, this.reject);

  final void Function(Object, [StackTrace?]) reject;
  final void Function([FutureOr<T>?]) resolve;
}
