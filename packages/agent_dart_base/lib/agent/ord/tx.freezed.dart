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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
  TxStatus get status => throw _privateConstructorUsedError;
  set status(TxStatus value) => throw _privateConstructorUsedError;

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
      int fee,
      TxStatus status});

  $TxStatusCopyWith<$Res> get status;
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
    Object? status = null,
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
abstract class _$$TxImplCopyWith<$Res> implements $TxCopyWith<$Res> {
  factory _$$TxImplCopyWith(_$TxImpl value, $Res Function(_$TxImpl) then) =
      __$$TxImplCopyWithImpl<$Res>;
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
      int fee,
      TxStatus status});

  @override
  $TxStatusCopyWith<$Res> get status;
}

/// @nodoc
class __$$TxImplCopyWithImpl<$Res> extends _$TxCopyWithImpl<$Res, _$TxImpl>
    implements _$$TxImplCopyWith<$Res> {
  __$$TxImplCopyWithImpl(_$TxImpl _value, $Res Function(_$TxImpl) _then)
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
    Object? status = null,
  }) {
    return _then(_$TxImpl(
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TxStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TxImpl implements _Tx {
  _$TxImpl(
      {required this.txid,
      required this.version,
      required this.locktime,
      required this.vin,
      required this.vout,
      required this.size,
      required this.weight,
      required this.fee,
      required this.status});

  factory _$TxImpl.fromJson(Map<String, dynamic> json) =>
      _$$TxImplFromJson(json);

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
  TxStatus status;

  @override
  String toString() {
    return 'Tx(txid: $txid, version: $version, locktime: $locktime, vin: $vin, vout: $vout, size: $size, weight: $weight, fee: $fee, status: $status)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TxImplCopyWith<_$TxImpl> get copyWith =>
      __$$TxImplCopyWithImpl<_$TxImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TxImplToJson(
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
      required int fee,
      required TxStatus status}) = _$TxImpl;

  factory _Tx.fromJson(Map<String, dynamic> json) = _$TxImpl.fromJson;

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
  TxStatus get status;
  set status(TxStatus value);
  @override
  @JsonKey(ignore: true)
  _$$TxImplCopyWith<_$TxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Vin _$VinFromJson(Map<String, dynamic> json) {
  return _Vin.fromJson(json);
}

/// @nodoc
mixin _$Vin {
  @JsonKey(name: 'txid')
  String get txid => throw _privateConstructorUsedError;
  @JsonKey(name: 'txid')
  set txid(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'vout')
  int get vout => throw _privateConstructorUsedError;
  @JsonKey(name: 'vout')
  set vout(int value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'prevout')
  Vout get prevout => throw _privateConstructorUsedError;
  @JsonKey(name: 'prevout')
  set prevout(Vout value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'scriptsig')
  String get scriptSig => throw _privateConstructorUsedError;
  @JsonKey(name: 'scriptsig')
  set scriptSig(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'scriptsig_asm')
  String get scriptsigAsm => throw _privateConstructorUsedError;
  @JsonKey(name: 'scriptsig_asm')
  set scriptsigAsm(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'witness')
  List<String> get witness => throw _privateConstructorUsedError;
  @JsonKey(name: 'witness')
  set witness(List<String> value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_coinbase')
  bool get isCoinbase => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_coinbase')
  set isCoinbase(bool value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'sequence')
  int get sequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'sequence')
  set sequence(int value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VinCopyWith<Vin> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VinCopyWith<$Res> {
  factory $VinCopyWith(Vin value, $Res Function(Vin) then) =
      _$VinCopyWithImpl<$Res, Vin>;
  @useResult
  $Res call(
      {@JsonKey(name: 'txid') String txid,
      @JsonKey(name: 'vout') int vout,
      @JsonKey(name: 'prevout') Vout prevout,
      @JsonKey(name: 'scriptsig') String scriptSig,
      @JsonKey(name: 'scriptsig_asm') String scriptsigAsm,
      @JsonKey(name: 'witness') List<String> witness,
      @JsonKey(name: 'is_coinbase') bool isCoinbase,
      @JsonKey(name: 'sequence') int sequence});

  $VoutCopyWith<$Res> get prevout;
}

/// @nodoc
class _$VinCopyWithImpl<$Res, $Val extends Vin> implements $VinCopyWith<$Res> {
  _$VinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? vout = null,
    Object? prevout = null,
    Object? scriptSig = null,
    Object? scriptsigAsm = null,
    Object? witness = null,
    Object? isCoinbase = null,
    Object? sequence = null,
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
      prevout: null == prevout
          ? _value.prevout
          : prevout // ignore: cast_nullable_to_non_nullable
              as Vout,
      scriptSig: null == scriptSig
          ? _value.scriptSig
          : scriptSig // ignore: cast_nullable_to_non_nullable
              as String,
      scriptsigAsm: null == scriptsigAsm
          ? _value.scriptsigAsm
          : scriptsigAsm // ignore: cast_nullable_to_non_nullable
              as String,
      witness: null == witness
          ? _value.witness
          : witness // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCoinbase: null == isCoinbase
          ? _value.isCoinbase
          : isCoinbase // ignore: cast_nullable_to_non_nullable
              as bool,
      sequence: null == sequence
          ? _value.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VoutCopyWith<$Res> get prevout {
    return $VoutCopyWith<$Res>(_value.prevout, (value) {
      return _then(_value.copyWith(prevout: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VinImplCopyWith<$Res> implements $VinCopyWith<$Res> {
  factory _$$VinImplCopyWith(_$VinImpl value, $Res Function(_$VinImpl) then) =
      __$$VinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'txid') String txid,
      @JsonKey(name: 'vout') int vout,
      @JsonKey(name: 'prevout') Vout prevout,
      @JsonKey(name: 'scriptsig') String scriptSig,
      @JsonKey(name: 'scriptsig_asm') String scriptsigAsm,
      @JsonKey(name: 'witness') List<String> witness,
      @JsonKey(name: 'is_coinbase') bool isCoinbase,
      @JsonKey(name: 'sequence') int sequence});

  @override
  $VoutCopyWith<$Res> get prevout;
}

/// @nodoc
class __$$VinImplCopyWithImpl<$Res> extends _$VinCopyWithImpl<$Res, _$VinImpl>
    implements _$$VinImplCopyWith<$Res> {
  __$$VinImplCopyWithImpl(_$VinImpl _value, $Res Function(_$VinImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? vout = null,
    Object? prevout = null,
    Object? scriptSig = null,
    Object? scriptsigAsm = null,
    Object? witness = null,
    Object? isCoinbase = null,
    Object? sequence = null,
  }) {
    return _then(_$VinImpl(
      txid: null == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String,
      vout: null == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int,
      prevout: null == prevout
          ? _value.prevout
          : prevout // ignore: cast_nullable_to_non_nullable
              as Vout,
      scriptSig: null == scriptSig
          ? _value.scriptSig
          : scriptSig // ignore: cast_nullable_to_non_nullable
              as String,
      scriptsigAsm: null == scriptsigAsm
          ? _value.scriptsigAsm
          : scriptsigAsm // ignore: cast_nullable_to_non_nullable
              as String,
      witness: null == witness
          ? _value.witness
          : witness // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCoinbase: null == isCoinbase
          ? _value.isCoinbase
          : isCoinbase // ignore: cast_nullable_to_non_nullable
              as bool,
      sequence: null == sequence
          ? _value.sequence
          : sequence // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VinImpl implements _Vin {
  const _$VinImpl(
      {@JsonKey(name: 'txid') required this.txid,
      @JsonKey(name: 'vout') required this.vout,
      @JsonKey(name: 'prevout') required this.prevout,
      @JsonKey(name: 'scriptsig') required this.scriptSig,
      @JsonKey(name: 'scriptsig_asm') required this.scriptsigAsm,
      @JsonKey(name: 'witness') required this.witness,
      @JsonKey(name: 'is_coinbase') required this.isCoinbase,
      @JsonKey(name: 'sequence') required this.sequence});

  factory _$VinImpl.fromJson(Map<String, dynamic> json) =>
      _$$VinImplFromJson(json);

  @override
  @JsonKey(name: 'txid')
  String txid;
  @override
  @JsonKey(name: 'vout')
  int vout;
  @override
  @JsonKey(name: 'prevout')
  Vout prevout;
  @override
  @JsonKey(name: 'scriptsig')
  String scriptSig;
  @override
  @JsonKey(name: 'scriptsig_asm')
  String scriptsigAsm;
  @override
  @JsonKey(name: 'witness')
  List<String> witness;
  @override
  @JsonKey(name: 'is_coinbase')
  bool isCoinbase;
  @override
  @JsonKey(name: 'sequence')
  int sequence;

  @override
  String toString() {
    return 'Vin(txid: $txid, vout: $vout, prevout: $prevout, scriptSig: $scriptSig, scriptsigAsm: $scriptsigAsm, witness: $witness, isCoinbase: $isCoinbase, sequence: $sequence)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VinImplCopyWith<_$VinImpl> get copyWith =>
      __$$VinImplCopyWithImpl<_$VinImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VinImplToJson(
      this,
    );
  }
}

abstract class _Vin implements Vin {
  const factory _Vin(
      {@JsonKey(name: 'txid') required String txid,
      @JsonKey(name: 'vout') required int vout,
      @JsonKey(name: 'prevout') required Vout prevout,
      @JsonKey(name: 'scriptsig') required String scriptSig,
      @JsonKey(name: 'scriptsig_asm') required String scriptsigAsm,
      @JsonKey(name: 'witness') required List<String> witness,
      @JsonKey(name: 'is_coinbase') required bool isCoinbase,
      @JsonKey(name: 'sequence') required int sequence}) = _$VinImpl;

  factory _Vin.fromJson(Map<String, dynamic> json) = _$VinImpl.fromJson;

  @override
  @JsonKey(name: 'txid')
  String get txid;
  @JsonKey(name: 'txid')
  set txid(String value);
  @override
  @JsonKey(name: 'vout')
  int get vout;
  @JsonKey(name: 'vout')
  set vout(int value);
  @override
  @JsonKey(name: 'prevout')
  Vout get prevout;
  @JsonKey(name: 'prevout')
  set prevout(Vout value);
  @override
  @JsonKey(name: 'scriptsig')
  String get scriptSig;
  @JsonKey(name: 'scriptsig')
  set scriptSig(String value);
  @override
  @JsonKey(name: 'scriptsig_asm')
  String get scriptsigAsm;
  @JsonKey(name: 'scriptsig_asm')
  set scriptsigAsm(String value);
  @override
  @JsonKey(name: 'witness')
  List<String> get witness;
  @JsonKey(name: 'witness')
  set witness(List<String> value);
  @override
  @JsonKey(name: 'is_coinbase')
  bool get isCoinbase;
  @JsonKey(name: 'is_coinbase')
  set isCoinbase(bool value);
  @override
  @JsonKey(name: 'sequence')
  int get sequence;
  @JsonKey(name: 'sequence')
  set sequence(int value);
  @override
  @JsonKey(ignore: true)
  _$$VinImplCopyWith<_$VinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Vout _$VoutFromJson(Map<String, dynamic> json) {
  return _Vout.fromJson(json);
}

/// @nodoc
mixin _$Vout {
  @JsonKey(name: 'scriptpubkey')
  String get scriptPubkey => throw _privateConstructorUsedError;
  @JsonKey(name: 'scriptpubkey_asm')
  String get scriptpubkeyAsm => throw _privateConstructorUsedError;
  @JsonKey(name: 'scriptpubkey_type')
  String get scriptpubkeyType => throw _privateConstructorUsedError;
  @JsonKey(name: 'scriptpubkey_address')
  String get scriptpubkeyAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'value')
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
      {@JsonKey(name: 'scriptpubkey') String scriptPubkey,
      @JsonKey(name: 'scriptpubkey_asm') String scriptpubkeyAsm,
      @JsonKey(name: 'scriptpubkey_type') String scriptpubkeyType,
      @JsonKey(name: 'scriptpubkey_address') String scriptpubkeyAddress,
      @JsonKey(name: 'value') int value});
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
    Object? scriptPubkey = null,
    Object? scriptpubkeyAsm = null,
    Object? scriptpubkeyType = null,
    Object? scriptpubkeyAddress = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      scriptPubkey: null == scriptPubkey
          ? _value.scriptPubkey
          : scriptPubkey // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkeyAsm: null == scriptpubkeyAsm
          ? _value.scriptpubkeyAsm
          : scriptpubkeyAsm // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkeyType: null == scriptpubkeyType
          ? _value.scriptpubkeyType
          : scriptpubkeyType // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkeyAddress: null == scriptpubkeyAddress
          ? _value.scriptpubkeyAddress
          : scriptpubkeyAddress // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VoutImplCopyWith<$Res> implements $VoutCopyWith<$Res> {
  factory _$$VoutImplCopyWith(
          _$VoutImpl value, $Res Function(_$VoutImpl) then) =
      __$$VoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'scriptpubkey') String scriptPubkey,
      @JsonKey(name: 'scriptpubkey_asm') String scriptpubkeyAsm,
      @JsonKey(name: 'scriptpubkey_type') String scriptpubkeyType,
      @JsonKey(name: 'scriptpubkey_address') String scriptpubkeyAddress,
      @JsonKey(name: 'value') int value});
}

/// @nodoc
class __$$VoutImplCopyWithImpl<$Res>
    extends _$VoutCopyWithImpl<$Res, _$VoutImpl>
    implements _$$VoutImplCopyWith<$Res> {
  __$$VoutImplCopyWithImpl(_$VoutImpl _value, $Res Function(_$VoutImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scriptPubkey = null,
    Object? scriptpubkeyAsm = null,
    Object? scriptpubkeyType = null,
    Object? scriptpubkeyAddress = null,
    Object? value = null,
  }) {
    return _then(_$VoutImpl(
      scriptPubkey: null == scriptPubkey
          ? _value.scriptPubkey
          : scriptPubkey // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkeyAsm: null == scriptpubkeyAsm
          ? _value.scriptpubkeyAsm
          : scriptpubkeyAsm // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkeyType: null == scriptpubkeyType
          ? _value.scriptpubkeyType
          : scriptpubkeyType // ignore: cast_nullable_to_non_nullable
              as String,
      scriptpubkeyAddress: null == scriptpubkeyAddress
          ? _value.scriptpubkeyAddress
          : scriptpubkeyAddress // ignore: cast_nullable_to_non_nullable
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
class _$VoutImpl implements _Vout {
  _$VoutImpl(
      {@JsonKey(name: 'scriptpubkey') required this.scriptPubkey,
      @JsonKey(name: 'scriptpubkey_asm') required this.scriptpubkeyAsm,
      @JsonKey(name: 'scriptpubkey_type') required this.scriptpubkeyType,
      @JsonKey(name: 'scriptpubkey_address') required this.scriptpubkeyAddress,
      @JsonKey(name: 'value') required this.value});

  factory _$VoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoutImplFromJson(json);

  @override
  @JsonKey(name: 'scriptpubkey')
  final String scriptPubkey;
  @override
  @JsonKey(name: 'scriptpubkey_asm')
  final String scriptpubkeyAsm;
  @override
  @JsonKey(name: 'scriptpubkey_type')
  final String scriptpubkeyType;
  @override
  @JsonKey(name: 'scriptpubkey_address')
  final String scriptpubkeyAddress;
  @override
  @JsonKey(name: 'value')
  final int value;

  @override
  String toString() {
    return 'Vout(scriptPubkey: $scriptPubkey, scriptpubkeyAsm: $scriptpubkeyAsm, scriptpubkeyType: $scriptpubkeyType, scriptpubkeyAddress: $scriptpubkeyAddress, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoutImpl &&
            (identical(other.scriptPubkey, scriptPubkey) ||
                other.scriptPubkey == scriptPubkey) &&
            (identical(other.scriptpubkeyAsm, scriptpubkeyAsm) ||
                other.scriptpubkeyAsm == scriptpubkeyAsm) &&
            (identical(other.scriptpubkeyType, scriptpubkeyType) ||
                other.scriptpubkeyType == scriptpubkeyType) &&
            (identical(other.scriptpubkeyAddress, scriptpubkeyAddress) ||
                other.scriptpubkeyAddress == scriptpubkeyAddress) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, scriptPubkey, scriptpubkeyAsm,
      scriptpubkeyType, scriptpubkeyAddress, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VoutImplCopyWith<_$VoutImpl> get copyWith =>
      __$$VoutImplCopyWithImpl<_$VoutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoutImplToJson(
      this,
    );
  }
}

abstract class _Vout implements Vout {
  factory _Vout(
      {@JsonKey(name: 'scriptpubkey') required final String scriptPubkey,
      @JsonKey(name: 'scriptpubkey_asm') required final String scriptpubkeyAsm,
      @JsonKey(name: 'scriptpubkey_type')
      required final String scriptpubkeyType,
      @JsonKey(name: 'scriptpubkey_address')
      required final String scriptpubkeyAddress,
      @JsonKey(name: 'value') required final int value}) = _$VoutImpl;

  factory _Vout.fromJson(Map<String, dynamic> json) = _$VoutImpl.fromJson;

  @override
  @JsonKey(name: 'scriptpubkey')
  String get scriptPubkey;
  @override
  @JsonKey(name: 'scriptpubkey_asm')
  String get scriptpubkeyAsm;
  @override
  @JsonKey(name: 'scriptpubkey_type')
  String get scriptpubkeyType;
  @override
  @JsonKey(name: 'scriptpubkey_address')
  String get scriptpubkeyAddress;
  @override
  @JsonKey(name: 'value')
  int get value;
  @override
  @JsonKey(ignore: true)
  _$$VoutImplCopyWith<_$VoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
