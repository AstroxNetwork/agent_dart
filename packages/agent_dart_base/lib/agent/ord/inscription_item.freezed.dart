// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inscription_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$InscriptionItemImplCopyWith<$Res>
    implements $InscriptionItemCopyWith<$Res> {
  factory _$$InscriptionItemImplCopyWith(_$InscriptionItemImpl value,
          $Res Function(_$InscriptionItemImpl) then) =
      __$$InscriptionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, InscriptionDetail detail, int? number, int? num});

  @override
  $InscriptionDetailCopyWith<$Res> get detail;
}

/// @nodoc
class __$$InscriptionItemImplCopyWithImpl<$Res>
    extends _$InscriptionItemCopyWithImpl<$Res, _$InscriptionItemImpl>
    implements _$$InscriptionItemImplCopyWith<$Res> {
  __$$InscriptionItemImplCopyWithImpl(
      _$InscriptionItemImpl _value, $Res Function(_$InscriptionItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? detail = null,
    Object? number = freezed,
    Object? num = freezed,
  }) {
    return _then(_$InscriptionItemImpl(
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
class _$InscriptionItemImpl implements _InscriptionItem {
  const _$InscriptionItemImpl(
      {required this.id,
      required this.detail,
      required this.number,
      required this.num});

  factory _$InscriptionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InscriptionItemImplFromJson(json);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InscriptionItemImpl &&
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
  _$$InscriptionItemImplCopyWith<_$InscriptionItemImpl> get copyWith =>
      __$$InscriptionItemImplCopyWithImpl<_$InscriptionItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InscriptionItemImplToJson(
      this,
    );
  }
}

abstract class _InscriptionItem implements InscriptionItem {
  const factory _InscriptionItem(
      {required final String id,
      required final InscriptionDetail detail,
      required final int? number,
      required final int? num}) = _$InscriptionItemImpl;

  factory _InscriptionItem.fromJson(Map<String, dynamic> json) =
      _$InscriptionItemImpl.fromJson;

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
  _$$InscriptionItemImplCopyWith<_$InscriptionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
