import 'package:freezed_annotation/freezed_annotation.dart';

part 'vout.freezed.dart';
part 'vout.g.dart';

@freezed
class Vout with _$Vout {
  factory Vout({
    required String scriptpubkey,
    required String scriptpubkey_asm,
    required String scriptpubkey_type,
    required String scriptpubkey_address,
    required int value,
  }) = _Vout;

  factory Vout.fromJson(Map<String, dynamic> json) => _$VoutFromJson(json);
}
