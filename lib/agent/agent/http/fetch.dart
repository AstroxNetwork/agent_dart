import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'index.dart';

Future<Map<String, dynamic>> defaultFetch(
    {required String endpoint,
    String? host,
    String? defaultHost,
    String method = "POST",
    Map<String, dynamic>? baseHeaders,
    Map<String, dynamic>? headers,
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
      var getResponse = await client.get(Uri.parse(host ?? "$defaultHost$endpoint"), headers: {
        ...?baseHeaders,
        ...?headers,
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
      var postResponse = await client.post(
        Uri.parse(host ?? "$defaultHost$endpoint"),
        headers: {
          ...?baseHeaders,
          ...?headers,
        },
        body: body,
        // encoding: Encoding.getByName('utf8')
      );

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
  FetchResponse(this.body, this.ok, this.statusCode, this.statusText, this.arrayBuffer);
  factory FetchResponse.fromMap(Map<String, dynamic> map) {
    return FetchResponse(
        map["body"], map["ok"], map["statusCode"], map["statusText"], map["arrayBuffer"]);
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
