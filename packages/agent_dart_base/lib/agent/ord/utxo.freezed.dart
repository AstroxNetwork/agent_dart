// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'utxo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Utxo _$UtxoFromJson(Map<String, dynamic> json) {
  return _Utxo.fromJson(json);
}

/// @nodoc
mixin _$Utxo {
  String get txId => throw _privateConstructorUsedError;
  set txId(String value) => throw _privateConstructorUsedError;
  int get outputIndex => throw _privateConstructorUsedError;
  set outputIndex(int value) => throw _privateConstructorUsedError;
  int get satoshis => throw _privateConstructorUsedError;
  set satoshis(int value) => throw _privateConstructorUsedError;
  String get scriptPk => throw _privateConstructorUsedError;
  set scriptPk(String value) => throw _privateConstructorUsedError;
  int get addressType => throw _privateConstructorUsedError;
  set addressType(int value) => throw _privateConstructorUsedError;
  List<Inscription> get inscriptions => throw _privateConstructorUsedError;
  set inscriptions(List<Inscription> value) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UtxoCopyWith<Utxo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UtxoCopyWith<$Res> {
  factory $UtxoCopyWith(Utxo value, $Res Function(Utxo) then) =
      _$UtxoCopyWithImpl<$Res, Utxo>;
  @useResult
  $Res call(
      {String txId,
      int outputIndex,
      int satoshis,
      String scriptPk,
      int addressType,
      List<Inscription> inscriptions});
}

/// @nodoc
class _$UtxoCopyWithImpl<$Res, $Val extends Utxo>
    implements $UtxoCopyWith<$Res> {
  _$UtxoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txId = null,
    Object? outputIndex = null,
    Object? satoshis = null,
    Object? scriptPk = null,
    Object? addressType = null,
    Object? inscriptions = null,
  }) {
    return _then(_value.copyWith(
      txId: null == txId
          ? _value.txId
          : txId // ignore: cast_nullable_to_non_nullable
              as String,
      outputIndex: null == outputIndex
          ? _value.outputIndex
          : outputIndex // ignore: cast_nullable_to_non_nullable
              as int,
      satoshis: null == satoshis
          ? _value.satoshis
          : satoshis // ignore: cast_nullable_to_non_nullable
              as int,
      scriptPk: null == scriptPk
          ? _value.scriptPk
          : scriptPk // ignore: cast_nullable_to_non_nullable
              as String,
      addressType: null == addressType
          ? _value.addressType
          : addressType // ignore: cast_nullable_to_non_nullable
              as int,
      inscriptions: null == inscriptions
          ? _value.inscriptions
          : inscriptions // ignore: cast_nullable_to_non_nullable
              as List<Inscription>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UtxoCopyWith<$Res> implements $UtxoCopyWith<$Res> {
  factory _$$_UtxoCopyWith(_$_Utxo value, $Res Function(_$_Utxo) then) =
      __$$_UtxoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String txId,
      int outputIndex,
      int satoshis,
      String scriptPk,
      int addressType,
      List<Inscription> inscriptions});
}

/// @nodoc
class __$$_UtxoCopyWithImpl<$Res> extends _$UtxoCopyWithImpl<$Res, _$_Utxo>
    implements _$$_UtxoCopyWith<$Res> {
  __$$_UtxoCopyWithImpl(_$_Utxo _value, $Res Function(_$_Utxo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txId = null,
    Object? outputIndex = null,
    Object? satoshis = null,
    Object? scriptPk = null,
    Object? addressType = null,
    Object? inscriptions = null,
  }) {
    return _then(_$_Utxo(
      txId: null == txId
          ? _value.txId
          : txId // ignore: cast_nullable_to_non_nullable
              as String,
      outputIndex: null == outputIndex
          ? _value.outputIndex
          : outputIndex // ignore: cast_nullable_to_non_nullable
              as int,
      satoshis: null == satoshis
          ? _value.satoshis
          : satoshis // ignore: cast_nullable_to_non_nullable
              as int,
      scriptPk: null == scriptPk
          ? _value.scriptPk
          : scriptPk // ignore: cast_nullable_to_non_nullable
              as String,
      addressType: null == addressType
          ? _value.addressType
          : addressType // ignore: cast_nullable_to_non_nullable
              as int,
      inscriptions: null == inscriptions
          ? _value.inscriptions
          : inscriptions // ignore: cast_nullable_to_non_nullable
              as List<Inscription>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Utxo implements _Utxo {
  _$_Utxo(
      {required this.txId,
      required this.outputIndex,
      required this.satoshis,
      required this.scriptPk,
      required this.addressType,
      required this.inscriptions});

  factory _$_Utxo.fromJson(Map<String, dynamic> json) => _$$_UtxoFromJson(json);

  @override
  String txId;
  @override
  int outputIndex;
  @override
  int satoshis;
  @override
  String scriptPk;
  @override
  int addressType;
  @override
  List<Inscription> inscriptions;

  @override
  String toString() {
    return 'Utxo(txId: $txId, outputIndex: $outputIndex, satoshis: $satoshis, scriptPk: $scriptPk, addressType: $addressType, inscriptions: $inscriptions)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UtxoCopyWith<_$_Utxo> get copyWith =>
      __$$_UtxoCopyWithImpl<_$_Utxo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UtxoToJson(
      this,
    );
  }
}

abstract class _Utxo implements Utxo {
  factory _Utxo(
      {required String txId,
      required int outputIndex,
      required int satoshis,
      required String scriptPk,
      required int addressType,
      required List<Inscription> inscriptions}) = _$_Utxo;

  factory _Utxo.fromJson(Map<String, dynamic> json) = _$_Utxo.fromJson;

  @override
  String get txId;
  set txId(String value);
  @override
  int get outputIndex;
  set outputIndex(int value);
  @override
  int get satoshis;
  set satoshis(int value);
  @override
  String get scriptPk;
  set scriptPk(String value);
  @override
  int get addressType;
  set addressType(int value);
  @override
  List<Inscription> get inscriptions;
  set inscriptions(List<Inscription> value);
  @override
  @JsonKey(ignore: true)
  _$$_UtxoCopyWith<_$_Utxo> get copyWith => throw _privateConstructorUsedError;
}
