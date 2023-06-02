// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inscriptionItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InscriptionItem _$$_InscriptionItemFromJson(Map<String, dynamic> json) =>
    _$_InscriptionItem(
      id: json['id'] as String,
      detail:
          InscriptionDetail.fromJson(json['detail'] as Map<String, dynamic>),
      number: json['number'] as int?,
      num: json['num'] as int?,
    );

Map<String, dynamic> _$$_InscriptionItemToJson(_$_InscriptionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'detail': instance.detail,
      'number': instance.number,
      'num': instance.num,
    };
