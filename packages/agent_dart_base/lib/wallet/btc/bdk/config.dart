import 'package:agent_dart_ffi/agent_dart_ffi.dart';

import './bdk_exception.dart';

const defaultSignOptions = SignOptions(
  trustWitnessUtxo: true,
  allowAllSighashes: true,
  removePartialSigs: false,
  tryFinalize: true,
  allowGrinding: true,
  signWithTapInternalKey: true,
  finalizeMineOnly: true,
);

BdkException configException(String e) {
  if (e.contains('Generic')) {
    final message = e.split('Generic');
    return BdkException.generic(message.last);
  } else if (e.contains('NoRecipients')) {
    return const BdkException.noRecipients();
  } else if (e.contains('ScriptDoesntHaveAddressForm')) {
    return const BdkException.scriptDoesntHaveAddressForm();
  } else if (e.contains('NoUtxosSelected')) {
    return const BdkException.noUtxosSelected();
  } else if (e.contains('OutputBelowDustLimit')) {
    return const BdkException.outputBelowDustLimit();
  } else if (e.contains('BnBTotalTriesExceeded')) {
    return const BdkException.bnBTotalTriesExceeded();
  } else if (e.contains('BnBNoExactMatch')) {
    return const BdkException.bnBNoExactMatch();
  } else if (e.contains('UnknownUtxo')) {
    return const BdkException.unknownUtxo();
  } else if (e.contains('TransactionNotFound')) {
    return const BdkException.transactionNotFound();
  } else if (e.contains('TransactionConfirmed')) {
    return const BdkException.transactionConfirmed();
  } else if (e.contains('FeeRateUnavailable')) {
    return const BdkException.feeRateUnavailable();
  } else if (e.contains('ChecksumMismatch')) {
    return const BdkException.checksumMismatch();
  } else if (e.contains('MissingCachedScripts')) {
    return const BdkException.missingCachedScripts();
  } else if (e.contains('InsufficientFunds')) {
    final msg = e.split('InsufficientFunds');
    return BdkException.insufficientFunds(msg.last);
  } else if (e.contains('FeeRateTooLow')) {
    final msg = e.split('FeeRateTooLow');
    return BdkException.feeRateTooLow(msg.last);
  } else if (e.contains('FeeTooLow')) {
    final msg = e.split('FeeTooLow');
    return BdkException.feeTooLow(msg.last);
  } else if (e.contains('Sled')) {
    final msg = e.split('Sled');
    return BdkException.sled(msg.last);
    // } else if( e.contains('Descriptor')){
    //   final msg = e.split('Descriptor');
    //   return BdkException.descriptor(msg.last);
  } else if (e.contains('Miniscript')) {
    final msg = e.split('Miniscript');
    return BdkException.miniscript(msg.last);
  } else if (e.contains('Bip3')) {
    final msg = e.split('Bip3');
    return BdkException.bip32(msg.last);
  } else if (e.contains('Esplora')) {
    final msg = e.split('Esplora');
    return BdkException.esplora(msg.last);
  } else if (e.contains('Secp256k1')) {
    final msg = e.split('Secp256k1');
    return BdkException.secp256k1(msg.last);
  } else if (e.contains('Electrum')) {
    final msg = e.split('Electrum');
    return BdkException.electrum(msg.last);
  } else if (e.contains('Rpc')) {
    final msg = e.split('Rpc');
    return BdkException.rpc(msg.last);
  } else if (e.contains('Rusqlite')) {
    final msg = e.split('Rusqlite');
    return BdkException.rusqlite(msg.last);
  }
  return BdkException.unExpected(e);
}
