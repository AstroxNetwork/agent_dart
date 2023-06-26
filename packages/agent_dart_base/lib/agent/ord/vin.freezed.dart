// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Vin _$VinFromJson(Map<String, dynamic> json) {
  return _Vin.fromJson(json);
}

/// @nodoc
mixin _$Vin {
  String get txid => throw _privateConstructorUsedError;
  set txid(String value) => throw _privateConstructorUsedError;
  int get vout => throw _privateConstructorUsedError;
  set vout(int value) => throw _privateConstructorUsedError;
  Vout get prevout => throw _privateConstructorUsedError;
  set prevout(Vout value) => throw _privateConstructorUsedError;
  String get scriptsig => throw _privateConstructorUsedError;
  set scriptsig(String value) => throw _privateConstructorUsedError;
  String get scriptsig_asm => throw _privateConstructorUsedError;
  set scriptsig_asm(String value) => throw _privateConstructorUsedError;
  List<String> get witness => throw _privateConstructorUsedError;
  set witness(List<String> value) => throw _privateConstructorUsedError;
  bool get is_coinbase => throw _privateConstructorUsedError;
  set is_coinbase(bool value) => throw _privateConstructorUsedError;
  int get sequence => throw _privateConstructorUsedError;
  set sequence(int value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VinCopyWith<Vin> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VinCopyWith<$Res> {
  factory $VinCopyWith(Vin value, $Res Function(Vin) then) =
      _$VinCopyWithImpl<$Res, Vin>;
  @useResult
  $Res call(
      {String txid,
      int vout,
      Vout prevout,
      String scriptsig,
      String scriptsig_asm,
      List<String> witness,
      bool is_coinbase,
      int sequence});

  $VoutCopyWith<$Res> get prevout;
}

/// @nodoc
class _$VinCopyWithImpl<$Res, $Val extends Vin> implements $VinCopyWith<$Res> {
  _$VinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? vout = null,
    Object? prevout = null,
    Object? scriptsig = null,
    Object? scriptsig_asm = null,
    Object? witness = null,
    Object? is_coinbase = null,
    Object? sequence = null,
  }) {
    return _then(_value.copyWith(
      txid: null == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String,
      vout: null == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int,
      prevout: null == prevout
          ? _value.prevout
          : prevout // ignore: cast_nullable_to_non_nullable
              as Vout,
      scriptsig: null == scriptsig
          ? _value.scriptsig
          : scriptsig // ignore: cast_nullable_to_non_nullable
              as String,
      scriptsig_asm: null == scriptsig_asm
          ? _value.scriptsig_asm
          : scriptsig_asm // ignore: cast_nullable_to_non_nullable
              as String,
      witness: null == witness
          ? _value.witness
          : witness // ignore: cast_nullable_to_non_nullable
              as List<String>,
      is_coinbase: null == is_coinbase
          ? _value.is_coinbase
          : is_coinbase // ignore: cast_nullable_to_non_nullable
              as bool,
      sequence: null == sequence
          ? _value.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VoutCopyWith<$Res> get prevout {
    return $VoutCopyWith<$Res>(_value.prevout, (value) {
      return _then(_value.copyWith(prevout: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_VinCopyWith<$Res> implements $VinCopyWith<$Res> {
  factory _$$_VinCopyWith(_$_Vin value, $Res Function(_$_Vin) then) =
      __$$_VinCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String txid,
      int vout,
      Vout prevout,
      String scriptsig,
      String scriptsig_asm,
      List<String> witness,
      bool is_coinbase,
      int sequence});

  @override
  $VoutCopyWith<$Res> get prevout;
}

/// @nodoc
class __$$_VinCopyWithImpl<$Res> extends _$VinCopyWithImpl<$Res, _$_Vin>
    implements _$$_VinCopyWith<$Res> {
  __$$_VinCopyWithImpl(_$_Vin _value, $Res Function(_$_Vin) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? vout = null,
    Object? prevout = null,
    Object? scriptsig = null,
    Object? scriptsig_asm = null,
    Object? witness = null,
    Object? is_coinbase = null,
    Object? sequence = null,
  }) {
    return _then(_$_Vin(
      txid: null == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String,
      vout: null == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int,
      prevout: null == prevout
          ? _value.prevout
          : prevout // ignore: cast_nullable_to_non_nullable
              as Vout,
      scriptsig: null == scriptsig
          ? _value.scriptsig
          : scriptsig // ignore: cast_nullable_to_non_nullable
              as String,
      scriptsig_asm: null == scriptsig_asm
          ? _value.scriptsig_asm
          : scriptsig_asm // ignore: cast_nullable_to_non_nullable
              as String,
      witness: null == witness
          ? _value.witness
          : witness // ignore: cast_nullable_to_non_nullable
              as List<String>,
      is_coinbase: null == is_coinbase
          ? _value.is_coinbase
          : is_coinbase // ignore: cast_nullable_to_non_nullable
              as bool,
      sequence: null == sequence
          ? _value.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Vin implements _Vin {
  _$_Vin(
      {required this.txid,
      required this.vout,
      required this.prevout,
      required this.scriptsig,
      required this.scriptsig_asm,
      required this.witness,
      required this.is_coinbase,
      required this.sequence});

  factory _$_Vin.fromJson(Map<String, dynamic> json) => _$$_VinFromJson(json);

  @override
  String txid;
  @override
  int vout;
  @override
  Vout prevout;
  @override
  String scriptsig;
  @override
  String scriptsig_asm;
  @override
  List<String> witness;
  @override
  bool is_coinbase;
  @override
  int sequence;

  @override
  String toString() {
    return 'Vin(txid: $txid, vout: $vout, prevout: $prevout, scriptsig: $scriptsig, scriptsig_asm: $scriptsig_asm, witness: $witness, is_coinbase: $is_coinbase, sequence: $sequence)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VinCopyWith<_$_Vin> get copyWith =>
      __$$_VinCopyWithImpl<_$_Vin>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_VinToJson(
      this,
    );
  }
}

abstract class _Vin implements Vin {
  factory _Vin(
      {required String txid,
      required int vout,
      required Vout prevout,
      required String scriptsig,
      required String scriptsig_asm,
      required List<String> witness,
      required bool is_coinbase,
      required int sequence}) = _$_Vin;

  factory _Vin.fromJson(Map<String, dynamic> json) = _$_Vin.fromJson;

  @override
  String get txid;
  set txid(String value);
  @override
  int get vout;
  set vout(int value);
  @override
  Vout get prevout;
  set prevout(Vout value);
  @override
  String get scriptsig;
  set scriptsig(String value);
  @override
  String get scriptsig_asm;
  set scriptsig_asm(String value);
  @override
  List<String> get witness;
  set witness(List<String> value);
  @override
  bool get is_coinbase;
  set is_coinbase(bool value);
  @override
  int get sequence;
  set sequence(int value);
  @override
  @JsonKey(ignore: true)
  _$$_VinCopyWith<_$_Vin> get copyWith => throw _privateConstructorUsedError;
}
