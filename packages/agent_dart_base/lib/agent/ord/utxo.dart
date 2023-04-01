import 'package:freezed_annotation/freezed_annotation.dart';

import 'inscription.dart';

part 'utxo.freezed.dart';
part 'utxo.g.dart';

@unfreezed
class Utxo with _$Utxo {
  factory Utxo(
      {required String txId,
      required int outputIndex,
      required int satoshis,
      required String scriptPk,
      required int addressType,
      required List<Inscription> inscriptions}) = _Utxo;

  factory Utxo.fromJson(Map<String, dynamic> json) => _$UtxoFromJson(json);
}
