// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_utxo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$AddressUtxoImplCopyWith<$Res>
    implements $AddressUtxoCopyWith<$Res> {
  factory _$$AddressUtxoImplCopyWith(
          _$AddressUtxoImpl value, $Res Function(_$AddressUtxoImpl) then) =
      __$$AddressUtxoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String txid, int vout, int value, TxStatus status});

  @override
  $TxStatusCopyWith<$Res> get status;
}

/// @nodoc
class __$$AddressUtxoImplCopyWithImpl<$Res>
    extends _$AddressUtxoCopyWithImpl<$Res, _$AddressUtxoImpl>
    implements _$$AddressUtxoImplCopyWith<$Res> {
  __$$AddressUtxoImplCopyWithImpl(
      _$AddressUtxoImpl _value, $Res Function(_$AddressUtxoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? vout = null,
    Object? value = null,
    Object? status = null,
  }) {
    return _then(_$AddressUtxoImpl(
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
class _$AddressUtxoImpl implements _AddressUtxo {
  _$AddressUtxoImpl(
      {required this.txid,
      required this.vout,
      required this.value,
      required this.status});

  factory _$AddressUtxoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressUtxoImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressUtxoImpl &&
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
  _$$AddressUtxoImplCopyWith<_$AddressUtxoImpl> get copyWith =>
      __$$AddressUtxoImplCopyWithImpl<_$AddressUtxoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressUtxoImplToJson(
      this,
    );
  }
}

abstract class _AddressUtxo implements AddressUtxo {
  factory _AddressUtxo(
      {required final String txid,
      required final int vout,
      required final int value,
      required final TxStatus status}) = _$AddressUtxoImpl;

  factory _AddressUtxo.fromJson(Map<String, dynamic> json) =
      _$AddressUtxoImpl.fromJson;

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
  _$$AddressUtxoImplCopyWith<_$AddressUtxoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TxStatus _$TxStatusFromJson(Map<String, dynamic> json) {
  return _TxStatus.fromJson(json);
}

/// @nodoc
mixin _$TxStatus {
  bool get confirmed => throw _privateConstructorUsedError;
  set confirmed(bool value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'block_height')
  int? get blockHeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'block_height')
  set blockHeight(int? value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'block_hash')
  String? get blockHash => throw _privateConstructorUsedError;
  @JsonKey(name: 'block_hash')
  set blockHash(String? value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'block_time')
  int? get blockTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'block_time')
  set blockTime(int? value) => throw _privateConstructorUsedError;

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
      {bool confirmed,
      @JsonKey(name: 'block_height') int? blockHeight,
      @JsonKey(name: 'block_hash') String? blockHash,
      @JsonKey(name: 'block_time') int? blockTime});
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
    Object? blockHeight = freezed,
    Object? blockHash = freezed,
    Object? blockTime = freezed,
  }) {
    return _then(_value.copyWith(
      confirmed: null == confirmed
          ? _value.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      blockHeight: freezed == blockHeight
          ? _value.blockHeight
          : blockHeight // ignore: cast_nullable_to_non_nullable
              as int?,
      blockHash: freezed == blockHash
          ? _value.blockHash
          : blockHash // ignore: cast_nullable_to_non_nullable
              as String?,
      blockTime: freezed == blockTime
          ? _value.blockTime
          : blockTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TxStatusImplCopyWith<$Res>
    implements $TxStatusCopyWith<$Res> {
  factory _$$TxStatusImplCopyWith(
          _$TxStatusImpl value, $Res Function(_$TxStatusImpl) then) =
      __$$TxStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool confirmed,
      @JsonKey(name: 'block_height') int? blockHeight,
      @JsonKey(name: 'block_hash') String? blockHash,
      @JsonKey(name: 'block_time') int? blockTime});
}

/// @nodoc
class __$$TxStatusImplCopyWithImpl<$Res>
    extends _$TxStatusCopyWithImpl<$Res, _$TxStatusImpl>
    implements _$$TxStatusImplCopyWith<$Res> {
  __$$TxStatusImplCopyWithImpl(
      _$TxStatusImpl _value, $Res Function(_$TxStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmed = null,
    Object? blockHeight = freezed,
    Object? blockHash = freezed,
    Object? blockTime = freezed,
  }) {
    return _then(_$TxStatusImpl(
      confirmed: null == confirmed
          ? _value.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      blockHeight: freezed == blockHeight
          ? _value.blockHeight
          : blockHeight // ignore: cast_nullable_to_non_nullable
              as int?,
      blockHash: freezed == blockHash
          ? _value.blockHash
          : blockHash // ignore: cast_nullable_to_non_nullable
              as String?,
      blockTime: freezed == blockTime
          ? _value.blockTime
          : blockTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TxStatusImpl implements _TxStatus {
  const _$TxStatusImpl(
      {required this.confirmed,
      @JsonKey(name: 'block_height') this.blockHeight,
      @JsonKey(name: 'block_hash') this.blockHash,
      @JsonKey(name: 'block_time') this.blockTime});

  factory _$TxStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$TxStatusImplFromJson(json);

  @override
  bool confirmed;
  @override
  @JsonKey(name: 'block_height')
  int? blockHeight;
  @override
  @JsonKey(name: 'block_hash')
  String? blockHash;
  @override
  @JsonKey(name: 'block_time')
  int? blockTime;

  @override
  String toString() {
    return 'TxStatus(confirmed: $confirmed, blockHeight: $blockHeight, blockHash: $blockHash, blockTime: $blockTime)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TxStatusImplCopyWith<_$TxStatusImpl> get copyWith =>
      __$$TxStatusImplCopyWithImpl<_$TxStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TxStatusImplToJson(
      this,
    );
  }
}

abstract class _TxStatus implements TxStatus {
  const factory _TxStatus(
      {required bool confirmed,
      @JsonKey(name: 'block_height') int? blockHeight,
      @JsonKey(name: 'block_hash') String? blockHash,
      @JsonKey(name: 'block_time') int? blockTime}) = _$TxStatusImpl;

  factory _TxStatus.fromJson(Map<String, dynamic> json) =
      _$TxStatusImpl.fromJson;

  @override
  bool get confirmed;
  set confirmed(bool value);
  @override
  @JsonKey(name: 'block_height')
  int? get blockHeight;
  @JsonKey(name: 'block_height')
  set blockHeight(int? value);
  @override
  @JsonKey(name: 'block_hash')
  String? get blockHash;
  @JsonKey(name: 'block_hash')
  set blockHash(String? value);
  @override
  @JsonKey(name: 'block_time')
  int? get blockTime;
  @JsonKey(name: 'block_time')
  set blockTime(int? value);
  @override
  @JsonKey(ignore: true)
  _$$TxStatusImplCopyWith<_$TxStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
