import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';
import 'package:agent_dart_base/utils/u8a.dart';

import '../converter/index.dart' as convert;
import '../interfaces.dart';
import '../tool.dart';
import 'index.dart';

Uint8List psbtToBuffer(PsbtAttributes attributes) {
  final keyVals = psbtToKeyVals(attributes);
  final globalMapKeyVals = keyVals.globalMapKeyVals;
  final inputKeyVals = keyVals.inputKeyVals;
  final outputKeyVals = keyVals.outputKeyVals;

  final globalBuffer = keyValsToBuffer(globalMapKeyVals);

  keyValsOrEmptyToBuffer(List<List<KeyValue>> keyVals) => keyVals.isEmpty
      ? [
          Uint8List.fromList([0])
        ]
      : keyVals.map(keyValsToBuffer);

  final inputBuffers = keyValsOrEmptyToBuffer(inputKeyVals).toList();
  final outputBuffers = keyValsOrEmptyToBuffer(outputKeyVals).toList();

  final header = Uint8List(5);
  writeUIntBE(header, 0x70736274ff, 0, 5);
  return u8aConcat([header, globalBuffer, ...inputBuffers, ...outputBuffers]);
}

int compare(Uint8List left, Uint8List right) {
  // ignore: parameter_assignments, avoid_multiple_declarations_per_line
  for (var i = 0, j = 0; i < left.length && j < right.length; i++, j++) {
    final a = left[i] & 0xff;
    final b = right[j] & 0xff;

    if (a != b) {
      return a - b;
    }
  }

  return left.length - right.length;
}

int sortKeyVals(KeyValue a, KeyValue b) {
  return compare(a.key, b.key);
}

List<KeyValue> mapInput(PsbtInput input) {
  final inputMap = input.toJson();
  final keyHexSet = <String>{};
  final keyVals =
      inputMap.entries.fold<List<KeyValue>>([], (previousValue, element) {
    if (element.key == 'unknownKeyVals') return previousValue;
    final converter = convert.inputConverters[element.key];
    if (converter == null) return previousValue;
    final encodedKeyVals = (element.value is List && element.value is! Uint8List
            ? element.value
            : [element.value])
        .map(
      (e) => converter.encode!(e),
    ) as List<KeyValue>;
    final keyHexes = encodedKeyVals.map((kv) => kv.key.toHex());
    for (var hex in keyHexes) {
      if (keyHexSet.contains(hex)) {
        throw Exception('Serialize Error: Duplicate key: $hex');
      }
      keyHexSet.add(hex);
    }
    return previousValue..addAll(encodedKeyVals);
  });

  // // Get other keyVals that have not yet been gotten
  final otherKeyVals = inputMap['unknownKeyVals'] != null
      ? (inputMap['unknownKeyVals'] as List<KeyValue>).where((keyVal) {
          return !keyHexSet.contains(keyVal.key.toHex());
        }).toList()
      : <KeyValue>[];
  return keyVals
    ..addAll(otherKeyVals)
    ..sort(sortKeyVals);
}

List<KeyValue> mapOutput(PsbtOutput output) {
  final outputMap = output.toJson();
  final keyHexSet = <String>{};
  final keyVals =
      outputMap.entries.fold<List<KeyValue>>([], (previousValue, element) {
    if (element.key == 'unknownKeyVals') return previousValue;
    final converter = convert.outputConverters[element.key];
    if (converter == null) return previousValue;
    final encodedKeyVals = (element.value is List && element.value is! Uint8List
            ? element.value
            : [element.value])
        .map(
      (e) => converter.encode!(e),
    ) as List<KeyValue>;
    final keyHexes = encodedKeyVals.map((kv) => kv.key.toHex());
    for (var hex in keyHexes) {
      if (keyHexSet.contains(hex)) {
        throw Exception('Serialize Error: Duplicate key: $hex');
      }
      keyHexSet.add(hex);
    }
    return previousValue..addAll(encodedKeyVals);
  });

  // // Get other keyVals that have not yet been gotten
  final otherKeyVals = outputMap['unknownKeyVals'] != null
      ? (outputMap['unknownKeyVals'] as List<KeyValue>).where((keyVal) {
          return !keyHexSet.contains(keyVal.key.toHex());
        }).toList()
      : <KeyValue>[];
  return keyVals
    ..addAll(otherKeyVals)
    ..sort(sortKeyVals);
}

List<KeyValue> mapGlobal(PsbtGlobal global) {
  final globalMap = global.toJson();
  final keyHexSet = <String>{};
  final keyVals =
      globalMap.entries.fold<List<KeyValue>>([], (previousValue, element) {
    if (element.key == 'unknownKeyVals') return previousValue;
    final converter = convert.globalConverters[element.key];
    if (converter == null) return previousValue;
    final encodedKeyVals = (element.value is List && element.value is! Uint8List
            ? element.value
            : [element.value])
        .map(
      (e) => converter.encode!(e),
    ) as List<KeyValue>;
    final keyHexes = encodedKeyVals.map((kv) => kv.key.toHex());
    for (var hex in keyHexes) {
      if (keyHexSet.contains(hex)) {
        throw Exception('Serialize Error: Duplicate key: $hex');
      }
      keyHexSet.add(hex);
    }
    return previousValue..addAll(encodedKeyVals);
  });

  // // Get other keyVals that have not yet been gotten
  final otherKeyVals = globalMap['unknownKeyVals'] != null
      ? (globalMap['unknownKeyVals'] as List<KeyValue>).where((keyVal) {
          return !keyHexSet.contains(keyVal.key.toHex());
        }).toList()
      : <KeyValue>[];
  return keyVals
    ..addAll(otherKeyVals)
    ..sort(sortKeyVals);
}

PsbtKeyVals psbtToKeyVals(PsbtAttributes psbtAttributes) {
  final inputs = psbtAttributes.inputs;
  final outputs = psbtAttributes.outputs;
  final globalMap = psbtAttributes.globalMap;
  final globalMapKeyVals = mapGlobal(globalMap);
  final inputKeyVals = inputs.map(mapInput).toList();
  final outputKeyVals = outputs.map(mapOutput).toList();

  return PsbtKeyVals(
    globalMapKeyVals: globalMapKeyVals,
    inputKeyVals: inputKeyVals,
    outputKeyVals: outputKeyVals,
  );
}

class PsbtKeyVals {
  List<KeyValue> globalMapKeyVals;
  List<List<KeyValue>> inputKeyVals;
  List<List<KeyValue>> outputKeyVals;
  PsbtKeyVals({
    required this.globalMapKeyVals,
    required this.inputKeyVals,
    required this.outputKeyVals,
  });

  Map<String, dynamic> toJson() => {
        'globalKeyVals': globalMapKeyVals,
        'inputKeyVals': inputKeyVals,
        'outputKeyVals': outputKeyVals,
      };
}
