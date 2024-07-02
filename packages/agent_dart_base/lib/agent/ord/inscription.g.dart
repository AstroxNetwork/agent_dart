// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InscriptionImpl _$$InscriptionImplFromJson(Map<String, dynamic> json) =>
    _$InscriptionImpl(
      id: json['id'] as String,
      offset: (json['offset'] as num).toInt(),
      number: (json['number'] as num?)?.toInt(),
      num: (json['num'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$InscriptionImplToJson(_$InscriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'offset': instance.offset,
      'number': instance.number,
      'num': instance.num,
    };
