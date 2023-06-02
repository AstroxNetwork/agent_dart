import 'dart:typed_data';

import 'package:agent_dart_base/utils/extension.dart';
import 'package:collection/collection.dart';

import '../interfaces.dart';
import '../tool.dart';
import '../types.dart';
import '../varint.dart' as varuint;
import '../converter/global/globalXpub.dart' as globalXpub;
import '../converter/input/nonWitnessUtxo.dart' as nonWitnessUtxo;
import '../converter/input/witnessUtxo.dart' as witnessUtxo;
import '../converter/input/partialSig.dart' as partialSig;
import '../converter/input/sighashType.dart' as sighashType;
import '../converter/input/finalScriptSig.dart' as finalScriptSig;
import '../converter/input/finalScriptWitness.dart' as finalScriptWitness;
import '../converter/input/porCommitment.dart' as porCommitment;
import '../converter/input/tapKeySig.dart' as tapKeySig;
import '../converter/input/tapScriptSig.dart' as tapScriptSig;
import '../converter/input/tapLeafScript.dart' as tapLeafScript;
import '../converter/input/tapMerkleRoot.dart' as tapMerkleRoot;
import '../converter/output/tapTree.dart' as tapTree;
import '../converter/shared/redeemScript.dart' as redeemScript;
import '../converter/shared/witnessScript.dart' as witnessScript;
import '../converter/shared/bip32Derivation.dart' as bip32Derivation;
import '../converter/shared/tapBip32Derivation.dart' as tapBip32Derivation;
import '../converter/shared/tapInternalKey.dart' as tapInternalKey;
import '../converter/shared/checkPubkey.dart' as checkPubkey;

import 'index.dart';

PsbtAttributes psbtFromBuffer(
    Uint8List buffer, TransactionFromBuffer txGetter) {
  var offset = 0;

  Uint8List varSlice() {
    final keyLen = varuint.decode(buffer, offset);
    offset += varuint.encodingLength(keyLen);
    final key = buffer.sublist(offset, offset + keyLen);
    offset += keyLen;
    return key;
  }

  int readUInt32BE() {
    final num = buffer.buffer.asByteData().getUint32(offset);
    offset += 4;
    return num;
  }

  int readUInt8() {
    final num = buffer.buffer.asByteData().getUint8(offset);
    offset += 1;
    return num;
  }

  KeyValue getKeyValue() {
    final key = varSlice();
    final value = varSlice();
    return KeyValue(
      key: key,
      value: value,
    );
  }

  bool checkEndOfKeyValPairs() {
    if (offset >= buffer.length) {
      throw Exception('Format Error: Unexpected End of PSBT');
    }
    final isEnd = buffer.buffer.asByteData().getUint8(offset) == 0;
    if (isEnd) {
      offset++;
    }
    return isEnd;
  }

  if (readUInt32BE() != 0x70736274) {
    throw Exception('Format Error: Invalid Magic Number');
  }
  if (readUInt8() != 0xff) {
    throw Exception(
      'Format Error: Magic Number must be followed by 0xff separator',
    );
  }

  final globalMapKeyVals = <KeyValue>[];
  final globalKeyIndex = <String, int>{};
  while (!checkEndOfKeyValPairs()) {
    final keyVal = getKeyValue();
    final hexKey = keyVal.key.toHex();
    if (globalKeyIndex[hexKey] != null) {
      throw Exception(
        'Format Error: Keys must be unique for global keymap: key $hexKey',
      );
    }
    globalMapKeyVals.add(keyVal);
    globalKeyIndex[hexKey] = 1;
  }
  final unsignedTxMaps = globalMapKeyVals
      .where((keyVal) => keyVal.key[0] == GlobalTypes.UNSIGNED_TX.index)
      .toList();

  if (unsignedTxMaps.length != 1) {
    throw Exception('Format Error: Only one UNSIGNED_TX allowed');
  }

  final unsignedTx = txGetter(unsignedTxMaps[0].value);

  final counts = unsignedTx.getInputOutputCounts();
  final inputCount = counts.inputCount;
  final outputCount = counts.outputCount;
  final inputKeyVals = <List<KeyValue>>[];
  final outputKeyVals = <List<KeyValue>>[];

  for (var index in range(inputCount)) {
    final inputKeyIndex = <String, int>{};
    final input = <KeyValue>[];
    while (!checkEndOfKeyValPairs()) {
      final keyVal = getKeyValue();
      final hexKey = keyVal.key.toHex();
      if (inputKeyIndex[hexKey] != null) {
        throw Exception(
          'Format Error: Keys must be unique for each input: ' +
              'input index $index key $hexKey',
        );
      }
      inputKeyIndex[hexKey] = 1;
      input.add(keyVal);
    }
    inputKeyVals.add(input);
  }

  for (var index in range(outputCount)) {
    final outputKeyIndex = <String, int>{};
    final output = <KeyValue>[];
    while (!checkEndOfKeyValPairs()) {
      final keyVal = getKeyValue();
      final hexKey = keyVal.key.toHex();
      if (outputKeyIndex[hexKey] != null) {
        throw Exception(
          'Format Error: Keys must be unique for each output: output index $index key $hexKey',
        );
      }
      outputKeyIndex[hexKey] = 1;
      output.add(keyVal);
    }
    outputKeyVals.add(output);
  }
  return psbtFromKeyVals(
      unsignedTx,
      PsbtFromKeyValsArg(
        globalMapKeyVals: globalMapKeyVals,
        inputKeyVals: inputKeyVals,
        outputKeyVals: outputKeyVals,
      ));
}

class PsbtFromKeyValsArg {
  List<KeyValue> globalMapKeyVals;
  List<List<KeyValue>> inputKeyVals;
  List<List<KeyValue>> outputKeyVals;
  PsbtFromKeyValsArg({
    required this.globalMapKeyVals,
    required this.inputKeyVals,
    required this.outputKeyVals,
  });
}

void checkKeyBuffer(String type, Uint8List keyBuf, int keyNum) {
  if (!keyBuf.equals(Uint8List.fromList([keyNum]))) {
    throw Exception(
      'Format Error: Invalid $type key: ${keyBuf.toHex()}',
    );
  }
}

PsbtAttributes psbtFromKeyVals(
    Transaction unsignedTx, PsbtFromKeyValsArg args) {
  final globalMap = PsbtGlobal(unsignedTx: unsignedTx);
  var txCount = 0;
  for (var keyVal in args.globalMapKeyVals) {
    if (keyVal.key[0] == GlobalTypes.UNSIGNED_TX.index) {
      checkKeyBuffer('global', keyVal.key, GlobalTypes.UNSIGNED_TX.index);
      if (txCount > 0) {
        throw Exception('Format Error: GlobalMap has multiple UNSIGNED_TX');
      }
      txCount++;
      break;
    } else if (keyVal.key[0] == GlobalTypes.GLOBAL_XPUB.index) {
      globalMap.globalXpub ??= [];
      globalMap.globalXpub!.add(globalXpub.decode(keyVal));
      break;
    } else {
      globalMap.unknownKeyVals ??= [];
      globalMap.unknownKeyVals!.add(keyVal);
    }
  }
  final inputCount = args.inputKeyVals.length;
  final outputCount = args.outputKeyVals.length;
  final inputs = <PsbtInput>[];
  final outputs = <PsbtOutput>[];

  for (var index in range(inputCount)) {
    final inputKeyVals = args.inputKeyVals[index];
    final input = PsbtInput();
    for (var keyVal in inputKeyVals) {
      final checker = checkPubkey.makeChecker([
        InputTypes.PARTIAL_SIG.index,
        InputTypes.BIP32_DERIVATION.index,
      ]);
      checker.decode!(keyVal);
      if (keyVal.key[0] == InputTypes.NON_WITNESS_UTXO.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.NON_WITNESS_UTXO.index);
        if (input.nonWitnessUtxo != null) {
          throw Exception(
            'Format Error: Input has multiple NON_WITNESS_UTXO',
          );
        }
        input.nonWitnessUtxo = nonWitnessUtxo.decode(keyVal);
        break;
      } else if (keyVal.key[0] == InputTypes.WITNESS_UTXO.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.WITNESS_UTXO.index);
        if (input.witnessUtxo != null) {
          throw Exception('Format Error: Input has multiple WITNESS_UTXO');
        }
        input.witnessUtxo = witnessUtxo.decode(keyVal);
        break;
      } else if (keyVal.key[0] == InputTypes.PARTIAL_SIG.index) {
        input.partialSig ??= [];
        input.partialSig!.add(partialSig.decode(keyVal));
        break;
      } else if (keyVal.key[0] == InputTypes.SIGHASH_TYPE.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.SIGHASH_TYPE.index);
        if (input.sighashType != null) {
          throw Exception('Format Error: Input has multiple SIGHASH_TYPE');
        }
        input.sighashType = sighashType.decode(keyVal);
        break;
      } else if (keyVal.key[0] == InputTypes.REDEEM_SCRIPT.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.REDEEM_SCRIPT.index);
        if (input.redeemScript != null) {
          throw Exception('Format Error: Input has multiple REDEEM_SCRIPT');
        }
        input.redeemScript = redeemScript
            .makeConverter(OutputTypes.REDEEM_SCRIPT.index)
            .decode!(keyVal);
        break;
      } else if (keyVal.key[0] == InputTypes.WITNESS_SCRIPT.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.WITNESS_SCRIPT.index);
        if (input.witnessScript != null) {
          throw Exception('Format Error: Input has multiple WITNESS_SCRIPT');
        }
        input.witnessScript = witnessScript
            .makeConverter(OutputTypes.WITNESS_SCRIPT.index)
            .decode!(keyVal);
        break;
      } else if (keyVal.key[0] == InputTypes.BIP32_DERIVATION.index) {
        input.bip32Derivation ??= [];
        input.bip32Derivation!.add(bip32Derivation
            .makeConverter(OutputTypes.BIP32_DERIVATION.index)
            .decode!(keyVal));
        break;
      } else if (keyVal.key[0] == InputTypes.FINAL_SCRIPTSIG.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.FINAL_SCRIPTSIG.index);
        if (input.finalScriptSig != null) {
          throw Exception('Format Error: Input has multiple FINAL_SCRIPTSIG');
        }
        input.finalScriptSig = finalScriptSig.decode(keyVal);
        break;
      } else if (keyVal.key[0] == InputTypes.FINAL_SCRIPTWITNESS.index) {
        checkKeyBuffer(
            'input', keyVal.key, InputTypes.FINAL_SCRIPTWITNESS.index);
        if (input.finalScriptWitness != null) {
          throw Exception(
              'Format Error: Input has multiple FINAL_SCRIPTWITNESS');
        }
        input.finalScriptWitness = finalScriptWitness.decode(keyVal);
        break;
      } else if (keyVal.key[0] == InputTypes.POR_COMMITMENT.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.POR_COMMITMENT.index);
        input.porCommitment = porCommitment.decode(keyVal);
        break;
      } else if (keyVal.key[0] == InputTypes.TAP_KEY_SIG.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.TAP_KEY_SIG.index);
        input.tapKeySig = tapKeySig.decode(keyVal);
      } else if (keyVal.key[0] == InputTypes.TAP_SCRIPT_SIG.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.TAP_SCRIPT_SIG.index);
        input.tapScriptSig ??= [];
        input.tapScriptSig!.add(tapScriptSig.decode(keyVal));
        break;
      } else if (keyVal.key[0] == InputTypes.TAP_LEAF_SCRIPT.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.TAP_LEAF_SCRIPT.index);
        input.tapLeafScript ??= [];
        input.tapLeafScript!.add(tapLeafScript.decode(keyVal));
        break;
      } else if (keyVal.key[0] == InputTypes.TAP_BIP32_DERIVATION.index) {
        checkKeyBuffer(
            'input', keyVal.key, InputTypes.TAP_BIP32_DERIVATION.index);
        input.tapBip32Derivation ??= [];
        input.tapBip32Derivation!.add(tapBip32Derivation
            .makeConverter(OutputTypes.TAP_BIP32_DERIVATION.index)
            .decode!(keyVal));
        break;
      } else if (keyVal.key[0] == InputTypes.TAP_INTERNAL_KEY.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.TAP_INTERNAL_KEY.index);
        input.tapInternalKey = tapInternalKey
            .makeConverter(OutputTypes.TAP_INTERNAL_KEY)
            .decode!(keyVal);
        break;
      } else if (keyVal.key[0] == InputTypes.TAP_MERKLE_ROOT.index) {
        checkKeyBuffer('input', keyVal.key, InputTypes.TAP_MERKLE_ROOT.index);
        input.tapMerkleRoot = tapMerkleRoot.decode(keyVal);
        break;
      } else {
        // This will allow inclusion during serialization.
        input.unknownKeyVals ??= [];
        input.unknownKeyVals!.add(keyVal);
      }
    }
    inputs.add(input);
  }
  for (var index in range(outputCount)) {
    final outputKeyVals = args.outputKeyVals[index];
    final output = PsbtOutput();
    for (var keyVal in outputKeyVals) {
      final checker = checkPubkey.makeChecker([
        InputTypes.PARTIAL_SIG.index,
        InputTypes.BIP32_DERIVATION.index,
      ]);
      checker.decode!(keyVal);

      if (keyVal.key[0] == OutputTypes.REDEEM_SCRIPT.index) {
        checkKeyBuffer('output', keyVal.key, OutputTypes.REDEEM_SCRIPT.index);
        if (output.redeemScript != null) {
          throw Exception('Format Error: Output has multiple REDEEM_SCRIPT');
        }
        output.redeemScript = redeemScript
            .makeConverter(OutputTypes.REDEEM_SCRIPT.index)
            .decode!(keyVal);
        break;
      } else if (keyVal.key[0] == OutputTypes.WITNESS_SCRIPT.index) {
        checkKeyBuffer('output', keyVal.key, OutputTypes.WITNESS_SCRIPT.index);
        if (output.witnessScript != null) {
          throw Exception('Format Error: Output has multiple WITNESS_SCRIPT');
        }
        output.witnessScript = witnessScript
            .makeConverter(OutputTypes.WITNESS_SCRIPT.index)
            .decode!(keyVal);
        break;
      } else if (keyVal.key[0] == OutputTypes.BIP32_DERIVATION.index) {
        checkKeyBuffer(
            'output', keyVal.key, OutputTypes.BIP32_DERIVATION.index);
        output.bip32Derivation ??= [];
        output.bip32Derivation!.add(bip32Derivation
            .makeConverter(OutputTypes.BIP32_DERIVATION.index)
            .decode!(keyVal));
        break;
      } else if (keyVal.key[0] == OutputTypes.TAP_INTERNAL_KEY) {
        checkKeyBuffer('output', keyVal.key, OutputTypes.TAP_INTERNAL_KEY);
        output.tapInternalKey = tapInternalKey
            .makeConverter(OutputTypes.TAP_INTERNAL_KEY)
            .decode!(keyVal);
        break;
      } else if (keyVal.key[0] == OutputTypes.TAP_TREE.index) {
        checkKeyBuffer('output', keyVal.key, OutputTypes.TAP_TREE.index);
        output.tapTree = tapTree.decode(keyVal);
        break;
      } else if (keyVal.key[0] == OutputTypes.TAP_BIP32_DERIVATION.index) {
        checkKeyBuffer(
            'output', keyVal.key, OutputTypes.TAP_BIP32_DERIVATION.index);
        output.tapBip32Derivation ??= [];
        output.tapBip32Derivation!.add(tapBip32Derivation
            .makeConverter(OutputTypes.TAP_BIP32_DERIVATION.index)
            .decode!(keyVal));
        break;
      } else {
        output.unknownKeyVals ??= [];
        output.unknownKeyVals!.add(keyVal);
      }
    }
    outputs.add(output);
  }
  return PsbtAttributes(globalMap: globalMap, inputs: inputs, outputs: outputs);
}
