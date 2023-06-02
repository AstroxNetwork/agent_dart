import 'dart:typed_data';

import '../../interfaces.dart';
import '../../types.dart';

KeyValue encode(Transaction data) {
  return KeyValue(
      key: Uint8List.fromList([GlobalTypes.UNSIGNED_TX.index]),
      value: data.toBuffer());
}

final unsignedTxConverter = TransactionConverter(
  encode: encode,
);

class TransactionConverter implements BaseConverter<Transaction> {
  @override
  Transaction Function(KeyValue keyVal)? decode;
  @override
  KeyValue Function(Transaction data)? encode;
  @override
  bool Function(dynamic data)? check;
  @override
  String? expected = 'Uint8List';
  @override
  bool Function(
    List<Transaction> array,
    Transaction item,
    Set<String> dupeSet,
  )? canAddToArray;
  @override
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  TransactionConverter({this.encode});
}
