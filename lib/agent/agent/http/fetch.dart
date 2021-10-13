import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:agent_dart/utils/extension.dart';
import 'index.dart';

const defaultTimeout = Duration(seconds: 30);

/// defaultFetch is wrapper of http get
/// can be replaced by any other http packages eg. dio
/// because the http is lower level implementation and is embedded by flutter by default
/// we use it directly.
/// here we have `get` and `post` in the play
/// you can set host should be full path of http/https
/// usually we use `defaultHost+endpoint` and set the defaultHost to somewhere final, and change the endpoint programatically
/// We set `Duration(second:30)` as default timeout limit, and throw error directly to end the request section
Future<Map<String, dynamic>> defaultFetch(
    {required String endpoint,
    String? host,
    String? defaultHost,
    String method = "POST",
    Map<String, dynamic>? baseHeaders,
    Map<String, dynamic>? headers,
    Duration? timeout = defaultTimeout,
    dynamic body}) async {
  final client = http.Client();
  FetchMethod fetchMethod = FetchMethod.post;

  if (method == "Get" || method == "get" || method == "GET") {
    fetchMethod = FetchMethod.get;
  } else {
    fetchMethod = FetchMethod.post;
  }

  try {
    if (fetchMethod == FetchMethod.get) {
      var getResponse = await client
          .get(Uri.parse(host ?? "$defaultHost$endpoint"), headers: {
        ...?baseHeaders,
        ...?headers,
      }).timeout(timeout ?? defaultTimeout, onTimeout: () {
        throw 'http request(GET) to ${host ?? "$defaultHost$endpoint"} timeout';
      });
      client.close();
      return {
        "body": getResponse.body,
        "ok": getResponse.statusCode >= 200 && getResponse.statusCode < 300,
        "statusCode": getResponse.statusCode,
        "statusText": getResponse.reasonPhrase ?? '',
        "arrayBuffer": getResponse.bodyBytes,
      };
    } else {
      var postResponse = await client
          .post(
        Uri.parse(host ?? "$defaultHost$endpoint"),
        headers: {
          ...?baseHeaders,
          ...?headers,
        },
        body: body,
        // encoding: Encoding.getByName('utf8')
      )
          .timeout(timeout ?? defaultTimeout, onTimeout: () {
        throw 'http request(POST) to ${host ?? "$defaultHost$endpoint"} timeout';
      });

      client.close();
      return {
        "body": postResponse.body,
        "ok": postResponse.statusCode >= 200 && postResponse.statusCode < 300,
        "statusCode": postResponse.statusCode,
        "statusText": postResponse.reasonPhrase ?? '',
        "arrayBuffer": postResponse.bodyBytes,
      };
    }
  } catch (e) {
    client.close();
    throw "http request failed because $e";
  }
}

class FetchResponse {
  String body;
  bool ok;
  int statusCode;
  String statusText;
  Uint8List arrayBuffer;
  FetchResponse(
      this.body, this.ok, this.statusCode, this.statusText, this.arrayBuffer);
  factory FetchResponse.fromMap(Map<String, dynamic> map) {
    return FetchResponse(map["body"], map["ok"], map["statusCode"],
        map["statusText"], map["arrayBuffer"]);
  }
  toJson() {
    return {
      "body": body,
      "ok": ok,
      "statusCode": statusCode,
      "statusText": statusText,
      "arrayBuffer": arrayBuffer
    };
  }
}
