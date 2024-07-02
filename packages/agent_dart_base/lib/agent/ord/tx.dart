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

import 'address_utxo.dart';

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
  const factory Vin({
    @JsonKey(name: 'txid') required String txid,
    @JsonKey(name: 'vout') required int vout,
    @JsonKey(name: 'prevout') required Vout prevout,
    @JsonKey(name: 'scriptsig') required String scriptSig,
    @JsonKey(name: 'scriptsig_asm') required String scriptsigAsm,
    @JsonKey(name: 'witness') required List<String> witness,
    @JsonKey(name: 'is_coinbase') required bool isCoinbase,
    @JsonKey(name: 'sequence') required int sequence,
  }) = _Vin;

  factory Vin.fromJson(Map<String, dynamic> json) => _$VinFromJson(json);
}

@freezed
class Vout with _$Vout {
  factory Vout({
    @JsonKey(name: 'scriptpubkey') required String scriptPubkey,
    @JsonKey(name: 'scriptpubkey_asm') required String scriptpubkeyAsm,
    @JsonKey(name: 'scriptpubkey_type') required String scriptpubkeyType,
    @JsonKey(name: 'scriptpubkey_address') required String scriptpubkeyAddress,
    @JsonKey(name: 'value') required int value,
  }) = _Vout;

  factory Vout.fromJson(Map<String, dynamic> json) => _$VoutFromJson(json);
}
