// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inscriptionDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InscriptionDetail _$$_InscriptionDetailFromJson(Map<String, dynamic> json) =>
    _$_InscriptionDetail(
      id: json['id'] as String,
      address: json['address'] as String,
      output_value: json['output_value'] as int,
      preview: json['preview'] as String,
      content: json['content'] as String,
      content_length: json['content_length'] as int,
      content_type: json['content_type'] as String,
      timestamp: json['timestamp'] as String,
      genesis_transaction: json['genesis_transaction'] as String,
      location: json['location'] as String,
      output: json['output'] as String,
      offset: json['offset'] as int,
      content_body: json['content_body'] as String,
    );

Map<String, dynamic> _$$_InscriptionDetailToJson(
        _$_InscriptionDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'output_value': instance.output_value,
      'preview': instance.preview,
      'content': instance.content,
      'content_length': instance.content_length,
      'content_type': instance.content_type,
      'timestamp': instance.timestamp,
      'genesis_transaction': instance.genesis_transaction,
      'location': instance.location,
      'output': instance.output,
      'offset': instance.offset,
      'content_body': instance.content_body,
    };
