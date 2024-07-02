// tx status
// {
//   confirmed: true,
//   block_height: 363348,
//   block_hash: "0000000000000000139385d7aa78ffb45469e0c715b8d6ea6cb2ffa98acc7171",
//   block_time: 1435754650
// }

//[
//   {
//     txid: "12f96289f8f9cd51ccfe390879a46d7eeb0435d9e0af9297776e6bdf249414ff",
//     vout: 0,
//     status: {
//       confirmed: true,
//       block_height: 698642,
//       block_hash: "00000000000000000007839f42e0e86fd53c797b64b7135fcad385158c9cafb8",
//       block_time: 1630561459
//     },
//     value: 644951084
//   },
//   ...
// ]
//

import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_utxo.freezed.dart';
part 'address_utxo.g.dart';

@freezed
class AddressUtxo with _$AddressUtxo {
  const factory AddressUtxo({
    required String txid,
    required int vout,
    required int value,
    required TxStatus status,
  }) = _AddressUtxo;

  factory AddressUtxo.fromJson(Map<String, dynamic> json) =>
      _$AddressUtxoFromJson(json);
}

@freezed
class TxStatus with _$TxStatus {
  const factory TxStatus({
    required bool confirmed,
    @JsonKey(name: 'block_height') required int? blockHeight,
    @JsonKey(name: 'block_hash') required String? blockHash,
    @JsonKey(name: 'block_time') required int? blockTime,
  }) = _TxStatus;

  factory TxStatus.fromJson(Map<String, dynamic> json) =>
      _$TxStatusFromJson(json);
}
