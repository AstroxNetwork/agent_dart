// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Vout _$VoutFromJson(Map<String, dynamic> json) {
  return _Vout.fromJson(json);
}

/// @nodoc
mixin _$Vout {
  String get scriptpubkey => throw _privateConstructorUsedError;
  String get scriptpubkey_asm => throw _privateConstructorUsedError;
  String get scriptpubkey_type => throw _privateConstructorUsedError;
  String get scriptpubkey_address => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VoutCopyWith<Vout> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoutCopyWith<$Res> {
  factory $VoutCopyWith(Vout value, $Res Function(Vout) then) =
      _$VoutCopyWithImpl<$Res, Vout>;
  @useResult
  $Res call(
      {String scriptpubkey,
      String scriptpubkey_asm,
      String scriptpubkey_type,
      String scriptpubkey_address,
      int value});
}

/// @nodoc
class _$VoutCopyWithImpl<$Res, $Val extends Vout>
    implements $VoutCopyWith<$Res> {
  _$VoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scriptpubkey = null,
    Object? scriptpubkey_asm = null,
    Object? scriptpubkey_type = null,
    Object? scriptpubkey_address = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      scriptpubkey: null == scriptpubkey
          ? _value.scriptpubkey
          : scriptpubkey // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkey_asm: null == scriptpubkey_asm
          ? _value.scriptpubkey_asm
          : scriptpubkey_asm // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkey_type: null == scriptpubkey_type
          ? _value.scriptpubkey_type
          : scriptpubkey_type // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkey_address: null == scriptpubkey_address
          ? _value.scriptpubkey_address
          : scriptpubkey_address // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_VoutCopyWith<$Res> implements $VoutCopyWith<$Res> {
  factory _$$_VoutCopyWith(_$_Vout value, $Res Function(_$_Vout) then) =
      __$$_VoutCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String scriptpubkey,
      String scriptpubkey_asm,
      String scriptpubkey_type,
      String scriptpubkey_address,
      int value});
}

/// @nodoc
class __$$_VoutCopyWithImpl<$Res> extends _$VoutCopyWithImpl<$Res, _$_Vout>
    implements _$$_VoutCopyWith<$Res> {
  __$$_VoutCopyWithImpl(_$_Vout _value, $Res Function(_$_Vout) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scriptpubkey = null,
    Object? scriptpubkey_asm = null,
    Object? scriptpubkey_type = null,
    Object? scriptpubkey_address = null,
    Object? value = null,
  }) {
    return _then(_$_Vout(
      scriptpubkey: null == scriptpubkey
          ? _value.scriptpubkey
          : scriptpubkey // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkey_asm: null == scriptpubkey_asm
          ? _value.scriptpubkey_asm
          : scriptpubkey_asm // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkey_type: null == scriptpubkey_type
          ? _value.scriptpubkey_type
          : scriptpubkey_type // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkey_address: null == scriptpubkey_address
          ? _value.scriptpubkey_address
          : scriptpubkey_address // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Vout implements _Vout {
  _$_Vout(
      {required this.scriptpubkey,
      required this.scriptpubkey_asm,
      required this.scriptpubkey_type,
      required this.scriptpubkey_address,
      required this.value});

  factory _$_Vout.fromJson(Map<String, dynamic> json) => _$$_VoutFromJson(json);

  @override
  final String scriptpubkey;
  @override
  final String scriptpubkey_asm;
  @override
  final String scriptpubkey_type;
  @override
  final String scriptpubkey_address;
  @override
  final int value;

  @override
  String toString() {
    return 'Vout(scriptpubkey: $scriptpubkey, scriptpubkey_asm: $scriptpubkey_asm, scriptpubkey_type: $scriptpubkey_type, scriptpubkey_address: $scriptpubkey_address, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Vout &&
            (identical(other.scriptpubkey, scriptpubkey) ||
                other.scriptpubkey == scriptpubkey) &&
            (identical(other.scriptpubkey_asm, scriptpubkey_asm) ||
                other.scriptpubkey_asm == scriptpubkey_asm) &&
            (identical(other.scriptpubkey_type, scriptpubkey_type) ||
                other.scriptpubkey_type == scriptpubkey_type) &&
            (identical(other.scriptpubkey_address, scriptpubkey_address) ||
                other.scriptpubkey_address == scriptpubkey_address) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, scriptpubkey, scriptpubkey_asm,
      scriptpubkey_type, scriptpubkey_address, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VoutCopyWith<_$_Vout> get copyWith =>
      __$$_VoutCopyWithImpl<_$_Vout>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_VoutToJson(
      this,
    );
  }
}

abstract class _Vout implements Vout {
  factory _Vout(
      {required final String scriptpubkey,
      required final String scriptpubkey_asm,
      required final String scriptpubkey_type,
      required final String scriptpubkey_address,
      required final int value}) = _$_Vout;

  factory _Vout.fromJson(Map<String, dynamic> json) = _$_Vout.fromJson;

  @override
  String get scriptpubkey;
  @override
  String get scriptpubkey_asm;
  @override
  String get scriptpubkey_type;
  @override
  String get scriptpubkey_address;
  @override
  int get value;
  @override
  @JsonKey(ignore: true)
  _$$_VoutCopyWith<_$_Vout> get copyWith => throw _privateConstructorUsedError;
}
