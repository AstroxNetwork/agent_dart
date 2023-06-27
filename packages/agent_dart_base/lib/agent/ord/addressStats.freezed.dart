// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'addressStats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AddressStats _$AddressStatsFromJson(Map<String, dynamic> json) {
  return _AddressStats.fromJson(json);
}

/// @nodoc
mixin _$AddressStats {
  String get address => throw _privateConstructorUsedError;
  set address(String value) => throw _privateConstructorUsedError;
  StatsItem get chain_stats => throw _privateConstructorUsedError;
  set chain_stats(StatsItem value) => throw _privateConstructorUsedError;
  StatsItem get mempool_stats => throw _privateConstructorUsedError;
  set mempool_stats(StatsItem value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressStatsCopyWith<AddressStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressStatsCopyWith<$Res> {
  factory $AddressStatsCopyWith(
          AddressStats value, $Res Function(AddressStats) then) =
      _$AddressStatsCopyWithImpl<$Res, AddressStats>;
  @useResult
  $Res call({String address, StatsItem chain_stats, StatsItem mempool_stats});

  $StatsItemCopyWith<$Res> get chain_stats;
  $StatsItemCopyWith<$Res> get mempool_stats;
}

/// @nodoc
class _$AddressStatsCopyWithImpl<$Res, $Val extends AddressStats>
    implements $AddressStatsCopyWith<$Res> {
  _$AddressStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? chain_stats = null,
    Object? mempool_stats = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      chain_stats: null == chain_stats
          ? _value.chain_stats
          : chain_stats // ignore: cast_nullable_to_non_nullable
              as StatsItem,
      mempool_stats: null == mempool_stats
          ? _value.mempool_stats
          : mempool_stats // ignore: cast_nullable_to_non_nullable
              as StatsItem,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StatsItemCopyWith<$Res> get chain_stats {
    return $StatsItemCopyWith<$Res>(_value.chain_stats, (value) {
      return _then(_value.copyWith(chain_stats: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StatsItemCopyWith<$Res> get mempool_stats {
    return $StatsItemCopyWith<$Res>(_value.mempool_stats, (value) {
      return _then(_value.copyWith(mempool_stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AddressStatsCopyWith<$Res>
    implements $AddressStatsCopyWith<$Res> {
  factory _$$_AddressStatsCopyWith(
          _$_AddressStats value, $Res Function(_$_AddressStats) then) =
      __$$_AddressStatsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String address, StatsItem chain_stats, StatsItem mempool_stats});

  @override
  $StatsItemCopyWith<$Res> get chain_stats;
  @override
  $StatsItemCopyWith<$Res> get mempool_stats;
}

/// @nodoc
class __$$_AddressStatsCopyWithImpl<$Res>
    extends _$AddressStatsCopyWithImpl<$Res, _$_AddressStats>
    implements _$$_AddressStatsCopyWith<$Res> {
  __$$_AddressStatsCopyWithImpl(
      _$_AddressStats _value, $Res Function(_$_AddressStats) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? chain_stats = null,
    Object? mempool_stats = null,
  }) {
    return _then(_$_AddressStats(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      chain_stats: null == chain_stats
          ? _value.chain_stats
          : chain_stats // ignore: cast_nullable_to_non_nullable
              as StatsItem,
      mempool_stats: null == mempool_stats
          ? _value.mempool_stats
          : mempool_stats // ignore: cast_nullable_to_non_nullable
              as StatsItem,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AddressStats implements _AddressStats {
  _$_AddressStats(
      {required this.address,
      required this.chain_stats,
      required this.mempool_stats});

  factory _$_AddressStats.fromJson(Map<String, dynamic> json) =>
      _$$_AddressStatsFromJson(json);

  @override
  String address;
  @override
  StatsItem chain_stats;
  @override
  StatsItem mempool_stats;

  @override
  String toString() {
    return 'AddressStats(address: $address, chain_stats: $chain_stats, mempool_stats: $mempool_stats)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AddressStatsCopyWith<_$_AddressStats> get copyWith =>
      __$$_AddressStatsCopyWithImpl<_$_AddressStats>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AddressStatsToJson(
      this,
    );
  }
}

abstract class _AddressStats implements AddressStats {
  factory _AddressStats(
      {required String address,
      required StatsItem chain_stats,
      required StatsItem mempool_stats}) = _$_AddressStats;

  factory _AddressStats.fromJson(Map<String, dynamic> json) =
      _$_AddressStats.fromJson;

  @override
  String get address;
  set address(String value);
  @override
  StatsItem get chain_stats;
  set chain_stats(StatsItem value);
  @override
  StatsItem get mempool_stats;
  set mempool_stats(StatsItem value);
  @override
  @JsonKey(ignore: true)
  _$$_AddressStatsCopyWith<_$_AddressStats> get copyWith =>
      throw _privateConstructorUsedError;
}

StatsItem _$StatsItemFromJson(Map<String, dynamic> json) {
  return _StatsItem.fromJson(json);
}

/// @nodoc
mixin _$StatsItem {
  int get funded_txo_count => throw _privateConstructorUsedError;
  int get funded_txo_sum => throw _privateConstructorUsedError;
  int get spent_txo_count => throw _privateConstructorUsedError;
  int get spent_txo_sum => throw _privateConstructorUsedError;
  int get tx_count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StatsItemCopyWith<StatsItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatsItemCopyWith<$Res> {
  factory $StatsItemCopyWith(StatsItem value, $Res Function(StatsItem) then) =
      _$StatsItemCopyWithImpl<$Res, StatsItem>;
  @useResult
  $Res call(
      {int funded_txo_count,
      int funded_txo_sum,
      int spent_txo_count,
      int spent_txo_sum,
      int tx_count});
}

/// @nodoc
class _$StatsItemCopyWithImpl<$Res, $Val extends StatsItem>
    implements $StatsItemCopyWith<$Res> {
  _$StatsItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? funded_txo_count = null,
    Object? funded_txo_sum = null,
    Object? spent_txo_count = null,
    Object? spent_txo_sum = null,
    Object? tx_count = null,
  }) {
    return _then(_value.copyWith(
      funded_txo_count: null == funded_txo_count
          ? _value.funded_txo_count
          : funded_txo_count // ignore: cast_nullable_to_non_nullable
              as int,
      funded_txo_sum: null == funded_txo_sum
          ? _value.funded_txo_sum
          : funded_txo_sum // ignore: cast_nullable_to_non_nullable
              as int,
      spent_txo_count: null == spent_txo_count
          ? _value.spent_txo_count
          : spent_txo_count // ignore: cast_nullable_to_non_nullable
              as int,
      spent_txo_sum: null == spent_txo_sum
          ? _value.spent_txo_sum
          : spent_txo_sum // ignore: cast_nullable_to_non_nullable
              as int,
      tx_count: null == tx_count
          ? _value.tx_count
          : tx_count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StatsItemCopyWith<$Res> implements $StatsItemCopyWith<$Res> {
  factory _$$_StatsItemCopyWith(
          _$_StatsItem value, $Res Function(_$_StatsItem) then) =
      __$$_StatsItemCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int funded_txo_count,
      int funded_txo_sum,
      int spent_txo_count,
      int spent_txo_sum,
      int tx_count});
}

/// @nodoc
class __$$_StatsItemCopyWithImpl<$Res>
    extends _$StatsItemCopyWithImpl<$Res, _$_StatsItem>
    implements _$$_StatsItemCopyWith<$Res> {
  __$$_StatsItemCopyWithImpl(
      _$_StatsItem _value, $Res Function(_$_StatsItem) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? funded_txo_count = null,
    Object? funded_txo_sum = null,
    Object? spent_txo_count = null,
    Object? spent_txo_sum = null,
    Object? tx_count = null,
  }) {
    return _then(_$_StatsItem(
      funded_txo_count: null == funded_txo_count
          ? _value.funded_txo_count
          : funded_txo_count // ignore: cast_nullable_to_non_nullable
              as int,
      funded_txo_sum: null == funded_txo_sum
          ? _value.funded_txo_sum
          : funded_txo_sum // ignore: cast_nullable_to_non_nullable
              as int,
      spent_txo_count: null == spent_txo_count
          ? _value.spent_txo_count
          : spent_txo_count // ignore: cast_nullable_to_non_nullable
              as int,
      spent_txo_sum: null == spent_txo_sum
          ? _value.spent_txo_sum
          : spent_txo_sum // ignore: cast_nullable_to_non_nullable
              as int,
      tx_count: null == tx_count
          ? _value.tx_count
          : tx_count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StatsItem implements _StatsItem {
  _$_StatsItem(
      {required this.funded_txo_count,
      required this.funded_txo_sum,
      required this.spent_txo_count,
      required this.spent_txo_sum,
      required this.tx_count});

  factory _$_StatsItem.fromJson(Map<String, dynamic> json) =>
      _$$_StatsItemFromJson(json);

  @override
  final int funded_txo_count;
  @override
  final int funded_txo_sum;
  @override
  final int spent_txo_count;
  @override
  final int spent_txo_sum;
  @override
  final int tx_count;

  @override
  String toString() {
    return 'StatsItem(funded_txo_count: $funded_txo_count, funded_txo_sum: $funded_txo_sum, spent_txo_count: $spent_txo_count, spent_txo_sum: $spent_txo_sum, tx_count: $tx_count)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StatsItem &&
            (identical(other.funded_txo_count, funded_txo_count) ||
                other.funded_txo_count == funded_txo_count) &&
            (identical(other.funded_txo_sum, funded_txo_sum) ||
                other.funded_txo_sum == funded_txo_sum) &&
            (identical(other.spent_txo_count, spent_txo_count) ||
                other.spent_txo_count == spent_txo_count) &&
            (identical(other.spent_txo_sum, spent_txo_sum) ||
                other.spent_txo_sum == spent_txo_sum) &&
            (identical(other.tx_count, tx_count) ||
                other.tx_count == tx_count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, funded_txo_count, funded_txo_sum,
      spent_txo_count, spent_txo_sum, tx_count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StatsItemCopyWith<_$_StatsItem> get copyWith =>
      __$$_StatsItemCopyWithImpl<_$_StatsItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StatsItemToJson(
      this,
    );
  }
}

abstract class _StatsItem implements StatsItem {
  factory _StatsItem(
      {required final int funded_txo_count,
      required final int funded_txo_sum,
      required final int spent_txo_count,
      required final int spent_txo_sum,
      required final int tx_count}) = _$_StatsItem;

  factory _StatsItem.fromJson(Map<String, dynamic> json) =
      _$_StatsItem.fromJson;

  @override
  int get funded_txo_count;
  @override
  int get funded_txo_sum;
  @override
  int get spent_txo_count;
  @override
  int get spent_txo_sum;
  @override
  int get tx_count;
  @override
  @JsonKey(ignore: true)
  _$$_StatsItemCopyWith<_$_StatsItem> get copyWith =>
      throw _privateConstructorUsedError;
}
