// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Tx _$$_TxFromJson(Map<String, dynamic> json) => _$_Tx(
      txid: json['txid'] as String,
      version: json['version'] as int,
      locktime: json['locktime'] as int,
      vin: (json['vin'] as List<dynamic>)
          .map((e) => Vin.fromJson(e as Map<String, dynamic>))
          .toList(),
      vout: (json['vout'] as List<dynamic>)
          .map((e) => Vout.fromJson(e as Map<String, dynamic>))
          .toList(),
      size: json['size'] as int,
      weight: json['weight'] as int,
      fee: json['fee'] as int,
    );

Map<String, dynamic> _$$_TxToJson(_$_Tx instance) => <String, dynamic>{
      'txid': instance.txid,
      'version': instance.version,
      'locktime': instance.locktime,
      'vin': instance.vin,
      'vout': instance.vout,
      'size': instance.size,
      'weight': instance.weight,
      'fee': instance.fee,
    };
