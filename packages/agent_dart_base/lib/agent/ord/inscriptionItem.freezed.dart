// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inscriptionItem.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

InscriptionItem _$InscriptionItemFromJson(Map<String, dynamic> json) {
  return _InscriptionItem.fromJson(json);
}

/// @nodoc
mixin _$InscriptionItem {
  String get id => throw _privateConstructorUsedError;
  InscriptionDetail get detail => throw _privateConstructorUsedError;
  int? get number => throw _privateConstructorUsedError;
  int? get num => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InscriptionItemCopyWith<InscriptionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InscriptionItemCopyWith<$Res> {
  factory $InscriptionItemCopyWith(
          InscriptionItem value, $Res Function(InscriptionItem) then) =
      _$InscriptionItemCopyWithImpl<$Res, InscriptionItem>;
  @useResult
  $Res call({String id, InscriptionDetail detail, int? number, int? num});

  $InscriptionDetailCopyWith<$Res> get detail;
}

/// @nodoc
class _$InscriptionItemCopyWithImpl<$Res, $Val extends InscriptionItem>
    implements $InscriptionItemCopyWith<$Res> {
  _$InscriptionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? detail = null,
    Object? number = freezed,
    Object? num = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      detail: null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as InscriptionDetail,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InscriptionDetailCopyWith<$Res> get detail {
    return $InscriptionDetailCopyWith<$Res>(_value.detail, (value) {
      return _then(_value.copyWith(detail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_InscriptionItemCopyWith<$Res>
    implements $InscriptionItemCopyWith<$Res> {
  factory _$$_InscriptionItemCopyWith(
          _$_InscriptionItem value, $Res Function(_$_InscriptionItem) then) =
      __$$_InscriptionItemCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, InscriptionDetail detail, int? number, int? num});

  @override
  $InscriptionDetailCopyWith<$Res> get detail;
}

/// @nodoc
class __$$_InscriptionItemCopyWithImpl<$Res>
    extends _$InscriptionItemCopyWithImpl<$Res, _$_InscriptionItem>
    implements _$$_InscriptionItemCopyWith<$Res> {
  __$$_InscriptionItemCopyWithImpl(
      _$_InscriptionItem _value, $Res Function(_$_InscriptionItem) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? detail = null,
    Object? number = freezed,
    Object? num = freezed,
  }) {
    return _then(_$_InscriptionItem(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      detail: null == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as InscriptionDetail,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_InscriptionItem implements _InscriptionItem {
  _$_InscriptionItem(
      {required this.id, required this.detail, this.number, this.num});

  factory _$_InscriptionItem.fromJson(Map<String, dynamic> json) =>
      _$$_InscriptionItemFromJson(json);

  @override
  final String id;
  @override
  final InscriptionDetail detail;
  @override
  final int? number;
  @override
  final int? num;

  @override
  String toString() {
    return 'InscriptionItem(id: $id, detail: $detail, number: $number, num: $num)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InscriptionItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.num, num) || other.num == num));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, detail, number, num);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InscriptionItemCopyWith<_$_InscriptionItem> get copyWith =>
      __$$_InscriptionItemCopyWithImpl<_$_InscriptionItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_InscriptionItemToJson(
      this,
    );
  }
}

abstract class _InscriptionItem implements InscriptionItem {
  factory _InscriptionItem(
      {required final String id,
      required final InscriptionDetail detail,
      final int? number,
      final int? num}) = _$_InscriptionItem;

  factory _InscriptionItem.fromJson(Map<String, dynamic> json) =
      _$_InscriptionItem.fromJson;

  @override
  String get id;
  @override
  InscriptionDetail get detail;
  @override
  int? get number;
  @override
  int? get num;
  @override
  @JsonKey(ignore: true)
  _$$_InscriptionItemCopyWith<_$_InscriptionItem> get copyWith =>
      throw _privateConstructorUsedError;
}
