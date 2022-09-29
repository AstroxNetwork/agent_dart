// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:agent_dart/agent/agent.dart';
import 'package:agent_dart/principal/principal.dart' as principal;
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/map.dart';
import 'package:agent_dart/utils/number.dart';
import 'package:agent_dart/utils/u8a.dart';
import 'package:meta/meta.dart';

typedef Pipe<T> = BufferPipe<T>;
typedef PrincipalId = principal.Principal;

class IDLTypeIds {
  const IDLTypeIds._();

  static const Null = -1;
  static const Bool = -2;
  static const Nat = -3;
  static const Int = -4;

  static const Float32 = -13;
  static const Float64 = -14;
  static const Text = -15;
  static const Reserved = -16;
  static const Empty = -17;
  static const Opt = -18;
  static const Vector = -19;
  static const Record = -20;
  static const Variant = -21;
  static const Func = -22;
  static const Service = -23;
  static const Principal = -24;
}

const _magicNumber = 'DIDL';

List<TR> zipWith<TX, TY, TR>(
  List<TX> xs,
  List<TY> ys,
  TR Function(TX a, TY b) f,
) {
  return List.generate(xs.length, (i) => f(xs[i], ys[i]), growable: false);
}

Uint8List? tryToJson(CType type, dynamic value) {
  if ((type is RecordClass ||
          type is VariantClass ||
          (type is TextClass && value is! String)) &&
      // obj may be a map, must be ignore.
      value is! Map) {
    try {
      return type.encodeValue(value.toJson());
    } catch (e) {
      return null;
    }
  }
  return null;
}

/// An IDL Type Table, which precedes the data in the stream.
class TypeTable {
  // List of types. Needs to be an array as the index needs to be stable.
  final List<Uint8List> _types = [];

  final Map<String, int> _idx = <String, int>{};

  bool has(CType obj) {
    return _idx.containsKey(obj.name);
  }

  void add<T>(ConstructType<T> type, Uint8List buf) {
    final idx = _types.length;
    _idx.putIfAbsent(type.name, () => idx);
    _types.add(buf);
  }

  void merge<T>(ConstructType<T> obj, String knot) {
    final idx = _idx[obj.name];
    final knotIdx = _idx[knot];
    if (idx == null) {
      throw StateError('Missing type index for $obj.');
    }
    if (knotIdx == null) {
      throw StateError('Missing type index for $knot.');
    }
    _types[idx] = _types[knotIdx];

    // Delete the type.
    _types.removeAt(knotIdx); // _types.splice(knotIdx, 1);
    _idx.remove(knot);
  }

  Uint8List encode() {
    final len = lebEncode(_types.length);
    final buf = u8aConcat(_types);
    final result = List<int>.from(len)..addAll(buf);
    return Uint8List.fromList(result);
  }

  Uint8List indexOf(String typeName) {
    if (!_idx.containsKey(typeName)) {
      throw StateError('Missing type index for $typeName.');
    }
    return slebEncode(_idx[typeName] ?? 0);
  }
}

@immutable
abstract class Visitor<D, R> {
  const Visitor();

  R visitType<T>(CType<T> t, D data);

  R visitPrimitive<T>(PrimitiveType<T> t, D data) {
    return visitType(t, data);
  }

  R visitEmpty(EmptyClass t, D data) {
    return visitPrimitive(t, data);
  }

  R visitBool(BoolClass t, D data) {
    return visitPrimitive(t, data);
  }

  R visitNull(NullClass t, D data) {
    return visitPrimitive(t, data);
  }

  R visitReserved(ReservedClass t, D data) {
    return visitPrimitive(t, data);
  }

  R visitText(TextClass t, D data) {
    return visitPrimitive(t, data);
  }

  R visitNumber<T>(PrimitiveType<T> t, D data) {
    return visitPrimitive(t, data);
  }

  R visitInt(IntClass t, D data) {
    return visitNumber(t, data);
  }

  R visitNat(NatClass t, D data) {
    return visitNumber(t, data);
  }

  R visitFloat(FloatClass t, D data) {
    return visitPrimitive(t, data);
  }

  R visitFixedInt(FixedIntClass t, D data) {
    return visitNumber(t, data);
  }

  R visitFixedNat(FixedNatClass t, D data) {
    return visitNumber(t, data);
  }

  R visitPrincipal(PrincipalClass t, D data) {
    return visitPrimitive(t, data);
  }

  R visitConstruct<T>(ConstructType<T> t, D data) {
    return visitType(t, data);
  }

  R visitVec<T>(Vec<T> t, CType<T> ty, D data) {
    return visitConstruct(t, data);
  }

  R visitOpt<T>(Opt<T> t, CType<T> ty, D data) {
    return visitConstruct(t, data);
  }

  R visitRecord<T>(Record t, List<dynamic> fields, D data) {
    return visitConstruct(t, data);
  }

  R visitTuple<T>(Tuple t, List<CType> components, D data) {
    return visitConstruct(t, data);
  }

  R visitVariant(Variant t, List fields, D data) {
    return visitConstruct(t, data);
  }

  R visitRec<T>(Rec<T> t, ConstructType<T> ty, D data) {
    return visitConstruct(ty, data);
  }

  R visitFunc(Func t, D data) {
    return visitConstruct(t, data);
  }

  R visitService(Service t, D data) {
    return visitConstruct(t, data);
  }
}

/// Represents an IDL type.
abstract class CType<T> {
  const CType();

  String get name;

  R accept<D, R>(Visitor<D, R> v, D d);

  /* Display type name */
  String display() {
    return name;
  }

  String valueToString(T x) {
    return jsonEncode(x);
  }

  /* Implement `T` in the IDL spec, only needed for non-primitive types */
  void buildTypeTable(TypeTable typeTable) {
    if (!typeTable.has(this)) {
      _buildTypeTableImpl(typeTable);
    }
  }

  /// Assert that JavaScript's `x` is the proper type represented by this
  /// Type.
  bool covariant(dynamic x); //  x is T;

  /// Encode the value. This needs to be public because it is used by
  /// encodeValue() from different types.
  /// @internal
  Uint8List encodeValue(T x);

  /// Implement `I` in the IDL spec.
  /// Encode this type for the type table.
  Uint8List encodeType(TypeTable? typeTable);

  CType checkType(CType t);

  T decodeValue(Pipe x, CType t);

  void _buildTypeTableImpl(TypeTable typeTable);
}

abstract class PrimitiveType<T> extends CType<T> {
  const PrimitiveType();

  @override
  CType checkType(CType t) {
    if (name != t.name) {
      throw TypeError();
    }
    return t;
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    // No type table encoding for Primitive types.
    return;
  }
}

abstract class ConstructType<T> extends CType<T> {
  const ConstructType();

  @override
  ConstructType checkType(CType t) {
    if (t is RecClass) {
      final ty = t.getType();
      if (ty == null) {
        throw UnsupportedError('Type is unsupported.');
      }
      return ty;
    }
    throw TypeError();
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return typeTable!.indexOf(name);
  }
}

class EmptyClass<T> extends PrimitiveType<T> {
  const EmptyClass._();

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitEmpty(this, d);
  }

  @override
  bool covariant(x) => false;

  @override
  T decodeValue(Pipe x, CType t) {
    throw UnsupportedError('Empty cannot appear as an output.');
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Empty);
  }

  @override
  Uint8List encodeValue(x) {
    throw UnsupportedError('Empty cannot appear as a function argument.');
  }

  @override
  String valueToString(T x) {
    throw UnsupportedError('Empty cannot appear as a value.');
  }

  @override
  String get name => 'empty';
}

/// Represents an IDL Bool
class BoolClass extends PrimitiveType<bool> {
  const BoolClass._();

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitBool(this, d);
  }

  @override
  bool covariant(x) => x is bool;

  @override
  bool decodeValue(Pipe x, CType t) {
    checkType(t);
    final k = Uint8List.fromList(safeRead<int>(x as Pipe<int>, 1)).toHex();
    if (k == '00') {
      return false;
    } else if (k == '01') {
      return true;
    }
    throw RangeError('Boolean value out of range.');
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Bool);
  }

  @override
  Uint8List encodeValue(bool x) {
    return Int8List.fromList([x ? 1 : 0]).buffer.asUint8List();
  }

  @override
  String get name => 'bool';
}

// ignore: prefer_void_to_null
class NullClass extends PrimitiveType<Null> {
  const NullClass._();

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitNull(this, d);
  }

  @override
  bool covariant(x) {
    return x == null;
  }

  @override
  Null decodeValue(Pipe x, CType t) {
    checkType(t);
    return null;
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Null);
  }

  @override
  // ignore: prefer_void_to_null
  Uint8List encodeValue(Null x) {
    return Uint8List.fromList([]);
  }

  @override
  get name => 'null';
}

/// A reserved class with no usages.
class ReservedClass extends PrimitiveType<dynamic> {
  const ReservedClass._();

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitReserved(this, d);
  }

  @override
  bool covariant(x) => true;

  @override
  dynamic decodeValue(Pipe x, CType t) {
    if (t.name != name) {
      t.decodeValue(x, t);
    }
    return null;
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Reserved);
  }

  @override
  Uint8List encodeValue(x) {
    return Uint8List.fromList([]);
  }

  @override
  String get name => 'reserved';
}

bool _isValidUTF8(Uint8List buf) {
  return u8aEq(
    buf.u8aToString().plainToU8a(useDartEncode: true),
    buf,
  );
}

class TextClass extends PrimitiveType<String> {
  const TextClass._();

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitText(this, d);
  }

  @override
  bool covariant(dynamic x) {
    return x is String;
  }

  @override
  Uint8List encodeValue(String x) {
    final buf = x.plainToU8a(useDartEncode: true);
    final len = lebEncode(buf.length);
    return u8aConcat([len, buf]);
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Text);
  }

  @override
  String decodeValue(Pipe x, CType t) {
    checkType(t);
    final len = lebDecode(x);
    final buf = safeRead(x as Pipe<int>, len.toInt());
    if (!_isValidUTF8(Uint8List.fromList(buf))) {
      throw ArgumentError('Not a valid UTF-8 text.');
    }
    return Uint8List.fromList(buf).u8aToString();
  }

  @override
  String get name => 'text';

  @override
  String valueToString(String x) => '"$x"';
}

/// Implicit types [BigInt] | [int].
class IntClass extends PrimitiveType {
  const IntClass._();

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitInt(this, d);
  }

  @override
  bool covariant(x) {
    return x is BigInt || x is int;
  }

  @override
  dynamic decodeValue(Pipe x, CType t) {
    checkType(t);
    return slebDecode(x);
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Int);
  }

  @override
  Uint8List encodeValue(x) {
    return slebEncode(x);
  }

  @override
  String get name => 'int';

  @override
  String valueToString(x) => x.toString();
}

class NatClass extends PrimitiveType {
  const NatClass._();

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitNat(this, d);
  }

  @override
  bool covariant(x) {
    return (x is BigInt && x >= BigInt.zero) || (x is int && x >= 0);
  }

  @override
  BigInt decodeValue(Pipe x, CType t) {
    checkType(t);
    return lebDecode(x);
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Nat);
  }

  @override
  Uint8List encodeValue(x) {
    return lebEncode(x);
  }

  @override
  String get name => 'nat';

  @override
  String valueToString(x) => x.toString();
}

class FloatClass extends PrimitiveType<num> {
  const FloatClass._(
    this._bits,
  ) : assert(_bits == 32 || _bits == 64, 'Bits is not a valid float type.');

  final int _bits;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitFloat(this, d);
  }

  @override
  bool covariant(x) {
    return x is num;
  }

  @override
  decodeValue(Pipe x, CType t) {
    checkType(t);
    final k = safeRead(x as Pipe<int>, (_bits / 8).ceil());
    if (_bits == 32) {
      return Uint8List.fromList(k)
          .buffer
          .asByteData()
          .getFloat32(0, Endian.little);
    } else {
      return Uint8List.fromList(k)
          .buffer
          .asByteData()
          .getFloat64(0, Endian.little);
    }
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    final opcode = _bits == 32 ? IDLTypeIds.Float32 : IDLTypeIds.Float64;
    return slebEncode(opcode);
  }

  @override
  Uint8List encodeValue(x) {
    // const buf = Buffer.allocUnsafe(this._bits / 8);
    final length = (_bits / 8).ceil();
    final byte = ByteData(length);

    _bits == 32
        ? byte.setFloat32(0, x is! double ? x.toDouble() : x, Endian.little)
        : byte.setFloat64(0, x is! double ? x.toDouble() : x, Endian.little);
    return byte.buffer.asUint8List();
  }

  @override
  get name => 'float$_bits';

  @override
  String valueToString(num x) => x.toString();
}

class FixedIntClass extends PrimitiveType {
  const FixedIntClass._(this._bits);

  final int _bits;

  int get bits => _bits;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitFixedInt(this, d);
  }

  @override
  bool covariant(x) {
    final min = BigInt.from(2).pow(_bits - 1) * BigInt.from(-1);
    final max = BigInt.from(2).pow(_bits - 1) - BigInt.one;
    if (x is BigInt) {
      return x >= min && x <= max;
    } else if (x is int) {
      final v = BigInt.from(x);
      return v >= min && v <= max;
    } else {
      return false;
    }
  }

  @override
  dynamic decodeValue(Pipe x, CType t) {
    checkType(t);
    final BigInt num = readIntLE(x, (_bits / 8).ceil());

    if (_bits <= 32) {
      return num.toInt();
    } else {
      // dart int has 64 bit width, should be safe.
      return num;
    }
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    final offset = log2(_bits) - 3;
    return slebEncode(-9 - offset);
  }

  @override
  Uint8List encodeValue(dynamic x) {
    assert(
      x is int || x is BigInt,
      'value with ${x.runtimeType} has to be int or BigInt',
    );
    return writeIntLE(x, (_bits / 8).ceil());
  }

  @override
  String get name => 'int$_bits';

  @override
  String valueToString(dynamic x) => x.toString();
}

class FixedNatClass extends PrimitiveType<dynamic> {
  const FixedNatClass._(this._bits);

  final int _bits;

  int get bits => _bits;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitFixedNat(this, d);
  }

  @override
  bool covariant(x) {
    final max = BigInt.from(2).pow(_bits);
    if (x is BigInt && x >= BigInt.zero) {
      return x < max;
    } else if (x is int && x >= 0) {
      final v = BigInt.from(x);
      return v < max;
    } else {
      return false;
    }
  }

  @override
  dynamic decodeValue(Pipe x, CType t) {
    checkType(t);
    final num = readUIntLE(x, (_bits / 8).ceil());
    if (_bits <= 32) {
      return num.toInt();
    } else {
      return num;
    }
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    final offset = log2(_bits) - 3;
    return slebEncode(-5 - offset);
  }

  @override
  Uint8List encodeValue(x) {
    return writeUIntLE(x, (_bits / 8).ceil());
  }

  @override
  String get name => 'nat$_bits';

  @override
  String valueToString(dynamic x) {
    return x.toString();
  }
}

class VecClass<T> extends ConstructType<List<T>> {
  const VecClass(this._type);

  final CType<T> _type;

  CType<T> get type => _type;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitVec(this, _type, d);
  }

  @override
  bool covariant(x) {
    return (x is List) && x.every((v) => _type.covariant(v));
  }

  @override
  Uint8List encodeValue(dynamic x) {
    final len = lebEncode(x.length);
    return u8aConcat([
      len,
      ...x.map((dynamic d) => tryToJson(_type, d) ?? _type.encodeValue(d))
    ]);
  }

  @override
  _buildTypeTableImpl(TypeTable typeTable) {
    _type.buildTypeTable(typeTable);

    final opCode = slebEncode(IDLTypeIds.Vector);
    final buffer = _type.encodeType(typeTable);
    typeTable.add(this, u8aConcat([opCode, buffer]));
  }

  @override
  List<T> decodeValue(Pipe x, CType t) {
    final vec = checkType(t);
    if (vec is VecClass) {
      final len = lebDecode(x).toInt();
      final rets = <T>[];
      for (int i = 0; i < len; i++) {
        rets.add(_type.decodeValue(x, vec.type));
      }
      return rets;
    }
    throw TypeError();
  }

  @override
  String get name => 'vec ${_type.name}';

  @override
  String display() => 'vec ${_type.display()}';

  @override
  String valueToString(List<T> x) {
    final elements = x.map((e) => _type.valueToString(e));
    return 'vec {${elements.join('; ')}}';
  }
}

class OptClass<T> extends ConstructType<List> {
  const OptClass(this._type);

  final CType<T> _type;

  CType<T> get type => _type;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitOpt(this, _type, d);
  }

  @override
  bool covariant(x) {
    return x is List && (x.isEmpty || (x.length == 1 && _type.covariant(x[0])));
  }

  @override
  Uint8List encodeValue(List x) {
    if (x.isEmpty) {
      return Uint8List.fromList([0]);
    }

    final val = x[0];
    return u8aConcat([
      Uint8List.fromList([1]),
      tryToJson(_type, val) ?? _type.encodeValue(val)
    ]);
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    _type.buildTypeTable(typeTable);

    final opCode = slebEncode(IDLTypeIds.Opt);
    final buffer = _type.encodeType(typeTable);
    typeTable.add(this, u8aConcat([opCode, buffer]));
  }

  @override
  List<T> decodeValue(Pipe x, CType t) {
    final opt = checkType(t);
    if (opt is! OptClass) {
      throw TypeError();
    }
    final len = Uint8List.fromList(safeRead(x as Pipe<int>, 1)).toHex();
    if (len == '00') {
      return [];
    } else if (len == '01') {
      return [_type.decodeValue(x, opt._type)];
    }
    throw UnsupportedError('not an option value.');
  }

  @override
  String get name => 'opt ${_type.name}';

  @override
  String display() => 'opt ${_type.display()}';

  @override
  String valueToString(List x) {
    if (x.isEmpty) {
      return 'null';
    }
    return 'opt ${_type.valueToString(x[0])}';
  }
}

class RecordClass extends ConstructType<Map> {
  RecordClass(Map? fields)
      : _fields = Map<String, dynamic>.from(fields ?? {}).entries.toList()
          ..sort(
            (a, b) => idlLabelToId(a.key).toInt() - idlLabelToId(b.key).toInt(),
          );

  final List<MapEntry> _fields;

  List<MapEntry> get fields => _fields;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitRecord(this, _fields, d);
  }

  List<CType>? tryAsTuple() {
    final res = <CType>[];
    for (int i = 0; i < _fields.length; i++) {
      final key = _fields[i].key;
      final type = _fields[i].value;
      if (key != '_${i}_') {
        return null;
      }
      res.add(type);
    }
    return res;
  }

  @override
  bool covariant(dynamic x) {
    if (x is! Map) {
      return false;
    }
    return _fields.every((entry) {
      final k = entry.key;
      final t = entry.value;
      if (!x.containsKey(k)) {
        throw StateError("Record is missing the key '$k'.");
      }
      return t.covariant(x[k]);
    });
  }

  @override
  Uint8List encodeValue(Map x) {
    final values = _fields.map((entry) => x[entry.key]).toList();
    final buffer = zipWith<MapEntry, dynamic, Uint8List>(
      _fields,
      values,
      (entry, d) {
        final t = entry.value;
        return tryToJson(t, d) ?? t.encodeValue(d);
      },
    );
    return u8aConcat(buffer);
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (final entry in _fields) {
      entry.value.buildTypeTable(typeTable);
    }
    final opCode = slebEncode(IDLTypeIds.Record);
    final len = lebEncode(_fields.length);
    final fields = _fields.map(
      (entry) => u8aConcat([
        lebEncode(idlLabelToId(entry.key)),
        entry.value.encodeType(typeTable)
      ]),
    );
    typeTable.add(this, u8aConcat([opCode, len, u8aConcat(fields.toList())]));
  }

  @override
  Map decodeValue(Pipe x, CType t) {
    final record = checkType(t);
    if (record is! RecordClass && record is! TupleClass) {
      throw ArgumentError.value(t, 't', 'Not a record type.');
    }
    final r = <dynamic, dynamic>{};
    int idx = 0;
    final fields =
        record is RecordClass ? record.fields : (record as TupleClass).fields;
    for (final entry in fields) {
      final hash = entry.key;
      final type = entry.value;
      // [hash, type]
      if (idx >= _fields.length ||
          idlLabelToId(_fields[idx].key) != idlLabelToId(hash)) {
        // skip field
        entry.value.decodeValue(x, type);
        continue;
      }
      final expectedEntry = _fields[idx];
      final expectKey = expectedEntry.key, expectType = expectedEntry.value;
      r[expectKey] = expectType.decodeValue(x, type);
      idx++;
    }
    if (idx < _fields.length) {
      throw RangeError.index(
        idx,
        _fields.length,
        'idx',
        'Cannot find field ${_fields[idx].key}',
      );
    }
    return r;
  }

  @override
  String get name {
    final fields = _fields.map((entry) => '${entry.key}:${entry.value.name}');
    return "record {${fields.join('; ')}}";
  }

  @override
  String display() {
    final fields =
        _fields.map((entry) => '${entry.key}:${entry.value.display()}');
    return "record {${fields.join('; ')}}";
  }

  @override
  String valueToString(Map x) {
    final values = _fields.map((entry) => x[entry.key]).toList();
    final fields = zipWith<MapEntry, dynamic, String>(
      _fields,
      values,
      (entry, d) => '${entry.key}=${entry.value.valueToString(d)}',
    );
    return "record {${fields.join('; ')}}";
  }
}

class TupleClass<T extends List> extends ConstructType<List> {
  TupleClass(List<CType> components) : _components = components {
    _fields = Map.from(_makeMap(components)).entries.toList();
    _fields.sort(
      (a, b) => idlLabelToId(a.key).toInt() - idlLabelToId(b.key).toInt(),
    );
  }

  final List<CType> _components;

  List<MapEntry> get fields => _fields;
  late final List<MapEntry> _fields;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitTuple(this, _components, d);
  }

  @override
  bool covariant(x) {
    if (x is! List) {
      return false;
    }
    // `>=` because tuples can be covariant when encoded.
    return x.length >= _fields.length &&
        _components
                .asMap()
                .entries
                .map((t) => t.value.covariant(x[t.key]) ? 0 : 1)
                .reduce((value, element) => value + element) ==
            0;
  }

  @override
  Uint8List encodeValue(List x) {
    final buffer = zipWith<CType, dynamic, Uint8List>(
      _components,
      x,
      (c, d) => c.encodeValue(d),
    );
    return u8aConcat(buffer);
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (final entry in _fields) {
      entry.value.buildTypeTable(typeTable);
    }
    final opCode = slebEncode(IDLTypeIds.Record);
    final len = lebEncode(_fields.length);
    final fields = _fields.map(
      (entry) => u8aConcat([
        lebEncode(idlLabelToId(entry.key)),
        entry.value.encodeType(typeTable)
      ]),
    );
    typeTable.add(this, u8aConcat([opCode, len, u8aConcat(fields.toList())]));
  }

  @override
  List decodeValue(Pipe x, CType t) {
    final tuple = checkType(t);
    if (tuple is! TupleClass) {
      throw ArgumentError.value(t, 't', 'Not a valid tuple type');
    }
    if (tuple._components.length < _components.length) {
      throw RangeError.range(
        tuple._components.length,
        _components.length,
        null,
        'tuple components',
        'Tuple components mismatch',
      );
    }
    final res = [];
    for (final entry in tuple._components.asMap().entries) {
      // [i, wireType]
      final i = entry.key;
      final wireType = entry.value;
      if (i >= _components.length) {
        // skip value
        wireType.decodeValue(x, wireType);
      } else {
        res.add(_components[i].decodeValue(x, wireType));
      }
    }
    return res;
  }

  @override
  String display() {
    final fields = _components.map((value) => value.display()).toList();
    return "record {${fields.join('; ')}}";
  }

  @override
  String valueToString(List x) {
    final fields = zipWith<CType, dynamic, String>(
      _components,
      x,
      (c, d) => c.valueToString(d),
    );
    return "record {${fields.join('; ')}}";
  }

  @override
  String get name {
    final fields = _fields.map((entry) => '${entry.key}:${entry.value.name}');
    return "record {${fields.join('; ')}}";
  }

  Map<String, dynamic> _makeMap(List<CType> components) {
    return {
      for (final e in components) '_${components.indexOf(e)}_': e,
    };
  }
}

class VariantClass extends ConstructType<Map<String, dynamic>> {
  VariantClass(Map<String, CType> fields) {
    _fields = fields.entries.toList();
    _fields.sort(
      (a, b) => idlLabelToId(a.key).toInt() - idlLabelToId(b.key).toInt(),
    );
  }

  late final List<MapEntry<String, CType<dynamic>>> _fields;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitVariant(this, _fields, d);
  }

  @override
  bool covariant(x) {
    // Ignoring types other than `Map`.
    if (x is! Map) {
      return true;
    }
    return x.entries.length == 1 &&
        _fields.every((entry) {
          // [k, v]
          return !x.containsKey(entry.key) ||
              entry.value.covariant(x[entry.key]);
        });
  }

  @override
  Uint8List encodeValue(Map<String, dynamic> x) {
    for (int i = 0; i < _fields.length; i++) {
      final name = _fields[i].key;
      final t = _fields[i].value;
      if (x.containsKey(name)) {
        final idx = lebEncode(i);
        return u8aConcat(
          [idx, tryToJson(t, x[name]) ?? t.encodeValue(x[name])],
        );
      }
    }
    throw StateError('variant has no data: $x.');
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (final entry in _fields) {
      final type = entry.value;
      type.buildTypeTable(typeTable);
    }
    final opCode = slebEncode(IDLTypeIds.Variant);
    final len = lebEncode(_fields.length);
    final fields = _fields.map(
      (entry) => u8aConcat([
        lebEncode(idlLabelToId(entry.key)),
        entry.value.encodeType(typeTable)
      ]),
    );
    typeTable.add(this, u8aConcat([opCode, len, ...fields]));
  }

  @override
  Map<String, dynamic> decodeValue(Pipe x, CType t) {
    final variant = checkType(t);
    if (variant is! VariantClass) {
      throw ArgumentError.value(t, 't', 'Not a valid variant type');
    }
    final idx = lebDecode(x).toInt();
    if (idx >= variant._fields.length) {
      throw RangeError.index(
        idx,
        variant._fields.length,
        'variant index',
        'Invalid variant index: $idx',
      );
    }
    final entry = variant._fields[idx];
    final wireHash = entry.key, wireType = entry.value;
    for (final fEntry in _fields) {
      final key = fEntry.key, expectType = fEntry.value;
      if (idlLabelToId(wireHash) == idlLabelToId(key)) {
        final value = expectType.decodeValue(x, wireType);
        return {key: value};
      }
    }
    throw StateError('cannot find field hash $wireHash.');
  }

  @override
  String get name {
    final fields = _fields.map((entry) => '${entry.key}:${entry.value.name}');
    return "variant {${fields.join('; ')}}";
  }

  @override
  String display() {
    final fields = _fields.map(
      (entry) {
        final sb = StringBuffer(entry.key);
        if (entry.value.name.isNotEmpty && entry.value.name != 'null') {
          sb.write(':${entry.value.display()}');
        }
        return sb.toString();
      },
    );
    return "variant {${fields.join('; ')}}";
  }

  @override
  String valueToString(Map<String, dynamic> x) {
    for (final fEntry in _fields) {
      final name = fEntry.key, type = fEntry.value;
      if (x.containsKey(name)) {
        final value = type.valueToString(x[name]);
        if (value.isEmpty || value == 'null') {
          return 'variant {$name}';
        } else {
          return 'variant {$name=$value}';
        }
      }
    }
    throw StateError('variant has no data: $x.');
  }
}

/// Represents a reference to IDL type, used for defining recursive data types.
class RecClass<T> extends ConstructType<T> {
  RecClass() : _id = _incrementId++;

  final int _id;

  ConstructType<T>? _type;
  static int _incrementId = 0;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    _checkType();
    return v.visitRec(this, _type!, d);
  }

  void fill(ConstructType<T> t) {
    _type = t;
  }

  ConstructType<T>? getType() {
    return _type;
  }

  @override
  bool covariant(dynamic x) {
    return _type != null ? _type!.covariant(x) : false;
  }

  @override
  Uint8List encodeValue(T x) {
    _checkType();
    return _type!.encodeValue(x);
  }

  @override
  _buildTypeTableImpl(TypeTable typeTable) {
    _checkType();
    typeTable.add(this, Uint8List.fromList([]));
    _type!.buildTypeTable(typeTable);
    typeTable.merge(this, _type!.name);
  }

  @override
  T decodeValue(Pipe x, CType t) {
    _checkType();
    return _type!.decodeValue(x, t);
  }

  @override
  String get name => 'rec_$_id';

  @override
  String display() {
    _checkType();
    return 'μ$name.${_type!.name}';
  }

  @override
  String valueToString(T x) {
    _checkType();
    return _type!.valueToString(x);
  }

  void _checkType() {
    if (_type == null) {
      throw StateError('Recursive type uninitialized.');
    }
  }
}

PrincipalId decodePrincipalId(Pipe b) {
  final x = Uint8List.fromList(safeRead(b as Pipe<int>, 1)).toHex();
  if (x != '01') {
    throw ArgumentError('Cannot decode principal $x.');
  }
  final len = lebDecode(b).toInt();
  final hex = Uint8List.fromList(safeRead(b, len)).toHex().toUpperCase();
  return PrincipalId.fromHex(hex);
}

class PrincipalClass extends PrimitiveType<PrincipalId> {
  const PrincipalClass._();

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitPrincipal(this, d);
  }

  @override
  bool covariant(x) {
    return x is PrincipalId;
  }

  @override
  PrincipalId decodeValue(Pipe x, CType t) {
    checkType(t);
    return decodePrincipalId(x);
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Principal);
  }

  @override
  Uint8List encodeValue(PrincipalId x) {
    final hex = x.toHex();
    final buf = hex.toU8a();
    final len = lebEncode(buf.length);
    return u8aConcat([
      Uint8List.fromList([1]),
      len,
      buf
    ]);
  }

  @override
  String get name => 'principal';

  @override
  String valueToString(PrincipalId x) => "$name '${x.toText()}'";
}

// [PrincipalId, string]
class FuncClass extends ConstructType<List> {
  const FuncClass(this.argTypes, this.retTypes, this.annotations);

  final List<CType> argTypes;
  final List<CType> retTypes;
  final List<String> annotations;

  static String argsToString(List<CType> types, List v) {
    if (types.length != v.length) {
      throw RangeError.range(
        types.length,
        v.length,
        v.length,
        'types',
        'Arity mismatch',
      );
    }
    return '(${types.asMap().entries.map((e) => e.value.valueToString(v[e.key])).join(', ')})';
  }

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitFunc(this, d);
  }

  @override
  bool covariant(x) {
    return x is List &&
        x.length == 2 &&
        x[0] != null &&
        x[0] is PrincipalId &&
        x[1] is String;
  }

  @override
  Uint8List encodeValue(x) {
    // [PrincipalId, string]
    final hex = (x[0] as PrincipalId).toHex();
    final buf = hex.toU8a();
    final len = lebEncode(buf.length);
    final canister = u8aConcat([
      Uint8List.fromList([1]),
      len,
      buf,
    ]);

    final method = Uint8List.fromList(
      (x[1] as String).plainToU8a(useDartEncode: true),
    );
    final methodLen = lebEncode(method.length);
    return u8aConcat([
      Uint8List.fromList([1]),
      canister,
      methodLen,
      method,
    ]);
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (final argT in argTypes) {
      argT.buildTypeTable(typeTable);
    }
    for (final argR in retTypes) {
      argR.buildTypeTable(typeTable);
    }
    final opCode = slebEncode(IDLTypeIds.Func);
    final argLen = lebEncode(argTypes.length);
    final args = u8aConcat(
      argTypes.map((arg) => arg.encodeType(typeTable)).toList(),
    );
    final retLen = lebEncode(retTypes.length);
    final rets = u8aConcat(
      retTypes.map((arg) => arg.encodeType(typeTable)).toList(),
    );
    final annLen = lebEncode(annotations.length);
    final ann = u8aConcat(
      annotations.map((a) => encodeAnnotation(a)).toList(),
    );

    typeTable.add(
      this,
      u8aConcat([opCode, argLen, args, retLen, rets, annLen, ann]),
    );
  }

  @override
  List<dynamic> decodeValue(Pipe x, CType t) {
    final r = Uint8List.fromList(safeRead(x as Pipe<int>, 1)).toHex();
    if (r != '01') {
      throw ArgumentError('Cannot decode function reference $x.');
    }
    final canister = decodePrincipalId(x);
    final mLen = lebDecode(x).toInt();
    final buf = Uint8List.fromList(safeRead(x, mLen));
    if (!_isValidUTF8(buf)) {
      throw ArgumentError('Not a valid UTF-8 method name.');
    }
    final method = buf.u8aToString();
    return [canister, method];
  }

  @override
  get name {
    final args = argTypes.map((arg) => arg.name).join(', ');
    final rets = retTypes.map((arg) => arg.name).join(', ');
    return '($args) -> ($rets) ${annotations.join(' ')}';
  }

  @override
  String valueToString(x) {
    final principal = x[0] as PrincipalId, str = x[1] as String;
    return "func '${principal.toText()}'.$str";
  }

  @override
  String display() {
    final args = argTypes.map((arg) => arg.display()).join(', ');
    final rets = retTypes.map((arg) => arg.display()).join(', ');
    return '($args) → ($rets) ${annotations.join(' ')}';
  }

  Uint8List encodeAnnotation(String ann) {
    if (ann == 'query') {
      return Uint8List.fromList([1]);
    } else if (ann == 'oneway') {
      return Uint8List.fromList([2]);
    }
    throw StateError('invalid function annotation.');
  }
}

class ServiceClass extends ConstructType<PrincipalId> {
  ServiceClass([Map<String, FuncClass> fields = const {}]) {
    _fields = fields.entries.toList();
    _fields.sort(
      (a, b) => idlLabelToId(a.key).toInt() - idlLabelToId(b.key).toInt(),
    );
  }

  late final List<MapEntry<String, FuncClass>> _fields;

  List<MapEntry<String, FuncClass>> get fields => _fields;

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitService(this, d);
  }

  @override
  bool covariant(x) => x is PrincipalId;

  @override
  Uint8List encodeValue(PrincipalId x) {
    final hex = x.toHex();
    final buf = hex.toU8a();
    final len = lebEncode(buf.length);
    return u8aConcat([
      Uint8List.fromList([1]),
      len,
      buf,
    ]);
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (final entry in _fields) {
      entry.value.buildTypeTable(typeTable);
    }
    final opCode = slebEncode(IDLTypeIds.Service);
    final len = lebEncode(_fields.length);
    final meths = _fields.map((entry) {
      final label = entry.key, func = entry.value;
      final labelBuf = label.plainToU8a(useDartEncode: true);
      final labelLen = lebEncode(labelBuf.length);
      return u8aConcat([labelLen, labelBuf, func.encodeType(typeTable)]);
    }).toList();
    typeTable.add(this, u8aConcat([opCode, len, u8aConcat(meths)]));
  }

  @override
  PrincipalId decodeValue(Pipe x, CType t) {
    return decodePrincipalId(x);
  }

  @override
  String get name {
    final fields = _fields.map((entry) => '${entry.key}:${entry.value.name}');
    return "service {${fields.join('; ')}}";
  }

  @override
  String valueToString(PrincipalId x) {
    return "service '${x.toText()}'";
  }
}

String toReadableString(dynamic x) {
  if (x is BigInt) {
    return 'BigInt($x)';
  } else if (x is Map) {
    return jsonEncode(makeBigIntToString(x));
  } else {
    return jsonEncode(x);
  }
}

/// Encode a array of values
/// @returns {Buffer} serialised value
BinaryBlob idlEncode(List<CType> argTypes, List args) {
  if (args.length < argTypes.length) {
    throw RangeError.range(
      args.length,
      argTypes.length,
      argTypes.length,
      'args',
      'Wrong number of message arguments',
    );
  }
  final typeTable = TypeTable();
  for (final t in argTypes) {
    t.buildTypeTable(typeTable);
  }
  final magic = _magicNumber.plainToU8a(useDartEncode: true);
  final table = typeTable.encode();
  final len = lebEncode(args.length);
  final types = u8aConcat(
    argTypes.map((t) => t.encodeType(typeTable)).toList(),
  );
  final vals = u8aConcat(
    zipWith<CType<dynamic>, dynamic, dynamic>(argTypes, args, (t, x) {
      final buf = tryToJson(t, x);
      if (buf != null) {
        return buf;
      }
      if (!t.covariant(x)) {
        throw ArgumentError.value(
          t,
          'type',
          'Error in covariant types ${t.display()} : ${toReadableString(x)}',
        );
      }
      return t.encodeValue(x);
    }),
  );
  return u8aConcat([magic, table, len, types, vals]);
}

/// Decode a binary value
/// @param retTypes - Types expected in the buffer.
/// @param bytes - hex-encoded string, or buffer.
/// @returns Value deserialized to JS type
List idlDecode(List<CType> retTypes, Uint8List bytes) {
  final b = Pipe(bytes);
  if (bytes.lengthInBytes < _magicNumber.length) {
    throw RangeError.range(
      bytes.lengthInBytes,
      _magicNumber.length,
      null,
      'bytes',
      'Message length is smaller than the magic number',
    );
  }
  final magic = Uint8List.fromList(
    safeRead(b, _magicNumber.length),
  ).u8aToString();
  if (magic != _magicNumber) {
    throw StateError('Wrong magic number: $magic.');
  }

  // [Array<[IDLTypeIds, any]>, number[]]
  List<dynamic> readTypeTable(Pipe pipe) {
    // Array<[IDLTypeIds, any]>;
    final typeTable = [];
    final len = lebDecode(pipe).toInt();

    for (int i = 0; i < len; i++) {
      final ty = slebDecode(pipe).toInt();
      switch (ty) {
        case IDLTypeIds.Opt:
        case IDLTypeIds.Vector:
          final t = slebDecode(pipe).toInt();
          typeTable.add([ty, t]);
          break;
        case IDLTypeIds.Record:
        case IDLTypeIds.Variant:
          final fields = List.from([]);
          int objectLength = lebDecode(pipe).toInt();
          int? prevHash;
          while (objectLength-- > 0) {
            final hash = lebDecode(pipe).toInt();
            if (hash >= math.pow(2, 32)) {
              throw RangeError.range(
                hash,
                null,
                math.pow(2, 32).toInt(),
                'hash',
                'Field ID is out of 32-bit range',
              );
            }
            if (prevHash != null && prevHash >= hash) {
              throw StateError('Field ID collision or not sorted.');
            }
            prevHash = hash;
            final t = slebDecode(pipe).toInt();
            fields.add([hash, t]);
          }
          typeTable.add([ty, fields]);
          break;
        case IDLTypeIds.Func:
          for (int k = 0; k < 2; k++) {
            int funcLength = lebDecode(pipe).toInt();
            while (funcLength-- > 0) {
              slebDecode(pipe);
            }
          }
          final annLen = lebDecode(pipe).toInt();
          safeRead(pipe, annLen);
          typeTable.add([ty, null]);
          break;
        case IDLTypeIds.Service:
          int servLength = lebDecode(pipe).toInt();
          while (servLength-- > 0) {
            final l = lebDecode(pipe).toInt();
            safeRead(pipe, l);
            slebDecode(pipe);
          }
          typeTable.add([ty, null]);
          break;
        default:
          throw FallThroughError();
      }
    }

    final rawList = <int>[];
    final length = lebDecode(pipe).toInt();
    for (int i = 0; i < length; i++) {
      rawList.add(slebDecode(pipe).toInt());
    }
    return [typeTable, rawList];
  }

  final typeTableRead = readTypeTable(b);

  final rawTable = typeTableRead[0] as List<dynamic>; // [IDLTypeIds, any]
  final rawTypes = typeTableRead[1] as List<int>;
  if (rawTypes.length < retTypes.length) {
    throw RangeError.range(
      rawTypes.length,
      retTypes.length,
      null,
      'rawTypes',
      'Wrong number of return values',
    );
  }

  final table = rawTable.map((_) => RecClass()).toList();

  CType getType(int t) {
    if (t < -24) {
      throw UnsupportedError('Future value is not supported.');
    }
    if (t < 0) {
      switch (t) {
        case -1:
          return IDL.Null;
        case -2:
          return IDL.Bool;
        case -3:
          return IDL.Nat;
        case -4:
          return IDL.Int;
        case -5:
          return IDL.Nat8;
        case -6:
          return IDL.Nat16;
        case -7:
          return IDL.Nat32;
        case -8:
          return IDL.Nat64;
        case -9:
          return IDL.Int8;
        case -10:
          return IDL.Int16;
        case -11:
          return IDL.Int32;
        case -12:
          return IDL.Int64;
        case -13:
          return IDL.Float32;
        case -14:
          return IDL.Float64;
        case -15:
          return IDL.Text;
        case -16:
          return IDL.Reserved;
        case -17:
          return IDL.Empty;
        case -24:
          return IDL.Principal;
        default:
          throw StateError('Invalid type code $t.');
      }
    }
    if (t >= rawTable.length) {
      throw RangeError.range(
        t,
        rawTable.length,
        rawTable.length,
        'type',
        'Type is out of range',
      );
    }
    return table[t];
  }

  ConstructType buildType(List<dynamic> entry) {
    // entry: [IDLTypeIds, any]
    switch (entry[0]) {
      case IDLTypeIds.Vector:
        return Vec(getType(entry[1]));
      case IDLTypeIds.Opt:
        return Opt(getType(entry[1]));
      case IDLTypeIds.Record:
        final fields = <String, CType>{};
        for (final e in entry[1] as List) {
          final name = '_${e[0].toString()}_';
          fields[name] = getType(e[1] as int);
        }
        final record = Record(fields);
        final tuple = record.tryAsTuple();
        if (tuple is List<CType>) {
          return Tuple(tuple);
        } else {
          return record;
        }
      case IDLTypeIds.Variant:
        final fields = <String, CType>{};
        for (final e in entry[1] as List) {
          final name = '_${e[0]}_';
          fields[name] = getType(e[1] as int);
        }
        return Variant(fields);
      case IDLTypeIds.Func:
        return const Func([], [], []);
      case IDLTypeIds.Service:
        return Service();
      default:
        throw StateError('Invalid type code ${entry[0]}.');
    }
  }

  rawTable.asMap().forEach((i, entry) {
    final t = buildType(entry);
    table[i].fill(t);
  });

  final types = rawTypes.map((t) => getType(t)).toList();

  final output = retTypes.asMap().entries.map((entry) {
    final result = entry.value.decodeValue(b, types[entry.key]);
    return result;
  }).toList();

  // Skip unused values.
  for (int ind = retTypes.length; ind < types.length; ind++) {
    types[ind].decodeValue(b, types[ind]);
  }
  if (b.buffer.isNotEmpty) {
    throw StateError('Unexpected left-over bytes.');
  }
  return output;
}

class IDL {
  const IDL._();

  static const Empty = EmptyClass._();
  static const Reserved = ReservedClass._();
  static const Bool = BoolClass._();
  static const Null = NullClass._();
  static const Text = TextClass._();
  static const Int = IntClass._();
  static const Nat = NatClass._();
  static const Float32 = FloatClass._(32);
  static const Float64 = FloatClass._(64);
  static const Int8 = FixedIntClass._(8);
  static const Int16 = FixedIntClass._(16);
  static const Int32 = FixedIntClass._(32);
  static const Int64 = FixedIntClass._(64);
  static const Nat8 = FixedNatClass._(8);
  static const Nat16 = FixedNatClass._(16);
  static const Nat32 = FixedNatClass._(32);
  static const Nat64 = FixedNatClass._(64);
  static const Principal = PrincipalClass._();

  static TupleClass<List> Tuple(List<CType> components) =>
      TupleClass(components);

  static VecClass<T> Vec<T>(CType<T> type) => VecClass(type);

  static OptClass<T> Opt<T>(CType<T> type) => OptClass(type);

  static RecordClass Record(Map? fields) => RecordClass(fields);

  static VariantClass Variant(Map<String, CType<dynamic>> fields) =>
      VariantClass(fields);

  static RecClass<T> Rec<T>() => RecClass<T>();

  static FuncClass Func(
    List<CType<dynamic>> argTypes,
    List<CType<dynamic>> retTypes,
    List<String> annotations,
  ) =>
      FuncClass(argTypes, retTypes, annotations);

  static ServiceClass Service(Map<String, FuncClass> fields) =>
      ServiceClass(fields);

  static BinaryBlob encode(List<CType> argTypes, List args) =>
      idlEncode(argTypes, args);

  static List decode(List<CType> retTypes, Uint8List bytes) =>
      idlDecode(retTypes, bytes);
}

typedef Tuple<T> = TupleClass<List>;
typedef Vec<T> = VecClass<T>;
typedef Opt<T> = OptClass<T>;
typedef Record = RecordClass;
typedef Variant = VariantClass;
typedef Rec<T> = RecClass<T>;
typedef Func = FuncClass;
typedef Service = ServiceClass;
