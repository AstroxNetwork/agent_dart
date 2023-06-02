import 'dart:typed_data';

// This function should throw if the scriptSig or scriptWitness section for
// any input is not empty. And it should throw if the transaction is segwit
// format. As per the BIP.
typedef TransactionFromBuffer = Transaction Function(Uint8List buffer);
// This is a light wrapper that will give the information needed for parsing
// and modifying the Transaction internally.
// This library will have no logical understanding of the Transaction format,
// and it must be provided via the below interface

class InputOutputCount {
  final int inputCount;
  final int outputCount;
  InputOutputCount({required this.inputCount, required this.outputCount});
}

abstract class Transaction {
  // Self explanatory
  InputOutputCount getInputOutputCounts();
  // This function should check the arg for the correct info needed to add an
  // input. For example in Bitcoin it would need the hash, index, and sequence.
  // This function will modify the internal state of the transaction.
  void addInput(dynamic objectArg);
  // Same as addInput. But with adding an output. For Bitcoin scriptPubkey
  // and value are all that should be needed.
  void addOutput(dynamic objectArg);
  // This is primarily used when serializing the PSBT to a binary.
  // You can implement caching behind the scenes if needed and clear the cache
  // when addInput or addOutput are called.
  Uint8List toBuffer();
}

class KeyValue {
  final Uint8List key;
  final Uint8List value;
  KeyValue({required this.key, required this.value});
}

class PsbtGlobal extends PsbtGlobalUpdate {
  final Transaction unsignedTx;
  List<KeyValue>? unknownKeyVals;
  PsbtGlobal({
    required this.unsignedTx,
    this.unknownKeyVals,
  });
  @override
  Map<String, dynamic> toJson() => {
        'unsignedTx': unsignedTx.toBuffer(),
        'globalXpub': globalXpub,
        'unknownKeyVals': unknownKeyVals,
      };
}

class PsbtGlobalUpdate {
  List<GlobalXpub>? globalXpub;
  PsbtGlobalUpdate({this.globalXpub});
  Map<String, dynamic> toJson() => {
        'globalXpub': globalXpub,
      };
}

class PsbtInput extends PsbtInputUpdate {
  List<KeyValue>? unknownKeyVals;
  Map<String, dynamic> toJson() => {
        'partialSig': partialSig,
        'witnessUtxo': witnessUtxo,
        'nonWitnessUtxo': nonWitnessUtxo,
        'sighashType': sighashType,
        'redeemScript': redeemScript,
        'witnessScript': witnessScript,
        'bip32Derivation': bip32Derivation,
        'finalScriptSig': finalScriptSig,
        'finalScriptWitness': finalScriptWitness,
        'porCommitment': porCommitment,
        'tapKeySig': tapKeySig,
        'tapScriptSig': tapScriptSig,
        'tapLeafScript': tapLeafScript,
        'tapBip32Derivation': tapBip32Derivation,
        'tapInternalKey': tapInternalKey,
        'tapMerkleRoot': tapMerkleRoot,
        'unknownKeyVals': unknownKeyVals,
      };
}

class PsbtInputUpdate {
  List<PartialSig>? partialSig;
  WitnessUtxo? witnessUtxo;
  NonWitnessUtxo? nonWitnessUtxo;
  SighashType? sighashType;
  RedeemScript? redeemScript;
  WitnessScript? witnessScript;
  List<Bip32Derivation>? bip32Derivation;
  FinalScriptSig? finalScriptSig;
  FinalScriptWitness? finalScriptWitness;
  PorCommitment? porCommitment;
  TapKeySig? tapKeySig;
  List<TapScriptSig>? tapScriptSig;
  List<TapLeafScript>? tapLeafScript;
  List<TapBip32Derivation>? tapBip32Derivation;
  TapInternalKey? tapInternalKey;
  TapMerkleRoot? tapMerkleRoot;
  PsbtInputUpdate(
      {this.partialSig,
      this.witnessUtxo,
      this.nonWitnessUtxo,
      this.sighashType,
      this.redeemScript,
      this.witnessScript,
      this.bip32Derivation,
      this.finalScriptSig,
      this.finalScriptWitness,
      this.porCommitment,
      this.tapKeySig,
      this.tapScriptSig,
      this.tapLeafScript,
      this.tapBip32Derivation,
      this.tapInternalKey,
      this.tapMerkleRoot});
  Map<String, dynamic> toJson() => {
        'partialSig': partialSig,
        'witnessUtxo': witnessUtxo,
        'nonWitnessUtxo': nonWitnessUtxo,
        'sighashType': sighashType,
        'redeemScript': redeemScript,
        'witnessScript': witnessScript,
        'bip32Derivation': bip32Derivation,
        'finalScriptSig': finalScriptSig,
        'finalScriptWitness': finalScriptWitness,
        'porCommitment': porCommitment,
        'tapKeySig': tapKeySig,
        'tapScriptSig': tapScriptSig,
        'tapLeafScript': tapLeafScript,
        'tapBip32Derivation': tapBip32Derivation,
        'tapInternalKey': tapInternalKey,
        'tapMerkleRoot': tapMerkleRoot,
      };
}

class PsbtInputExtended extends PsbtInput {
  Map<String, dynamic> index;
  PsbtInputExtended({required this.index});
}

class PsbtOutput extends PsbtOutputUpdate {
  List<KeyValue>? unknownKeyVals;
  PsbtOutput({this.unknownKeyVals});
  Map<String, dynamic> toJson() => {
        'redeemScript': redeemScript,
        'witnessScript': witnessScript,
        'bip32Derivation': bip32Derivation,
        'tapBip32Derivation': tapBip32Derivation,
        'tapTree': tapTree,
        'tapInternalKey': tapInternalKey,
        'unknownKeyVals': unknownKeyVals
      };
}

class PsbtOutputUpdate {
  RedeemScript? redeemScript;
  WitnessScript? witnessScript;
  List<Bip32Derivation>? bip32Derivation;
  List<TapBip32Derivation>? tapBip32Derivation;
  TapTree? tapTree;
  TapInternalKey? tapInternalKey;
  PsbtOutputUpdate(
      {this.redeemScript,
      this.witnessScript,
      this.bip32Derivation,
      this.tapBip32Derivation,
      this.tapTree,
      this.tapInternalKey});
  Map<String, dynamic> toJson() => {
        'redeemScript': redeemScript,
        'witnessScript': witnessScript,
        'bip32Derivation': bip32Derivation,
        'tapBip32Derivation': tapBip32Derivation,
        'tapTree': tapTree,
        'tapInternalKey': tapInternalKey,
      };
}

class PsbtOutputExtended extends PsbtOutput {
  final Map<String, dynamic> index;
  PsbtOutputExtended({required this.index});
}

class GlobalXpub {
  final Uint8List extendedPubkey;
  final Uint8List masterFingerprint;
  String path;
  GlobalXpub(
      {required this.extendedPubkey,
      required this.masterFingerprint,
      required this.path});
}

class PartialSig {
  final Uint8List pubkey;
  final Uint8List signature;
  PartialSig({required this.pubkey, required this.signature});
}

class Bip32Derivation {
  final Uint8List masterFingerprint;
  final Uint8List pubkey;
  final String path;

  Bip32Derivation(
      {required this.masterFingerprint,
      required this.pubkey,
      required this.path});
}

class WitnessUtxo {
  final Uint8List script;
  final int value;
  WitnessUtxo({required this.script, required this.value});
}

typedef NonWitnessUtxo = Uint8List;

typedef SighashType = int;

typedef RedeemScript = Uint8List;
// export type RedeemScript = Buffer;

typedef WitnessScript = Uint8List;
// export type WitnessScript = Buffer;

typedef FinalScriptSig = Uint8List;
// export type FinalScriptSig = Buffer;

typedef FinalScriptWitness = Uint8List;
// export type FinalScriptWitness = Buffer;

typedef PorCommitment = String;
// export type PorCommitment = string;

typedef TapKeySig = Uint8List;
// export type TapKeySig = Buffer;

class TapScriptSig extends PartialSig {
  final Uint8List leafHash;
  TapScriptSig(
      {required this.leafHash,
      required Uint8List pubkey,
      required Uint8List signature})
      : super(pubkey: pubkey, signature: signature);
}

class TapScript {
  final int leafVersion;
  final Uint8List script;
  TapScript({required this.leafVersion, required this.script});
}

typedef ControlBlock = Uint8List;
// export type ControlBlock = Buffer;

class TapLeafScript extends TapScript {
  final ControlBlock controlBlock;
  TapLeafScript(
      {required int leafVersion,
      required Uint8List script,
      required this.controlBlock})
      : super(leafVersion: leafVersion, script: script);
}

class TapBip32Derivation extends Bip32Derivation {
  final List<Uint8List> leafHashes;
  TapBip32Derivation(
      {required this.leafHashes,
      required super.masterFingerprint,
      required super.pubkey,
      required super.path});
}

typedef TapInternalKey = Uint8List;

typedef TapMerkleRoot = Uint8List;

class TapLeaf extends TapScript {
  final int depth;
  TapLeaf(
      {required int leafVersion,
      required Uint8List script,
      required this.depth})
      : super(leafVersion: leafVersion, script: script);
}

class TapTree {
  final List<TapLeaf> leaves;
  TapTree({required this.leaves});
}

typedef TransactionIOCountGetter = InputOutputCount Function(
    Uint8List txBuffer);

class TransactionInput {
  final Uint8List hash;
  final int index;
  final int? sequence;
  TransactionInput({required this.hash, required this.index, this.sequence});
}

typedef TransactionInputAdder = Uint8List Function(
    TransactionInput input, Uint8List txBuffer);

class TransactionOutput {
  final Uint8List script;
  final int value;
  TransactionOutput({required this.script, required this.value});
}

typedef TransactionOutputAdder = Uint8List Function(
    TransactionOutput output, Uint8List txBuffer);

typedef TransactionVersionSetter = Uint8List Function(
    int version, Uint8List txBuffer);

typedef TransactionLocktimeSetter = Uint8List Function(
    int locktime, Uint8List txBuffer);

abstract class BaseConverter<T> {
  T Function(KeyValue keyVal)? decode;
  KeyValue Function(T data)? encode;
  bool Function(dynamic data)? check;
  String? expected;
  bool Function(
    List<T> array,
    T item,
    Set<String> dupeSet,
  )? canAddToArray;
  bool Function(dynamic currentData, dynamic newData)? canAdd;
  BaseConverter({
    this.decode,
    this.encode,
    this.check,
    this.canAddToArray,
    this.canAdd,
  });
}
