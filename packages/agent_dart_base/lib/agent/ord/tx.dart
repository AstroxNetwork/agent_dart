// {
//     "txid": "ad4370edce9d1671f7fdc8bf56e409a4d82a6a9044531b1567daccdcd76e14df",
//     "version": 2,
//     "locktime": 0,
//     "vin": [],
//     "vout": [],
//     "size": 592,
//     "weight": 2164,
//     "fee": 7896,
//     "status": {
//         "confirmed": false
//     }
// }

import 'package:freezed_annotation/freezed_annotation.dart';

import 'addressUtxo.dart';

part 'tx.freezed.dart';
part 'tx.g.dart';

@unfreezed
class Tx with _$Tx {
  factory Tx({
    required String txid,
    required int version,
    required int locktime,
    required List<Vin> vin,
    required List<Vout> vout,
    required int size,
    required int weight,
    required int fee,
    required TxStatus status,
  }) = _Tx;

  factory Tx.fromJson(Map<String, dynamic> json) => _$TxFromJson(json);
}

@unfreezed
class Vin with _$Vin {
  factory Vin({
    required String txid,
    required int vout,
    required Vout prevout,
    required String scriptsig,
    required String scriptsig_asm,
    required List<String> witness,
    required bool is_coinbase,
    required int sequence,
  }) = _Vin;

  factory Vin.fromJson(Map<String, dynamic> json) => _$VinFromJson(json);
}

@freezed
class Vout with _$Vout {
  factory Vout({
    required String scriptpubkey,
    required String scriptpubkey_asm,
    required String scriptpubkey_type,
    required String scriptpubkey_address,
    required int value,
  }) = _Vout;

  factory Vout.fromJson(Map<String, dynamic> json) => _$VoutFromJson(json);
}
