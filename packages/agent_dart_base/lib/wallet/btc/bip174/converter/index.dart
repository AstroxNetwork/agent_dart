import '../interfaces.dart';
import '../types.dart';
import './global/globalXpub.dart';
import './global/unsignedTx.dart';
import './input/nonWitnessUtxo.dart';
import './input/witnessUtxo.dart';
import './input/partialSig.dart';
import './input/sigHashType.dart';
import './input/finalScriptSig.dart';
import './input/finalScriptWitness.dart';
import './input/porCommitment.dart';
import './input/tapKeySig.dart';
import './input/tapScriptSig.dart';
import './input/tapLeafScript.dart';
import './input/tapMerkleRoot.dart';
import './output/tapTree.dart';
import './shared/redeemScript.dart' as redeemScript;
import './shared/witnessScript.dart' as witnessScript;
import './shared/bip32Derivation.dart' as bip32Derivation;
import './shared/tapBip32Derivation.dart' as tapBip32Derivation;
import './shared/tapInternalKey.dart' as tapInternalKey;
import './shared/checkPubkey.dart' as checkPubkey;

typedef EncodeFunction = KeyValue Function(dynamic data);

final inputConverters = <String, BaseConverter<dynamic>>{
  'finalScriptSig': finalScriptSigConverter,
  'finalScriptWitness': finalScriptWitnessConverter,
  'nonWitnessUtxo': nonWitnessUtxoConverter,
  'partialSig': partialSigConverter,
  'porCommitment': porCommitmentConverter,
  'signhashType': sighashTypeConverter,
  'witnessUtxo': witnessUtxoConverter,
  'tapKeySig': tapKeySigConverter,
  'tapScriptSig': tapScriptSigConverter,
  'tapLeafScript': tapLeafScriptConverter,
  'tapMerkleRoot': tapMerkleRootConverter,
  'bip32Derivation':
      bip32Derivation.makeConverter(InputTypes.BIP32_DERIVATION.index),
  'redeemScript': redeemScript.makeConverter(InputTypes.REDEEM_SCRIPT.index),
  'witnessScript': witnessScript.makeConverter(InputTypes.WITNESS_SCRIPT.index),
  'tapBip32Derivation':
      tapBip32Derivation.makeConverter(InputTypes.TAP_BIP32_DERIVATION.index),
  'tapInternalKey':
      tapInternalKey.makeConverter(InputTypes.TAP_INTERNAL_KEY.index),
};

final outputConverters = <String, BaseConverter<dynamic>>{
  'bip32Derivation':
      bip32Derivation.makeConverter(OutputTypes.BIP32_DERIVATION.index),
  'redeemScript': redeemScript.makeConverter(OutputTypes.REDEEM_SCRIPT.index),
  'witnessScript':
      witnessScript.makeConverter(OutputTypes.WITNESS_SCRIPT.index),
  'checkPubkey': checkPubkey.makeChecker([OutputTypes.BIP32_DERIVATION.index]),
  'tapBip32Derivation': tapBip32Derivation.makeConverter(
    OutputTypes.TAP_BIP32_DERIVATION.index,
  ),
  'tapTree': tapTreeConverter,
  'tapInternalKey': tapInternalKey.makeConverter(OutputTypes.TAP_INTERNAL_KEY),
};

final globalConverters = <String, BaseConverter<dynamic>>{
  'globalXpub': globalXpubConverter,
  'unsignedTx': unsignedTxConverter,
  'checkPubkey': checkPubkey.makeChecker([]),
};
