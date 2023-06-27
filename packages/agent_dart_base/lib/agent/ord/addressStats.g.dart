// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addressStats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AddressStats _$$_AddressStatsFromJson(Map<String, dynamic> json) =>
    _$_AddressStats(
      address: json['address'] as String,
      chain_stats:
          StatsItem.fromJson(json['chain_stats'] as Map<String, dynamic>),
      mempool_stats:
          StatsItem.fromJson(json['mempool_stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AddressStatsToJson(_$_AddressStats instance) =>
    <String, dynamic>{
      'address': instance.address,
      'chain_stats': instance.chain_stats,
      'mempool_stats': instance.mempool_stats,
    };

_$_StatsItem _$$_StatsItemFromJson(Map<String, dynamic> json) => _$_StatsItem(
      funded_txo_count: json['funded_txo_count'] as int,
      funded_txo_sum: json['funded_txo_sum'] as int,
      spent_txo_count: json['spent_txo_count'] as int,
      spent_txo_sum: json['spent_txo_sum'] as int,
      tx_count: json['tx_count'] as int,
    );

Map<String, dynamic> _$$_StatsItemToJson(_$_StatsItem instance) =>
    <String, dynamic>{
      'funded_txo_count': instance.funded_txo_count,
      'funded_txo_sum': instance.funded_txo_sum,
      'spent_txo_count': instance.spent_txo_count,
      'spent_txo_sum': instance.spent_txo_sum,
      'tx_count': instance.tx_count,
    };
