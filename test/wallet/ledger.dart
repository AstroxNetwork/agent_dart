import 'package:agent_dart/agent/agent/factory.dart';
import 'package:agent_dart/wallet/ledger.dart';
import 'package:agent_dart/wallet/signer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ledgerTest();
}

///
/// first go checkout: https://github.com/AstroxNetwork/local-ledger-wasm
/// then run the test
/// this test is not complete yet
void ledgerTest() {
  group("ledger test", () {
    const phrase =
        'steel obey anxiety vast clever relax million girl cost pond elbow bridge hill health toilet desk sleep grid boost flavor shy cry armed mass';

    final signer = ICPSigner.importPhrase(phrase);
    final identity = signer.account.identity;

    Future<AgentFactory> getAgent() async {
      return await AgentFactory.createAgent(
          canisterId:
              "rkp4c-7iaaa-aaaaa-aaaca-cai", // local ledger canister id, should change accourdingly
          url: "http://127.0.0.1:8000/", // For Android emulator, please use 10.0.2.2 as endpoint
          idl: ledgerIdl,
          identity: identity,
          debug: true);
    }

    test('test fetch balance and send', () async {
      var agent = await getAgent();
      var someReceiver = ICPSigner.create();
      var senderBalance =
          await Ledger.getBalance(agent: agent, accountId: signer.idChecksumAddress!);
      expect(senderBalance.e8s > BigInt.zero, true);

      var receiverBeforeSend =
          await Ledger.getBalance(agent: agent, accountId: someReceiver.idChecksumAddress!);
      expect(receiverBeforeSend.e8s == BigInt.zero, true);

      var blockHeight = await Ledger.send(
          agent: agent,
          to: someReceiver.idChecksumAddress!,
          amount: BigInt.from(100000000),
          sendOpts: SendOpts());
      expect(blockHeight >= BigInt.zero, true);
      var receiverAfterSend =
          await Ledger.getBalance(agent: agent, accountId: someReceiver.idChecksumAddress!);
      expect(receiverAfterSend.e8s == BigInt.from(100000000), true);
      var senderBalanceAfter =
          await Ledger.getBalance(agent: agent, accountId: signer.idChecksumAddress!);
      expect(senderBalanceAfter.e8s < senderBalance.e8s - BigInt.from(100000000), true);
    });
  });
}
