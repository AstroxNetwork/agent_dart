import 'package:agent_dart_base/src/ffi/bls.base.dart';
import 'package:agent_dart_base/utils/extension.dart';
import 'package:test/test.dart';

void main() {
  blsTest();
}

void blsTest() {
  test('verify', () async {
    const pk =
        'a7623a93cdb56c4d23d99c14216afaab3dfd6d4f9eb3db23d038280b6d5cb2caaee2a19dd92c9df7001dede23bf036bc0f33982dfb41e8fa9b8e96b5dc3e83d55ca4dd146c7eb2e8b6859cb5a5db815db86810b8d12cee1588b5dbf34a4dc9a5';
    const sig =
        'b89e13a212c830586eaa9ad53946cd968718ebecc27eda849d9232673dcd4f440e8b5df39bf14a88048c15e16cbcaabe';
    const msg = 'hello';
    final BaseBLS bls = BaseBLS();
    expect(
      await bls.blsVerify(pk.toU8a(), sig.toU8a(), msg.plainToU8a()),
      true,
    );
    expect(
      await bls.blsVerify(pk.toU8a(), sig.toU8a(), 'Hallo'.plainToU8a()),
      false,
    );
  });
}
