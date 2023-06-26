// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Vin _$$_VinFromJson(Map<String, dynamic> json) => _$_Vin(
      txid: json['txid'] as String,
      vout: json['vout'] as int,
      prevout: Vout.fromJson(json['prevout'] as Map<String, dynamic>),
      scriptsig: json['scriptsig'] as String,
      scriptsig_asm: json['scriptsig_asm'] as String,
      witness:
          (json['witness'] as List<dynamic>).map((e) => e as String).toList(),
      is_coinbase: json['is_coinbase'] as bool,
      sequence: json['sequence'] as int,
    );

Map<String, dynamic> _$$_VinToJson(_$_Vin instance) => <String, dynamic>{
      'txid': instance.txid,
      'vout': instance.vout,
      'prevout': instance.prevout,
      'scriptsig': instance.scriptsig,
      'scriptsig_asm': instance.scriptsig_asm,
      'witness': instance.witness,
      'is_coinbase': instance.is_coinbase,
      'sequence': instance.sequence,
    };
