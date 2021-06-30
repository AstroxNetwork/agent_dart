import 'dart:typed_data';

import 'package:agent_dart/agent/agent/api.dart';
import 'package:agent_dart/agent/agent/http/fetch.dart';
import 'package:agent_dart/agent/agent/http/transform.dart';
import 'package:agent_dart/agent/auth.dart';
import 'package:agent_dart/agent/cbor.dart' as cbor;
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/principal/principal.dart';
import 'package:agent_dart/agent/types.dart';
import 'package:agent_dart/utils/base64.dart' show base64Encode;
import 'package:typed_data/typed_data.dart';

import 'types.dart';

const btoa = base64Encode;
enum FetchMethod { get, post }

class RequestStatusResponseStatus {
  // ignore: constant_identifier_names
  static const Received = 'received';
  // ignore: constant_identifier_names
  static const Processing = 'processing';
  // ignore: constant_identifier_names
  static const Replied = 'replied';
  // ignore: constant_identifier_names
  static const Rejected = 'rejected';
  // ignore: constant_identifier_names
  static const Unknown = 'unknown';
  // ignore: constant_identifier_names
  static const Done = 'done';
}

// Default delta for ingress expiry is 5 minutes.
// ignore: constant_identifier_names
const DEFAULT_INGRESS_EXPIRY_DELTA_IN_MSECS = 5 * 60 * 1000;

// Root public key for the IC, encoded as hex
// ignore: constant_identifier_names
const IC_ROOT_KEY =
    // ignore: prefer_adjacent_string_concatenation
    '308182301d060d2b0601040182dc7c0503010201060c2b0601040182dc7c05030201036100814' +
        'c0e6ec71fab583b08bd81373c255c3c371b2e84863c98a4f1e08b74235d14fb5d9c0cd546d968' +
        '5f913a0c0b2cc5341583bf4b4392e467db96d65b9bb4cb717112f8472e0d5a4d14505ffd7484' +
        'b01291091c5f87b98883463f98091a0baaae';

abstract class Credentials {
  late String? name;
  late String? password;
}

class HttpAgentOptions {
  // Another HttpAgent to inherit configuration (pipeline and fetch) of. This
  // is only used at construction.
  HttpAgent? source;

  // A surrogate to the global fetch function. Useful for testing. // axios in dart maybe
  Function? fetch;

  // The host to use for the client. By default, uses the same host as
  // the current page.
  String? host;

  // The principal used to send messages. This cannot be empty at the request
  // time (will throw).
  Identity? identity;

  Credentials? credentials;
}

class DefaultHttpAgentOption extends HttpAgentOptions {}

final defaultHttpAgentOption = DefaultHttpAgentOption();

typedef FetchFunc<T> = Future<T> Function(
    {required String endpoint,
    String? host,
    String method,
    Map<String, dynamic>? headers,
    dynamic body});

// A HTTP agent allows users to interact with a client of the internet computer
// using the available methods. It exposes an API that closely follows the
// public view of the internet computer, and is not intended to be exposed
// directly to the majority of users due to its low-level interface.
//
// There is a pipeline to apply transformations to the request before sending
// it to the client. This is to decouple signature, nonce generation and
// other computations so that this class can stay as simple as possible while
// allowing extensions.
class HttpAgent implements Agent {
  List<HttpAgentRequestTransformFn> _pipeline = [];

  late Future<Identity>? _identity;
  // _fetch: typeof fetch;
  late String? _host;
  late String? _credentials;

  late String defaultProtocol;
  late String defaultHost;
  late String defaultPort;

  late FetchFunc<Map<String, dynamic>>? _fetch;

  late Map<String, dynamic> _baseHeaders;

  // ignore: unused_field
  bool _rootKeyFetched = false;

  @override
  BinaryBlob? rootKey = blobFromHex(IC_ROOT_KEY);

  HttpAgent(
      {HttpAgentOptions? options,
      this.defaultProtocol = 'https',
      this.defaultHost = 'localhost',
      this.defaultPort = ':8000'}) {
    if (options != null) {
      if (options.source is HttpAgent && options.source != null) {
        setPipeline(options.source!._pipeline);
        setIdentity(options.source!._identity);
        setHost(options.source!._host);
        setCredentials(options.source!._credentials);
        setFetch(options.source!._fetch);
      } else {
        setFetch(_defaultFetch);
      }

      /// setHost
      if (options.host != null) {
        setHost(defaultProtocol + '://${options.host}');
      } else {
        setHost(defaultProtocol + '://$defaultHost$defaultPort');
      }

      /// setIdentity
      setIdentity(Future.value(options.identity ?? AnonymousIdentity()));

      /// setCrendential
      if (options.credentials != null) {
        var name = options.credentials?.name ?? '';
        var password = options.credentials?.password;
        setCredentials("$name${password != null ? ':' + password : ''}");
      } else {
        setCredentials("");
      }

      _baseHeaders = _createBaseHeaders();
    } else {
      setIdentity(Future.value(AnonymousIdentity()));
      setHost(defaultProtocol + '://$defaultHost$defaultPort');
      setFetch(_defaultFetch);
      setCredentials("");
      // run default headers
      _baseHeaders = _createBaseHeaders();
    }
  }

  void setPipeline(List<HttpAgentRequestTransformFn> pl) {
    _pipeline = pl;
  }

  void setIdentity(Future<Identity>? id) async {
    _identity = id;
  }

  void setHost(String? host) {
    _host = host;
  }

  void setCredentials(String? cred) {
    _credentials = cred;
  }

  void setFetch(FetchFunc<Map<String, dynamic>>? fetch) {
    _fetch = fetch ?? _defaultFetch;
  }

  void addTransform(HttpAgentRequestTransformFn fn, [int? priority]) {
    // Keep the pipeline sorted at all time, by priority.
    priority ??= fn.priority ?? 0;
    final i = _pipeline.indexWhere((x) => (x.priority ?? 0) < priority!);
    fn.priority = priority;
    _pipeline.insert(i >= 0 ? i : _pipeline.length, fn);
  }

  @override
  Future<SubmitResponse> call(Principal canisterId, CallOptions fields, Identity? identity) async {
    final id = (identity ?? await _identity);

    final canister = Principal.from(canisterId);

    final ecid =
        fields.effectiveCanisterId != null ? Principal.from(fields.effectiveCanisterId) : canister;

    // ignore: unnecessary_null_comparison
    final sender = id != null ? id.getPrincipal() : Principal.anonymous();

    CallRequest submit = CallRequest()
      ..request_type = SubmitRequestType.Call
      ..canister_id = canister
      ..method_name = fields.methodName
      ..arg = fields.arg
      ..sender = sender
      ..ingress_expiry = Expiry(DEFAULT_INGRESS_EXPIRY_DELTA_IN_MSECS);

    var rsRequest = HttpAgentCallRequest()
      ..endpoint = Endpoint.Call
      ..body = submit
      ..request = {
        "method": "POST",
        "headers": {
          'Content-Type': 'application/cbor',
          ..._baseHeaders,
        },
      };
    var transformedRequest = await _transform(rsRequest);
    Map<String, dynamic> newTransformed = await id!.transformRequest(transformedRequest);

    var body = cbor.cborEncode(newTransformed["body"]);

    var list = await Future.wait([
      _fetch!(
          endpoint: "/api/v2/canister/${ecid.toText()}/call",
          method: "POST",
          headers: newTransformed["request"]["headers"],
          body: body),
      Future.value(requestIdOf(submit.toJson()))
    ]);

    var response = list[0] as Map<String, dynamic>;
    var requestId = list[1] as Uint8List;

    if (!(response["ok"] as bool)) {
      // ignore: prefer_adjacent_string_concatenation
      throw 'Server returned an error:\n' +
          '  Code: ${response["statusCode"]} (${response["statusText"]})\n' +
          '  Body: ${response["body"] is Uint8List ? (response["body"] as Uint8List).u8aToString() : response["body"]}\n';
    }

    return CallResponseBody.fromJson({...response, "requestId": requestId});
  }

  @override
  Future<BinaryBlob> fetchRootKey() async {
    if (_rootKeyFetched == false) {
      var key = (((await status())["root_key"]) as Uint8Buffer).buffer.asUint8List();
      // Hex-encoded version of the replica root key
      rootKey = blobFromUint8Array(key);
      _rootKeyFetched = true;
    }
    return Future.value(rootKey!);
  }

  @override
  Future<Principal> getPrincipal() async {
    try {
      return (await _identity)!.getPrincipal();
    } catch (e) {
      throw "Cannot fetch identity or principal: $e";
    }
  }

  @override
  Future<QueryResponse> query(Principal canisterId, QueryFields options, Identity? identity) async {
    final canister = canisterId is String ? Principal.fromText(canisterId as String) : canisterId;
    final id = (identity ?? await _identity);
    final sender = id?.getPrincipal() ?? Principal.anonymous();

    var requestBody = QueryRequest()
      ..request_type = ReadRequestType.TypeQuery
      ..canister_id = canister
      ..method_name = options.methodName
      ..arg = options.arg!
      ..sender = sender
      ..ingress_expiry = Expiry(DEFAULT_INGRESS_EXPIRY_DELTA_IN_MSECS);

    var rsRequest = HttpAgentQueryRequest()
      ..endpoint = Endpoint.Query
      ..body = requestBody
      ..request = {
        "method": "POST",
        "headers": {
          'Content-Type': 'application/cbor',
          ..._baseHeaders,
        },
      };

    var transformedRequest = await _transform(rsRequest);
    Map<String, dynamic> newTransformed = await id!.transformRequest(transformedRequest);

    var body = cbor.cborEncode(newTransformed["body"]);
    final response = await _fetch!(
        endpoint: "/api/v2/canister/${canister.toText()}/query",
        method: "POST",
        headers: newTransformed["request"]["headers"],
        body: body);

    if (!(response["ok"] as bool)) {
      // ignore: prefer_adjacent_string_concatenation
      throw 'Server returned an error:\n' +
          '  Code: ${response["statusCode"]} (${response["statusText"]})\n' +
          '  Body: ${response["body"]}\n';
    }

    final buffer = response["arrayBuffer"] as Uint8List;

    return QueryResponseWithStatus.fromMap(cbor.cborDecode<Map>(buffer));
  }

  @override
  Future<ReadStateResponse> readState(
      Principal canisterId, ReadStateOptions fields, Identity? identity) async {
    final canister = canisterId is String ? Principal.fromText(canisterId as String) : canisterId;
    final id = (identity ?? await _identity);
    final sender = id?.getPrincipal() ?? Principal.anonymous();

    var requestBody = ReadStateRequest()
      ..request_type = ReadRequestType.ReadState
      ..paths = fields.paths
      ..sender = sender
      ..ingress_expiry = Expiry(DEFAULT_INGRESS_EXPIRY_DELTA_IN_MSECS);

    var rsRequest = HttpAgentReadStateRequest()
      ..endpoint = Endpoint.ReadState
      ..body = requestBody
      ..request = {
        "method": "POST",
        "headers": {
          'Content-Type': 'application/cbor',
          ..._baseHeaders,
        },
      };

    var transformedRequest = await _transform(rsRequest);

    Map<String, dynamic> newTransformed = await id!.transformRequest(transformedRequest);

    var body = cbor.cborEncode(newTransformed["body"]);

    final response = await _fetch!(
        endpoint: "/api/v2/canister/$canister/read_state",
        method: "POST",
        headers: newTransformed["request"]["headers"],
        body: body);

    if (!(response["ok"] as bool)) {
      // ignore: prefer_adjacent_string_concatenation
      throw 'Server returned an error:\n' +
          '  Code: ${response["statusCode"]} (${response["statusText"]})\n' +
          '  Body: ${response["body"]}\n';
    }

    final buffer = response["arrayBuffer"] as Uint8List;

    return ReadStateResponseResult()
      ..certificate =
          blobFromBuffer(((cbor.cborDecode<Map>(buffer)["certificate"]) as Uint8Buffer).buffer);
  }

  @override
  Future<Map> status() async {
    var response = await _fetch!(endpoint: "/api/v2/status", headers: {}, method: "GET");

    if (!(response["ok"] as bool)) {
      // ignore: prefer_adjacent_string_concatenation
      throw 'Server returned an error:\n' +
          '  Code: ${response["statusCode"]} (${response["statusText"]})\n' +
          '  Body: ${response["body"]}\n';
    }

    final buffer = response["arrayBuffer"] as Uint8List;

    return cbor.cborDecode<Map>(buffer);
  }

  Map<String, dynamic> _createBaseHeaders() {
    return _credentials != null && _credentials!.isNotEmpty
        ? {
            "Authorization": 'Basic ' + btoa(_credentials),
          }
        : {};
  }

  Future<Map<String, dynamic>> _defaultFetch(
      {required String endpoint,
      String? host,
      String method = "POST",
      Map<String, dynamic>? headers,
      dynamic body}) async {
    return defaultFetch(
        endpoint: endpoint,
        host: host,
        defaultHost: _host,
        method: method,
        headers: headers,
        baseHeaders: _baseHeaders,
        body: body);
  }

  Future<HttpAgentRequest> _transform(HttpAgentRequest request) {
    var p = Future.value(request);

    for (var fn in _pipeline) {
      p = p.then((r) => fn.call(r).then((r2) => r2 ?? r));
    }
    return p;
  }
}

class HttpAgentReadStateRequest extends HttpAgentQueryRequest {
  HttpAgentReadStateRequest() : super();

  @override
  Map<String, dynamic> toJson() {
    return {
      "endpoint": endpoint,
      "body": body.toJson(),
      "request": {...request as Map<String, dynamic>}
    };
  }
}

class HttpAgentCallRequest extends HttpAgentSubmitRequest {
  HttpAgentCallRequest() : super();
  @override
  Map<String, dynamic> toJson() {
    return {
      "endpoint": endpoint,
      "body": body.toJson(),
      "request": {...request as Map<String, dynamic>}
    };
  }
}

class ReadStateResponseResult extends ReadStateResponse {}
