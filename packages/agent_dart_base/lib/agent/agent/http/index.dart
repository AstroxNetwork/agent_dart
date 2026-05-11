import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:typed_data/typed_data.dart';

import '../../../principal/principal.dart';
import '../../../utils/base64.dart';
import '../../auth.dart';
import '../../cbor.dart' as cbor;
import '../../errors.dart';
import '../../request_id.dart';
import '../../types.dart';
import '../api.dart';
import 'fetch.dart';
import 'transform.dart';
import 'types.dart';

/// Encodes a string as base64 for HTTP Basic authentication headers.
const btoa = base64Encode;

/// Runs [action] with simple linear backoff retries.
///
/// [retryTimes] is the maximum number of attempts and
/// [retryIntervalMills] is multiplied by the attempt number before each retry.
Future<T> withRetry<T>(
  FutureOr<T> Function() action, {
  int retryTimes = 3,
  int retryIntervalMills = 500,
}) async {
  assert(retryTimes >= 0);
  assert(retryIntervalMills >= 0);
  int times = 0;
  while (true) {
    try {
      return await action();
    } catch (e) {
      times++;
      if (times >= retryTimes) {
        rethrow;
      }
      await Future.delayed(Duration(milliseconds: times * retryIntervalMills));
    }
  }
}

/// Most of the timeouts will happen in 5 minutes.
const defaultExpireInMinutes = 5;
const defaultExpireInDuration = Duration(minutes: defaultExpireInMinutes);

/// Default delta for ingress expiry is 5 minutes.
const _defaultIngressExpiryDeltaInMilliseconds =
    defaultExpireInMinutes * 60 * 1000;

/// Root public key for the IC, encoded as hex.
const _icRootKey = '308182301d060d2b0601040182dc7c0503010201060c2b0601040182dc7'
    'c05030201036100814c0e6ec71fab583b08bd81373c255c3c371b2e84863c98a4f1e08b742'
    '35d14fb5d9c0cd546d9685f913a0c0b2cc5341583bf4b4392e467db96d65b9bb4cb717112f'
    '8472e0d5a4d14505ffd7484b01291091c5f87b98883463f98091a0baaae';

/// HTTP Basic authentication credentials used by [HttpAgent].
@immutable
abstract class Credentials {
  /// Creates credentials from an optional user [name] and [password].
  const Credentials({this.name, this.password});

  /// Username for Basic authentication.
  final String? name;

  /// Password for Basic authentication.
  final String? password;
}

/// Configuration used to create an [HttpAgent].
class HttpAgentOptions {
  /// Creates HTTP agent options.
  const HttpAgentOptions({
    this.source,
    this.fetch,
    this.host,
    this.identity,
    this.credentials,
  });

  /// Another [HttpAgent] to inherit pipeline and fetch configuration from.
  ///
  /// This is only used during construction.
  final HttpAgent? source;

  /// A surrogate fetch hook. Useful for tests and custom transports.
  final void Function()? fetch;

  /// Replica host used by the client.
  final String? host;

  /// Identity used to sign requests. Defaults to [AnonymousIdentity].
  final Identity? identity;

  /// Optional Basic authentication credentials.
  final Credentials? credentials;
}

/// Default HTTP agent options.
class DefaultHttpAgentOption extends HttpAgentOptions {
  /// Creates default HTTP agent options.
  const DefaultHttpAgentOption();
}

/// Shared default HTTP agent options instance.
const defaultHttpAgentOption = DefaultHttpAgentOption();

/// Transport function used by [HttpAgent] to perform HTTP requests.
typedef FetchFunction<T> = Future<T> Function({
  required String endpoint,
  String? host,
  FetchMethod method,
  Map<String, String>? headers,
  dynamic body,
});

/// Low-level HTTP implementation of [Agent].
///
/// `HttpAgent` talks to Internet Computer replica endpoints for status, query,
/// update, and read-state calls. Most applications should create actors through
/// [AgentFactory] or [Actor] helpers instead of calling this class directly.
///
/// Requests pass through a transform pipeline before they are signed and sent,
/// which keeps signing, nonce generation, and other request decoration separate
/// from transport logic.
class HttpAgent implements Agent {
  /// Creates an HTTP agent.
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
        setHost('$defaultProtocol://$defaultHost:$defaultPort');
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

  /// Creates an HTTP agent using protocol, host, and port from [uri].
  factory HttpAgent.fromUri(Uri uri, {HttpAgentOptions? options}) {
    return HttpAgent(
      defaultHost: uri.host,
      defaultPort: uri.port,
      defaultProtocol: uri.scheme,
      options: options,
    );
  }

  List<HttpAgentRequestTransformFn> _pipeline = [];

  /// Protocol used when [HttpAgentOptions.host] is not fully specified.
  final String defaultProtocol;

  /// Host used when no host option is supplied.
  final String defaultHost;

  /// Port used when no host option is supplied.
  final int defaultPort;

  late Identity? _identity;
  late String? _host;
  late String? _credentials;
  late FetchFunction<Map<String, dynamic>>? _fetch;
  late Map<String, String> _baseHeaders;

  bool _rootKeyFetched = false;

  @override
  BinaryBlob? rootKey = blobFromHex(_icRootKey);

  /// The identity currently attached to the agent.
  Identity? get identity => _identity;

  /// Replaces the request transform pipeline.
  void setPipeline(List<HttpAgentRequestTransformFn> pl) {
    _pipeline = pl;
  }

  /// Sets the identity used for requests that do not supply one explicitly.
  void setIdentity(Identity? id) {
    _identity = id;
  }

  /// Sets the replica host URL.
  void setHost(String? host) {
    _host = host;
  }

  /// Sets the Basic authentication credential string.
  void setCredentials(String? cred) {
    _credentials = cred;
  }

  /// Sets the transport function used by this agent.
  void setFetch(FetchFunction<Map<String, dynamic>>? fetch) {
    _fetch = fetch ?? _defaultFetch;
  }

  /// Adds a request transform to the pipeline.
  ///
  /// Higher-priority transforms run earlier.
  void addTransform(HttpAgentRequestTransformFn fn, [int? priority]) {
    // Keep the pipeline sorted at all time, by priority.
    priority ??= fn.priority ?? 0;
    final i = _pipeline.indexWhere((x) => (x.priority ?? 0) < priority!);
    fn.priority = priority;
    _pipeline.insert(i >= 0 ? i : _pipeline.length, fn);
  }

  @override
  Future<CallResponseBody> callRequest(
    Principal canisterId,
    CallOptions fields,
    Identity? identity,
  ) async {
    final id = identity ?? _identity;
    final canister = Principal.from(canisterId);
    final ecid = fields.effectiveCanisterId != null
        ? Principal.from(fields.effectiveCanisterId)
        : canister;
    final callSync = fields.callSync;
    final sender = id != null ? id.getPrincipal() : Principal.anonymous();

    final CallRequest submit = CallRequest(
      canisterId: canister,
      methodName: fields.methodName,
      arg: fields.arg,
      sender: sender,
      ingressExpiry: Expiry(_defaultIngressExpiryDeltaInMilliseconds),
    );

    final rsRequest = HttpAgentCallRequest(
      request: {
        'method': 'POST',
        'headers': {
          'Content-Type': 'application/cbor',
          ..._baseHeaders,
        },
      },
      body: submit,
    );
    final transformedRequest = await _transform(rsRequest);
    final newTransformed = await id!.transformRequest(transformedRequest);
    final body = cbor.cborEncode(newTransformed['body']);

    Future<Map<String, dynamic>> callV3() {
      return _fetch!(
        endpoint: '/api/v3/canister/${ecid.toText()}/call',
        method: FetchMethod.post,
        headers: newTransformed['request']['headers'],
        body: body,
      );
    }

    Future<Map<String, dynamic>> callV2() {
      return withRetry(
        () => _fetch!(
          endpoint: '/api/v2/canister/${ecid.toText()}/call',
          method: FetchMethod.post,
          headers: newTransformed['request']['headers'],
          body: body,
        ),
      );
    }

    Map<String, dynamic> response;
    if (callSync) {
      response = await callV3();
      if (response['statusCode'] == 404) {
        response = await callV2();
      }
    } else {
      response = await callV2();
    }
    final requestId = requestIdOf(submit.toJson());

    if (!(response['ok'] as bool)) {
      throw AgentFetchError(
        statusCode: response['statusCode'],
        statusText: response['statusText'],
        body: response['body'],
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

    final rsRequest = HttpAgentQueryRequest(
      request: {
        'method': 'POST',
        'headers': {'Content-Type': 'application/cbor', ..._baseHeaders},
      },
      body: requestBody,
    );

    final transformedRequest = await _transform(rsRequest);
    final Map<String, dynamic> newTransformed =
        await id!.transformRequest(transformedRequest);

    final body = cbor.cborEncode(newTransformed['body']);

    final response = await withRetry(
      () => _fetch!(
        endpoint: '/api/v2/canister/${canister.toText()}/query',
        method: FetchMethod.post,
        headers: newTransformed['request']['headers'],
        body: body,
      ),
    );

    if (!(response['ok'] as bool)) {
      throw AgentFetchError(
        statusCode: response['statusCode'],
        statusText: response['statusText'],
        body: response['body'],
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

    final rsRequest = HttpAgentReadStateRequest(
      request: {
        'method': 'POST',
        'headers': {'Content-Type': 'application/cbor', ..._baseHeaders},
      },
      body: requestBody,
    );

    final transformedRequest = await _transform(rsRequest);
    final newTransformed = await id!.transformRequest(
      transformedRequest,
    );

    final body = cbor.cborEncode(newTransformed['body']);
    final response = await withRetry(
      () => _fetch!(
        endpoint: '/api/v2/canister/$canister/read_state',
        method: FetchMethod.post,
        headers: newTransformed['request']['headers'],
        body: body,
      ),
    );

    if (!(response['ok'] as bool)) {
      throw AgentFetchError(
        statusCode: response['statusCode'],
        statusText: response['statusText'],
        body: response['body'],
      );
    }

    final buffer = response['arrayBuffer'] as Uint8List;
    final decoded = cbor.cborDecode<Map>(buffer);
    return ReadStateResponseResult(
      certificate: blobFromBuffer(
        (decoded['certificate'] as Uint8Buffer).buffer,
      ),
    );
  }

  @override
  Future<Map> status() async {
    final response = await withRetry(
      () => _fetch!(
        endpoint: '/api/v2/status',
        headers: {},
        method: FetchMethod.get,
      ),
    );
    if (!(response['ok'] as bool)) {
      throw AgentFetchError(
        statusCode: response['statusCode'],
        statusText: response['statusText'],
        body: response['body'],
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
    Future<HttpAgentRequest> p = Future.value(request);

    for (final fn in _pipeline) {
      p = p.then((r) => fn.call(r).then((r2) => r2 ?? r));
    }
    return p;
  }
}

/// Read-state HTTP request wrapper.
class HttpAgentReadStateRequest extends HttpAgentQueryRequest {
  /// Creates a read-state request wrapper.
  const HttpAgentReadStateRequest({
    required super.request,
    required super.body,
    super.endpoint = Endpoint.readState,
  });
}

/// Read-state response containing a replica certificate.
class ReadStateResponseResult extends ReadStateResponse {
  /// Creates a read-state response result.
  const ReadStateResponseResult({required super.certificate});
}
