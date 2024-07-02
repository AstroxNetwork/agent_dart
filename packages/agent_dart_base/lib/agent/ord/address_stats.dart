// {
//   address: "1wiz18xYmhRX6xStj2b9t1rwWX4GKUgpv",
//   chain_stats: {
//     funded_txo_count: 5,
//     funded_txo_sum: 15007599040,
//     spent_txo_count: 5,
//     spent_txo_sum: 15007599040,
//     tx_count: 7
//   },
//   mempool_stats: {
//     funded_txo_count: 0,
//     funded_txo_sum: 0,
//     spent_txo_count: 0,
//     spent_txo_sum: 0,
//     tx_count: 0
//   }
// }

import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_stats.freezed.dart';
part 'address_stats.g.dart';

@unfreezed
class AddressStats with _$AddressStats {
  factory AddressStats({
    required String address,
    @JsonKey(name: 'chain_stats') required StatsItem chainStats,
    @JsonKey(name: 'mempool_stats') required StatsItem mempoolStats,
  }) = _AddressStats;

  factory AddressStats.fromJson(Map<String, dynamic> json) =>
      _$AddressStatsFromJson(json);
}

@freezed
class StatsItem with _$StatsItem {
  factory StatsItem({
    @JsonKey(name: 'funded_utxo_count') required int fundedUtxoCount,
    @JsonKey(name: 'funded_utxo_sum') required int fundedUtxoSum,
    @JsonKey(name: 'spent_utxo_count') required int spentUtxoCount,
    @JsonKey(name: 'spent_utxo_sum') required int spentUtxoSum,
    @JsonKey(name: 'tx_count') required int txCount,
  }) = _StatsItem;

  factory StatsItem.fromJson(Map<String, dynamic> json) =>
      _$StatsItemFromJson(json);
}
