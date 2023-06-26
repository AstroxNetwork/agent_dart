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

import 'vin.dart';
import 'vout.dart';

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
  }) = _Tx;

  factory Tx.fromJson(Map<String, dynamic> json) => _$TxFromJson(json);
}
