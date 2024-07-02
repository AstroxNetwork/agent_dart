// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddressStats _$AddressStatsFromJson(Map<String, dynamic> json) {
  return _AddressStats.fromJson(json);
}

/// @nodoc
mixin _$AddressStats {
  String get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'chain_stats')
  StatsItem get chainStats => throw _privateConstructorUsedError;
  @JsonKey(name: 'mempool_stats')
  StatsItem get mempoolStats => throw _privateConstructorUsedError;

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
  $Res call(
      {String address,
      @JsonKey(name: 'chain_stats') StatsItem chainStats,
      @JsonKey(name: 'mempool_stats') StatsItem mempoolStats});

  $StatsItemCopyWith<$Res> get chainStats;
  $StatsItemCopyWith<$Res> get mempoolStats;
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
    Object? chainStats = null,
    Object? mempoolStats = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      chainStats: null == chainStats
          ? _value.chainStats
          : chainStats // ignore: cast_nullable_to_non_nullable
              as StatsItem,
      mempoolStats: null == mempoolStats
          ? _value.mempoolStats
          : mempoolStats // ignore: cast_nullable_to_non_nullable
              as StatsItem,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StatsItemCopyWith<$Res> get chainStats {
    return $StatsItemCopyWith<$Res>(_value.chainStats, (value) {
      return _then(_value.copyWith(chainStats: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StatsItemCopyWith<$Res> get mempoolStats {
    return $StatsItemCopyWith<$Res>(_value.mempoolStats, (value) {
      return _then(_value.copyWith(mempoolStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AddressStatsImplCopyWith<$Res>
    implements $AddressStatsCopyWith<$Res> {
  factory _$$AddressStatsImplCopyWith(
          _$AddressStatsImpl value, $Res Function(_$AddressStatsImpl) then) =
      __$$AddressStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String address,
      @JsonKey(name: 'chain_stats') StatsItem chainStats,
      @JsonKey(name: 'mempool_stats') StatsItem mempoolStats});

  @override
  $StatsItemCopyWith<$Res> get chainStats;
  @override
  $StatsItemCopyWith<$Res> get mempoolStats;
}

/// @nodoc
class __$$AddressStatsImplCopyWithImpl<$Res>
    extends _$AddressStatsCopyWithImpl<$Res, _$AddressStatsImpl>
    implements _$$AddressStatsImplCopyWith<$Res> {
  __$$AddressStatsImplCopyWithImpl(
      _$AddressStatsImpl _value, $Res Function(_$AddressStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? chainStats = null,
    Object? mempoolStats = null,
  }) {
    return _then(_$AddressStatsImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      chainStats: null == chainStats
          ? _value.chainStats
          : chainStats // ignore: cast_nullable_to_non_nullable
              as StatsItem,
      mempoolStats: null == mempoolStats
          ? _value.mempoolStats
          : mempoolStats // ignore: cast_nullable_to_non_nullable
              as StatsItem,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressStatsImpl implements _AddressStats {
  const _$AddressStatsImpl(
      {required this.address,
      @JsonKey(name: 'chain_stats') required this.chainStats,
      @JsonKey(name: 'mempool_stats') required this.mempoolStats});

  factory _$AddressStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressStatsImplFromJson(json);

  @override
  final String address;
  @override
  @JsonKey(name: 'chain_stats')
  final StatsItem chainStats;
  @override
  @JsonKey(name: 'mempool_stats')
  final StatsItem mempoolStats;

  @override
  String toString() {
    return 'AddressStats(address: $address, chainStats: $chainStats, mempoolStats: $mempoolStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressStatsImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.chainStats, chainStats) ||
                other.chainStats == chainStats) &&
            (identical(other.mempoolStats, mempoolStats) ||
                other.mempoolStats == mempoolStats));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, address, chainStats, mempoolStats);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressStatsImplCopyWith<_$AddressStatsImpl> get copyWith =>
      __$$AddressStatsImplCopyWithImpl<_$AddressStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressStatsImplToJson(
      this,
    );
  }
}

abstract class _AddressStats implements AddressStats {
  const factory _AddressStats(
      {required final String address,
      @JsonKey(name: 'chain_stats') required final StatsItem chainStats,
      @JsonKey(name: 'mempool_stats')
      required final StatsItem mempoolStats}) = _$AddressStatsImpl;

  factory _AddressStats.fromJson(Map<String, dynamic> json) =
      _$AddressStatsImpl.fromJson;

  @override
  String get address;
  @override
  @JsonKey(name: 'chain_stats')
  StatsItem get chainStats;
  @override
  @JsonKey(name: 'mempool_stats')
  StatsItem get mempoolStats;
  @override
  @JsonKey(ignore: true)
  _$$AddressStatsImplCopyWith<_$AddressStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StatsItem _$StatsItemFromJson(Map<String, dynamic> json) {
  return _StatsItem.fromJson(json);
}

/// @nodoc
mixin _$StatsItem {
  @JsonKey(name: 'funded_utxo_count')
  int get fundedUtxoCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'funded_utxo_sum')
  int get fundedUtxoSum => throw _privateConstructorUsedError;
  @JsonKey(name: 'spent_utxo_count')
  int get spentUtxoCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'spent_utxo_sum')
  int get spentUtxoSum => throw _privateConstructorUsedError;
  @JsonKey(name: 'tx_count')
  int get txCount => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'funded_utxo_count') int fundedUtxoCount,
      @JsonKey(name: 'funded_utxo_sum') int fundedUtxoSum,
      @JsonKey(name: 'spent_utxo_count') int spentUtxoCount,
      @JsonKey(name: 'spent_utxo_sum') int spentUtxoSum,
      @JsonKey(name: 'tx_count') int txCount});
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
    Object? fundedUtxoCount = null,
    Object? fundedUtxoSum = null,
    Object? spentUtxoCount = null,
    Object? spentUtxoSum = null,
    Object? txCount = null,
  }) {
    return _then(_value.copyWith(
      fundedUtxoCount: null == fundedUtxoCount
          ? _value.fundedUtxoCount
          : fundedUtxoCount // ignore: cast_nullable_to_non_nullable
              as int,
      fundedUtxoSum: null == fundedUtxoSum
          ? _value.fundedUtxoSum
          : fundedUtxoSum // ignore: cast_nullable_to_non_nullable
              as int,
      spentUtxoCount: null == spentUtxoCount
          ? _value.spentUtxoCount
          : spentUtxoCount // ignore: cast_nullable_to_non_nullable
              as int,
      spentUtxoSum: null == spentUtxoSum
          ? _value.spentUtxoSum
          : spentUtxoSum // ignore: cast_nullable_to_non_nullable
              as int,
      txCount: null == txCount
          ? _value.txCount
          : txCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatsItemImplCopyWith<$Res>
    implements $StatsItemCopyWith<$Res> {
  factory _$$StatsItemImplCopyWith(
          _$StatsItemImpl value, $Res Function(_$StatsItemImpl) then) =
      __$$StatsItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'funded_utxo_count') int fundedUtxoCount,
      @JsonKey(name: 'funded_utxo_sum') int fundedUtxoSum,
      @JsonKey(name: 'spent_utxo_count') int spentUtxoCount,
      @JsonKey(name: 'spent_utxo_sum') int spentUtxoSum,
      @JsonKey(name: 'tx_count') int txCount});
}

/// @nodoc
class __$$StatsItemImplCopyWithImpl<$Res>
    extends _$StatsItemCopyWithImpl<$Res, _$StatsItemImpl>
    implements _$$StatsItemImplCopyWith<$Res> {
  __$$StatsItemImplCopyWithImpl(
      _$StatsItemImpl _value, $Res Function(_$StatsItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fundedUtxoCount = null,
    Object? fundedUtxoSum = null,
    Object? spentUtxoCount = null,
    Object? spentUtxoSum = null,
    Object? txCount = null,
  }) {
    return _then(_$StatsItemImpl(
      fundedUtxoCount: null == fundedUtxoCount
          ? _value.fundedUtxoCount
          : fundedUtxoCount // ignore: cast_nullable_to_non_nullable
              as int,
      fundedUtxoSum: null == fundedUtxoSum
          ? _value.fundedUtxoSum
          : fundedUtxoSum // ignore: cast_nullable_to_non_nullable
              as int,
      spentUtxoCount: null == spentUtxoCount
          ? _value.spentUtxoCount
          : spentUtxoCount // ignore: cast_nullable_to_non_nullable
              as int,
      spentUtxoSum: null == spentUtxoSum
          ? _value.spentUtxoSum
          : spentUtxoSum // ignore: cast_nullable_to_non_nullable
              as int,
      txCount: null == txCount
          ? _value.txCount
          : txCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatsItemImpl implements _StatsItem {
  const _$StatsItemImpl(
      {@JsonKey(name: 'funded_utxo_count') required this.fundedUtxoCount,
      @JsonKey(name: 'funded_utxo_sum') required this.fundedUtxoSum,
      @JsonKey(name: 'spent_utxo_count') required this.spentUtxoCount,
      @JsonKey(name: 'spent_utxo_sum') required this.spentUtxoSum,
      @JsonKey(name: 'tx_count') required this.txCount});

  factory _$StatsItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatsItemImplFromJson(json);

  @override
  @JsonKey(name: 'funded_utxo_count')
  final int fundedUtxoCount;
  @override
  @JsonKey(name: 'funded_utxo_sum')
  final int fundedUtxoSum;
  @override
  @JsonKey(name: 'spent_utxo_count')
  final int spentUtxoCount;
  @override
  @JsonKey(name: 'spent_utxo_sum')
  final int spentUtxoSum;
  @override
  @JsonKey(name: 'tx_count')
  final int txCount;

  @override
  String toString() {
    return 'StatsItem(fundedUtxoCount: $fundedUtxoCount, fundedUtxoSum: $fundedUtxoSum, spentUtxoCount: $spentUtxoCount, spentUtxoSum: $spentUtxoSum, txCount: $txCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatsItemImpl &&
            (identical(other.fundedUtxoCount, fundedUtxoCount) ||
                other.fundedUtxoCount == fundedUtxoCount) &&
            (identical(other.fundedUtxoSum, fundedUtxoSum) ||
                other.fundedUtxoSum == fundedUtxoSum) &&
            (identical(other.spentUtxoCount, spentUtxoCount) ||
                other.spentUtxoCount == spentUtxoCount) &&
            (identical(other.spentUtxoSum, spentUtxoSum) ||
                other.spentUtxoSum == spentUtxoSum) &&
            (identical(other.txCount, txCount) || other.txCount == txCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fundedUtxoCount, fundedUtxoSum,
      spentUtxoCount, spentUtxoSum, txCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatsItemImplCopyWith<_$StatsItemImpl> get copyWith =>
      __$$StatsItemImplCopyWithImpl<_$StatsItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatsItemImplToJson(
      this,
    );
  }
}

abstract class _StatsItem implements StatsItem {
  const factory _StatsItem(
      {@JsonKey(name: 'funded_utxo_count') required final int fundedUtxoCount,
      @JsonKey(name: 'funded_utxo_sum') required final int fundedUtxoSum,
      @JsonKey(name: 'spent_utxo_count') required final int spentUtxoCount,
      @JsonKey(name: 'spent_utxo_sum') required final int spentUtxoSum,
      @JsonKey(name: 'tx_count') required final int txCount}) = _$StatsItemImpl;

  factory _StatsItem.fromJson(Map<String, dynamic> json) =
      _$StatsItemImpl.fromJson;

  @override
  @JsonKey(name: 'funded_utxo_count')
  int get fundedUtxoCount;
  @override
  @JsonKey(name: 'funded_utxo_sum')
  int get fundedUtxoSum;
  @override
  @JsonKey(name: 'spent_utxo_count')
  int get spentUtxoCount;
  @override
  @JsonKey(name: 'spent_utxo_sum')
  int get spentUtxoSum;
  @override
  @JsonKey(name: 'tx_count')
  int get txCount;
  @override
  @JsonKey(ignore: true)
  _$$StatsItemImplCopyWith<_$StatsItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
