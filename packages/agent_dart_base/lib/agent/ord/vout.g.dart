// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
