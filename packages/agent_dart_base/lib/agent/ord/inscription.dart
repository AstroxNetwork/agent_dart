import 'package:freezed_annotation/freezed_annotation.dart';

part 'inscription.freezed.dart';
part 'inscription.g.dart';

@freezed
class Inscription with _$Inscription {
  factory Inscription({
    required String id,
    required int offset,
    int? number,
    int? num,
  }) = _Inscription;

  factory Inscription.fromJson(Map<String, dynamic> json) =>
      _$InscriptionFromJson(json);
}
