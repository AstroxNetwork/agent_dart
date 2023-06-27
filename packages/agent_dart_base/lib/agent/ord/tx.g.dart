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
      status: TxStatus.fromJson(json['status'] as Map<String, dynamic>),
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
      'status': instance.status,
    };

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

_$_Vout _$$_VoutFromJson(Map<String, dynamic> json) => _$_Vout(
      scriptpubkey: json['scriptpubkey'] as String,
      scriptpubkey_asm: json['scriptpubkey_asm'] as String,
      scriptpubkey_type: json['scriptpubkey_type'] as String,
      scriptpubkey_address: json['scriptpubkey_address'] as String,
      value: json['value'] as int,
    );

Map<String, dynamic> _$$_VoutToJson(_$_Vout instance) => <String, dynamic>{
      'scriptpubkey': instance.scriptpubkey,
      'scriptpubkey_asm': instance.scriptpubkey_asm,
      'scriptpubkey_type': instance.scriptpubkey_type,
      'scriptpubkey_address': instance.scriptpubkey_address,
      'value': instance.value,
    };
