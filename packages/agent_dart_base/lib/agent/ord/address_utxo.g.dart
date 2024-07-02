// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_utxo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressUtxoImpl _$$AddressUtxoImplFromJson(Map<String, dynamic> json) =>
    _$AddressUtxoImpl(
      txid: json['txid'] as String,
      vout: (json['vout'] as num).toInt(),
      value: (json['value'] as num).toInt(),
      status: TxStatus.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AddressUtxoImplToJson(_$AddressUtxoImpl instance) =>
    <String, dynamic>{
      'txid': instance.txid,
      'vout': instance.vout,
      'value': instance.value,
      'status': instance.status,
    };

_$TxStatusImpl _$$TxStatusImplFromJson(Map<String, dynamic> json) =>
    _$TxStatusImpl(
      confirmed: json['confirmed'] as bool,
      blockHeight: (json['block_height'] as num?)?.toInt(),
      blockHash: json['block_hash'] as String?,
      blockTime: (json['block_time'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TxStatusImplToJson(_$TxStatusImpl instance) =>
    <String, dynamic>{
      'confirmed': instance.confirmed,
      'block_height': instance.blockHeight,
      'block_hash': instance.blockHash,
      'block_time': instance.blockTime,
    };
