import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:agent_dart_base/wallet/ledger.dart';
import 'package:test/test.dart';

void main() {
  ledgerTest();
}

///
/// first go checkout: https://github.com/AstroxNetwork/local-ledger-wasm
/// then run the test
/// this test is not complete yet
const dfx12 = './test/fixture/dfx12.pem';
void ledgerTest() {
  group('ledger test', () {
    Future<Secp256k1KeyIdentity> getSigner() async {
      // const phrase =
      //     'steel obey anxiety vast clever relax million girl cost pond elbow bridge hill health toilet desk sleep grid boost flavor shy cry armed mass';
      // final signer =
      //     await ICPSigner.importPhrase(phrase, curveType: CurveType.secp256k1);
      // /// we use secp256k1 curve here
      // return signer;

      // use dfx 0.12.1
      final pem = await getPemFile(dfx12);
      expect(pem.keyType, KeyType.secp265k1);
      final signer = await secp256k1KeyIdentityFromPem(pem.rawString);
      return signer;
    }

    Future<AgentFactory> getAgent() async {
      return AgentFactory.createAgent(
        canisterId: 'ryjl3-tyaaa-aaaaa-aaaba-cai',
        // local ledger canister id, should change accourdingly
        url: 'http://localhost:8080/',
        // For Android emulator, please use 10.0.2.2 as endpoint
        idl: ledgerIdl,
        identity: await getSigner(),
      );
    }

    test('test fetch balance and send', () async {
      final signer = await getSigner();
      final agent = await getAgent();
      final signerAddress = signer.getAccountId().toHex();
      final someReceiver =
          await ICPSigner.create(curveType: CurveType.secp256k1);
      final senderBalance =
          await Ledger.getBalance(agent: agent, accountId: signerAddress);
      expect(senderBalance.e8s > BigInt.zero, true);
      print('\n----- test fetch balance and send -----');
      print('\n---👩 sender Balance before send:');
      print(senderBalance.e8s);
      final receiverBeforeSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: someReceiver.ecAddress!,
      );
      expect(receiverBeforeSend.e8s == BigInt.zero, true);
      print('\n---🧑 receiver balance before send:');
      print(receiverBeforeSend.e8s);

      print('\n---📖 payload:');
      print('amount:  ${BigInt.from(100000000)}');
      print('fee:     ${BigInt.from(10000)}');
      print('from:    $signerAddress');
      print('to:      ${someReceiver.ecAddress}');

      print('\n---🤔 sending start=====>');
      final blockHeight = await Ledger.send(
        agent: agent,
        to: someReceiver.ecAddress!,
        amount: BigInt.from(100000000),
        sendOpts: const SendOpts(),
      );
      print('\n---✅ sending end=====>');
      print('\n---🔢 block height: $blockHeight');
      expect(blockHeight >= BigInt.zero, true);
      final receiverAfterSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: someReceiver.ecAddress!,
      );
      expect(receiverAfterSend.e8s == BigInt.from(100000000), true);
      print('\n---🧑 receiver balance after send:');
      print(receiverAfterSend.e8s);
      final senderBalanceAfter = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signerAddress,
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
      final signer = await getSigner();
      final signerAddress = signer.getAccountId().toHex();
      print('\n $signerAddress');
      final agent = await getAgent();
      final someReceiver =
          await ICPSigner.create(curveType: CurveType.secp256k1);
      final senderBalance = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signerAddress,
      );
      expect(senderBalance.e8s > BigInt.zero, true);
      print('\n----- test fetch balance and send -----');
      print('\n---👩 sender Balance before send:');
      print(senderBalance.e8s);
      final receiverBeforeSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: someReceiver.ecAddress!,
      );
      expect(receiverBeforeSend.e8s == BigInt.zero, true);
      print('\n---🧑 receiver balance before send:');
      print(receiverBeforeSend.e8s);

      print('\n---📖 payload:');
      print('amount:  ${BigInt.from(100000000)}');
      print('fee:     ${BigInt.from(10000)}');
      print('from:    $signerAddress');
      print('to:      ${someReceiver.ecAddress}');

      print('\n---🤔 sending start=====>');
      final blockHeight = await Ledger.transfer(
        agent: agent,
        to: someReceiver.ecAddress!,
        amount: BigInt.from(100000000),
        sendOpts: const SendOpts(),
      );
      print('\n---✅ sending end=====>');
      print('\n---🔢 block height: ${blockHeight.ok}');
      expect(blockHeight.ok! >= BigInt.zero, true);
      final receiverAfterSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: someReceiver.ecAddress!,
      );
      expect(receiverAfterSend.e8s == BigInt.from(100000000), true);
      print('\n---🧑 receiver balance after send:');
      print(receiverAfterSend.e8s);
      final senderBalanceAfter = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signerAddress,
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
      final signer = await getSigner();
      final agent = await getAgent();
      final signerAddress = signer.getAccountId().toHex();
      // final someReceiver = ICPSigner.create();
      const receiverCanister = 'qhbym-qaaaa-aaaaa-aaafq-cai';
      final senderBalance = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signerAddress,
      );
      expect(senderBalance.e8s > BigInt.zero, true);
      print('\n----- test fetch balance and send -----');
      print('\n---👩 sender Balance before send:');
      print(senderBalance.e8s);
      final receiverBeforeSend = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: receiverCanister,
      );
      print('\n---🧑 receiver balance before send:');
      print(receiverBeforeSend.e8s);

      print('\n---📖 payload:');
      print('amount:  ${BigInt.from(100000000)}');
      print('fee:     ${BigInt.from(10000)}');
      print('from:    $signerAddress');
      print('to:      $receiverCanister');

      print('\n---🤔 sending start=====>');
      final blockHeight = await Ledger.transfer(
        agent: agent,
        to: receiverCanister,
        amount: BigInt.from(100000000),
        sendOpts: const SendOpts(),
      );
      print('\n---✅ sending end=====>');
      print('\n---🔢 block height: ${blockHeight.ok}');
      expect(blockHeight.ok! >= BigInt.zero, true);
      final receiverAfterSend = await Ledger.accountBalance(
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
      final senderBalanceAfter = await Ledger.accountBalance(
        agent: agent,
        accountIdOrPrincipal: signerAddress,
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
