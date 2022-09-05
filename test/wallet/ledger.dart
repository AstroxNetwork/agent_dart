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
  group('ledger test', () {
    Future<ICPSigner> getSigner() async {
      const phrase =
          'steel obey anxiety vast clever relax million girl cost pond elbow bridge hill health toilet desk sleep grid boost flavor shy cry armed mass';

      final signer =
          await ICPSigner.importPhrase(phrase, curveType: CurveType.secp256k1);

      /// we use secp256k1 curve here
      return signer;
    }

    Future<AgentFactory> getAgent() async {
      return await AgentFactory.createAgent(
        canisterId: 'ryjl3-tyaaa-aaaaa-aaaba-cai',
        // local ledger canister id, should change accourdingly
        url: 'http://localhost:8000/',
        // For Android emulator, please use 10.0.2.2 as endpoint
        idl: ledgerIdl,
        identity: (await getSigner()).account.ecIdentity,
        debug: true,
      );
    }

    test('test fetch balance and send', () async {
      var signer = await getSigner();
      var agent = await getAgent();
      var someReceiver = await ICPSigner.create(curveType: CurveType.secp256k1);
      var senderBalance =
          await Ledger.getBalance(agent: agent, accountId: signer.ecAddress!);
      expect(senderBalance.e8s > BigInt.zero, true);
      print('\n----- test fetch balance and send -----');
      print('\n---👩 sender Balance before send:');
      print(senderBalance.e8s);
      var receiverBeforeSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: someReceiver.ecAddress!,
      );
      expect(receiverBeforeSend.e8s == BigInt.zero, true);
      print('\n---🧑 receiver balance before send:');
      print(receiverBeforeSend.e8s);

      print('\n---📖 payload:');
      print('amount:  ${BigInt.from(100000000)}');
      print('fee:     ${BigInt.from(10000)}');
      print('from:    ${signer.ecAddress}');
      print('to:      ${someReceiver.ecAddress}');

      print('\n---🤔 sending start=====>');
      var blockHeight = await Ledger.send(
        agent: agent,
        to: someReceiver.ecAddress!,
        amount: BigInt.from(100000000),
        sendOpts: const SendOpts(),
      );
      print('\n---✅ sending end=====>');
      print('\n---🔢 block height: $blockHeight');
      expect(blockHeight >= BigInt.zero, true);
      var receiverAfterSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: someReceiver.ecAddress!,
      );
      expect(receiverAfterSend.e8s == BigInt.from(100000000), true);
      print('\n---🧑 receiver balance after send:');
      print(receiverAfterSend.e8s);
      var senderBalanceAfter = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signer.ecAddress!,
      );
      expect(
        senderBalanceAfter.e8s < senderBalance.e8s - BigInt.from(100000000),
        true,
      );
      print('\n---👩 sender balance after send:');
      print(senderBalanceAfter.e8s);
      print('\n---💰 balance change:');
      print(senderBalanceAfter.e8s - senderBalance.e8s);
    });

    test('latest account balance and transfer', () async {
      var signer = await getSigner();
      print('\n ${signer.ecAddress}');
      var agent = await getAgent();
      var someReceiver = await ICPSigner.create(curveType: CurveType.secp256k1);
      var senderBalance = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signer.ecAddress!,
      );
      expect(senderBalance.e8s > BigInt.zero, true);
      print('\n----- test fetch balance and send -----');
      print('\n---👩 sender Balance before send:');
      print(senderBalance.e8s);
      var receiverBeforeSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: someReceiver.ecAddress!,
      );
      expect(receiverBeforeSend.e8s == BigInt.zero, true);
      print('\n---🧑 receiver balance before send:');
      print(receiverBeforeSend.e8s);

      print('\n---📖 payload:');
      print('amount:  ${BigInt.from(100000000)}');
      print('fee:     ${BigInt.from(10000)}');
      print('from:    ${signer.ecAddress}');
      print('to:      ${someReceiver.ecAddress}');

      print('\n---🤔 sending start=====>');
      var blockHeight = await Ledger.transfer(
        agent: agent,
        to: someReceiver.ecAddress!,
        amount: BigInt.from(100000000),
        sendOpts: const SendOpts(),
      );
      print('\n---✅ sending end=====>');
      print('\n---🔢 block height: ${blockHeight.ok}');
      expect((blockHeight).ok! >= BigInt.zero, true);
      var receiverAfterSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: someReceiver.ecAddress!,
      );
      expect(receiverAfterSend.e8s == BigInt.from(100000000), true);
      print('\n---🧑 receiver balance after send:');
      print(receiverAfterSend.e8s);
      var senderBalanceAfter = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signer.ecAddress!,
      );
      expect(
        senderBalanceAfter.e8s < senderBalance.e8s - BigInt.from(100000000),
        true,
      );
      print('\n---👩 sender balance after send:');
      print(senderBalanceAfter.e8s);
      print('\n---💰 balance change:');
      print(senderBalanceAfter.e8s - senderBalance.e8s);
    });

    test('transfer to Canister', () async {
      var signer = await getSigner();
      var agent = await getAgent();
      // var someReceiver = ICPSigner.create();
      var receiverCanister = 'qhbym-qaaaa-aaaaa-aaafq-cai';
      var senderBalance = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signer.ecAddress!,
      );
      expect(senderBalance.e8s > BigInt.zero, true);
      print('\n----- test fetch balance and send -----');
      print('\n---👩 sender Balance before send:');
      print(senderBalance.e8s);
      var receiverBeforeSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: receiverCanister,
      );
      print('\n---🧑 receiver balance before send:');
      print(receiverBeforeSend.e8s);

      print('\n---📖 payload:');
      print('amount:  ${BigInt.from(100000000)}');
      print('fee:     ${BigInt.from(10000)}');
      print('from:    ${signer.ecAddress}');
      print('to:      $receiverCanister');

      print('\n---🤔 sending start=====>');
      var blockHeight = await Ledger.transfer(
        agent: agent,
        to: receiverCanister,
        amount: BigInt.from(100000000),
        sendOpts: const SendOpts(),
      );
      print('\n---✅ sending end=====>');
      print('\n---🔢 block height: ${blockHeight.ok}');
      expect((blockHeight).ok! >= BigInt.zero, true);
      var receiverAfterSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: receiverCanister,
      );
      expect(
        receiverAfterSend.e8s ==
            receiverBeforeSend.e8s + BigInt.from(100000000),
        true,
      );
      print('\n---🧑 receiver balance after send:');
      print(receiverAfterSend.e8s);
      var senderBalanceAfter = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signer.ecAddress!,
      );
      expect(
        senderBalanceAfter.e8s < senderBalance.e8s - BigInt.from(100000000),
        true,
      );
      print('\n---👩 sender balance after send:');
      print(senderBalanceAfter.e8s);
      print('\n---💰 balance change:');
      print(senderBalanceAfter.e8s - senderBalance.e8s);
    });
  });
}
