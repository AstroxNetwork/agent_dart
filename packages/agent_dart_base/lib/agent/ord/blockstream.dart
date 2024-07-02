import 'dart:convert';

import 'package:agent_dart_base/agent/agent.dart';

import 'address_stats.dart';
import 'address_utxo.dart';
import 'client.dart';
import 'service.dart';
import 'tx.dart';

enum TxsFilter { All, Confirmed, Unconfirmed }

class BlockStreamApi {
  BlockStreamApi({
    String host = 'blockstream.info/api',
    OverrideOptions? override,
  }) {
    _client = OrdClient(options: HttpAgentOptions(host: host));
    _override = override ??
        const OverrideOptions(
          headers: {
            'Content-Type': 'application/json;charset=utf-8',
          },
        );
  }
  late OrdClient _client;
  late OverrideOptions _override;

  void setHost(String host) {
    _client.setHost(host);
  }

  void setOverride(OverrideOptions override) {
    _override = override;
  }

  DataResponse _decodeResponse(SubmitResponse response) {
    final body = response.toJson()['body'];
    final data = jsonDecode(body)['data'];
    return DataResponse(
      data,
      data is List,
    );
  }

  DataResponse _decodeGetResponse(SubmitResponse response) {
    final body = response.toJson()['body'];
    final data = jsonDecode(body);

    return DataResponse(
      data,
      data is List,
    );
  }

  Future<Tx> getTx(String txId) async {
    final response = await _client.httpGet(
      '/tx/$txId',
      {},
      _override,
    );
    return Tx.fromJson(_decodeGetResponse(response).data);
  }

  Future<AddressStats> getAddressStats(String address) async {
    final response = await _client.httpGet(
      '/address/$address',
      {},
      _override,
    );
    return AddressStats.fromJson(_decodeGetResponse(response).data);
  }

  Future<List<AddressUtxo>> getAddressUtxo(String address) async {
    final response = await _client.httpGet(
      '/address/$address/utxo',
      {},
      _override,
    );
    return (_decodeGetResponse(response).data as List<dynamic>)
        .map((e) => AddressUtxo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Tx>> getAddressTxs({
    required String address,
    TxsFilter filter = TxsFilter.All,
    String? lastSeenTxId,
  }) async {
    final prefix = '/address/$address/txs';
    String thePrefix;
    var id = '';
    if (lastSeenTxId != null) {
      id = '/$lastSeenTxId';
    }
    switch (filter) {
      case TxsFilter.All:
        thePrefix = prefix;
        break;
      case TxsFilter.Confirmed:
        thePrefix = '$prefix/chain';
        break;
      case TxsFilter.Unconfirmed:
        thePrefix = '$prefix/mempool';
        break;
    }

    final response = await _client.httpGet(
      thePrefix + id,
      {},
      _override,
    );
    return (_decodeGetResponse(response).data as List<dynamic>)
        .map((e) => Tx.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> getTxHex(String txId) async {
    final response = await _client.httpGet(
      '/tx/$txId/hex',
      {},
      _override,
    );

    return response.toJson()['body'];
  }

  Future<int> getBlockHeight() async {
    final response = await _client.httpGet(
      '/blocks/tip/height',
      {},
      _override,
    );

    return int.parse(response.toJson()['body'].toString(), radix: 10);
  }

  Future<String> broadcastTx(String txHex) async {
    final response = await _client.httpPostString(
      '/tx',
      txHex,
      _override,
    );
    return response.toJson()['body'];
  }
}
