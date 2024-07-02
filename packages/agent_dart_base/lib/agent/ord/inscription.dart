import 'package:freezed_annotation/freezed_annotation.dart';

part 'inscription.freezed.dart';
part 'inscription.g.dart';

@freezed
class Inscription with _$Inscription {
  const factory Inscription({
    required String id,
    required int offset,
    required int? number,
    required int? num,
  }) = _Inscription;

  factory Inscription.fromJson(Map<String, dynamic> json) =>
      _$InscriptionFromJson(json);
}
