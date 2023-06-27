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

part 'addressStats.freezed.dart';
part 'addressStats.g.dart';

@unfreezed
class AddressStats with _$AddressStats {
  factory AddressStats({
    required String address,
    required StatsItem chain_stats,
    required StatsItem mempool_stats,
  }) = _AddressStats;

  factory AddressStats.fromJson(Map<String, dynamic> json) =>
      _$AddressStatsFromJson(json);
}

@freezed
class StatsItem with _$StatsItem {
  factory StatsItem({
    required int funded_txo_count,
    required int funded_txo_sum,
    required int spent_txo_count,
    required int spent_txo_sum,
    required int tx_count,
  }) = _StatsItem;

  factory StatsItem.fromJson(Map<String, dynamic> json) =>
      _$StatsItemFromJson(json);
}
