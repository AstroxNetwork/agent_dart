import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';

import 'interfaces.dart';
import 'parser/fromBuffer.dart';
import 'parser/index.dart';
import 'parser/toBuffer.dart';
import './utils.dart' as util;
import 'types.dart';

class Psbt {
  List<PsbtInput> inputs = [];
  List<PsbtOutput> outputs = [];
  late PsbtGlobal globalMap;

  Psbt(Transaction tx) {
    globalMap = PsbtGlobal(
      unsignedTx: tx,
    );
  }

  static Psbt fromBase64(String data, TransactionFromBuffer txFromBuffer) {
    final buffer = base64Decode(data);
    return Psbt.fromBuffer(buffer, txFromBuffer);
  }

  static Psbt fromHex(String data, TransactionFromBuffer txFromBuffer) {
    final buffer = data.toU8a();
    return Psbt.fromBuffer(buffer, txFromBuffer);
  }

  static Psbt fromBuffer(Uint8List buffer, TransactionFromBuffer txFromBuffer) {
    final results = psbtFromBuffer(buffer, txFromBuffer);
    final psbt = Psbt(results.globalMap.unsignedTx);
    return psbt;
  }

  String toBase64() {
    final buffer = toBuffer();
    return base64Encode(buffer);
  }

  String toHex() {
    final buffer = toBuffer();
    return buffer.toHex();
  }

  Uint8List toBuffer() {
    return psbtToBuffer(
        PsbtAttributes(globalMap: globalMap, inputs: inputs, outputs: outputs));
  }

  Psbt updateGlobal(PsbtGlobalUpdate updateData) {
    util.updateGlobal(updateData, globalMap);
    return this;
  }

  Psbt updateInput(int inputIndex, PsbtInputUpdate updateData) {
    final input = util.checkForInput(this.inputs, inputIndex);
    util.updateInput(updateData, input);
    return this;
  }

  Psbt updateOutput(int outputIndex, PsbtOutputUpdate updateData) {
    final output = util.checkForOutput(this.outputs, outputIndex);
    util.updateOutput(updateData, output);
    return this;
  }

  Psbt addUnknownKeyValToGlobal(KeyValue keyVal) {
    globalMap.unknownKeyVals ??= [];
    util.checkHasKey(
      keyVal,
      globalMap.unknownKeyVals!,
      GlobalTypes.values.length,
    );
    globalMap.unknownKeyVals!.add(keyVal);
    return this;
  }

  Psbt addUnknownKeyValToInput(int inputIndex, KeyValue keyVal) {
    final input = util.checkForInput(inputs, inputIndex);
    input.unknownKeyVals ??= [];
    util.checkHasKey(keyVal, input.unknownKeyVals!, InputTypes.values.length);
    input.unknownKeyVals!.add(keyVal);
    return this;
  }

  Psbt addUnknownKeyValToOutput(int inputIndex, KeyValue keyVal) {
    final output = util.checkForOutput(outputs, inputIndex);
    output.unknownKeyVals ??= [];
    util.checkHasKey(keyVal, output.unknownKeyVals!, OutputEnum.values.length);
    output.unknownKeyVals!.add(keyVal);
    return this;
  }

  Psbt addInput(PsbtInputExtended inputData) {
    globalMap.unsignedTx.addInput(inputData);
    inputs.add(PsbtInput()..unknownKeyVals = []);
    final addKeyVals = inputData.unknownKeyVals ?? [];
    final inputIndex = inputs.length - 1;
    if (addKeyVals is! List) {
      throw Exception('unknownKeyVals must be an Array');
    }
    for (var keyVal in addKeyVals) {
      addUnknownKeyValToInput(inputIndex, keyVal);
    }
    util.addInputAttributes(inputs, inputData);
    return this;
  }

  Psbt addOutput(PsbtOutputExtended outputData) {
    globalMap.unsignedTx.addOutput(outputData);
    outputs.add(PsbtOutput()..unknownKeyVals = []);
    final addKeyVals = outputData.unknownKeyVals ?? [];
    final outputIndex = outputs.length - 1;
    if (addKeyVals is! List) {
      throw Exception('unknownKeyVals must be an Array');
    }
    for (var keyVal in addKeyVals) {
      addUnknownKeyValToOutput(outputIndex, keyVal);
    }
    util.addOutputAttributes(outputs, outputData);
    return this;
  }

  Psbt clearFinalizedInput(int inputIndex) {
    final input = util.checkForInput(inputs, inputIndex);
    util.inputCheckUncleanFinalized(inputIndex, input);
    final inputMap = input.toJson();
    for (var key in inputMap.keys) {
      if (![
        'witnessUtxo',
        'nonWitnessUtxo',
        'finalScriptSig',
        'finalScriptWitness',
        'unknownKeyVals',
      ].contains(key)) {
        inputMap.remove(key);
      }
    }
    return this;
  }
  //   combine(...those: this[]): this {
//     // Combine this with those.
//     // Return self for chaining.
//     const result = combine([this].concat(those));
//     Object.assign(this, result);
//     return this;
//   }
}
// export class Psbt {
//   static fromBase64<T extends typeof Psbt>(
//     this: T,
//     data: string,
//     txFromBuffer: TransactionFromBuffer,
//   ): InstanceType<T> {
//     const buffer = Buffer.from(data, 'base64');
//     return this.fromBuffer(buffer, txFromBuffer);
//   }
//   static fromHex<T extends typeof Psbt>(
//     this: T,
//     data: string,
//     txFromBuffer: TransactionFromBuffer,
//   ): InstanceType<T> {
//     const buffer = Buffer.from(data, 'hex');
//     return this.fromBuffer(buffer, txFromBuffer);
//   }
//   static fromBuffer<T extends typeof Psbt>(
//     this: T,
//     buffer: Buffer,
//     txFromBuffer: TransactionFromBuffer,
//   ): InstanceType<T> {
//     const results = psbtFromBuffer(buffer, txFromBuffer);
//     const psbt = new this(results.globalMap.unsignedTx) as InstanceType<T>;
//     Object.assign(psbt, results);
//     return psbt;
//   }

//   readonly inputs: PsbtInput[] = [];
//   readonly outputs: PsbtOutput[] = [];
//   readonly globalMap: PsbtGlobal;

//   constructor(tx: Transaction) {
//     this.globalMap = {
//       unsignedTx: tx,
//     };
//   }

//   toBase64(): string {
//     const buffer = this.toBuffer();
//     return buffer.toString('base64');
//   }

//   toHex(): string {
//     const buffer = this.toBuffer();
//     return buffer.toString('hex');
//   }

//   toBuffer(): Buffer {
//     return psbtToBuffer(this);
//   }

//   updateGlobal(updateData: PsbtGlobalUpdate): this {
//     updateGlobal(updateData, this.globalMap);
//     return this;
//   }

//   updateInput(inputIndex: number, updateData: PsbtInputUpdate): this {
//     const input = checkForInput(this.inputs, inputIndex);
//     updateInput(updateData, input);
//     return this;
//   }

//   updateOutput(outputIndex: number, updateData: PsbtOutputUpdate): this {
//     const output = checkForOutput(this.outputs, outputIndex);
//     updateOutput(updateData, output);
//     return this;
//   }

//   addUnknownKeyValToGlobal(keyVal: KeyValue): this {
//     checkHasKey(
//       keyVal,
//       this.globalMap.unknownKeyVals,
//       getEnumLength(GlobalTypes),
//     );
//     if (!this.globalMap.unknownKeyVals) this.globalMap.unknownKeyVals = [];
//     this.globalMap.unknownKeyVals.push(keyVal);
//     return this;
//   }

//   addUnknownKeyValToInput(inputIndex: number, keyVal: KeyValue): this {
//     const input = checkForInput(this.inputs, inputIndex);
//     checkHasKey(keyVal, input.unknownKeyVals, getEnumLength(InputTypes));
//     if (!input.unknownKeyVals) input.unknownKeyVals = [];
//     input.unknownKeyVals.push(keyVal);
//     return this;
//   }

//   addUnknownKeyValToOutput(outputIndex: number, keyVal: KeyValue): this {
//     const output = checkForOutput(this.outputs, outputIndex);
//     checkHasKey(keyVal, output.unknownKeyVals, getEnumLength(OutputTypes));
//     if (!output.unknownKeyVals) output.unknownKeyVals = [];
//     output.unknownKeyVals.push(keyVal);
//     return this;
//   }

//   addInput(inputData: PsbtInputExtended): this {
//     this.globalMap.unsignedTx.addInput(inputData);
//     this.inputs.push({
//       unknownKeyVals: [],
//     });
//     const addKeyVals = inputData.unknownKeyVals || [];
//     const inputIndex = this.inputs.length - 1;
//     if (!Array.isArray(addKeyVals)) {
//       throw new Error('unknownKeyVals must be an Array');
//     }
//     addKeyVals.forEach((keyVal: KeyValue) =>
//       this.addUnknownKeyValToInput(inputIndex, keyVal),
//     );
//     addInputAttributes(this.inputs, inputData);
//     return this;
//   }

//   addOutput(outputData: PsbtOutputExtended): this {
//     this.globalMap.unsignedTx.addOutput(outputData);
//     this.outputs.push({
//       unknownKeyVals: [],
//     });
//     const addKeyVals = outputData.unknownKeyVals || [];
//     const outputIndex = this.outputs.length - 1;
//     if (!Array.isArray(addKeyVals)) {
//       throw new Error('unknownKeyVals must be an Array');
//     }
//     addKeyVals.forEach((keyVal: KeyValue) =>
//       this.addUnknownKeyValToInput(outputIndex, keyVal),
//     );
//     addOutputAttributes(this.outputs, outputData);
//     return this;
//   }

//   clearFinalizedInput(inputIndex: number): this {
//     const input = checkForInput(this.inputs, inputIndex);
//     inputCheckUncleanFinalized(inputIndex, input);
//     for (const key of Object.keys(input)) {
//       if (
//         ![
//           'witnessUtxo',
//           'nonWitnessUtxo',
//           'finalScriptSig',
//           'finalScriptWitness',
//           'unknownKeyVals',
//         ].includes(key)
//       ) {
//         // @ts-ignore
//         delete input[key];
//       }
//     }
//     return this;
//   }

//   combine(...those: this[]): this {
//     // Combine this with those.
//     // Return self for chaining.
//     const result = combine([this].concat(those));
//     Object.assign(this, result);
//     return this;
//   }

//   getTransaction(): Buffer {
//     return this.globalMap.unsignedTx.toBuffer();
//   }
// }