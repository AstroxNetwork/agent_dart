import 'dart:typed_data';

import 'package:agent_dart/agent_dart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  httpTest();
}

void httpTest() {
  group('description 1', () {
    test('some', () async {
      Principal canisterId = Principal.fromText('2chl6-4hpzw-vqaaa-aaaaa-c');
      var nonce = Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7]);
      var principal = Principal.anonymous();

      var agent = HttpAgent(
        options: HttpAgentOptions()..identity = const AnonymousIdentity(),
      );

      agent.addTransform(HttpAgentRequestTransformFn()
        ..call = makeNonceTransform(() => nonce));

      const methodName = 'greet';
      final arg = Uint8List.fromList([]);

      agent.setFetch(({
        body,
        endpoint = 'https://localhost:8000',
        headers,
        host,
        method = FetchMethod.post,
      }) {
        return Future.value({
          'body': null,
          'ok': true,
          'statusCode': 200,
          'statusText': '',
          'arrayBuffer': null,
        });
      });

      // ignore: unused_local_variable
      var res = await agent.call(
        canisterId,
        CallOptions(arg: arg, methodName: methodName),
        null,
      );

      // print((res as CallResponseBody).toJson());

      final mockPartialRequest = {
        'request_type': SubmitRequestType.call,
        'canister_id': canisterId,
        'method_name': methodName,
        // We need a request id for the signature and at the same time we
        // are checking that signature does not impact the request id.
        'arg': arg,
        'nonce': nonce,
        'sender': principal,
        'ingress_expiry': Expiry(300000),
      };

      var mockPartialsRequestId = requestIdOf(mockPartialRequest);

      var expectedRequest = {
        'content': mockPartialRequest,
      };

      var expectedRequestId =
          requestIdOf(expectedRequest['content'] as Map<String, dynamic>);

      expect(expectedRequestId, mockPartialsRequestId);
    });
  });
  group('description 2 ', () {});
}
