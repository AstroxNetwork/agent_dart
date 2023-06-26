// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tx.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Tx _$TxFromJson(Map<String, dynamic> json) {
  return _Tx.fromJson(json);
}

/// @nodoc
mixin _$Tx {
  String get txid => throw _privateConstructorUsedError;
  set txid(String value) => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  set version(int value) => throw _privateConstructorUsedError;
  int get locktime => throw _privateConstructorUsedError;
  set locktime(int value) => throw _privateConstructorUsedError;
  List<Vin> get vin => throw _privateConstructorUsedError;
  set vin(List<Vin> value) => throw _privateConstructorUsedError;
  List<Vout> get vout => throw _privateConstructorUsedError;
  set vout(List<Vout> value) => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  set size(int value) => throw _privateConstructorUsedError;
  int get weight => throw _privateConstructorUsedError;
  set weight(int value) => throw _privateConstructorUsedError;
  int get fee => throw _privateConstructorUsedError;
  set fee(int value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TxCopyWith<Tx> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TxCopyWith<$Res> {
  factory $TxCopyWith(Tx value, $Res Function(Tx) then) =
      _$TxCopyWithImpl<$Res, Tx>;
  @useResult
  $Res call(
      {String txid,
      int version,
      int locktime,
      List<Vin> vin,
      List<Vout> vout,
      int size,
      int weight,
      int fee});
}

/// @nodoc
class _$TxCopyWithImpl<$Res, $Val extends Tx> implements $TxCopyWith<$Res> {
  _$TxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? version = null,
    Object? locktime = null,
    Object? vin = null,
    Object? vout = null,
    Object? size = null,
    Object? weight = null,
    Object? fee = null,
  }) {
    return _then(_value.copyWith(
      txid: null == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      locktime: null == locktime
          ? _value.locktime
          : locktime // ignore: cast_nullable_to_non_nullable
              as int,
      vin: null == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as List<Vin>,
      vout: null == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as List<Vout>,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int,
      fee: null == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TxCopyWith<$Res> implements $TxCopyWith<$Res> {
  factory _$$_TxCopyWith(_$_Tx value, $Res Function(_$_Tx) then) =
      __$$_TxCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String txid,
      int version,
      int locktime,
      List<Vin> vin,
      List<Vout> vout,
      int size,
      int weight,
      int fee});
}

/// @nodoc
class __$$_TxCopyWithImpl<$Res> extends _$TxCopyWithImpl<$Res, _$_Tx>
    implements _$$_TxCopyWith<$Res> {
  __$$_TxCopyWithImpl(_$_Tx _value, $Res Function(_$_Tx) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? version = null,
    Object? locktime = null,
    Object? vin = null,
    Object? vout = null,
    Object? size = null,
    Object? weight = null,
    Object? fee = null,
  }) {
    return _then(_$_Tx(
      txid: null == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      locktime: null == locktime
          ? _value.locktime
          : locktime // ignore: cast_nullable_to_non_nullable
              as int,
      vin: null == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as List<Vin>,
      vout: null == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as List<Vout>,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int,
      fee: null == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Tx implements _Tx {
  _$_Tx(
      {required this.txid,
      required this.version,
      required this.locktime,
      required this.vin,
      required this.vout,
      required this.size,
      required this.weight,
      required this.fee});

  factory _$_Tx.fromJson(Map<String, dynamic> json) => _$$_TxFromJson(json);

  @override
  String txid;
  @override
  int version;
  @override
  int locktime;
  @override
  List<Vin> vin;
  @override
  List<Vout> vout;
  @override
  int size;
  @override
  int weight;
  @override
  int fee;

  @override
  String toString() {
    return 'Tx(txid: $txid, version: $version, locktime: $locktime, vin: $vin, vout: $vout, size: $size, weight: $weight, fee: $fee)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TxCopyWith<_$_Tx> get copyWith =>
      __$$_TxCopyWithImpl<_$_Tx>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TxToJson(
      this,
    );
  }
}

abstract class _Tx implements Tx {
  factory _Tx(
      {required String txid,
      required int version,
      required int locktime,
      required List<Vin> vin,
      required List<Vout> vout,
      required int size,
      required int weight,
      required int fee}) = _$_Tx;

  factory _Tx.fromJson(Map<String, dynamic> json) = _$_Tx.fromJson;

  @override
  String get txid;
  set txid(String value);
  @override
  int get version;
  set version(int value);
  @override
  int get locktime;
  set locktime(int value);
  @override
  List<Vin> get vin;
  set vin(List<Vin> value);
  @override
  List<Vout> get vout;
  set vout(List<Vout> value);
  @override
  int get size;
  set size(int value);
  @override
  int get weight;
  set weight(int value);
  @override
  int get fee;
  set fee(int value);
  @override
  @JsonKey(ignore: true)
  _$$_TxCopyWith<_$_Tx> get copyWith => throw _privateConstructorUsedError;
}
