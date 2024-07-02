// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DatabaseConfig {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() memory,
    required TResult Function(SqliteDbConfiguration config) sqlite,
    required TResult Function(SledDbConfiguration config) sled,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? memory,
    TResult? Function(SqliteDbConfiguration config)? sqlite,
    TResult? Function(SledDbConfiguration config)? sled,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? memory,
    TResult Function(SqliteDbConfiguration config)? sqlite,
    TResult Function(SledDbConfiguration config)? sled,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseConfig_Memory value) memory,
    required TResult Function(DatabaseConfig_Sqlite value) sqlite,
    required TResult Function(DatabaseConfig_Sled value) sled,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseConfig_Memory value)? memory,
    TResult? Function(DatabaseConfig_Sqlite value)? sqlite,
    TResult? Function(DatabaseConfig_Sled value)? sled,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseConfig_Memory value)? memory,
    TResult Function(DatabaseConfig_Sqlite value)? sqlite,
    TResult Function(DatabaseConfig_Sled value)? sled,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DatabaseConfigCopyWith<$Res> {
  factory $DatabaseConfigCopyWith(
          DatabaseConfig value, $Res Function(DatabaseConfig) then) =
      _$DatabaseConfigCopyWithImpl<$Res, DatabaseConfig>;
}

/// @nodoc
class _$DatabaseConfigCopyWithImpl<$Res, $Val extends DatabaseConfig>
    implements $DatabaseConfigCopyWith<$Res> {
  _$DatabaseConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DatabaseConfig_MemoryImplCopyWith<$Res> {
  factory _$$DatabaseConfig_MemoryImplCopyWith(
          _$DatabaseConfig_MemoryImpl value,
          $Res Function(_$DatabaseConfig_MemoryImpl) then) =
      __$$DatabaseConfig_MemoryImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DatabaseConfig_MemoryImplCopyWithImpl<$Res>
    extends _$DatabaseConfigCopyWithImpl<$Res, _$DatabaseConfig_MemoryImpl>
    implements _$$DatabaseConfig_MemoryImplCopyWith<$Res> {
  __$$DatabaseConfig_MemoryImplCopyWithImpl(_$DatabaseConfig_MemoryImpl _value,
      $Res Function(_$DatabaseConfig_MemoryImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DatabaseConfig_MemoryImpl extends DatabaseConfig_Memory {
  const _$DatabaseConfig_MemoryImpl() : super._();

  @override
  String toString() {
    return 'DatabaseConfig.memory()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatabaseConfig_MemoryImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() memory,
    required TResult Function(SqliteDbConfiguration config) sqlite,
    required TResult Function(SledDbConfiguration config) sled,
  }) {
    return memory();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? memory,
    TResult? Function(SqliteDbConfiguration config)? sqlite,
    TResult? Function(SledDbConfiguration config)? sled,
  }) {
    return memory?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? memory,
    TResult Function(SqliteDbConfiguration config)? sqlite,
    TResult Function(SledDbConfiguration config)? sled,
    required TResult orElse(),
  }) {
    if (memory != null) {
      return memory();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseConfig_Memory value) memory,
    required TResult Function(DatabaseConfig_Sqlite value) sqlite,
    required TResult Function(DatabaseConfig_Sled value) sled,
  }) {
    return memory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseConfig_Memory value)? memory,
    TResult? Function(DatabaseConfig_Sqlite value)? sqlite,
    TResult? Function(DatabaseConfig_Sled value)? sled,
  }) {
    return memory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseConfig_Memory value)? memory,
    TResult Function(DatabaseConfig_Sqlite value)? sqlite,
    TResult Function(DatabaseConfig_Sled value)? sled,
    required TResult orElse(),
  }) {
    if (memory != null) {
      return memory(this);
    }
    return orElse();
  }
}

abstract class DatabaseConfig_Memory extends DatabaseConfig {
  const factory DatabaseConfig_Memory() = _$DatabaseConfig_MemoryImpl;
  const DatabaseConfig_Memory._() : super._();
}

/// @nodoc
abstract class _$$DatabaseConfig_SqliteImplCopyWith<$Res> {
  factory _$$DatabaseConfig_SqliteImplCopyWith(
          _$DatabaseConfig_SqliteImpl value,
          $Res Function(_$DatabaseConfig_SqliteImpl) then) =
      __$$DatabaseConfig_SqliteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SqliteDbConfiguration config});
}

/// @nodoc
class __$$DatabaseConfig_SqliteImplCopyWithImpl<$Res>
    extends _$DatabaseConfigCopyWithImpl<$Res, _$DatabaseConfig_SqliteImpl>
    implements _$$DatabaseConfig_SqliteImplCopyWith<$Res> {
  __$$DatabaseConfig_SqliteImplCopyWithImpl(_$DatabaseConfig_SqliteImpl _value,
      $Res Function(_$DatabaseConfig_SqliteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
  }) {
    return _then(_$DatabaseConfig_SqliteImpl(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as SqliteDbConfiguration,
    ));
  }
}

/// @nodoc

class _$DatabaseConfig_SqliteImpl extends DatabaseConfig_Sqlite {
  const _$DatabaseConfig_SqliteImpl({required this.config}) : super._();

  @override
  final SqliteDbConfiguration config;

  @override
  String toString() {
    return 'DatabaseConfig.sqlite(config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatabaseConfig_SqliteImpl &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DatabaseConfig_SqliteImplCopyWith<_$DatabaseConfig_SqliteImpl>
      get copyWith => __$$DatabaseConfig_SqliteImplCopyWithImpl<
          _$DatabaseConfig_SqliteImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() memory,
    required TResult Function(SqliteDbConfiguration config) sqlite,
    required TResult Function(SledDbConfiguration config) sled,
  }) {
    return sqlite(config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? memory,
    TResult? Function(SqliteDbConfiguration config)? sqlite,
    TResult? Function(SledDbConfiguration config)? sled,
  }) {
    return sqlite?.call(config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? memory,
    TResult Function(SqliteDbConfiguration config)? sqlite,
    TResult Function(SledDbConfiguration config)? sled,
    required TResult orElse(),
  }) {
    if (sqlite != null) {
      return sqlite(config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseConfig_Memory value) memory,
    required TResult Function(DatabaseConfig_Sqlite value) sqlite,
    required TResult Function(DatabaseConfig_Sled value) sled,
  }) {
    return sqlite(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseConfig_Memory value)? memory,
    TResult? Function(DatabaseConfig_Sqlite value)? sqlite,
    TResult? Function(DatabaseConfig_Sled value)? sled,
  }) {
    return sqlite?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseConfig_Memory value)? memory,
    TResult Function(DatabaseConfig_Sqlite value)? sqlite,
    TResult Function(DatabaseConfig_Sled value)? sled,
    required TResult orElse(),
  }) {
    if (sqlite != null) {
      return sqlite(this);
    }
    return orElse();
  }
}

abstract class DatabaseConfig_Sqlite extends DatabaseConfig {
  const factory DatabaseConfig_Sqlite(
          {required final SqliteDbConfiguration config}) =
      _$DatabaseConfig_SqliteImpl;
  const DatabaseConfig_Sqlite._() : super._();

  SqliteDbConfiguration get config;
  @JsonKey(ignore: true)
  _$$DatabaseConfig_SqliteImplCopyWith<_$DatabaseConfig_SqliteImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DatabaseConfig_SledImplCopyWith<$Res> {
  factory _$$DatabaseConfig_SledImplCopyWith(_$DatabaseConfig_SledImpl value,
          $Res Function(_$DatabaseConfig_SledImpl) then) =
      __$$DatabaseConfig_SledImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SledDbConfiguration config});
}

/// @nodoc
class __$$DatabaseConfig_SledImplCopyWithImpl<$Res>
    extends _$DatabaseConfigCopyWithImpl<$Res, _$DatabaseConfig_SledImpl>
    implements _$$DatabaseConfig_SledImplCopyWith<$Res> {
  __$$DatabaseConfig_SledImplCopyWithImpl(_$DatabaseConfig_SledImpl _value,
      $Res Function(_$DatabaseConfig_SledImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
  }) {
    return _then(_$DatabaseConfig_SledImpl(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as SledDbConfiguration,
    ));
  }
}

/// @nodoc

class _$DatabaseConfig_SledImpl extends DatabaseConfig_Sled {
  const _$DatabaseConfig_SledImpl({required this.config}) : super._();

  @override
  final SledDbConfiguration config;

  @override
  String toString() {
    return 'DatabaseConfig.sled(config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatabaseConfig_SledImpl &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DatabaseConfig_SledImplCopyWith<_$DatabaseConfig_SledImpl> get copyWith =>
      __$$DatabaseConfig_SledImplCopyWithImpl<_$DatabaseConfig_SledImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() memory,
    required TResult Function(SqliteDbConfiguration config) sqlite,
    required TResult Function(SledDbConfiguration config) sled,
  }) {
    return sled(config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? memory,
    TResult? Function(SqliteDbConfiguration config)? sqlite,
    TResult? Function(SledDbConfiguration config)? sled,
  }) {
    return sled?.call(config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? memory,
    TResult Function(SqliteDbConfiguration config)? sqlite,
    TResult Function(SledDbConfiguration config)? sled,
    required TResult orElse(),
  }) {
    if (sled != null) {
      return sled(config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseConfig_Memory value) memory,
    required TResult Function(DatabaseConfig_Sqlite value) sqlite,
    required TResult Function(DatabaseConfig_Sled value) sled,
  }) {
    return sled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseConfig_Memory value)? memory,
    TResult? Function(DatabaseConfig_Sqlite value)? sqlite,
    TResult? Function(DatabaseConfig_Sled value)? sled,
  }) {
    return sled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseConfig_Memory value)? memory,
    TResult Function(DatabaseConfig_Sqlite value)? sqlite,
    TResult Function(DatabaseConfig_Sled value)? sled,
    required TResult orElse(),
  }) {
    if (sled != null) {
      return sled(this);
    }
    return orElse();
  }
}

abstract class DatabaseConfig_Sled extends DatabaseConfig {
  const factory DatabaseConfig_Sled(
      {required final SledDbConfiguration config}) = _$DatabaseConfig_SledImpl;
  const DatabaseConfig_Sled._() : super._();

  SledDbConfiguration get config;
  @JsonKey(ignore: true)
  _$$DatabaseConfig_SledImplCopyWith<_$DatabaseConfig_SledImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
