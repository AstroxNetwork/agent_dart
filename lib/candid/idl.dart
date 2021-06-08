import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
// import 'dart:math';

import 'package:agent_dart/agent/agent.dart';
import 'package:agent_dart/agent/utils/buffer_pipe.dart' show BufferPipe;
import 'package:agent_dart/agent/utils/leb128.dart';
import 'package:agent_dart/agent/utils/utils.dart';
import 'package:agent_dart/principal/principal.dart' as principal;
import 'package:agent_dart/utils/extension.dart';
import 'package:agent_dart/utils/number.dart';
import 'package:agent_dart/utils/u8a.dart';
// import 'package:agent_dart/agent_dart.dart';

typedef Pipe<T> = BufferPipe<T>;
typedef PrincipalId = principal.Principal;

class IDLTypeIds {
  // ignore: constant_identifier_names
  static const Null = -1;
  // ignore: constant_identifier_names
  static const Bool = -2;
  // ignore: constant_identifier_names
  static const Nat = -3;
  // ignore: constant_identifier_names
  static const Int = -4;
  // ignore: constant_identifier_names
  static const Float32 = -13;
  // ignore: constant_identifier_names
  static const Float64 = -14;
  // ignore: constant_identifier_names
  static const Text = -15;
  // ignore: constant_identifier_names
  static const Reserved = -16;
  // ignore: constant_identifier_names
  static const Empty = -17;
  // ignore: constant_identifier_names
  static const Opt = -18;
  // ignore: constant_identifier_names
  static const Vector = -19;
  // ignore: constant_identifier_names
  static const Record = -20;
  // ignore: constant_identifier_names
  static const Variant = -21;
  // ignore: constant_identifier_names
  static const Func = -22;
  // ignore: constant_identifier_names
  static const Service = -23;
  // ignore: constant_identifier_names
  static const Principal = -24;
}

const magicNumber = 'DIDL';

List<TR> zipWith<TX, TY, TR>(List<TX> xs, List<TY> ys, TR Function(TX a, TY b) f) {
  return xs.asMap().entries.map((e) => f(e.value, ys[e.key])).toList();
}

/// An IDL Type Table, which precedes the data in the stream.
class TypeTable {
  // List of types. Needs to be an array as the index needs to be stable.
  List<Uint8List> _typs = [];

  Map<String, int> _idx = <String, int>{};

  bool has(CType obj) {
    return _idx.containsKey(obj.name);
  }

  void add<T>(ConstructType<T> type, Uint8List buf) {
    final idx = _typs.length;
    _idx.putIfAbsent(type.name, () => idx);
    _typs.add(buf);
  }

  merge<T>(ConstructType<T> obj, String knot) {
    final idx = _idx[obj.name];
    final knotIdx = _idx[knot];
    if (idx == null) {
      throw 'Missing type index for $obj';
    }
    if (knotIdx == null) {
      throw 'Missing type index for $knot';
    }
    _typs[idx] = _typs[knotIdx];

    // Delete the type.
    _typs.removeAt(knotIdx); // js: _typs.splice(knotIdx, 1);
    _idx.remove(knot);
  }

  Uint8List encode() {
    final len = lebEncode(_typs.length);
    final buf = u8aConcat(_typs);
    final result = List<int>.from(len, growable: true)..addAll(buf);
    return Uint8List.fromList(result);
  }

  Uint8List indexOf(String typeName) {
    if (!_idx.containsKey(typeName)) {
      throw 'Missing type index for $typeName';
    }
    return slebEncode(_idx[typeName] ?? 0);
  }
}

abstract class Visitor<D, R> {
  R visitType<T>(CType<T> t, D data) {
    throw 'Not implemented';
  }

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

  R visitVec<T>(VecClass<T> t, CType<T> ty, D data) {
    return visitConstruct(t, data);
  }

  R visitOpt<T>(OptClass<T> t, CType<T> ty, D data) {
    return visitConstruct(t, data);
  }

  R visitRecord(RecordClass t, List<dynamic> fields, D data) {
    return visitConstruct(t, data);
  }

  R visitTuple(TupleClass t, List<CType> components, D data) {
    // final fields = components.map((ty) => ["_${components.indexOf(ty)}_", ty]).toList();
    return visitConstruct(t, data);
  }

  R visitVariant(VariantClass t, List fields, D data) {
    return visitConstruct(t, data);
  }

  R visitRec<T>(RecClass<T> t, ConstructType<T> ty, D data) {
    return visitConstruct(ty, data);
  }

  R visitFunc(FuncClass t, D data) {
    return visitConstruct(t, data);
  }

  R visitService(ServiceClass t, D data) {
    return visitConstruct(t, data);
  }
}

/// Represents an IDL type.
abstract class CType<T> {
  late String name;
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
  @override
  CType checkType(CType t) {
    if (name != t.name) {
      throw "type mismatch: type on the wire ${t.name}, expect type $name";
    }
    return t;
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    // No type table encoding for Primitive types.
    return;
  }
}

class ConstructType<T> extends CType<T> {
  @override
  ConstructType checkType(CType t) {
    if (t is RecClass) {
      final ty = t.getType();
      if (ty == null) {
        throw 'type mismatch with uninitialized type';
      }
      return ty;
    }
    throw "type mismatch: type on the wire ${t.name}, expect type $name";
  }

  @override
  encodeType(TypeTable? typeTable) {
    return typeTable!.indexOf(name);
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    // TODO: implement _buildTypeTableImpl
  }

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    // TODO: implement accept
    throw UnimplementedError();
  }

  @override
  bool covariant(x) {
    // TODO: implement covariant
    throw UnimplementedError();
  }

  @override
  T decodeValue(Pipe x, CType t) {
    // TODO: implement decodeValue
    throw UnimplementedError();
  }

  @override
  Uint8List encodeValue(T x) {
    // TODO: implement encodeValue
    throw UnimplementedError();
  }
}

class EmptyClass<T> extends PrimitiveType<T> {
  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitEmpty(this, d);
  }

  @override
  bool covariant(x) {
    return false;
  }

  @override
  decodeValue(Pipe x, CType t) {
    throw 'Empty cannot appear as an output';
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Empty);
  }

  @override
  Uint8List encodeValue(x) {
    throw 'Empty cannot appear as a function argument';
  }

  @override
  valueToString(T x) {
    throw 'Empty cannot appear as a value';
  }

  @override
  get name => 'empty';
}

/// Represents an IDL Bool
class BoolClass extends PrimitiveType<bool> {
  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitBool(this, d);
  }

  @override
  bool covariant(x) {
    return x is bool;
  }

  @override
  bool decodeValue(Pipe x, CType t) {
    checkType(t);
    final k = Uint8List.fromList(safeRead<int>(x as Pipe<int>, 1)).toHex();
    if (k == '00') {
      return false;
    } else if (k == '01') {
      return true;
    } else {
      throw 'Boolean value out of range';
    }
  }

  @override
  Uint8List encodeType(TypeTable? typeTable) {
    return slebEncode(IDLTypeIds.Bool);
  }

  @override
  Uint8List encodeValue(bool x) {
    return x
        ? Int8List.fromList([1]).buffer.asUint8List()
        : Int8List.fromList([0]).buffer.asUint8List();
  }

  @override
  get name => "bool";
}

// ignore: prefer_void_to_null
class NullClass extends PrimitiveType<Null> {
  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitNull(this, d);
  }

  @override
  bool covariant(x) {
    return x == null;
  }

  @override
  // ignore: prefer_void_to_null
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

class ReservedClass extends PrimitiveType<dynamic> {
  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitReserved(this, d);
  }

  @override
  bool covariant(x) {
    return true;
  }

  @override
  decodeValue(Pipe x, CType t) {
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
  get name => 'reserved';
}

bool isValidUTF8(Uint8List buf) {
  return u8aEq(buf.u8aToString(useDartEncode: true).plainToU8a(useDartEncode: true), buf);
}

class TextClass extends PrimitiveType<String> {
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
  decodeValue(Pipe x, CType t) {
    checkType(t);
    final len = lebDecode(x);
    final buf = safeRead((x as Pipe<int>), len.toInt());
    if (!isValidUTF8(Uint8List.fromList(buf))) {
      throw 'Not valid UTF8 text';
    }
    return Uint8List.fromList(buf).u8aToString(useDartEncode: true);
  }

  @override
  get name => 'text';

  @override
  String valueToString(String x) => '"' + x + '"';
}

class IntClass extends PrimitiveType {
  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitInt(this, d);
  }

  @override
  bool covariant(x) {
    return x is BigInt || x is int;
  }

  @override
  decodeValue(Pipe x, CType t) {
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
  get name => 'int';

  @override
  String valueToString(x) => x.toString();
}

class NatClass extends PrimitiveType {
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
  get name => 'nat';

  @override
  String valueToString(x) => x.toString();
}

class FloatClass extends PrimitiveType<num> {
  late final int _bits;
  FloatClass(this._bits) : super() {
    if (_bits != 32 && _bits != 64) {
      throw 'not a valid float type';
    }
  }

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
    final k = safeRead((x as Pipe<int>), (_bits / 8).ceil());
    if (_bits == 32) {
      return Uint8List.fromList(k).buffer.asByteData().getFloat32(0, Endian.little);
    } else {
      return Uint8List.fromList(k).buffer.asByteData().getFloat64(0, Endian.little);
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
    var length = (_bits / 8).ceil();
    var byte = ByteData(length);

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
  late final int _bits;
  FixedIntClass(this._bits) : super();
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
    BigInt num = readIntLE(x, (_bits / 8).ceil());

    if (_bits <= 32) {
      return num.toInt();
    } else {
      // dart int has 64 bit width, should be safe
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
    assert((x is int || x is BigInt), "value with ${x.runtimeType} has to be int or BigInt");
    return writeIntLE(x, (_bits / 8).ceil());
  }

  @override
  String get name => "int$_bits";

  @override
  String valueToString(dynamic x) => x.toString();
}

class FixedNatClass extends PrimitiveType<dynamic> {
  late final int _bits;
  FixedNatClass(this._bits) : super();
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
  decodeValue(Pipe x, CType t) {
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
  get name => "nat$_bits";

  @override
  String valueToString(dynamic x) {
    return x.toString();
  }
}

class VecClass<T> extends ConstructType<List<T>> {
  // ignore: prefer_final_fields
  bool _blobOptimization = false;

  late final CType<T> _type;

  CType<T> get type => _type;

  VecClass(this._type);

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitVec(this, _type, d);
  }

  @override
  bool covariant(x) {
    return (x is List) && x.every((v) => _type.covariant(v));
  }

  @override
  Uint8List encodeValue(x) {
    var len = lebEncode(x.length);
    if (_blobOptimization) {
      return u8aConcat([len, Uint8List.fromList(x as List<int>)]);
    }
    return u8aConcat([len, ...x.map((d) => _type.encodeValue(d))]);
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
    var vec = checkType(t);
    if (vec is! VecClass) {
      throw 'Not a vector type';
    } else {
      var len = lebDecode(x).toInt();
      if (_blobOptimization) {
        return [...x.read(len) as List<T>];
      }
      var rets = <T>[];
      for (var i = 0; i < len; i++) {
        rets.add(_type.decodeValue(x, (vec).type));
      }
      return rets;
    }
  }

  @override
  get name => "vec ${_type.name}";

  @override
  String display() => "vec ${_type.display()}";

  @override
  String valueToString(List<T> x) {
    final elements = x.map((e) => _type.valueToString(e));
    return 'vec {' + elements.join('; ') + '}';
  }
}

class OptClass<T> extends ConstructType<List> {
  late final CType<T> _type;
  CType<T> get type => _type;
  OptClass(this._type);
  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitOpt(this, _type, d);
  }

  @override
  bool covariant(x) {
    return (x is List) && (x.isEmpty || (x.length == 1 && _type.covariant(x[0])));
  }

  @override
  Uint8List encodeValue(List x) {
    if (x.isEmpty) {
      return Uint8List.fromList([0]);
    } else {
      return u8aConcat([
        Uint8List.fromList([1]),
        _type.encodeValue(x[0])
      ]);
    }
  }

  @override
  _buildTypeTableImpl(TypeTable typeTable) {
    _type.buildTypeTable(typeTable);

    final opCode = slebEncode(IDLTypeIds.Opt);
    final buffer = _type.encodeType(typeTable);
    typeTable.add(this, u8aConcat([opCode, buffer]));
  }

  @override
  List<T> decodeValue(Pipe x, CType t) {
    final opt = checkType(t);
    if (opt is! OptClass) {
      throw 'Not an option type';
    }
    final len = Uint8List.fromList(safeRead((x as Pipe<int>), 1)).toHex();
    if (len == '00') {
      return [];
    } else if (len == '01') {
      return [_type.decodeValue(x, opt._type)];
    } else {
      throw 'Not an option value';
    }
  }

  @override
  get name => "opt ${_type.name}";

  @override
  String display() => "opt ${_type.display()}";

  @override
  String valueToString(List x) {
    if (x.isEmpty) {
      return 'null';
    } else {
      return "opt ${_type.valueToString(x[0])}";
    }
  }
}

class RecordClass extends ConstructType<Map> {
  late final List<MapEntry> _fields;
  List<MapEntry> get fields => _fields;
  RecordClass(Map? fields) {
    fields ??= Map.from({});
    _fields = (Map.from(fields)).entries.toList();
    assert(
        _fields.every(
            (element) => (element.key is String && element.key != null) || (element.key == null)),
        "Currently we only support Map<String,dynamic> as input");
    _fields.sort((a, b) =>
        idlLabelToId((a.key).toString()).toInt() - idlLabelToId((b.key).toString()).toInt());
  }

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitRecord(this, _fields, d);
  }

  List<CType>? tryAsTuple() {
    final res = <CType>[];
    for (var i = 0; i < _fields.length; i++) {
      var key = _fields[i].key;
      var type = _fields[i].value;

      if (key != "_${i}_") {
        return null;
      }
      res.add(type);
    }
    return res;
  }

  @override
  bool covariant(dynamic x) {
    return (x is Map &&
        _fields.every((entry) {
          var k = entry.key;
          var t = entry.value;

          if (!x.containsKey(k)) {
            throw "Record is missing key '$k'.";
          }
          return t.covariant(x[k]);
        }));
  }

  @override
  Uint8List encodeValue(Map x) {
    final values = _fields.map((entry) => x[entry.key]).toList();

    final bufs = zipWith<MapEntry, dynamic, Uint8List>(
        _fields, values, (entry, d) => entry.value.encodeValue(d));
    return u8aConcat(bufs);
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (var entry in _fields) {
      entry.value.buildTypeTable(typeTable);
    }
    final opCode = slebEncode(IDLTypeIds.Record);
    final len = lebEncode(_fields.length);
    final fields = _fields.map(
      (entry) => u8aConcat([lebEncode(idlLabelToId(entry.key)), entry.value.encodeType(typeTable)]),
    );

    typeTable.add(this, u8aConcat([opCode, len, u8aConcat(fields.toList())]));
  }

  @override
  Map decodeValue(Pipe x, CType t) {
    final record = checkType(t);

    if (record is RecordClass || record is TupleClass) {
      final r = {};
      var idx = 0;
      var fields = (record is RecordClass) ? record.fields : (record as TupleClass).fields;
      for (var entry in fields) {
        var hash = entry.key;
        var type = entry.value;
        // [hash, type]
        if (idx >= _fields.length || idlLabelToId(_fields[idx].key) != idlLabelToId(hash)) {
          // skip field
          entry.value.decodeValue(x, type);
          continue;
        }
        var expectedEntry = _fields[idx];
        var expectKey = expectedEntry.key, expectType = expectedEntry.value;
        r[expectKey] = expectType.decodeValue(x, type);
        idx++;
      }
      if (idx < _fields.length) {
        throw 'Cannot find field ${_fields[idx].key}';
      }
      return r;
    } else {
      throw 'Not a record type';
    }
  }

  @override
  String get name {
    final fields = _fields.map((entry) => entry.key + ':' + entry.value.name);
    return "record {${fields.join('; ')}}";
  }

  @override
  String display() {
    final fields = _fields.map((entry) => entry.key + ':' + entry.value.display());
    return "record {${fields.join('; ')}}";
  }

  @override
  valueToString(Map x) {
    final values = _fields.map((entry) => x[entry.key]).toList();
    final fields = zipWith<MapEntry, dynamic, String>(
        _fields, values, (entry, d) => entry.key + '=' + entry.value.valueToString(d));
    return "record {${fields.join('; ')}}";
  }
}

Map makeMap(List<CType> components) {
  final x = {};
  for (var e in components) {
    var i = components.indexOf(e);
    (x['_${i}_'] = e);
  }
  return x;
}

class TupleClass<T extends List> extends ConstructType<List> {
  late final List<CType> _components;
  late final List<MapEntry> _fields;
  List<MapEntry> get fields => _fields;
  TupleClass(List<CType> components) : super() {
    _components = components;
    _fields = (Map.from(makeMap(components))).entries.toList();
    _fields.sort((a, b) => idlLabelToId(a.key).toInt() - idlLabelToId(b.key).toInt());
  }

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitTuple(this, _components, d);
  }

  @override
  bool covariant(x) {
    // `>=` because tuples can be covariant when encoded.

    return ((x is List) &&
        x.length >= _fields.length &&
        _components.asMap().entries.map((t) {
              return t.value.covariant(x[t.key]) ? 0 : 1;
            }).reduce((value, element) => value + element) ==
            0);
  }

  @override
  Uint8List encodeValue(List x) {
    final bufs = zipWith<CType, dynamic, Uint8List>(_components, x, (c, d) => c.encodeValue(d));
    return u8aConcat(bufs);
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (var entry in _fields) {
      entry.value.buildTypeTable(typeTable);
    }
    final opCode = slebEncode(IDLTypeIds.Record);
    final len = lebEncode(_fields.length);
    final fields = _fields.map(
      (entry) => u8aConcat([lebEncode(idlLabelToId(entry.key)), entry.value.encodeType(typeTable)]),
    );

    typeTable.add(this, u8aConcat([opCode, len, u8aConcat(fields.toList())]));
  }

  @override
  T decodeValue(Pipe x, CType t) {
    final tuple = checkType(t);
    if ((tuple is! TupleClass)) {
      throw 'not a tuple type';
    }
    if (tuple._components.length < _components.length) {
      throw 'tuple mismatch';
    }
    final res = [];
    for (var entry in tuple._components.asMap().entries) {
      //[i, wireType]
      var i = entry.key;
      var wireType = entry.value;

      if (i >= _components.length) {
        // skip value
        wireType.decodeValue(x, wireType);
      } else {
        res.add(_components[i].decodeValue(x, wireType));
      }
    }
    return res as T;
  }

  @override
  String display() {
    final fields = _components.map((value) => value.display()).toList();
    return "record {${fields.join('; ')}}";
  }

  @override
  String valueToString(List x) {
    final fields = zipWith<CType, dynamic, String>(_components, x, (c, d) => c.valueToString(d));
    return "record {${fields.join('; ')}}";
  }

  @override
  String get name {
    final fields = _fields.map((entry) => entry.key + ':' + entry.value.name);
    return "record {${fields.join('; ')}}";
  }
}

class VariantClass extends ConstructType<Map<String, dynamic>> {
  late final List<MapEntry<String, CType<dynamic>>> _fields;
  VariantClass(Map<String, CType> fields) : super() {
    _fields = fields.entries.toList();
    _fields.sort((a, b) => idlLabelToId(a.key).toInt() - idlLabelToId(b.key).toInt());
  }

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitVariant(this, _fields, d);
  }

  @override
  bool covariant(x) {
    return (x is Map &&
        (x).entries.length == 1 &&
        _fields.every((entry) {
          // [k, v]
          // eslint-disable-next-line
          return !x.containsKey(entry.key) || entry.value.covariant(x[entry.key]);
        }));
  }

  @override
  Uint8List encodeValue(Map<String, dynamic> x) {
    for (var i = 0; i < _fields.length; i++) {
      var name = _fields[i].key;
      var type = _fields[i].value;
      // eslint-disable-next-line
      if (x.containsKey(name)) {
        final idx = lebEncode(i);
        final buf = type.encodeValue(x[name]);

        return u8aConcat([idx, buf]);
      }
    }
    throw 'Variant has no data: $x';
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (var entry in _fields) {
      var type = entry.value;
      type.buildTypeTable(typeTable);
    }
    final opCode = slebEncode(IDLTypeIds.Variant);
    final len = lebEncode(_fields.length);
    final fields = _fields.map(
      (entry) => u8aConcat([lebEncode(idlLabelToId(entry.key)), entry.value.encodeType(typeTable)]),
    );
    typeTable.add(this, u8aConcat([opCode, len, ...fields]));
  }

  @override
  Map<String, dynamic> decodeValue(Pipe x, CType t) {
    final variant = checkType(t);
    if ((variant is! VariantClass)) {
      throw 'Not a variant type';
    }
    final idx = (lebDecode(x).toInt());
    if (idx >= variant._fields.length) {
      throw 'Invalid variant index: $idx';
    }
    final entry = variant._fields[idx];
    var wireHash = entry.key, wireType = entry.value;
    for (var fEntry in _fields) {
      var key = fEntry.key, expectType = fEntry.value;
      if (idlLabelToId(wireHash) == idlLabelToId(key)) {
        final value = expectType.decodeValue(x, wireType);
        return {key: value};
      }
    }
    throw 'Cannot find field hash $wireHash';
  }

  @override
  String get name {
    final fields = _fields.map((entry) => entry.key + ':' + entry.value.name);
    return "variant {${fields.join('; ')}}";
  }

  @override
  String display() {
    final fields = _fields.map(
      (entry) => entry.key + (entry.value.name == 'null' ? '' : ":${entry.value.display()}"),
    );
    return "variant {${fields.join('; ')}}";
  }

  @override
  String valueToString(Map<String, dynamic> x) {
    for (var fEntry in _fields) {
      var name = fEntry.key, type = fEntry.value;
      // eslint-disable-next-line
      if (x.containsKey(name)) {
        final value = type.valueToString(x[name]);
        if (value == 'null') {
          return "variant {$name}";
        } else {
          return "variant {$name=$value}";
        }
      }
    }
    throw 'Variant has no data: $x';
  }
}

/// Represents a reference to an IDL type, used for defining recursive data
/// types.
class RecClass<T> extends ConstructType<T> {
  static int _counter = 0;
  // ignore: prefer_final_fields
  int _id = RecClass._counter++;
  ConstructType<T>? _type;

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
  encodeValue(T x) {
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
  decodeValue(Pipe x, CType t) {
    _checkType();
    return _type!.decodeValue(x, t);
  }

  @override
  get name => "rec_$_id";

  @override
  display() {
    _checkType();
    return "μ$name.${_type!.name}";
  }

  @override
  valueToString(T x) {
    _checkType();
    return _type!.valueToString(x);
  }

  _checkType() {
    if (_type == null) {
      throw 'Recursive type uninitialized';
    }
  }
}

PrincipalId decodePrincipalId(Pipe b) {
  final x = Uint8List.fromList(safeRead((b as Pipe<int>), 1)).toHex();
  if (x != '01') {
    throw 'Cannot decode principal';
  }
  final len = lebDecode(b).toInt();
  final hex = Uint8List.fromList(safeRead(b, len)).toHex().toUpperCase();
  return PrincipalId.fromHex(hex);
}

class PrincipalClass extends PrimitiveType<PrincipalId> {
  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitPrincipal(this, d);
  }

  @override
  bool covariant(x) {
    return x is PrincipalId;
  }

  @override
  decodeValue(Pipe x, CType t) {
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
  static argsToString(List<CType> types, List v) {
    if (types.length != v.length) {
      throw 'arity mismatch';
    }
    return '(' +
        types.asMap().entries.map((entry) => entry.value.valueToString(v[entry.key])).join(', ') +
        ')';
  }

  final List<CType> argTypes;
  final List<CType> retTypes;
  final List<String> annotations;

  FuncClass(this.argTypes, this.retTypes, this.annotations) : super();

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitFunc(this, d);
  }

  @override
  bool covariant(x) {
    return ((x is List) && x.length == 2 && x[0] != null && x[0] is PrincipalId && x[1] is String);
  }

  @override
  Uint8List encodeValue(x) {
    // : [PrincipalId, string]
    final hex = (x[0] as PrincipalId).toHex();
    final buf = hex.toU8a();
    final len = lebEncode(buf.length);
    final canister = u8aConcat([
      Uint8List.fromList([1]),
      len,
      buf
    ]);

    final method = Uint8List.fromList((x[1] as String).plainToU8a(useDartEncode: true));
    final methodLen = lebEncode(method.length);
    return u8aConcat([
      Uint8List.fromList([1]),
      canister,
      methodLen,
      method
    ]);
  }

  @override
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (var argT in argTypes) {
      argT.buildTypeTable(typeTable);
    }
    for (var argR in retTypes) {
      argR.buildTypeTable(typeTable);
    }

    final opCode = slebEncode(IDLTypeIds.Func);
    final argLen = lebEncode(argTypes.length);
    final args = u8aConcat(argTypes.map((arg) => arg.encodeType(typeTable)).toList());
    final retLen = lebEncode(retTypes.length);
    final rets = u8aConcat(retTypes.map((arg) => arg.encodeType(typeTable)).toList());
    final annLen = lebEncode(annotations.length);
    final anns = u8aConcat(annotations.map((a) => encodeAnnotation(a)).toList());

    typeTable.add(this, u8aConcat([opCode, argLen, args, retLen, rets, annLen, anns]));
  }

  @override
  List<dynamic> decodeValue(Pipe x, CType t) {
    final r = Uint8List.fromList(safeRead((x as Pipe<int>), 1)).toHex();
    if (r != '01') {
      throw 'Cannot decode function reference';
    }
    final canister = decodePrincipalId(x);

    final mLen = (lebDecode(x).toInt());
    final buf = Uint8List.fromList(safeRead(x, mLen));
    if (!isValidUTF8(buf)) {
      throw 'Not valid UTF8 method name';
    }
    final method = buf.u8aToString();
    return [canister, method];
  }

  @override
  get name {
    final args = argTypes.map((arg) => arg.name).join(', ');
    final rets = retTypes.map((arg) => arg.name).join(', ');
    final annon = ' ' + annotations.join(' ');
    return "($args) -> ($rets)$annon";
  }

  @override
  String valueToString(x) {
    var principal = x[0] as PrincipalId, str = x[1] as String;
    return "func '${principal.toText()}'.$str";
  }

  @override
  String display() {
    final args = argTypes.map((arg) => arg.display()).join(', ');
    final rets = retTypes.map((arg) => arg.display()).join(', ');
    final annon = ' ' + annotations.join(' ');
    return "($args) → ($rets)$annon";
  }

  Uint8List encodeAnnotation(String ann) {
    if (ann == 'query') {
      return Uint8List.fromList([1]);
    } else if (ann == 'oneway') {
      return Uint8List.fromList([2]);
    } else {
      throw 'Illeagal function annotation';
    }
  }
}

class ServiceClass extends ConstructType<PrincipalId> {
  late final List<MapEntry<String, FuncClass>> _fields;
  List<MapEntry<String, FuncClass>> get fields => _fields;

  ServiceClass(Map<String, FuncClass> fields) : super() {
    _fields = (fields.entries).toList();
    _fields.sort(
        (a, b) => idlLabelToId(a.key.toString()).toInt() - idlLabelToId(b.key.toString()).toInt());
  }

  @override
  R accept<D, R>(Visitor<D, R> v, D d) {
    return v.visitService(this, d);
  }

  @override
  bool covariant(x) {
    return x is PrincipalId;
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
  void _buildTypeTableImpl(TypeTable typeTable) {
    for (var entry in _fields) {
      entry.value.buildTypeTable(typeTable);
    }
    final opCode = slebEncode(IDLTypeIds.Service);
    final len = lebEncode(_fields.length);
    final meths = _fields.map((entry) {
      var label = entry.key, func = entry.value;
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
  get name {
    final fields = _fields.map((entry) => entry.key + ':' + entry.value.name);
    return "service {${fields.join('; ')}}";
  }

  @override
  String valueToString(PrincipalId x) {
    return "service '${x.toText()}'";
  }
}

///
/// @param x
/// @returns {string}
String toReadableString(dynamic x) {
  if (x is BigInt) {
    return "BigInt($x)";
  } else {
    return jsonEncode(x);
  }
}

/// Encode a array of values
/// @returns {Buffer} serialised value
BinaryBlob idlEncode(List<CType> argTypes, List args) {
  if (args.length < argTypes.length) {
    throw 'Wrong number of message arguments';
  }

  final typeTable = TypeTable();
  for (var t in argTypes) {
    t.buildTypeTable(typeTable);
  }

  final magic = magicNumber.plainToU8a(useDartEncode: true);
  final table = typeTable.encode();
  final len = lebEncode(args.length);
  final typs = u8aConcat(argTypes.map((t) => t.encodeType(typeTable)).toList());
  final vals = u8aConcat(
    zipWith<CType<dynamic>, dynamic, dynamic>(argTypes, args, (t, x) {
      if (!t.covariant(x)) {
        throw "Invalid ${t.display()} argument: ${toReadableString(x)}";
      }
      return t.encodeValue(x);
    }),
  );

  return blobFromUint8Array(u8aConcat([magic, table, len, typs, vals]));
}

/// Decode a binary value
/// @param retTypes - Types expected in the buffer.
/// @param bytes - hex-encoded string, or buffer.
/// @returns Value deserialised to JS type
List idlDecode(List<CType> retTypes, Uint8List bytes) {
  final b = Pipe(bytes);

  if (bytes.lengthInBytes < magicNumber.length) {
    throw 'Message length smaller than magic number';
  }
  final magic = Uint8List.fromList(safeRead(b, magicNumber.length)).u8aToString();

  if (magic != magicNumber) {
    throw 'Wrong magic number: $magic';
  }

  // : [Array<[IDLTypeIds, any]>, number[]]
  List<dynamic> readTypeTable(Pipe pipe) {
    // Array<[IDLTypeIds, any]>;
    var typeTable = [];
    var len = lebDecode(pipe).toInt();

    for (var i = 0; i < len; i++) {
      var ty = slebDecode(pipe).toInt();
      switch (ty) {
        case IDLTypeIds.Opt:
        case IDLTypeIds.Vector:
          {
            var t = slebDecode(pipe).toInt();
            typeTable.add([ty, t]);
            break;
          }
        case IDLTypeIds.Record:
        case IDLTypeIds.Variant:
          {
            var fields = List.from([]);
            var objectLength = lebDecode(pipe).toInt();
            var prevHash;
            while (objectLength-- > 0) {
              var hash = lebDecode(pipe).toInt();
              if (hash >= pow(2, 32)) {
                throw 'field id out of 32-bit range';
              }
              if (prevHash is num && prevHash >= hash) {
                throw 'field id collision or not sorted';
              }
              prevHash = hash;
              var t = slebDecode(pipe).toInt();
              fields.add([hash, t]);
            }
            typeTable.add([ty, fields]);
            break;
          }
        case IDLTypeIds.Func:
          {
            for (var k = 0; k < 2; k++) {
              var funcLength = lebDecode(pipe).toInt();
              while (funcLength-- > 0) {
                slebDecode(pipe);
              }
            }
            var annLen = lebDecode(pipe).toInt();
            safeRead(pipe, annLen);
            typeTable.add([ty, null]);
            break;
          }
        case IDLTypeIds.Service:
          {
            var servLength = lebDecode(pipe).toInt();
            while (servLength-- > 0) {
              var l = lebDecode(pipe).toInt();
              safeRead(pipe, l);
              slebDecode(pipe);
            }
            typeTable.add([ty, null]);
            break;
          }
        default:
          throw 'Illegal op_code: $ty';
      }
    }

    var rawList = <int>[];
    var length = lebDecode(pipe).toInt();
    for (var i = 0; i < length; i++) {
      rawList.add(slebDecode(pipe).toInt());
    }
    return [typeTable, rawList];
  }

  var typeTableRead = readTypeTable(b);

  var rawTable = typeTableRead[0] as List<dynamic>; //Array<[IDLTypeIds, any]>
  var rawTypes = typeTableRead[1] as List<int>;
  if (rawTypes.length < retTypes.length) {
    throw 'Wrong number of return values';
  }

  var table = rawTable.map((_) => RecClass()).toList();

  CType getType(int t) {
    if (t < -24) {
      throw 'future value not supported';
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
          throw 'Illegal op_code: t';
      }
    }
    if (t >= rawTable.length) {
      throw 'type index out of range';
    }
    return table[t];
  }

  ConstructType buildType(List<dynamic> entry) {
    // entry: [IDLTypeIds, any]

    switch (entry[0]) {
      case IDLTypeIds.Vector:
        {
          var ty = getType(entry[1]);
          return Vec(ty);
        }
      case IDLTypeIds.Opt:
        {
          var ty = getType(entry[1]);
          return Opt(ty);
        }
      case IDLTypeIds.Record:
        {
          var fields = <String, CType>{};
          for (var e in entry[1] as List) {
            var name = "_${e[0].toString()}_";
            fields[name] = getType(e[1] as int);
          }
          var record = Record(fields);
          var tuple = record.tryAsTuple();
          if (tuple is List<CType>) {
            return Tuple(tuple);
          } else {
            return record;
          }
        }
      case IDLTypeIds.Variant:
        {
          var fields = <String, CType>{};
          for (var e in entry[1] as List) {
            var name = "_${e[0]}_";
            fields[name] = getType(e[1] as int);
          }
          return Variant(fields);
        }
      case IDLTypeIds.Func:
        {
          return Func([], [], []);
        }
      case IDLTypeIds.Service:
        {
          return Service({});
        }
      default:
        throw 'Illegal op_code: ${entry[0]}';
    }
  }

  rawTable.asMap().forEach((i, entry) {
    final t = buildType(entry);
    table[i].fill(t);
  });

  final types = rawTypes.map((t) => getType(t)).toList();

  final output = retTypes.asMap().entries.map((entry) {
    var result = entry.value.decodeValue(b, types[entry.key]);
    return result;
  }).toList();

  // skip unused values
  for (var ind = retTypes.length; ind < types.length; ind++) {
    types[ind].decodeValue(b, types[ind]);
  }

  if (b.buffer.isNotEmpty) {
    throw 'decode: Left-over bytes';
  }

  return output;
}

class IDL {
// ignore: non_constant_identifier_names
  static final Empty = EmptyClass();
// ignore: non_constant_identifier_names
  static final Reserved = ReservedClass();
// ignore: non_constant_identifier_names
  static final Bool = BoolClass();
// ignore: non_constant_identifier_names
  static final Null = NullClass();
// ignore: non_constant_identifier_names
  static final Text = TextClass();
// ignore: non_constant_identifier_names
  static final Int = IntClass();
// ignore: non_constant_identifier_names
  static final Nat = NatClass();
// ignore: non_constant_identifier_names
  static final Float32 = FloatClass(32);
// ignore: non_constant_identifier_names
  static final Float64 = FloatClass(64);
// ignore: non_constant_identifier_names
  static final Int8 = FixedIntClass(8);
// ignore: non_constant_identifier_names
  static final Int16 = FixedIntClass(16);
// ignore: non_constant_identifier_names
  static final Int32 = FixedIntClass(32);
// ignore: non_constant_identifier_names
  static final Int64 = FixedIntClass(64);
// ignore: non_constant_identifier_names
  static final Nat8 = FixedNatClass(8);
// ignore: non_constant_identifier_names
  static final Nat16 = FixedNatClass(16);
// ignore: non_constant_identifier_names
  static final Nat32 = FixedNatClass(32);
// ignore: non_constant_identifier_names
  static final Nat64 = FixedNatClass(64);
// ignore: non_constant_identifier_names
  static final Principal = PrincipalClass();

  // ignore: constant_identifier_names

  // ignore: non_constant_identifier_names
  static Tuple(List<CType> components) => TupleClass(components);
  // ignore: non_constant_identifier_names
  static Vec<T>(CType<T> type) => VecClass(type);
  // ignore: non_constant_identifier_names
  static Opt<T>(CType<T> type) => OptClass(type);
  // ignore: non_constant_identifier_names
  static Record(Map? fields) => RecordClass(fields);
  // ignore: non_constant_identifier_names
  static Variant(Map<String, CType<dynamic>> fields) => VariantClass(fields);
  // ignore: non_constant_identifier_names
  static Rec() => RecClass();
  // ignore: non_constant_identifier_names
  static Func(
          List<CType<dynamic>> argTypes, List<CType<dynamic>> retTypes, List<String> annotations) =>
      FuncClass(argTypes, retTypes, annotations);
  // ignore: non_constant_identifier_names
  static Service(Map<String, FuncClass> fields) => ServiceClass(fields);

  static BinaryBlob encode(List<CType> argTypes, List args) => idlEncode(argTypes, args);

  static List decode(List<CType> retTypes, Uint8List bytes) => idlDecode(retTypes, bytes);
}

typedef Tuple = TupleClass;
typedef Vec = VecClass;
typedef Opt = OptClass;
typedef Record = RecordClass;
typedef Variant = VariantClass;
typedef Rec = RecClass;
typedef Func = FuncClass;
typedef Service = ServiceClass;
