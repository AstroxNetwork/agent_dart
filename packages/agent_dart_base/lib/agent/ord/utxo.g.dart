// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utxo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Utxo _$$_UtxoFromJson(Map<String, dynamic> json) => _$_Utxo(
      txId: json['txId'] as String,
      outputIndex: json['outputIndex'] as int,
      satoshis: json['satoshis'] as int,
      scriptPk: json['scriptPk'] as String,
      addressType: json['addressType'] as int,
      inscriptions: (json['inscriptions'] as List<dynamic>)
          .map((e) => Inscription.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_UtxoToJson(_$_Utxo instance) => <String, dynamic>{
      'txId': instance.txId,
      'outputIndex': instance.outputIndex,
      'satoshis': instance.satoshis,
      'scriptPk': instance.scriptPk,
      'addressType': instance.addressType,
      'inscriptions': instance.inscriptions,
    };
