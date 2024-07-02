// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blockchain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BlockchainConfig {
  Object get config => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ElectrumConfig config) electrum,
    required TResult Function(EsploraConfig config) esplora,
    required TResult Function(RpcConfig config) rpc,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ElectrumConfig config)? electrum,
    TResult? Function(EsploraConfig config)? esplora,
    TResult? Function(RpcConfig config)? rpc,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ElectrumConfig config)? electrum,
    TResult Function(EsploraConfig config)? esplora,
    TResult Function(RpcConfig config)? rpc,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlockchainConfig_Electrum value) electrum,
    required TResult Function(BlockchainConfig_Esplora value) esplora,
    required TResult Function(BlockchainConfig_Rpc value) rpc,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlockchainConfig_Electrum value)? electrum,
    TResult? Function(BlockchainConfig_Esplora value)? esplora,
    TResult? Function(BlockchainConfig_Rpc value)? rpc,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlockchainConfig_Electrum value)? electrum,
    TResult Function(BlockchainConfig_Esplora value)? esplora,
    TResult Function(BlockchainConfig_Rpc value)? rpc,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockchainConfigCopyWith<$Res> {
  factory $BlockchainConfigCopyWith(
          BlockchainConfig value, $Res Function(BlockchainConfig) then) =
      _$BlockchainConfigCopyWithImpl<$Res, BlockchainConfig>;
}

/// @nodoc
class _$BlockchainConfigCopyWithImpl<$Res, $Val extends BlockchainConfig>
    implements $BlockchainConfigCopyWith<$Res> {
  _$BlockchainConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$BlockchainConfig_ElectrumImplCopyWith<$Res> {
  factory _$$BlockchainConfig_ElectrumImplCopyWith(
          _$BlockchainConfig_ElectrumImpl value,
          $Res Function(_$BlockchainConfig_ElectrumImpl) then) =
      __$$BlockchainConfig_ElectrumImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ElectrumConfig config});
}

/// @nodoc
class __$$BlockchainConfig_ElectrumImplCopyWithImpl<$Res>
    extends _$BlockchainConfigCopyWithImpl<$Res,
        _$BlockchainConfig_ElectrumImpl>
    implements _$$BlockchainConfig_ElectrumImplCopyWith<$Res> {
  __$$BlockchainConfig_ElectrumImplCopyWithImpl(
      _$BlockchainConfig_ElectrumImpl _value,
      $Res Function(_$BlockchainConfig_ElectrumImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
  }) {
    return _then(_$BlockchainConfig_ElectrumImpl(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as ElectrumConfig,
    ));
  }
}

/// @nodoc

class _$BlockchainConfig_ElectrumImpl extends BlockchainConfig_Electrum {
  const _$BlockchainConfig_ElectrumImpl({required this.config}) : super._();

  @override
  final ElectrumConfig config;

  @override
  String toString() {
    return 'BlockchainConfig.electrum(config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockchainConfig_ElectrumImpl &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockchainConfig_ElectrumImplCopyWith<_$BlockchainConfig_ElectrumImpl>
      get copyWith => __$$BlockchainConfig_ElectrumImplCopyWithImpl<
          _$BlockchainConfig_ElectrumImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ElectrumConfig config) electrum,
    required TResult Function(EsploraConfig config) esplora,
    required TResult Function(RpcConfig config) rpc,
  }) {
    return electrum(config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ElectrumConfig config)? electrum,
    TResult? Function(EsploraConfig config)? esplora,
    TResult? Function(RpcConfig config)? rpc,
  }) {
    return electrum?.call(config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ElectrumConfig config)? electrum,
    TResult Function(EsploraConfig config)? esplora,
    TResult Function(RpcConfig config)? rpc,
    required TResult orElse(),
  }) {
    if (electrum != null) {
      return electrum(config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlockchainConfig_Electrum value) electrum,
    required TResult Function(BlockchainConfig_Esplora value) esplora,
    required TResult Function(BlockchainConfig_Rpc value) rpc,
  }) {
    return electrum(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlockchainConfig_Electrum value)? electrum,
    TResult? Function(BlockchainConfig_Esplora value)? esplora,
    TResult? Function(BlockchainConfig_Rpc value)? rpc,
  }) {
    return electrum?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlockchainConfig_Electrum value)? electrum,
    TResult Function(BlockchainConfig_Esplora value)? esplora,
    TResult Function(BlockchainConfig_Rpc value)? rpc,
    required TResult orElse(),
  }) {
    if (electrum != null) {
      return electrum(this);
    }
    return orElse();
  }
}

abstract class BlockchainConfig_Electrum extends BlockchainConfig {
  const factory BlockchainConfig_Electrum(
      {required final ElectrumConfig config}) = _$BlockchainConfig_ElectrumImpl;
  const BlockchainConfig_Electrum._() : super._();

  @override
  ElectrumConfig get config;
  @JsonKey(ignore: true)
  _$$BlockchainConfig_ElectrumImplCopyWith<_$BlockchainConfig_ElectrumImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BlockchainConfig_EsploraImplCopyWith<$Res> {
  factory _$$BlockchainConfig_EsploraImplCopyWith(
          _$BlockchainConfig_EsploraImpl value,
          $Res Function(_$BlockchainConfig_EsploraImpl) then) =
      __$$BlockchainConfig_EsploraImplCopyWithImpl<$Res>;
  @useResult
  $Res call({EsploraConfig config});
}

/// @nodoc
class __$$BlockchainConfig_EsploraImplCopyWithImpl<$Res>
    extends _$BlockchainConfigCopyWithImpl<$Res, _$BlockchainConfig_EsploraImpl>
    implements _$$BlockchainConfig_EsploraImplCopyWith<$Res> {
  __$$BlockchainConfig_EsploraImplCopyWithImpl(
      _$BlockchainConfig_EsploraImpl _value,
      $Res Function(_$BlockchainConfig_EsploraImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
  }) {
    return _then(_$BlockchainConfig_EsploraImpl(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as EsploraConfig,
    ));
  }
}

/// @nodoc

class _$BlockchainConfig_EsploraImpl extends BlockchainConfig_Esplora {
  const _$BlockchainConfig_EsploraImpl({required this.config}) : super._();

  @override
  final EsploraConfig config;

  @override
  String toString() {
    return 'BlockchainConfig.esplora(config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockchainConfig_EsploraImpl &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockchainConfig_EsploraImplCopyWith<_$BlockchainConfig_EsploraImpl>
      get copyWith => __$$BlockchainConfig_EsploraImplCopyWithImpl<
          _$BlockchainConfig_EsploraImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ElectrumConfig config) electrum,
    required TResult Function(EsploraConfig config) esplora,
    required TResult Function(RpcConfig config) rpc,
  }) {
    return esplora(config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ElectrumConfig config)? electrum,
    TResult? Function(EsploraConfig config)? esplora,
    TResult? Function(RpcConfig config)? rpc,
  }) {
    return esplora?.call(config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ElectrumConfig config)? electrum,
    TResult Function(EsploraConfig config)? esplora,
    TResult Function(RpcConfig config)? rpc,
    required TResult orElse(),
  }) {
    if (esplora != null) {
      return esplora(config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlockchainConfig_Electrum value) electrum,
    required TResult Function(BlockchainConfig_Esplora value) esplora,
    required TResult Function(BlockchainConfig_Rpc value) rpc,
  }) {
    return esplora(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlockchainConfig_Electrum value)? electrum,
    TResult? Function(BlockchainConfig_Esplora value)? esplora,
    TResult? Function(BlockchainConfig_Rpc value)? rpc,
  }) {
    return esplora?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlockchainConfig_Electrum value)? electrum,
    TResult Function(BlockchainConfig_Esplora value)? esplora,
    TResult Function(BlockchainConfig_Rpc value)? rpc,
    required TResult orElse(),
  }) {
    if (esplora != null) {
      return esplora(this);
    }
    return orElse();
  }
}

abstract class BlockchainConfig_Esplora extends BlockchainConfig {
  const factory BlockchainConfig_Esplora(
      {required final EsploraConfig config}) = _$BlockchainConfig_EsploraImpl;
  const BlockchainConfig_Esplora._() : super._();

  @override
  EsploraConfig get config;
  @JsonKey(ignore: true)
  _$$BlockchainConfig_EsploraImplCopyWith<_$BlockchainConfig_EsploraImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BlockchainConfig_RpcImplCopyWith<$Res> {
  factory _$$BlockchainConfig_RpcImplCopyWith(_$BlockchainConfig_RpcImpl value,
          $Res Function(_$BlockchainConfig_RpcImpl) then) =
      __$$BlockchainConfig_RpcImplCopyWithImpl<$Res>;
  @useResult
  $Res call({RpcConfig config});
}

/// @nodoc
class __$$BlockchainConfig_RpcImplCopyWithImpl<$Res>
    extends _$BlockchainConfigCopyWithImpl<$Res, _$BlockchainConfig_RpcImpl>
    implements _$$BlockchainConfig_RpcImplCopyWith<$Res> {
  __$$BlockchainConfig_RpcImplCopyWithImpl(_$BlockchainConfig_RpcImpl _value,
      $Res Function(_$BlockchainConfig_RpcImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
  }) {
    return _then(_$BlockchainConfig_RpcImpl(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as RpcConfig,
    ));
  }
}

/// @nodoc

class _$BlockchainConfig_RpcImpl extends BlockchainConfig_Rpc {
  const _$BlockchainConfig_RpcImpl({required this.config}) : super._();

  @override
  final RpcConfig config;

  @override
  String toString() {
    return 'BlockchainConfig.rpc(config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockchainConfig_RpcImpl &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockchainConfig_RpcImplCopyWith<_$BlockchainConfig_RpcImpl>
      get copyWith =>
          __$$BlockchainConfig_RpcImplCopyWithImpl<_$BlockchainConfig_RpcImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ElectrumConfig config) electrum,
    required TResult Function(EsploraConfig config) esplora,
    required TResult Function(RpcConfig config) rpc,
  }) {
    return rpc(config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ElectrumConfig config)? electrum,
    TResult? Function(EsploraConfig config)? esplora,
    TResult? Function(RpcConfig config)? rpc,
  }) {
    return rpc?.call(config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ElectrumConfig config)? electrum,
    TResult Function(EsploraConfig config)? esplora,
    TResult Function(RpcConfig config)? rpc,
    required TResult orElse(),
  }) {
    if (rpc != null) {
      return rpc(config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlockchainConfig_Electrum value) electrum,
    required TResult Function(BlockchainConfig_Esplora value) esplora,
    required TResult Function(BlockchainConfig_Rpc value) rpc,
  }) {
    return rpc(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlockchainConfig_Electrum value)? electrum,
    TResult? Function(BlockchainConfig_Esplora value)? esplora,
    TResult? Function(BlockchainConfig_Rpc value)? rpc,
  }) {
    return rpc?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlockchainConfig_Electrum value)? electrum,
    TResult Function(BlockchainConfig_Esplora value)? esplora,
    TResult Function(BlockchainConfig_Rpc value)? rpc,
    required TResult orElse(),
  }) {
    if (rpc != null) {
      return rpc(this);
    }
    return orElse();
  }
}

abstract class BlockchainConfig_Rpc extends BlockchainConfig {
  const factory BlockchainConfig_Rpc({required final RpcConfig config}) =
      _$BlockchainConfig_RpcImpl;
  const BlockchainConfig_Rpc._() : super._();

  @override
  RpcConfig get config;
  @JsonKey(ignore: true)
  _$$BlockchainConfig_RpcImplCopyWith<_$BlockchainConfig_RpcImpl>
      get copyWith => throw _privateConstructorUsedError;
}
