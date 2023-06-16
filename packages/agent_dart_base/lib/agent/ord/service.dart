import 'dart:convert';

import 'package:agent_dart_base/agent/agent.dart';
import 'package:agent_dart_base/agent/ord/inscriptionItem.dart';
import 'package:agent_dart_base/agent/ord/utxo.dart';

import 'client.dart';

class DataResponse {
  DataResponse(this.data, this.isList);
  final dynamic data;
  final bool isList;
}

class OrdService {
  OrdService({
    String host = 'ordapi.astrox.app',
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
    final data = jsonDecode(body)['result'];
    return DataResponse(
      data,
      data is List,
    );
  }

  // Future<List<Utxo>> getUtxo(String address) async {
  //   final response = await _client.httpPost(
  //       '/v1/api/inscribe/utxo', {'address': address}, _override);
  //   final res = _decodeReponse(response);
  //   if (!res.isList) {
  //     throw 'Can not get utxo';
  //   } else {
  //     final list = (res.data as List);
  //     final utxos = <Utxo>[];
  //     for (final a in list) {
  //       var u = Utxo.fromJson(a)..scriptPk = await asmToHex(a['scriptPk']);
  //       utxos.add(u);
  //     }
  //     return utxos;
  //   }
  // }

  Future<List<Utxo>> getUtxoGet(String address) async {
    final response = await _client.httpGet(
      '/v2/address/utxo?address=$address',
      {},
      _override,
    );

    final res = _decodeGetReponse(response);
    if (!res.isList) {
      throw 'Can not get utxo';
    } else {
      final list = res.data as List;
      final utxos = <Utxo>[];
      for (final a in list) {
        final u = Utxo.fromJson(a);
        utxos.add(u);
      }
      return utxos;
    }
  }

  Future<List<InscriptionItem>> getInscriptions(String address) async {
    final response = await _client.httpGet(
      '/v2/address/inscriptions?address=$address',
      {},
      _override,
    );

    final res = _decodeGetReponse(response);
    if (!res.isList) {
      throw 'Can not get utxo';
    } else {
      final list = res.data as List;
      final ins = <InscriptionItem>[];
      for (final a in list) {
        final u = InscriptionItem.fromJson(a);
        ins.add(u);
      }
      return ins;
    }
  }
}
