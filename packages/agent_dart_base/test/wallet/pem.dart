import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:test/test.dart';

void main() {
  pemTest();
}

void pemTest() {
  const ed25519File = './test/fixture/ed25519.pem';
  const secp256k1File = './test/fixture/secp256k1.pem';
  test('from ed25519 pem', () async {
    final pem = await getPemFile(ed25519File);
    expect(pem.keyType, KeyType.ed25519);
    final id = await ed25519KeyIdentityFromPem(pem.rawString);
    expect(
      id.getPrincipal().toText(),
      'uz7u7-ut6sf-gx45r-pb3ww-ntxjp-y4lv2-bdobd-65xa3-7yt6t-ti2lz-aqe',
    );
  });
  test('from secp256k1 pem', () async {
    final pem = await getPemFile(secp256k1File);
    expect(pem.keyType, KeyType.secp265k1);
    final id = await secp256k1KeyIdentityFromPem(pem.rawString);
    expect(
      id.getPrincipal().toText(),
      '4tu7k-esetu-2lfo6-zzg45-ivl5m-77h3d-gjszr-uoeg4-zh24n-jly75-dqe',
    );
  });
}
