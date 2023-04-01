import 'dart:convert';
import 'dart:io';

import 'package:agent_dart_base/agent/ord/client.dart';
import 'package:agent_dart_base/agent/ord/service.dart';
import 'package:agent_dart_base/agent/ord/utxo.dart';
import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:agent_dart_base/identity/psbt.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  matchFFI();
  psbtTest();
}

void psbtTest() {
  test('get psbt address', () async {
    final wallet = await BitcoinWallet.fromPhrase(
        'rocket image glove chief harbor cat chapter easy symptom goddess city target');
    // final addss = wallet.signers.map((e) => e.address);
    print(wallet.signers);

    print(await asmToHex(
        "OP_PUSHNUM_1 OP_PUSHBYTES_32 6a076655bb72b88230dd27e90993f57b89231e05ea3cde160167036b6be1d3a5"));
    // final b = await wallet.getBalance();
    final ord = OrdService();
    final list = await ord.getUtxo(
        "bc1prhylusp2j4ks7ut2pu0scxtxz76p2wn849jjzay42vvvcyxy4uzqhkng7h");

    list.map((e) => e.toJson()).forEach(print);
    // final s = Utxo.fromJson(jsonDecode(res.toJson()["body"])["data"]);
    // print(s.inscriptions);
  });
}
