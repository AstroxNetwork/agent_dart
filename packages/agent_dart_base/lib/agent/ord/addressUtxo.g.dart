// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addressUtxo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AddressUtxo _$$_AddressUtxoFromJson(Map<String, dynamic> json) =>
    _$_AddressUtxo(
      txid: json['txid'] as String,
      vout: json['vout'] as int,
      value: json['value'] as int,
      status: TxStatus.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AddressUtxoToJson(_$_AddressUtxo instance) =>
    <String, dynamic>{
      'txid': instance.txid,
      'vout': instance.vout,
      'value': instance.value,
      'status': instance.status,
    };

_$_TxStatus _$$_TxStatusFromJson(Map<String, dynamic> json) => _$_TxStatus(
      confirmed: json['confirmed'] as bool,
      block_height: json['block_height'] as int?,
      block_hash: json['block_hash'] as String?,
      block_time: json['block_time'] as int?,
    );

Map<String, dynamic> _$$_TxStatusToJson(_$_TxStatus instance) =>
    <String, dynamic>{
      'confirmed': instance.confirmed,
      'block_height': instance.block_height,
      'block_hash': instance.block_hash,
      'block_time': instance.block_time,
    };
