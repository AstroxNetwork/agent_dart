//                 "id": "6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00i0",
//                 "address": "bc1pt4varhu4ha80a8c50hr7le9fcvk7rrhxevq6f4u7w607c5p5x3ssw9fyuf",
//                 "output_value": 546,
//                 "preview": "https://unisat.io/api/v1/inscription/preview/text/6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00i0",
//                 "content": "https://static.unisat.io/inscription/content/6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00i0",
//                 "content_length": 414,
//                 "content_type": "text/plain;charset=utf-8",
//                 "timestamp": "1970-01-01 00:00:00 UTC",
//                 "genesis_transaction": "6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00",
//                 "location": "6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00:0:0",
//                 "output": "6d814a4fd8711688755c3ffbb3a08415fd555fec61e431888f2a0a25c94a3b00:0",
//                 "offset": 0,
//                 "content_body": ""

import 'package:freezed_annotation/freezed_annotation.dart';

part 'inscriptionDetail.freezed.dart';
part 'inscriptionDetail.g.dart';

@freezed
class InscriptionDetail with _$InscriptionDetail {
  factory InscriptionDetail({
    required String id,
    required String address,
    required int output_value,
    required String preview,
    required String content,
    required int content_length,
    required String content_type,
    required String timestamp,
    required String genesis_transaction,
    required String location,
    required String output,
    required int offset,
    required String content_body,
  }) = _InscriptionDetail;

  factory InscriptionDetail.fromJson(Map<String, dynamic> json) =>
      _$InscriptionDetailFromJson(json);
}
