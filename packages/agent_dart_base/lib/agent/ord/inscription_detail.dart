// "id": "6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00i0",
// "address": "bc1pt4varhu4ha80a8c50hr7le9fcvk7rrhxevq6f4u7w607c5p5x3ssw9fyuf",
// "output_value": 546,
// "preview": "https://unisat.io/api/v1/inscription/preview/text/6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00i0",
// "content": "https://static.unisat.io/inscription/content/6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00i0",
// "content_length": 414,
// "content_type": "text/plain;charset=utf-8",
// "timestamp": "1970-01-01 00:00:00 UTC",
// "genesis_transaction": "6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00",
// "location": "6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00:0:0",
// "output": "6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00:0",
// "offset": 0,
// "content_body": ""

import 'package:freezed_annotation/freezed_annotation.dart';

part 'inscription_detail.freezed.dart';
part 'inscription_detail.g.dart';

@freezed
class InscriptionDetail with _$InscriptionDetail {
  const factory InscriptionDetail({
    required String id,
    required String address,
    @JsonKey(name: 'output_value') required int outputValue,
    required String preview,
    required String content,
    @JsonKey(name: 'content_length') required int contentLength,
    @JsonKey(name: 'content_type') required String contentType,
    required String timestamp,
    @JsonKey(name: 'genesis_transaction') required String genesisTransaction,
    required String location,
    required String output,
    required int offset,
    @JsonKey(name: 'content_body') required String contentBody,
  }) = _InscriptionDetail;

  factory InscriptionDetail.fromJson(Map<String, dynamic> json) =>
      _$InscriptionDetailFromJson(json);
}
