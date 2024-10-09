import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:test/test.dart';

void main() {
  group(PollingResponseException, () {
    test('toString() equalization', () {
      final canisterId = Principal.fromText('vmyqj-fzaaa-aaaaa-qaaga-cai');
      const requestId = 'test_id';
      const status = RequestStatusResponseStatus.rejected;
      const method = 'test_method';
      final caller = Principal.anonymous();

      final e1 = PollingResponseException(
        canisterId: canisterId,
        requestId: requestId,
        status: status,
        method: method,
        caller: caller,
      );
      expect(
        e1.toString(),
        equals('''Call was rejected:
|- Canister ID: vmyqj-fzaaa-aaaaa-qaaga-cai
|-- Request ID: test_id
|------ Caller: 2vxsx-fae
|------ Method: test_method'''),
      );

      final e2 = PollingResponseNoReplyException(
        canisterId: canisterId,
        requestId: requestId,
        status: status,
        method: method,
        caller: caller,
      );
      expect(
        e2.toString(),
        equals('''Call was marked as rejected but never replied:
|- Canister ID: vmyqj-fzaaa-aaaaa-qaaga-cai
|-- Request ID: test_id
|------ Caller: 2vxsx-fae
|------ Method: test_method'''),
      );

      final rejectCode = BigInt.from(5);
      const rejectMessage =
          'Canister vmyqj-fzaaa-aaaaa-qaaga-cai trapped explicitly';
      final e3 = PollingResponseRejectedException(
        canisterId: canisterId,
        requestId: requestId,
        status: status,
        method: method,
        caller: caller,
        rejectCode: rejectCode,
        rejectMessage: rejectMessage,
      );
      expect(
        e3.toString(),
        equals('''Call was rejected:
|- Canister ID: vmyqj-fzaaa-aaaaa-qaaga-cai
|-- Request ID: test_id
|------ Caller: 2vxsx-fae
|------ Method: test_method
|-------- Code: 5
|----- Message: Canister vmyqj-fzaaa-aaaaa-qaaga-cai trapped explicitly'''),
      );
    });
  });
}
