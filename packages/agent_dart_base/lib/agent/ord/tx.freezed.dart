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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
abstract class _$$_TxCopyWith<$Res> implements $TxCopyWith<$Res> {
  factory _$$_TxCopyWith(_$_Tx value, $Res Function(_$_Tx) then) =
      __$$_TxCopyWithImpl<$Res>;
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
class __$$_TxCopyWithImpl<$Res> extends _$TxCopyWithImpl<$Res, _$_Tx>
    implements _$$_TxCopyWith<$Res> {
  __$$_TxCopyWithImpl(_$_Tx _value, $Res Function(_$_Tx) _then)
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
    return _then(_$_Tx(
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
class _$_Tx implements _Tx {
  _$_Tx(
      {required this.txid,
      required this.version,
      required this.locktime,
      required this.vin,
      required this.vout,
      required this.size,
      required this.weight,
      required this.fee,
      required this.status});

  factory _$_Tx.fromJson(Map<String, dynamic> json) => _$$_TxFromJson(json);

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
  _$$_TxCopyWith<_$_Tx> get copyWith =>
      __$$_TxCopyWithImpl<_$_Tx>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TxToJson(
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
      required TxStatus status}) = _$_Tx;

  factory _Tx.fromJson(Map<String, dynamic> json) = _$_Tx.fromJson;

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
  _$$_TxCopyWith<_$_Tx> get copyWith => throw _privateConstructorUsedError;
}

Vin _$VinFromJson(Map<String, dynamic> json) {
  return _Vin.fromJson(json);
}

/// @nodoc
mixin _$Vin {
  String get txid => throw _privateConstructorUsedError;
  set txid(String value) => throw _privateConstructorUsedError;
  int get vout => throw _privateConstructorUsedError;
  set vout(int value) => throw _privateConstructorUsedError;
  Vout get prevout => throw _privateConstructorUsedError;
  set prevout(Vout value) => throw _privateConstructorUsedError;
  String get scriptsig => throw _privateConstructorUsedError;
  set scriptsig(String value) => throw _privateConstructorUsedError;
  String get scriptsig_asm => throw _privateConstructorUsedError;
  set scriptsig_asm(String value) => throw _privateConstructorUsedError;
  List<String> get witness => throw _privateConstructorUsedError;
  set witness(List<String> value) => throw _privateConstructorUsedError;
  bool get is_coinbase => throw _privateConstructorUsedError;
  set is_coinbase(bool value) => throw _privateConstructorUsedError;
  int get sequence => throw _privateConstructorUsedError;
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
      {String txid,
      int vout,
      Vout prevout,
      String scriptsig,
      String scriptsig_asm,
      List<String> witness,
      bool is_coinbase,
      int sequence});

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
    Object? scriptsig = null,
    Object? scriptsig_asm = null,
    Object? witness = null,
    Object? is_coinbase = null,
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
      scriptsig: null == scriptsig
          ? _value.scriptsig
          : scriptsig // ignore: cast_nullable_to_non_nullable
              as String,
      scriptsig_asm: null == scriptsig_asm
          ? _value.scriptsig_asm
          : scriptsig_asm // ignore: cast_nullable_to_non_nullable
              as String,
      witness: null == witness
          ? _value.witness
          : witness // ignore: cast_nullable_to_non_nullable
              as List<String>,
      is_coinbase: null == is_coinbase
          ? _value.is_coinbase
          : is_coinbase // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_VinCopyWith<$Res> implements $VinCopyWith<$Res> {
  factory _$$_VinCopyWith(_$_Vin value, $Res Function(_$_Vin) then) =
      __$$_VinCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String txid,
      int vout,
      Vout prevout,
      String scriptsig,
      String scriptsig_asm,
      List<String> witness,
      bool is_coinbase,
      int sequence});

  @override
  $VoutCopyWith<$Res> get prevout;
}

/// @nodoc
class __$$_VinCopyWithImpl<$Res> extends _$VinCopyWithImpl<$Res, _$_Vin>
    implements _$$_VinCopyWith<$Res> {
  __$$_VinCopyWithImpl(_$_Vin _value, $Res Function(_$_Vin) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = null,
    Object? vout = null,
    Object? prevout = null,
    Object? scriptsig = null,
    Object? scriptsig_asm = null,
    Object? witness = null,
    Object? is_coinbase = null,
    Object? sequence = null,
  }) {
    return _then(_$_Vin(
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
      scriptsig: null == scriptsig
          ? _value.scriptsig
          : scriptsig // ignore: cast_nullable_to_non_nullable
              as String,
      scriptsig_asm: null == scriptsig_asm
          ? _value.scriptsig_asm
          : scriptsig_asm // ignore: cast_nullable_to_non_nullable
              as String,
      witness: null == witness
          ? _value.witness
          : witness // ignore: cast_nullable_to_non_nullable
              as List<String>,
      is_coinbase: null == is_coinbase
          ? _value.is_coinbase
          : is_coinbase // ignore: cast_nullable_to_non_nullable
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
class _$_Vin implements _Vin {
  _$_Vin(
      {required this.txid,
      required this.vout,
      required this.prevout,
      required this.scriptsig,
      required this.scriptsig_asm,
      required this.witness,
      required this.is_coinbase,
      required this.sequence});

  factory _$_Vin.fromJson(Map<String, dynamic> json) => _$$_VinFromJson(json);

  @override
  String txid;
  @override
  int vout;
  @override
  Vout prevout;
  @override
  String scriptsig;
  @override
  String scriptsig_asm;
  @override
  List<String> witness;
  @override
  bool is_coinbase;
  @override
  int sequence;

  @override
  String toString() {
    return 'Vin(txid: $txid, vout: $vout, prevout: $prevout, scriptsig: $scriptsig, scriptsig_asm: $scriptsig_asm, witness: $witness, is_coinbase: $is_coinbase, sequence: $sequence)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VinCopyWith<_$_Vin> get copyWith =>
      __$$_VinCopyWithImpl<_$_Vin>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_VinToJson(
      this,
    );
  }
}

abstract class _Vin implements Vin {
  factory _Vin(
      {required String txid,
      required int vout,
      required Vout prevout,
      required String scriptsig,
      required String scriptsig_asm,
      required List<String> witness,
      required bool is_coinbase,
      required int sequence}) = _$_Vin;

  factory _Vin.fromJson(Map<String, dynamic> json) = _$_Vin.fromJson;

  @override
  String get txid;
  set txid(String value);
  @override
  int get vout;
  set vout(int value);
  @override
  Vout get prevout;
  set prevout(Vout value);
  @override
  String get scriptsig;
  set scriptsig(String value);
  @override
  String get scriptsig_asm;
  set scriptsig_asm(String value);
  @override
  List<String> get witness;
  set witness(List<String> value);
  @override
  bool get is_coinbase;
  set is_coinbase(bool value);
  @override
  int get sequence;
  set sequence(int value);
  @override
  @JsonKey(ignore: true)
  _$$_VinCopyWith<_$_Vin> get copyWith => throw _privateConstructorUsedError;
}

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
