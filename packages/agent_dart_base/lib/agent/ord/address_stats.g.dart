// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressStatsImpl _$$AddressStatsImplFromJson(Map<String, dynamic> json) =>
    _$AddressStatsImpl(
      address: json['address'] as String,
      chainStats:
          StatsItem.fromJson(json['chain_stats'] as Map<String, dynamic>),
      mempoolStats:
          StatsItem.fromJson(json['mempool_stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AddressStatsImplToJson(_$AddressStatsImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'chain_stats': instance.chainStats,
      'mempool_stats': instance.mempoolStats,
    };

_$StatsItemImpl _$$StatsItemImplFromJson(Map<String, dynamic> json) =>
    _$StatsItemImpl(
      fundedUtxoCount: (json['funded_utxo_count'] as num).toInt(),
      fundedUtxoSum: (json['funded_utxo_sum'] as num).toInt(),
      spentUtxoCount: (json['spent_utxo_count'] as num).toInt(),
      spentUtxoSum: (json['spent_utxo_sum'] as num).toInt(),
      txCount: (json['tx_count'] as num).toInt(),
    );

Map<String, dynamic> _$$StatsItemImplToJson(_$StatsItemImpl instance) =>
    <String, dynamic>{
      'funded_utxo_count': instance.fundedUtxoCount,
      'funded_utxo_sum': instance.fundedUtxoSum,
      'spent_utxo_count': instance.spentUtxoCount,
      'spent_utxo_sum': instance.spentUtxoSum,
      'tx_count': instance.txCount,
    };
