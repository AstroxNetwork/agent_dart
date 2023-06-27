// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'addressUtxo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AddressUtxo _$AddressUtxoFromJson(Map<String, dynamic> json) {
  return _AddressUtxo.fromJson(json);
}

/// @nodoc
mixin _$AddressUtxo {
  String get txid => throw _privateConstructorUsedError;
  int get vout => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError;
  TxStatus get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressUtxoCopyWith<AddressUtxo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressUtxoCopyWith<$Res> {
  factory $AddressUtxoCopyWith(
          AddressUtxo value, $Res Function(AddressUtxo) then) =
      _$AddressUtxoCopyWithImpl<$Res, AddressUtxo>;
  @useResult
  $Res call({String txid, int vout, int value, TxStatus status});

  $TxStatusCopyWith<$Res> get status;
}

/// @nodoc
class _$AddressUtxoCopyWithImpl<$Res, $Val extends AddressUtxo>
    implements $AddressUtxoCopyWith<$Res> {
  _$AddressUtxoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? vout = null,
    Object? value = null,
    Object? status = null,
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
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TxStatus,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TxStatusCopyWith<$Res> get status {
    return $TxStatusCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AddressUtxoCopyWith<$Res>
    implements $AddressUtxoCopyWith<$Res> {
  factory _$$_AddressUtxoCopyWith(
          _$_AddressUtxo value, $Res Function(_$_AddressUtxo) then) =
      __$$_AddressUtxoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String txid, int vout, int value, TxStatus status});

  @override
  $TxStatusCopyWith<$Res> get status;
}

/// @nodoc
class __$$_AddressUtxoCopyWithImpl<$Res>
    extends _$AddressUtxoCopyWithImpl<$Res, _$_AddressUtxo>
    implements _$$_AddressUtxoCopyWith<$Res> {
  __$$_AddressUtxoCopyWithImpl(
      _$_AddressUtxo _value, $Res Function(_$_AddressUtxo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? vout = null,
    Object? value = null,
    Object? status = null,
  }) {
    return _then(_$_AddressUtxo(
      txid: null == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String,
      vout: null == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TxStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AddressUtxo implements _AddressUtxo {
  _$_AddressUtxo(
      {required this.txid,
      required this.vout,
      required this.value,
      required this.status});

  factory _$_AddressUtxo.fromJson(Map<String, dynamic> json) =>
      _$$_AddressUtxoFromJson(json);

  @override
  final String txid;
  @override
  final int vout;
  @override
  final int value;
  @override
  final TxStatus status;

  @override
  String toString() {
    return 'AddressUtxo(txid: $txid, vout: $vout, value: $value, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AddressUtxo &&
            (identical(other.txid, txid) || other.txid == txid) &&
            (identical(other.vout, vout) || other.vout == vout) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, txid, vout, value, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AddressUtxoCopyWith<_$_AddressUtxo> get copyWith =>
      __$$_AddressUtxoCopyWithImpl<_$_AddressUtxo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AddressUtxoToJson(
      this,
    );
  }
}

abstract class _AddressUtxo implements AddressUtxo {
  factory _AddressUtxo(
      {required final String txid,
      required final int vout,
      required final int value,
      required final TxStatus status}) = _$_AddressUtxo;

  factory _AddressUtxo.fromJson(Map<String, dynamic> json) =
      _$_AddressUtxo.fromJson;

  @override
  String get txid;
  @override
  int get vout;
  @override
  int get value;
  @override
  TxStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$_AddressUtxoCopyWith<_$_AddressUtxo> get copyWith =>
      throw _privateConstructorUsedError;
}

TxStatus _$TxStatusFromJson(Map<String, dynamic> json) {
  return _TxStatus.fromJson(json);
}

/// @nodoc
mixin _$TxStatus {
  bool get confirmed => throw _privateConstructorUsedError;
  set confirmed(bool value) => throw _privateConstructorUsedError;
  int? get block_height => throw _privateConstructorUsedError;
  set block_height(int? value) => throw _privateConstructorUsedError;
  String? get block_hash => throw _privateConstructorUsedError;
  set block_hash(String? value) => throw _privateConstructorUsedError;
  int? get block_time => throw _privateConstructorUsedError;
  set block_time(int? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TxStatusCopyWith<TxStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TxStatusCopyWith<$Res> {
  factory $TxStatusCopyWith(TxStatus value, $Res Function(TxStatus) then) =
      _$TxStatusCopyWithImpl<$Res, TxStatus>;
  @useResult
  $Res call(
      {bool confirmed, int? block_height, String? block_hash, int? block_time});
}

/// @nodoc
class _$TxStatusCopyWithImpl<$Res, $Val extends TxStatus>
    implements $TxStatusCopyWith<$Res> {
  _$TxStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmed = null,
    Object? block_height = freezed,
    Object? block_hash = freezed,
    Object? block_time = freezed,
  }) {
    return _then(_value.copyWith(
      confirmed: null == confirmed
          ? _value.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      block_height: freezed == block_height
          ? _value.block_height
          : block_height // ignore: cast_nullable_to_non_nullable
              as int?,
      block_hash: freezed == block_hash
          ? _value.block_hash
          : block_hash // ignore: cast_nullable_to_non_nullable
              as String?,
      block_time: freezed == block_time
          ? _value.block_time
          : block_time // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TxStatusCopyWith<$Res> implements $TxStatusCopyWith<$Res> {
  factory _$$_TxStatusCopyWith(
          _$_TxStatus value, $Res Function(_$_TxStatus) then) =
      __$$_TxStatusCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool confirmed, int? block_height, String? block_hash, int? block_time});
}

/// @nodoc
class __$$_TxStatusCopyWithImpl<$Res>
    extends _$TxStatusCopyWithImpl<$Res, _$_TxStatus>
    implements _$$_TxStatusCopyWith<$Res> {
  __$$_TxStatusCopyWithImpl(
      _$_TxStatus _value, $Res Function(_$_TxStatus) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmed = null,
    Object? block_height = freezed,
    Object? block_hash = freezed,
    Object? block_time = freezed,
  }) {
    return _then(_$_TxStatus(
      confirmed: null == confirmed
          ? _value.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      block_height: freezed == block_height
          ? _value.block_height
          : block_height // ignore: cast_nullable_to_non_nullable
              as int?,
      block_hash: freezed == block_hash
          ? _value.block_hash
          : block_hash // ignore: cast_nullable_to_non_nullable
              as String?,
      block_time: freezed == block_time
          ? _value.block_time
          : block_time // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TxStatus implements _TxStatus {
  _$_TxStatus(
      {required this.confirmed,
      this.block_height,
      this.block_hash,
      this.block_time});

  factory _$_TxStatus.fromJson(Map<String, dynamic> json) =>
      _$$_TxStatusFromJson(json);

  @override
  bool confirmed;
  @override
  int? block_height;
  @override
  String? block_hash;
  @override
  int? block_time;

  @override
  String toString() {
    return 'TxStatus(confirmed: $confirmed, block_height: $block_height, block_hash: $block_hash, block_time: $block_time)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TxStatusCopyWith<_$_TxStatus> get copyWith =>
      __$$_TxStatusCopyWithImpl<_$_TxStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TxStatusToJson(
      this,
    );
  }
}

abstract class _TxStatus implements TxStatus {
  factory _TxStatus(
      {required bool confirmed,
      int? block_height,
      String? block_hash,
      int? block_time}) = _$_TxStatus;

  factory _TxStatus.fromJson(Map<String, dynamic> json) = _$_TxStatus.fromJson;

  @override
  bool get confirmed;
  set confirmed(bool value);
  @override
  int? get block_height;
  set block_height(int? value);
  @override
  String? get block_hash;
  set block_hash(String? value);
  @override
  int? get block_time;
  set block_time(int? value);
  @override
  @JsonKey(ignore: true)
  _$$_TxStatusCopyWith<_$_TxStatus> get copyWith =>
      throw _privateConstructorUsedError;
}
