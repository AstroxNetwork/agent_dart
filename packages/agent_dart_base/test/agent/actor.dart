import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:test/test.dart';

void main() {
  actorTest();
}

void actorTest() {
  test('actor', () async {
    final agent = HttpAgent(
      defaultHost: 'icp-api.io',
      defaultPort: 443,
      options: const HttpAgentOptions(identity: AnonymousIdentity()),
    );
    final idl = IDL.Service({
      'create_challenge': IDL.Func(
        [],
        [
          IDL.Record({
            'png_base64': IDL.Text,
            'challenge_key': IDL.Text,
          }),
        ],
        [],
      ),
    });
    final actor = CanisterActor(
      ActorConfig(
        canisterId: Principal.fromText('rdmx6-jaaaa-aaaaa-aaadq-cai'),
        agent: agent,
      ),
      idl,
    );
    final result = await actor.getFunc('create_challenge')!.call([]);
    expect(result, isA<Map>());
    expect(result['challenge_key'], isA<String>());
  });
}
