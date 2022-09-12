import 'dart:typed_data';

import 'package:agent_dart/agent/agent/http/fetch.dart';
import 'package:agent_dart/agent/cbor.dart' as cbor;
import 'package:agent_dart/agent_dart.dart';
import 'package:typed_data/typed_data.dart';

const btoa = base64Encode;

enum FetchMethod {
  get,
  head,
  post,
  put,
  delete,
  connect,
  options,
  trace,
  patch,
}

enum RequestStatusResponseStatus {
  received,
  processing,
  replied,
  rejected,
  unknown,
  done;

  factory RequestStatusResponseStatus.fromName(String value) {
    return values.singleWhere((e) => e.name == value);
  }
}

/// Default delta for ingress expiry is 5 minutes.
const _defaultIngressExpiryDeltaInMilliseconds = 5 * 60 * 1000;

/// Root public key for the IC, encoded as hex
const _icRootKey = '308182301d060d2b0601040182dc7c0503010201060c2b0601040182dc7'
    'c05030201036100814c0e6ec71fab583b08bd81373c255c3c371b2e84863c98a4f1e08b742'
    '35d14fb5d9c0cd546d9685f913a0c0b2cc5341583bf4b4392e467db96d65b9bb4cb717112f'
    '8472e0d5a4d14505ffd7484b01291091c5f87b98883463f98091a0baaae';

abstract class Credentials {
  const Credentials({this.name, this.password});

  final String? name;
  final String? password;
}

class HttpAgentOptions {
  const HttpAgentOptions({
    this.source,
    this.fetch,
    this.host,
    this.identity,
    this.credentials,
  });

  // Another HttpAgent to inherit configuration (pipeline and fetch) of.
  // This is only used at construction.
  final HttpAgent? source;

  // A surrogate to the global fetch function. Useful for testing.
  final void Function()? fetch;

  // The host to use for the client. By default, uses the same host as
  // the current page.
  final String? host;

  // The principal used to send messages. This cannot be empty at the request
  // time (will throw).
  final Identity? identity;

  final Credentials? credentials;
}

class DefaultHttpAgentOption extends HttpAgentOptions {
  const DefaultHttpAgentOption();
}

const defaultHttpAgentOption = DefaultHttpAgentOption();

typedef FetchFunction<T> = Future<T> Function({
  required String endpoint,
  String? host,
  FetchMethod method,
  Map<String, String>? headers,
  dynamic body,
});

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
  HttpAgent({
    HttpAgentOptions? options,
    this.defaultProtocol = 'https',
    this.defaultHost = 'localhost',
    this.defaultPort = 8000,
  }) {
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
        setHost('$defaultProtocol://${options.host}');
      } else {
        setHost('$defaultProtocol://$defaultHost$defaultPort');
      }

      /// setIdentity
      setIdentity(options.identity ?? const AnonymousIdentity());

      /// setCredential
      if (options.credentials != null) {
        final name = options.credentials?.name ?? '';
        final password = options.credentials?.password;
        setCredentials("$name${password != null ? ':$password' : ''}");
      } else {
        setCredentials('');
      }
      _baseHeaders = _createBaseHeaders();
    } else {
      setIdentity(const AnonymousIdentity());
      setHost('$defaultProtocol://$defaultHost:$defaultPort');
      setFetch(_defaultFetch);
      setCredentials('');
      // run default headers
      _baseHeaders = _createBaseHeaders();
    }
  }

  List<HttpAgentRequestTransformFn> _pipeline = [];

  final String defaultProtocol;
  final String defaultHost;
  final int defaultPort;

  late Identity? _identity;
  late String? _host;
  late String? _credentials;
  late FetchFunction<Map<String, dynamic>>? _fetch;
  late Map<String, String> _baseHeaders;

  bool _rootKeyFetched = false;

  @override
  BinaryBlob? rootKey = blobFromHex(_icRootKey);

  void setPipeline(List<HttpAgentRequestTransformFn> pl) {
    _pipeline = pl;
  }

  void setIdentity(Identity? id) {
    _identity = id;
  }

  void setHost(String? host) {
    _host = host;
  }

  void setCredentials(String? cred) {
    _credentials = cred;
  }

  void setFetch(FetchFunction<Map<String, dynamic>>? fetch) {
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
  Future<SubmitResponse> call(
    Principal canisterId,
    CallOptions fields,
    Identity? identity,
  ) async {
    final id = identity ?? _identity;
    final canister = Principal.from(canisterId);
    final ecid = fields.effectiveCanisterId != null
        ? Principal.from(fields.effectiveCanisterId)
        : canister;
    final sender = id != null ? id.getPrincipal() : Principal.anonymous();

    final CallRequest submit = CallRequest(
      canisterId: canister,
      methodName: fields.methodName,
      arg: fields.arg,
      sender: sender,
      ingressExpiry: Expiry(_defaultIngressExpiryDeltaInMilliseconds),
    );

    final rsRequest = HttpAgentCallRequest()
      ..body = submit
      ..request = {
        'method': 'POST',
        'headers': {
          'Content-Type': 'application/cbor',
          ..._baseHeaders,
        },
      };
    final transformedRequest = await _transform(rsRequest);

    final newTransformed = await id!.transformRequest(transformedRequest);
    final body = cbor.cborEncode(newTransformed['body']);
    final list = await Future.wait([
      _fetch!(
        endpoint: '/api/v2/canister/${ecid.toText()}/call',
        method: FetchMethod.post,
        headers: newTransformed['request']['headers'],
        body: body,
      ),
      Future.value(requestIdOf(submit.toJson()))
    ]);

    final response = list[0] as Map<String, dynamic>;
    final requestId = list[1] as Uint8List;
    if (!(response['ok'] as bool)) {
      throw AgentError(
        'Server returned an error:\n'
        '  Code: ${response["statusCode"]} (${response["statusText"]})\n'
        '  Body: ${response["body"] is Uint8List ? (response["body"] as Uint8List).u8aToString() : response["body"]}\n',
      );
    }

    return CallResponseBody.fromJson({...response, 'requestId': requestId});
  }

  @override
  Future<BinaryBlob> fetchRootKey() async {
    if (_rootKeyFetched == false) {
      final key =
          ((await status())['root_key'] as Uint8Buffer).buffer.asUint8List();
      // Hex-encoded version of the replica root key.
      rootKey = blobFromUint8Array(key);
      _rootKeyFetched = true;
    }
    return Future.value(rootKey!);
  }

  @override
  Future<Principal> getPrincipal() async {
    return _identity!.getPrincipal();
  }

  @override
  Future<QueryResponse> query(
    Principal canisterId,
    QueryFields options,
    Identity? identity,
  ) async {
    final canister = canisterId is String
        ? Principal.fromText(canisterId as String)
        : canisterId;
    final id = identity ?? _identity;
    final sender = id?.getPrincipal() ?? Principal.anonymous();

    final requestBody = QueryRequest(
      canisterId: canister,
      methodName: options.methodName,
      arg: options.arg!,
      sender: sender,
      ingressExpiry: Expiry(_defaultIngressExpiryDeltaInMilliseconds),
    );

    final rsRequest = HttpAgentQueryRequest()
      ..body = requestBody
      ..request = {
        'method': 'POST',
        'headers': {'Content-Type': 'application/cbor', ..._baseHeaders},
      };

    final transformedRequest = await _transform(rsRequest);
    final Map<String, dynamic> newTransformed =
        await id!.transformRequest(transformedRequest);

    final body = cbor.cborEncode(newTransformed['body']);

    final response = await _fetch!(
      endpoint: '/api/v2/canister/${canister.toText()}/query',
      method: FetchMethod.post,
      headers: newTransformed['request']['headers'],
      body: body,
    );

    if (!(response['ok'] as bool)) {
      throw AgentError(
        'Server returned an error:\n'
        '  Code: ${response["statusCode"]} (${response["statusText"]})\n'
        '  Body: ${response["body"]}\n',
      );
    }

    final buffer = response['arrayBuffer'] as Uint8List;

    return QueryResponseWithStatus.fromJson(cbor.cborDecode<Map>(buffer));
  }

  @override
  Future<ReadStateResponse> readState(
    Principal canisterId,
    ReadStateOptions fields,
    Identity? identity,
  ) async {
    final canister = canisterId is String
        ? Principal.fromText(canisterId as String)
        : canisterId;
    final id = identity ?? _identity;
    final sender = id?.getPrincipal() ?? Principal.anonymous();

    final requestBody = ReadStateRequest(
      paths: fields.paths,
      sender: sender,
      ingressExpiry: Expiry(_defaultIngressExpiryDeltaInMilliseconds),
    );

    final rsRequest = HttpAgentReadStateRequest()
      ..body = requestBody
      ..request = {
        'method': 'POST',
        'headers': {'Content-Type': 'application/cbor', ..._baseHeaders},
      };

    final transformedRequest = await _transform(rsRequest);
    final newTransformed = await id!.transformRequest(
      transformedRequest,
    );

    final body = cbor.cborEncode(newTransformed['body']);
    final response = await _fetch!(
      endpoint: '/api/v2/canister/$canister/read_state',
      method: FetchMethod.post,
      headers: newTransformed['request']['headers'],
      body: body,
    );

    if (!(response['ok'] as bool)) {
      throw AgentError(
        'Server returned an error:\n'
        '  Code: ${response["statusCode"]} (${response["statusText"]})\n'
        '  Body: ${response["body"]}\n',
      );
    }

    final buffer = response['arrayBuffer'] as Uint8List;

    return ReadStateResponseResult(
      certificate: blobFromBuffer(
        (cbor.cborDecode<Map>(buffer)['certificate'] as Uint8Buffer).buffer,
      ),
    );
  }

  @override
  Future<Map> status() async {
    final response = await _fetch!(
      endpoint: '/api/v2/status',
      headers: {},
      method: FetchMethod.get,
    );
    if (!(response['ok'] as bool)) {
      throw AgentError(
        'Server returned an error:\n'
        '  Code: ${response["statusCode"]} (${response["statusText"]})\n'
        '  Body: ${response["body"]}\n',
      );
    }
    final buffer = response['arrayBuffer'] as Uint8List;
    return cbor.cborDecode<Map>(buffer);
  }

  Map<String, String> _createBaseHeaders() {
    return {
      if (_credentials != null && _credentials!.isNotEmpty)
        'Authorization': 'Basic ${btoa(_credentials)}',
    };
  }

  Future<Map<String, dynamic>> _defaultFetch({
    required String endpoint,
    String? host,
    FetchMethod method = FetchMethod.post,
    Map<String, String>? headers,
    dynamic body,
  }) {
    return defaultFetch(
      endpoint: endpoint,
      host: host,
      defaultHost: _host,
      method: method,
      headers: headers,
      baseHeaders: _baseHeaders,
      body: body,
    );
  }

  Future<HttpAgentRequest> _transform(HttpAgentRequest request) {
    var p = Future.value(request);

    for (final fn in _pipeline) {
      p = p.then((r) => fn.call(r).then((r2) => r2 ?? r));
    }
    return p;
  }
}

class HttpAgentReadStateRequest extends HttpAgentQueryRequest {
  @override
  String get endpoint => Endpoint.readState;

  @override
  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint,
      'body': body.toJson(),
      'request': {...request as Map<String, dynamic>}
    };
  }
}

class HttpAgentCallRequest extends HttpAgentSubmitRequest {
  @override
  String get endpoint => Endpoint.call;

  @override
  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint,
      'body': body.toJson(),
      'request': {...request as Map<String, dynamic>}
    };
  }
}

class ReadStateResponseResult extends ReadStateResponse {
  const ReadStateResponseResult({required super.certificate});
}
