import 'dart:typed_data';

import 'package:agent_dart_base/wallet/btc/bip174/converter/index.dart';
import 'package:collection/collection.dart';
import 'package:agent_dart_base/utils/extension.dart';

import 'interfaces.dart';
import 'tool.dart';

PsbtInput checkForInput(
  List<PsbtInput> inputs,
  int inputIndex,
) {
  final input = inputs[inputIndex];
  if (input == null && input is! PsbtInput) {
    throw Exception('No input $inputIndex');
  }
  return input;
}

PsbtOutput checkForOutput(
  List<PsbtOutput> outputs,
  int outputIndex,
) {
  final output = outputs[outputIndex];
  if (output == null) throw Exception('No output #$outputIndex');
  return output;
}

void checkHasKey(
  KeyValue checkKeyVal,
  List<KeyValue> keyVals,
  int enumLength,
) {
  if (checkKeyVal.key[0] < enumLength) {
    throw Exception(
      'Use the method for your specific key instead of addUnknownKeyVal*',
    );
  }
  if (keyVals.where((kv) => kv.key.equals(checkKeyVal.key)).isNotEmpty) {
    throw Exception('Duplicate Key: ${checkKeyVal.key.toHex()}');
  }
}

int getEnumLength(Map<String, dynamic> myenum) {
  return myenum.keys.length;
}

void inputCheckUncleanFinalized(
  int inputIndex,
  PsbtInput input,
) {
  var result = false;
  if (input.nonWitnessUtxo != null || input.witnessUtxo != null) {
    final needScriptSig = input.redeemScript != null;
    final needWitnessScript = input.witnessScript != null;
    final scriptSigOK = needScriptSig == null || input.finalScriptSig != null;
    final witnessScriptOK =
        needWitnessScript == null || input.finalScriptWitness != null;
    final hasOneFinal =
        input.finalScriptSig != null || input.finalScriptWitness != null;
    result = scriptSigOK && witnessScriptOK && hasOneFinal;
  }
  if (result == false) {
    throw Exception(
      'Input #$inputIndex has too much or too little data to clean',
    );
  }
}

// function throwForUpdateMaker(
//   typeName: string,
//   name: string,
//   expected: string,
//   data: any,
// ): void {
//   throw new Error(
//     `Data for ${typeName} key ${name} is incorrect: Expected ` +
//       `${expected} and got ${JSON.stringify(data)}`,
//   );
// }

void updateGlobal(PsbtGlobalUpdate update, PsbtGlobal mainData) {
  final updateData = update.toJson();
  final mainDataMap = mainData.toJson();
  for (var name in update.toJson().keys) {
    final data = updateData[name];
    final converter = globalConverters[name]!;
    final isArray = converter.canAddToArray != null;
    // If unknown data. ignore and do not add
    if (converter.check != null) {
      if (isArray) {
        if ((data is Uint8List || (data is! Uint8List && data is! List)) ||
            // @ts-ignore
            (mainDataMap[name] && mainDataMap[name] is! List)) {
          throw Exception('Key type $name must be an array');
        }
        if ((data is! Uint8List && data is List) &&
            data.every(converter.check!)) {
          throw Exception('Key type $name must be an array');
        }
        // @ts-ignore
        final arr = mainDataMap[name] as List;
        final dupeCheckSet = <String>{};
        if (!data
            .every((v) => converter.canAddToArray!(arr, v, dupeCheckSet))) {
          throw Exception('Can not add duplicate data to array');
        }
        // @ts-ignore
        mainDataMap[name] = arr..add(data);
      } else {
        if (!converter.check!(data)) {
          throw Exception('Key type $name must be an array');
        }
        if (!converter.canAdd!(mainDataMap, data)) {
          throw Exception('Can not add duplicate data to array');
        }
        // @ts-ignore
        mainDataMap[name] = data;
      }
    }
  }
}

void updateInput(PsbtInputUpdate update, PsbtInput mainData) {
  final updateData = update.toJson();
  final mainDataMap = mainData.toJson();
  for (var name in update.toJson().keys) {
    final data = updateData[name];
    final converter = globalConverters[name]!;
    final isArray = converter.canAddToArray != null;
    // If unknown data. ignore and do not add
    if (converter.check != null) {
      if (isArray) {
        if ((data is Uint8List || (data is! Uint8List && data is! List)) ||
            // @ts-ignore
            (mainDataMap[name] && mainDataMap[name] is! List)) {
          throw Exception('Key type $name must be an array');
        }
        if ((data is! Uint8List && data is List) &&
            data.every(converter.check!)) {
          throw Exception('Key type $name must be an array');
        }
        // @ts-ignore
        final arr = mainDataMap[name] as List;
        final dupeCheckSet = <String>{};
        if (!data
            .every((v) => converter.canAddToArray!(arr, v, dupeCheckSet))) {
          throw Exception('Can not add duplicate data to array');
        }
        // @ts-ignore
        mainDataMap[name] = arr..add(data);
      } else {
        if (!converter.check!(data)) {
          throw Exception('Key type $name must be an array');
        }
        if (!converter.canAdd!(mainDataMap, data)) {
          throw Exception('Can not add duplicate data to array');
        }
        // @ts-ignore
        mainDataMap[name] = data;
      }
    }
  }
}

void updateOutput(PsbtOutputUpdate update, PsbtOutput mainData) {
  final updateData = update.toJson();
  final mainDataMap = mainData.toJson();
  for (var name in update.toJson().keys) {
    final data = updateData[name];
    final converter = globalConverters[name]!;
    final isArray = converter.canAddToArray != null;
    // If unknown data. ignore and do not add
    if (converter.check != null) {
      if (isArray) {
        if ((data is Uint8List || (data is! Uint8List && data is! List)) ||
            // @ts-ignore
            (mainDataMap[name] && mainDataMap[name] is! List)) {
          throw Exception('Key type $name must be an array');
        }
        if ((data is! Uint8List && data is List) &&
            data.every(converter.check!)) {
          throw Exception('Key type $name must be an array');
        }
        // @ts-ignore
        final arr = mainDataMap[name] as List;
        final dupeCheckSet = <String>{};
        if (!data
            .every((v) => converter.canAddToArray!(arr, v, dupeCheckSet))) {
          throw Exception('Can not add duplicate data to array');
        }
        // @ts-ignore
        mainDataMap[name] = arr..add(data);
      } else {
        if (!converter.check!(data)) {
          throw Exception('Key type $name must be an array');
        }
        if (!converter.canAdd!(mainDataMap, data)) {
          throw Exception('Can not add duplicate data to array');
        }
        // @ts-ignore
        mainDataMap[name] = data;
      }
    }
  }
}

void addInputAttributes(List<PsbtInput> inputs, PsbtInput data) {
  final index = inputs.length - 1;
  final input = checkForInput(inputs, index);
  updateInput(data, input);
}

void addOutputAttributes(List<PsbtOutput> outputs, PsbtOutput data) {
  final index = outputs.length - 1;
  final output = checkForOutput(outputs, index);
  updateOutput(data, output);
}

Uint8List defaultVersionSetter(int version, Uint8List txBuf) {
  if (txBuf is! Uint8List || txBuf.length < 4) {
    throw Exception('Set Version: Invalid Transaction');
  }
  writeUInt32LE(txBuf, version, 0);
  return txBuf;
}

Uint8List defaultLocktimeSetter(int locktime, Uint8List txBuf) {
  if (txBuf is! Uint8List || txBuf.length < 4) {
    throw Exception('Set Version: Invalid Transaction');
  }
  writeUInt32LE(txBuf, locktime, txBuf.length - 4);
  return txBuf;
}
