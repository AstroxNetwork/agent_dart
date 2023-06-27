import 'dart:convert';

import 'package:agent_dart_base/agent/agent.dart';
import 'package:agent_dart_base/agent/ord/addressStats.dart';
import 'package:agent_dart_base/agent/ord/addressUtxo.dart';
import 'package:agent_dart_base/agent/ord/service.dart';
import 'package:agent_dart_base/agent/ord/tx.dart';

import 'client.dart';

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

  DataResponse _decodeReponse(SubmitResponse response) {
    final body = response.toJson()['body'];
    final data = jsonDecode(body)['data'];
    return DataResponse(
      data,
      data is List,
    );
  }

  DataResponse _decodeGetReponse(SubmitResponse response) {
    final body = response.toJson()['body'];
    final data = jsonDecode(body);

    return DataResponse(
      data,
      data is List,
    );
  }

  Future<Tx> getTx(String txId) async {
    final response = await _client.httpGet(
      '/tx/${txId}',
      {},
      _override,
    );
    return Tx.fromJson(_decodeGetReponse(response).data);
  }

  Future<AddressStats> getAddressStats(String address) async {
    final response = await _client.httpGet(
      '/address/${address}',
      {},
      _override,
    );
    return AddressStats.fromJson(_decodeGetReponse(response).data);
  }

  Future<List<AddressUtxo>> getAddressUtxo(String address) async {
    final response = await _client.httpGet(
      '/address/${address}/utxo',
      {},
      _override,
    );
    return (_decodeGetReponse(response).data as List<dynamic>)
        .map((e) => AddressUtxo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Tx>> getAddressTxs({
    required String address,
    TxsFilter filter = TxsFilter.All,
    String? lastSeenTxId,
  }) async {
    final prefix = '/address/${address}/txs';
    var thePrefix;
    var id = '';
    if (lastSeenTxId != null) {
      id = '/${lastSeenTxId}';
    }
    switch (filter) {
      case TxsFilter.All:
        thePrefix = prefix;
        break;
      case TxsFilter.Confirmed:
        thePrefix = prefix + '/chain';
        break;
      case TxsFilter.Unconfirmed:
        thePrefix = prefix + '/mempool';
        break;
    }

    final response = await _client.httpGet(
      thePrefix + id,
      {},
      _override,
    );
    return (_decodeGetReponse(response).data as List<dynamic>)
        .map((e) => Tx.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> getTxHex(String txId) async {
    final response = await _client.httpGet(
      '/tx/${txId}/hex',
      {},
      _override,
    );

    return response.toJson()['body'];
  }
}
