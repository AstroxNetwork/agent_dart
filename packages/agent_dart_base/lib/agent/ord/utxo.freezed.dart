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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Utxo _$UtxoFromJson(Map<String, dynamic> json) {
  return _Utxo.fromJson(json);
}

/// @nodoc
mixin _$Utxo {
  String get txId => throw _privateConstructorUsedError;
  int get outputIndex => throw _privateConstructorUsedError;
  int get satoshis => throw _privateConstructorUsedError;
  String get scriptPk => throw _privateConstructorUsedError;
  int get addressType => throw _privateConstructorUsedError;
  List<Inscription> get inscriptions => throw _privateConstructorUsedError;

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
abstract class _$$UtxoImplCopyWith<$Res> implements $UtxoCopyWith<$Res> {
  factory _$$UtxoImplCopyWith(
          _$UtxoImpl value, $Res Function(_$UtxoImpl) then) =
      __$$UtxoImplCopyWithImpl<$Res>;
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
class __$$UtxoImplCopyWithImpl<$Res>
    extends _$UtxoCopyWithImpl<$Res, _$UtxoImpl>
    implements _$$UtxoImplCopyWith<$Res> {
  __$$UtxoImplCopyWithImpl(_$UtxoImpl _value, $Res Function(_$UtxoImpl) _then)
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
    return _then(_$UtxoImpl(
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
          ? _value._inscriptions
          : inscriptions // ignore: cast_nullable_to_non_nullable
              as List<Inscription>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UtxoImpl implements _Utxo {
  const _$UtxoImpl(
      {required this.txId,
      required this.outputIndex,
      required this.satoshis,
      required this.scriptPk,
      required this.addressType,
      required final List<Inscription> inscriptions})
      : _inscriptions = inscriptions;

  factory _$UtxoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UtxoImplFromJson(json);

  @override
  final String txId;
  @override
  final int outputIndex;
  @override
  final int satoshis;
  @override
  final String scriptPk;
  @override
  final int addressType;
  final List<Inscription> _inscriptions;
  @override
  List<Inscription> get inscriptions {
    if (_inscriptions is EqualUnmodifiableListView) return _inscriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inscriptions);
  }

  @override
  String toString() {
    return 'Utxo(txId: $txId, outputIndex: $outputIndex, satoshis: $satoshis, scriptPk: $scriptPk, addressType: $addressType, inscriptions: $inscriptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UtxoImpl &&
            (identical(other.txId, txId) || other.txId == txId) &&
            (identical(other.outputIndex, outputIndex) ||
                other.outputIndex == outputIndex) &&
            (identical(other.satoshis, satoshis) ||
                other.satoshis == satoshis) &&
            (identical(other.scriptPk, scriptPk) ||
                other.scriptPk == scriptPk) &&
            (identical(other.addressType, addressType) ||
                other.addressType == addressType) &&
            const DeepCollectionEquality()
                .equals(other._inscriptions, _inscriptions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      txId,
      outputIndex,
      satoshis,
      scriptPk,
      addressType,
      const DeepCollectionEquality().hash(_inscriptions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UtxoImplCopyWith<_$UtxoImpl> get copyWith =>
      __$$UtxoImplCopyWithImpl<_$UtxoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UtxoImplToJson(
      this,
    );
  }
}

abstract class _Utxo implements Utxo {
  const factory _Utxo(
      {required final String txId,
      required final int outputIndex,
      required final int satoshis,
      required final String scriptPk,
      required final int addressType,
      required final List<Inscription> inscriptions}) = _$UtxoImpl;

  factory _Utxo.fromJson(Map<String, dynamic> json) = _$UtxoImpl.fromJson;

  @override
  String get txId;
  @override
  int get outputIndex;
  @override
  int get satoshis;
  @override
  String get scriptPk;
  @override
  int get addressType;
  @override
  List<Inscription> get inscriptions;
  @override
  @JsonKey(ignore: true)
  _$$UtxoImplCopyWith<_$UtxoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
