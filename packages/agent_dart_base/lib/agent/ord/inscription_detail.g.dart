// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inscription_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InscriptionDetailImpl _$$InscriptionDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$InscriptionDetailImpl(
      id: json['id'] as String,
      address: json['address'] as String,
      outputValue: (json['output_value'] as num).toInt(),
      preview: json['preview'] as String,
      content: json['content'] as String,
      contentLength: (json['content_length'] as num).toInt(),
      contentType: json['content_type'] as String,
      timestamp: json['timestamp'] as String,
      genesisTransaction: json['genesis_transaction'] as String,
      location: json['location'] as String,
      output: json['output'] as String,
      offset: (json['offset'] as num).toInt(),
      contentBody: json['content_body'] as String,
    );

Map<String, dynamic> _$$InscriptionDetailImplToJson(
        _$InscriptionDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'output_value': instance.outputValue,
      'preview': instance.preview,
      'content': instance.content,
      'content_length': instance.contentLength,
      'content_type': instance.contentType,
      'timestamp': instance.timestamp,
      'genesis_transaction': instance.genesisTransaction,
      'location': instance.location,
      'output': instance.output,
      'offset': instance.offset,
      'content_body': instance.contentBody,
    };
