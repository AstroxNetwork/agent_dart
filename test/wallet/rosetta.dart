import 'dart:typed_data';

import 'package:agent_dart/agent/cbor.dart';
import 'package:agent_dart/identity/identity.dart';
import 'package:agent_dart/wallet/hashing.dart';
import 'package:agent_dart/wallet/signer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/wallet/rosetta.dart';
import '../test_utils.dart';

void main() {
  rosettaTest();
}

void rosettaTest() {
  test('encodes properly', () async {
    // var mne = genrateMnemonic();
    // var mne = 'poem pause flame glue ocean diesel extra onion patch rich farm detail';
    // var prv =
    //     '2a29d1516eda736523fc10e20bd1929e738e71d85bc4d6bb2f1a92ae9046829b'; // equivilant above as bip39(index=0);
    // var acc = ICPAccount.fromPrivateKey(prv);

    // var mne2 =
    //     'open jelly jeans corn ketchup supreme brief element armed lens vault weather original scissors rug priority vicious lesson raven spot gossip powder person volcano';
    // var acc2 = ICPSigner.fromPhrase(mne2);

    // print(acc2.account.ecKeys?.accountId!.toHex());
    // print(acc2.account.identity?.accountId.toHex());

    // var rose = RosettaApi(host: "http://localhost:8080");

    // await rose.init();
    // var res = await rose.transferPreCombine(acc.identity!.getPublicKey().rawKey,
    //     acc2.account.identity!.accountId, BigInt.from(1), null, null);
    // print(cborDecode(res.unsigned_transaction.toU8a()));

    // print(hash_of_map({"a": "b"}).toHex());

    // print(hash_of_map({"a": 1}).toHex());
    // print(hash_string("a").toHex());
    var signer =
        ICPSigner.fromPrivatKey("07acb84879d371491ceccb357322b264fc7703e7966686c0fd4d39cebcaffab3");
    print(signer.idPublicKey);
    print(signer.idAddress);

    final seed = Uint8List.fromList(List.filled(32, 0)).toHex();
    var receiver = ICPSigner.fromPrivatKey(seed);

    final count = BigInt.one;

    print(receiver.idAddress);

    var rose = RosettaApi(); // host: "http://localhost:8080"
    await rose.init();

    var payloadsRes = await rose.transferPreCombine(
        signer.idPublicKey!.toU8a(), receiver.idAddress!.toU8a(), count, null, null);

    print("from :${signer.idAddress}");
    print("to :${receiver.idAddress}");
    print("sender_pubkey :${signer.idPublicKey}");

    var result = await transferCombine(signer.account.identity!, payloadsRes);

    var txn = await rose.transfer_post_combine(result);
    print(txn.toJson());

    // {"network_identifier":{"blockchain":"Internet Computer","network":"00000000000000020101"},"operations":[{"operation_identifier":{"index":0},"type":"TRANSACTION","account":{"address":"a8a3746fca2b69ee144224ab735b0c0f1977d3aa44a97c75240da7ab05becea4"},"amount":{"value":"-1","currency":{"symbol":"ICP","decimals":8}}},{"operation_identifier":{"index":1},"type":"TRANSACTION","account":{"address":"1e1838071cb875e59c1da64af5e04951bb3c1e94c1285bf9ff7480a645e1aa56"},"amount":{"value":"1","currency":{"symbol":"ICP","decimals":8}}},{"operation_identifier":{"index":2},"type":"FEE","account":{"address":"a8a3746fca2b69ee144224ab735b0c0f1977d3aa44a97c75240da7ab05becea4"},"amount":{"value":"-10000","currency":{"symbol":"ICP","decimals":8}}}],"metadata":{},"public_keys":[{"hex_bytes":"1033d9c1e8ca030d03f5fb4e68aa9bf0b45d85306d4d14297fe862d66aeae123","curve_type":"edwards25519"}]}
    // {"network_identifier":{"blockchain":"Internet Computer","network":"00000000000000020101"},"operations":[{"type":"TRANSACTION","operation_identifier":{"index":0},"account":{"address":"a8a3746fca2b69ee144224ab735b0c0f1977d3aa44a97c75240da7ab05becea4"},"amount":{"value":"-1","currency":{"symbol":"ICP","decimals":8}}},{"type":"TRANSACTION","operation_identifier":{"index":1},"account":{"address":"1e1838071cb875e59c1da64af5e04951bb3c1e94c1285bf9ff7480a645e1aa56"},"amount":{"value":"1","currency":{"symbol":"ICP","decimals":8}}},{"type":"FEE","operation_identifier":{"index":2},"account":{"address":"a8a3746fca2b69ee144224ab735b0c0f1977d3aa44a97c75240da7ab05becea4"},"amount":{"value":"-10000","currency":{"symbol":"ICP","decimals":8}}}],"public_keys":[{"hex_bytes":"1033d9c1e8ca030d03f5fb4e68aa9bf0b45d85306d4d14297fe862d66aeae123","curve_type":"edwards25519"}],"metadata":{}}
  });
}
