// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TxImpl _$$TxImplFromJson(Map<String, dynamic> json) => _$TxImpl(
      txid: json['txid'] as String,
      version: (json['version'] as num).toInt(),
      locktime: (json['locktime'] as num).toInt(),
      vin: (json['vin'] as List<dynamic>)
          .map((e) => Vin.fromJson(e as Map<String, dynamic>))
          .toList(),
      vout: (json['vout'] as List<dynamic>)
          .map((e) => Vout.fromJson(e as Map<String, dynamic>))
          .toList(),
      size: (json['size'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
      fee: (json['fee'] as num).toInt(),
      status: TxStatus.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TxImplToJson(_$TxImpl instance) => <String, dynamic>{
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

_$VinImpl _$$VinImplFromJson(Map<String, dynamic> json) => _$VinImpl(
      txid: json['txid'] as String,
      vout: (json['vout'] as num).toInt(),
      prevout: Vout.fromJson(json['prevout'] as Map<String, dynamic>),
      scriptSig: json['scriptsig'] as String,
      scriptsigAsm: json['scriptsig_asm'] as String,
      witness:
          (json['witness'] as List<dynamic>).map((e) => e as String).toList(),
      isCoinbase: json['is_coinbase'] as bool,
      sequence: (json['sequence'] as num).toInt(),
    );

Map<String, dynamic> _$$VinImplToJson(_$VinImpl instance) => <String, dynamic>{
      'txid': instance.txid,
      'vout': instance.vout,
      'prevout': instance.prevout,
      'scriptsig': instance.scriptSig,
      'scriptsig_asm': instance.scriptsigAsm,
      'witness': instance.witness,
      'is_coinbase': instance.isCoinbase,
      'sequence': instance.sequence,
    };

_$VoutImpl _$$VoutImplFromJson(Map<String, dynamic> json) => _$VoutImpl(
      scriptPubkey: json['scriptpubkey'] as String,
      scriptpubkeyAsm: json['scriptpubkey_asm'] as String,
      scriptpubkeyType: json['scriptpubkey_type'] as String,
      scriptpubkeyAddress: json['scriptpubkey_address'] as String,
      value: (json['value'] as num).toInt(),
    );

Map<String, dynamic> _$$VoutImplToJson(_$VoutImpl instance) =>
    <String, dynamic>{
      'scriptpubkey': instance.scriptPubkey,
      'scriptpubkey_asm': instance.scriptpubkeyAsm,
      'scriptpubkey_type': instance.scriptpubkeyType,
      'scriptpubkey_address': instance.scriptpubkeyAddress,
      'value': instance.value,
    };
