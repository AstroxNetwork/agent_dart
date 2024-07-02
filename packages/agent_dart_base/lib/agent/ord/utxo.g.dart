// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utxo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UtxoImpl _$$UtxoImplFromJson(Map<String, dynamic> json) => _$UtxoImpl(
      txId: json['txId'] as String,
      outputIndex: (json['outputIndex'] as num).toInt(),
      satoshis: (json['satoshis'] as num).toInt(),
      scriptPk: json['scriptPk'] as String,
      addressType: (json['addressType'] as num).toInt(),
      inscriptions: (json['inscriptions'] as List<dynamic>)
          .map((e) => Inscription.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UtxoImplToJson(_$UtxoImpl instance) =>
    <String, dynamic>{
      'txId': instance.txId,
      'outputIndex': instance.outputIndex,
      'satoshis': instance.satoshis,
      'scriptPk': instance.scriptPk,
      'addressType': instance.addressType,
      'inscriptions': instance.inscriptions,
    };
