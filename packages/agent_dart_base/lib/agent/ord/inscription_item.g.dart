// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inscription_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InscriptionItemImpl _$$InscriptionItemImplFromJson(
        Map<String, dynamic> json) =>
    _$InscriptionItemImpl(
      id: json['id'] as String,
      detail:
          InscriptionDetail.fromJson(json['detail'] as Map<String, dynamic>),
      number: (json['number'] as num?)?.toInt(),
      num: (json['num'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$InscriptionItemImplToJson(
        _$InscriptionItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'detail': instance.detail,
      'number': instance.number,
      'num': instance.num,
    };
