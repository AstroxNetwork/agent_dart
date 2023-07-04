import 'dart:convert';

import 'package:agent_dart_base/agent/agent.dart';
import 'package:agent_dart_base/agent/agent/http/fetch.dart';

class OverrideOptions {
  const OverrideOptions({
    this.host,
    this.headers,
  });
  final Map<String, dynamic>? headers;
  final String? host;
}

class OrdClient {
  OrdClient({
    HttpAgentOptions? options,
    this.defaultProtocol = 'https',
    this.defaultHost = 'localhost',
    this.defaultPort = 8000,
  }) {
    if (options != null) {
      setFetch(_defaultOrdFetch);

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
      setFetch(_defaultOrdFetch);
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
    _fetch = fetch ?? _defaultOrdFetch;
  }

  void addTransform(HttpAgentRequestTransformFn fn, [int? priority]) {
    // Keep the pipeline sorted at all time, by priority.
    priority ??= fn.priority ?? 0;
    final i = _pipeline.indexWhere((x) => (x.priority ?? 0) < priority!);
    fn.priority = priority;
    _pipeline.insert(i >= 0 ? i : _pipeline.length, fn);
  }

  Future<SubmitResponse> httpPost(
    String endpoint,
    Map<String, dynamic> body,
    OverrideOptions? override,
  ) async {
    final response = await _fetch!(
      host: override?.host ?? _host,
      endpoint: endpoint,
      method: FetchMethod.post,
      headers: {
        ...override?.headers ?? {},
      },
      body: jsonEncode(body),
    );

    if (!(response['ok'] as bool)) {
      throw AgentFetchError(
        statusCode: response['statusCode'],
        statusText: response['statusText'],
        body: response[body],
      );
    }
    return CallResponseBody.fromJson({...response});
  }

  Future<SubmitResponse> httpPostString(
    String endpoint,
    String body,
    OverrideOptions? override,
  ) async {
    final response = await _fetch!(
      host: override?.host ?? _host,
      endpoint: endpoint,
      method: FetchMethod.post,
      headers: {
        ...override?.headers ?? {},
      },
      body: body,
    );

    if (!(response['ok'] as bool)) {
      throw AgentFetchError(
        statusCode: response['statusCode'],
        statusText: response['statusText'],
        body: response[body],
      );
    }
    return CallResponseBody.fromJson({...response});
  }

  Future<SubmitResponse> httpGet(
    String endpoint,
    Map<String, dynamic> body,
    OverrideOptions? override,
  ) async {
    final response = await _fetch!(
      host: override?.host ?? _host,
      endpoint: endpoint,
      method: FetchMethod.get,
      headers: {
        ...override?.headers ?? {},
      },
      body: jsonEncode(body),
    );

    if (!(response['ok'] as bool)) {
      throw AgentFetchError(
        statusCode: response['statusCode'],
        statusText: response['statusText'],
        body: response[body],
      );
    }
    return CallResponseBody.fromJson({...response});
  }

  Map<String, String> _createBaseHeaders() {
    return {
      if (_credentials != null && _credentials!.isNotEmpty)
        'Authorization': 'Basic ${btoa(_credentials)}',
    };
  }

  Future<Map<String, dynamic>> _defaultOrdFetch({
    required String endpoint,
    String? host,
    FetchMethod method = FetchMethod.post,
    Map<String, String>? headers,
    dynamic body,
  }) {
    return defaultFetch(
      endpoint: endpoint,
      cbor: false,
      defaultHost: host,
      method: method,
      headers: headers,
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
