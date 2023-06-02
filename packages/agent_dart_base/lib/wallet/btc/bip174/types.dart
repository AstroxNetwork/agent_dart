// ignore_for_file: constant_identifier_names

enum GlobalTypes {
  UNSIGNED_TX,
  GLOBAL_XPUB,
}

const GLOBAL_TYPE_NAMES = ['unsignedTx', 'globalXpub'];

enum InputTypes {
  NON_WITNESS_UTXO,
  WITNESS_UTXO,
  PARTIAL_SIG,
  SIGHASH_TYPE,
  REDEEM_SCRIPT,
  WITNESS_SCRIPT,
  BIP32_DERIVATION,
  FINAL_SCRIPTSIG,
  FINAL_SCRIPTWITNESS,
  POR_COMMITMENT,
  TAP_KEY_SIG,
  TAP_SCRIPT_SIG,
  TAP_LEAF_SCRIPT,
  TAP_BIP32_DERIVATION,
  TAP_INTERNAL_KEY,
  TAP_MERKLE_ROOT,
}

const INPUT_TYPE_NAMES = [
  'nonWitnessUtxo',
  'witnessUtxo',
  'partialSig',
  'sighashType',
  'redeemScript',
  'witnessScript',
  'bip32Derivation',
  'finalScriptSig',
  'finalScriptWitness',
  'porCommitment',
  'tapKeySig',
  'tapScriptSig',
  'tapLeafScript',
  'tapBip32Derivation',
  'tapInternalKey',
  'tapMerkleRoot',
];

enum OutputEnum {
  REDEEM_SCRIPT,
  WITNESS_SCRIPT,
  BIP32_DERIVATION, // multiple OK, key contains pubkey
  TAP_INTERNAL_KEY, //  = 0x05,
  TAP_TREE,
  TAP_BIP32_DERIVATION, // multiple OK, key contains x-only pubkey
}

class OutputTypes {
  static const REDEEM_SCRIPT = OutputEnum.REDEEM_SCRIPT;
  static const WITNESS_SCRIPT = OutputEnum.WITNESS_SCRIPT;
  static const BIP32_DERIVATION =
      OutputEnum.BIP32_DERIVATION; // multiple OK, key contains pubkey
  static const TAP_INTERNAL_KEY = 0x05;
  static const TAP_TREE = OutputEnum.TAP_TREE;
  static const TAP_BIP32_DERIVATION = OutputEnum
      .TAP_BIP32_DERIVATION; // multiple OK, key contains x-only pubkey
}

const OUTPUT_TYPE_NAMES = [
  'redeemScript',
  'witnessScript',
  'bip32Derivation',
  'tapInternalKey',
  'tapTree',
  'tapBip32Derivation',
];
