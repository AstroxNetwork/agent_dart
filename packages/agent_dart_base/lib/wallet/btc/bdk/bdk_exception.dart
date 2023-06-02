import 'package:freezed_annotation/freezed_annotation.dart';

part 'bdk_exception.freezed.dart';

@freezed
class BdkException with _$BdkException {
  ///This error is thrown when trying to convert Bare and Public key script to address
  const factory BdkException.scriptDoesntHaveAddressForm() =
      ScriptDoesntHaveAddressForm;

  ///Cannot build a tx without recipients
  const factory BdkException.noRecipients() = NoRecipients;

  ///Generic error
  const factory BdkException.generic(String e) = Generic;

  ///manuallySelectedOnly option is selected but no utxo has been passed
  const factory BdkException.noUtxosSelected() = NoUtxosSelected;

  ///Output created is under the dust limit, 546 satoshis
  const factory BdkException.outputBelowDustLimit() = OutputBelowDustLimit;

  ///Wallet’s UTXO set is not enough to cover recipient’s requested plus fee
  const factory BdkException.insufficientFunds(String e) = InsufficientFunds;

  ///Branch and bound coin selection possible attempts with sufficiently big UTXO set could grow exponentially, thus a limit is set, and when hit, this error is thrown
  const factory BdkException.bnBTotalTriesExceeded() = BnBTotalTriesExceeded;

  ///Branch and bound coin selection tries to avoid needing a change by finding the right inputs for the desired outputs plus fee, if there is not such combination this error is thrown
  const factory BdkException.bnBNoExactMatch() = BnBNoExactMatch;

  ///Happens when trying to spend an UTXO that is not in the internal database
  const factory BdkException.unknownUtxo() = UnknownUtxo;

  ///Thrown when a tx is not found in the internal database
  const factory BdkException.transactionNotFound() = TransactionNotFound;

  ///Happens when trying to bump a transaction that is already confirmed
  const factory BdkException.transactionConfirmed() = TransactionConfirmed;

  ///When bumping a tx the fee rate requested is lower than required
  const factory BdkException.feeRateTooLow(String e) = FeeRateTooLow;

  ///When bumping a tx the absolute fee requested is lower than replaced tx absolute fee
  const factory BdkException.feeTooLow(String e) = FeeTooLow;

  ///Node doesn’t have data to estimate a fee rate
  const factory BdkException.feeRateUnavailable() = FeeRateUnavailable;

  ///Descriptor checksum mismatch
  const factory BdkException.checksumMismatch() = ChecksumMismatch;

  ///Miniscript error
  const factory BdkException.miniscript(String e) = Miniscript;

  ///Miniscript error
  const factory BdkException.bip32(String e) = Bip32;

  ///An ECDSA error
  const factory BdkException.secp256k1(String e) = Secp256k1;

  ///Sync attempt failed due to missing scripts in cache which are needed to satisfy stopGap.
  const factory BdkException.missingCachedScripts() = MissingCachedScripts;

  ///Electrum client error
  const factory BdkException.electrum(String e) = Electrum;

  ///Esplora client error
  const factory BdkException.esplora(String e) = Esplora;

  ///Sled database error
  const factory BdkException.sled(String e) = Sled;

  ///Rpc client error
  const factory BdkException.rpc(String e) = Rpc;

  ///Rusqlite client error
  const factory BdkException.rusqlite(String e) = Rusqlite;

  ///Unknown error
  const factory BdkException.unExpected(String e) = UnExpected;
}
