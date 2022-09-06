import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'index.dart';

const defaultTimeout = Duration(seconds: 30);

/// [defaultFetch] is a wrapper of [http.get],
/// which can be replaced by any other http packages (e.g. `dio`).
/// [http] has embedded by default, so the library use it directly.
/// Users can set host should be full path of http/https.
/// Usually the usage could be `defaultHost+endpoint`
/// and set the defaultHost to somewhere final,
/// then change the endpoint programatically.
/// `Duration(second: 30)` is the default timeout limit,
/// and throw error directly to end the request section.
///
Future<Map<String, dynamic>> defaultFetch({
  required String endpoint,
  String? host,
  String? defaultHost,
  FetchMethod method = FetchMethod.post,
  Map<String, String>? baseHeaders,
  Map<String, String>? headers,
  Duration? timeout = defaultTimeout,
  bool cbor = true,
  dynamic body,
}) async {
  final client = http.Client();
  try {
    final uri = Uri.parse(host ?? '$defaultHost$endpoint');
    Future<http.Response> fr;
    final compactHeaders = {...?baseHeaders, ...?headers};
    if (cbor) {
      compactHeaders['Content-Type'] = 'application/cbor';
    }
    switch (method) {
      case FetchMethod.post:
        fr = client.post(
          uri,
          headers: compactHeaders,
          body: body,
        );
        break;
      case FetchMethod.get:
        fr = client.get(uri, headers: {...?baseHeaders, ...?headers});
        break;
      case FetchMethod.head:
        fr = client.head(uri, headers: {...?baseHeaders, ...?headers});
        break;
      case FetchMethod.put:
        fr = client.put(
          uri,
          headers: compactHeaders,
          body: body,
        );
        break;
      case FetchMethod.delete:
        fr = client.delete(
          uri,
          headers: compactHeaders,
          body: body,
        );
        break;
      case FetchMethod.patch:
        fr = client.patch(
          uri,
          headers: compactHeaders,
          body: body,
        );
        break;
      case FetchMethod.connect:
      case FetchMethod.options:
      case FetchMethod.trace:
        throw UnimplementedError(
          'Unsupported http request method: `${method.name.toUpperCase()}`.',
        );
    }

    final response = await fr.timeout(
      timeout ?? defaultTimeout,
      onTimeout: () => throw TimeoutException(
        '${host ?? '$defaultHost$endpoint'} timeout',
      ),
    );
    if (response.headers['content-type'] != null &&
        response.headers['content-type']!.split(',').length > 1) {
      final actualHeader = response.headers['content-type']!.split(',').first;
      response.headers['content-type'] = actualHeader;
    }
    client.close();
    return {
      'body': response.body,
      'ok': response.statusCode >= 200 && response.statusCode < 300,
      'statusCode': response.statusCode,
      'statusText': response.reasonPhrase ?? '',
      'arrayBuffer': response.bodyBytes,
    };
  } catch (e) {
    client.close();
    rethrow;
  }
}

class FetchResponse {
  FetchResponse(
    this.body,
    this.ok,
    this.statusCode,
    this.statusText,
    this.arrayBuffer,
  );

  factory FetchResponse.fromMap(Map<String, dynamic> map) {
    return FetchResponse(
      map['body'],
      map['ok'],
      map['statusCode'],
      map['statusText'],
      map['arrayBuffer'],
    );
  }

  final String body;
  final bool ok;
  final int statusCode;
  final String statusText;
  final Uint8List arrayBuffer;

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'ok': ok,
      'statusCode': statusCode,
      'statusText': statusText,
      'arrayBuffer': arrayBuffer
    };
  }
}
