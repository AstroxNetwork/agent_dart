import 'package:agent_dart/agent/agent/factory.dart';
import 'package:agent_dart/agent_dart.dart';
import 'package:agent_dart/protobuf/ic_base_types/pb/v1/types.pb.dart';
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

    /// we use secp256k1 curve here
    final identity = signer.account.ecIdentity;

    Future<AgentFactory> getAgent() async {
      return await AgentFactory.createAgent(
          canisterId:
              "ryjl3-tyaaa-aaaaa-aaaba-cai", // local ledger canister id, should change accourdingly
          url:
              "http://localhost:8000/", // For Android emulator, please use 10.0.2.2 as endpoint
          idl: ledgerIdl,
          identity: identity,
          debug: true);
    }

    test('test fetch balance and send', () async {
      var agent = await getAgent();
      var someReceiver = ICPSigner.create();
      var senderBalance = await Ledger.getBalance(
          agent: agent, accountId: signer.ecChecksumAddress!);
      expect(senderBalance.e8s > BigInt.zero, true);
      print("\n----- test fetch balance and send -----");
      print("\n---👩 sender Balance before send:");
      print(senderBalance.e8s);
      var receiverBeforeSend = await Ledger.getBalance(
          agent: agent, accountId: someReceiver.ecChecksumAddress!);
      expect(receiverBeforeSend.e8s == BigInt.zero, true);
      print("\n---🧑 receiver balance before send:");
      print(receiverBeforeSend.e8s);

      print("\n---📖 payload:");
      print("amount:  ${BigInt.from(100000000)}");
      print("fee:     ${BigInt.from(10000)}");
      print("from:    ${signer.ecChecksumAddress}");
      print("to:      ${someReceiver.ecChecksumAddress}");

      print("\n---🤔 sending start=====>");
      var blockHeight = await Ledger.send(
          agent: agent,
          to: someReceiver.ecChecksumAddress!,
          amount: BigInt.from(100000000),
          sendOpts: SendOpts());
      print("\n---✅ sending end=====>");
      print("\n---🔢 block height: $blockHeight");
      expect(blockHeight >= BigInt.zero, true);
      var receiverAfterSend = await Ledger.getBalance(
          agent: agent, accountId: someReceiver.ecChecksumAddress!);
      expect(receiverAfterSend.e8s == BigInt.from(100000000), true);
      print("\n---🧑 receiver balance after send:");
      print(receiverAfterSend.e8s);
      var senderBalanceAfter = await Ledger.getBalance(
          agent: agent, accountId: signer.ecChecksumAddress!);
      expect(
          senderBalanceAfter.e8s < senderBalance.e8s - BigInt.from(100000000),
          true);
      print("\n---👩 sender balance after send:");
      print(senderBalanceAfter.e8s);
      print("\n---💰 balance change:");
      print(senderBalanceAfter.e8s - senderBalance.e8s);
    });

    test('latest account balance and transfer', () async {
      print("\n ${signer.ecChecksumAddress}");
      var agent = await getAgent();
      var someReceiver = ICPSigner.create();
      var senderBalance = await Ledger.accountBalance(
          agent: agent, accountIdOrPrincipal: signer.ecChecksumAddress!);
      expect(senderBalance.e8s > BigInt.zero, true);
      print("\n----- test fetch balance and send -----");
      print("\n---👩 sender Balance before send:");
      print(senderBalance.e8s);
      var receiverBeforeSend = await Ledger.accountBalance(
          agent: agent, accountIdOrPrincipal: someReceiver.ecChecksumAddress!);
      expect(receiverBeforeSend.e8s == BigInt.zero, true);
      print("\n---🧑 receiver balance before send:");
      print(receiverBeforeSend.e8s);

      print("\n---📖 payload:");
      print("amount:  ${BigInt.from(100000000)}");
      print("fee:     ${BigInt.from(10000)}");
      print("from:    ${signer.ecChecksumAddress}");
      print("to:      ${someReceiver.ecChecksumAddress}");

      print("\n---🤔 sending start=====>");
      var blockHeight = await Ledger.transfer(
          agent: agent,
          to: someReceiver.ecChecksumAddress!,
          amount: BigInt.from(100000000),
          sendOpts: SendOpts());
      print("\n---✅ sending end=====>");
      print("\n---🔢 block height: ${blockHeight.Ok}");
      expect((blockHeight as TransferResult).Ok! >= BigInt.zero, true);
      var receiverAfterSend = await Ledger.accountBalance(
          agent: agent, accountIdOrPrincipal: someReceiver.ecChecksumAddress!);
      expect(receiverAfterSend.e8s == BigInt.from(100000000), true);
      print("\n---🧑 receiver balance after send:");
      print(receiverAfterSend.e8s);
      var senderBalanceAfter = await Ledger.accountBalance(
          agent: agent, accountIdOrPrincipal: signer.ecChecksumAddress!);
      expect(
          senderBalanceAfter.e8s < senderBalance.e8s - BigInt.from(100000000),
          true);
      print("\n---👩 sender balance after send:");
      print(senderBalanceAfter.e8s);
      print("\n---💰 balance change:");
      print(senderBalanceAfter.e8s - senderBalance.e8s);
    });

    test('transfer to Canister', () async {
      var agent = await getAgent();
      // var someReceiver = ICPSigner.create();
      var receiver_canister = 'qhbym-qaaaa-aaaaa-aaafq-cai';
      var senderBalance = await Ledger.accountBalance(
          agent: agent, accountIdOrPrincipal: signer.ecChecksumAddress!);
      expect(senderBalance.e8s > BigInt.zero, true);
      print("\n----- test fetch balance and send -----");
      print("\n---👩 sender Balance before send:");
      print(senderBalance.e8s);
      var receiverBeforeSend = await Ledger.accountBalance(
          agent: agent, accountIdOrPrincipal: receiver_canister);
      print("\n---🧑 receiver balance before send:");
      print(receiverBeforeSend.e8s);

      print("\n---📖 payload:");
      print("amount:  ${BigInt.from(100000000)}");
      print("fee:     ${BigInt.from(10000)}");
      print("from:    ${signer.ecChecksumAddress}");
      print("to:      ${receiver_canister}");

      print("\n---🤔 sending start=====>");
      var blockHeight = await Ledger.transfer(
          agent: agent,
          to: receiver_canister,
          amount: BigInt.from(100000000),
          sendOpts: SendOpts());
      print("\n---✅ sending end=====>");
      print("\n---🔢 block height: ${blockHeight.Ok}");
      expect((blockHeight as TransferResult).Ok! >= BigInt.zero, true);
      var receiverAfterSend = await Ledger.accountBalance(
          agent: agent, accountIdOrPrincipal: receiver_canister);
      expect(
          receiverAfterSend.e8s ==
              receiverBeforeSend.e8s + BigInt.from(100000000),
          true);
      print("\n---🧑 receiver balance after send:");
      print(receiverAfterSend.e8s);
      var senderBalanceAfter = await Ledger.accountBalance(
          agent: agent, accountIdOrPrincipal: signer.ecChecksumAddress!);
      expect(
          senderBalanceAfter.e8s < senderBalance.e8s - BigInt.from(100000000),
          true);
      print("\n---👩 sender balance after send:");
      print(senderBalanceAfter.e8s);
      print("\n---💰 balance change:");
      print(senderBalanceAfter.e8s - senderBalance.e8s);
    });
  });
}
