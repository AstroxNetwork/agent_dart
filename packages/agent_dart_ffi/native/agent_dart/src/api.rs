use crate::bdk::psbt::Transaction;
pub use crate::bdk::types::*;
use crate::bls_ffi::BlsFFI;
use crate::ed25519::ED25519FFI;
use crate::keyring::KeyRingFFI;
use crate::keystore::KeystoreFFI;
use crate::p256::{P256IdentityExport, P256FFI};
use crate::psbt::{asm_to_scriptpubkey, PsbtFFI};
use crate::schnorr::{SchnorrFFI, SchnorrIdentityExport};
use crate::secp256k1::{Secp256k1FFI, Secp256k1IdentityExport};
use crate::types::{
    AesDecryptReq, AesEncryptReq, BLSVerifyReq, ED25519FromSeedReq, ED25519Res, ED25519SignReq,
    ED25519VerifyReq, GetAddressReq, KeyDerivedRes, P256FromSeedReq, P256ShareSecretReq,
    P256SignReq, P256SignWithSeedReq, P256VerifyReq, PBKDFDeriveReq, PhraseToSeedReq,
    PsbtCombineReq, PsbtFreeAmountReq, PsbtFreeRateReq, PsbtToTxReq, PsbtToTxidReq, PsbtWalletReq,
    SchnorrFromSeedReq, SchnorrSignReq, SchnorrSignWithSeedReq, SchnorrVerifyReq, ScriptDeriveReq,
    Secp256k1FromSeedReq, Secp256k1RecoverReq, Secp256k1ShareSecretReq, Secp256k1SignReq,
    Secp256k1SignWithSeedReq, Secp256k1VerifyReq, SeedToKeyReq, SignatureFFI, TxBulderReq,
};
use std::str::FromStr;

/// --------------------
/// mnemonic
/// --------------------
/// create_phrase
/// phrase_to_seed
/// seed_to_key  

pub fn mnemonic_phrase_to_seed(req: PhraseToSeedReq) -> Vec<u8> {
    KeyRingFFI::phrase_to_seed(req)
}

pub fn mnemonic_seed_to_key(req: SeedToKeyReq) -> Vec<u8> {
    KeyRingFFI::seed_to_key(req)
}

/// --------------------
/// bls
/// --------------------
/// bls_init
/// bls_verify

pub fn bls_init() -> bool {
    BlsFFI::bls_init()
}

pub fn bls_verify(req: BLSVerifyReq) -> bool {
    BlsFFI::bls_verify(req)
}

/// --------------
/// ed25519
/// --------------------
/// ed25519_from_seed
/// ed25519_sign
/// ed25519_verify

pub fn ed25519_from_seed(req: ED25519FromSeedReq) -> ED25519Res {
    ED25519FFI::ed25519_from_blob(req)
}

pub fn ed25519_sign(req: ED25519SignReq) -> Vec<u8> {
    ED25519FFI::ed25519_sign(req)
}

pub fn ed25519_verify(req: ED25519VerifyReq) -> bool {
    ED25519FFI::ed25519_verify(req)
}

/// ---------------------
/// secp256k1
/// ---------------------

pub fn secp256k1_from_seed(req: Secp256k1FromSeedReq) -> Secp256k1IdentityExport {
    Secp256k1IdentityExport::from_raw(Secp256k1FFI::from_seed(req))
}

pub fn secp256k1_sign(req: Secp256k1SignWithSeedReq) -> SignatureFFI {
    Secp256k1FFI::from_seed(Secp256k1FromSeedReq { seed: req.seed })
        .sign(Secp256k1SignReq { msg: req.msg })
        .unwrap()
}

pub fn secp256k1_sign_recoverable(req: Secp256k1SignWithSeedReq) -> SignatureFFI {
    Secp256k1FFI::from_seed(Secp256k1FromSeedReq { seed: req.seed })
        .sign_recoverable(Secp256k1SignReq { msg: req.msg })
        .unwrap()
}

pub fn secp256k1_verify(req: Secp256k1VerifyReq) -> bool {
    Secp256k1FFI::verify_signature(req)
}

pub fn secp256k1_get_shared_secret(req: Secp256k1ShareSecretReq) -> Vec<u8> {
    Secp256k1FFI::get_share_secret(req).unwrap()
}

pub fn secp256k1_recover(req: Secp256k1RecoverReq) -> Vec<u8> {
    Secp256k1FFI::recover_pub_key(req).unwrap()
}

/// ---------------------
/// secp256k1
/// ---------------------

pub fn p256_from_seed(req: P256FromSeedReq) -> P256IdentityExport {
    P256IdentityExport::from_raw(P256FFI::from_seed(req))
}

pub fn p256_sign(req: P256SignWithSeedReq) -> SignatureFFI {
    P256FFI::from_seed(P256FromSeedReq { seed: req.seed })
        .sign(P256SignReq { msg: req.msg })
        .unwrap()
}

pub fn p256_verify(req: P256VerifyReq) -> bool {
    P256FFI::verify_signature(req)
}

pub fn p256_get_shared_secret(req: P256ShareSecretReq) -> Vec<u8> {
    P256FFI::get_share_secret(req).unwrap()
}

/// ---------------------
/// schnorr
/// ---------------------

pub fn schnorr_from_seed(req: SchnorrFromSeedReq) -> SchnorrIdentityExport {
    SchnorrIdentityExport::from_raw(SchnorrFFI::from_seed(req))
}

pub fn schnorr_sign(req: SchnorrSignWithSeedReq) -> SignatureFFI {
    SchnorrFFI::from_seed(SchnorrFromSeedReq { seed: req.seed })
        .sign(SchnorrSignReq {
            msg: req.msg,
            aux_rand: req.aux_rand,
        })
        .unwrap()
}

pub fn schnorr_verify(req: SchnorrVerifyReq) -> bool {
    SchnorrFFI::verify_signature(req)
}

/// ---------------------
/// aes
/// ---------------------
pub fn aes_128_ctr_encrypt(req: AesEncryptReq) -> Vec<u8> {
    KeystoreFFI::encrypt_128_ctr(req)
}

pub fn aes_128_ctr_decrypt(req: AesDecryptReq) -> Vec<u8> {
    KeystoreFFI::decrypt_128_ctr(req)
}

pub fn aes_256_cbc_encrypt(req: AesEncryptReq) -> Vec<u8> {
    KeystoreFFI::encrypt_256_cbc(req)
}

pub fn aes_256_cbc_decrypt(req: AesDecryptReq) -> Vec<u8> {
    KeystoreFFI::decrypt_256_cbc(req)
}

pub fn aes_256_gcm_encrypt(req: AesEncryptReq) -> Vec<u8> {
    KeystoreFFI::encrypt_256_gcm(req)
}

pub fn aes_256_gcm_decrypt(req: AesDecryptReq) -> Vec<u8> {
    KeystoreFFI::decrypt_256_gcm(req)
}

pub fn pbkdf2_derive_key(req: PBKDFDeriveReq) -> KeyDerivedRes {
    KeystoreFFI::pbkdf2_derive_key(req)
}

pub fn scrypt_derive_key(req: ScriptDeriveReq) -> KeyDerivedRes {
    KeystoreFFI::scrypt_derive_key(req)
}

//=========Transaction===========
pub fn new_transaction(tx: Vec<u8>) -> Vec<u8> {
    let res = Transaction::new(tx).expect("Cannot create transaction");
    res.serialize()
}

/// ---------------------
/// psbt
/// ---------------------
///
pub fn psbt_to_txid(req: PsbtToTxidReq) -> anyhow::Result<String> {
    PsbtFFI::psbt_to_txid(req.psbt_str)
}

pub fn psbt_extract_tx(req: PsbtToTxReq) -> anyhow::Result<Vec<u8>> {
    PsbtFFI::extract_tx(req.psbt_str)
}

pub fn psbt_get_fee_rate(req: PsbtFreeRateReq) -> Option<f32> {
    PsbtFFI::get_psbt_fee_rate(req.psbt_str)
}

pub fn psbt_get_fee_amount(req: PsbtFreeAmountReq) -> Option<u64> {
    PsbtFFI::get_fee_amount(req.psbt_str)
}

pub fn psbt_combine_psbt(req: PsbtCombineReq) -> anyhow::Result<String> {
    PsbtFFI::combine_psbt(req.psbt_str, req.other)
}

pub fn psbt_get_address(req: GetAddressReq) -> anyhow::Result<BitcoinAddress> {
    PsbtFFI::get_address_from_pubkey(
        req.public_key,
        req.network
            .map_or_else(|| None, |e| Some(bitcoin::Network::from_str(&e).unwrap())),
    )
}

pub fn psbt_tx_builder_finish(req: TxBulderReq) -> BdkTxBuilderResult {
    PsbtFFI::tx_builder_finish(
        req.wallet_req,
        req.recipients,
        req.utxos,
        req.unspendable,
        req.manually_selected_only,
        req.only_spend_change,
        req.do_not_spend_change,
        req.fee_rate,
        req.fee_absolute,
        req.drain_wallet,
        req.drain_to,
        req.enable_rbf,
        req.n_sequence,
        req.data,
    )
    .unwrap()
}

//========Wallet==========
pub fn psbt_wallet_get_address(wallet: PsbtWalletReq, address_index: AddressIndex) -> AddressInfo {
    PsbtFFI::get_address(
        wallet.prv,
        wallet.address_type,
        wallet.network,
        address_index,
    )
}

pub fn psbt_wallet_internalized_address(
    wallet: PsbtWalletReq,
    address_index: AddressIndex,
) -> AddressInfo {
    PsbtFFI::get_internalized_address(
        wallet.prv,
        wallet.address_type,
        wallet.network,
        address_index,
    )
}
//
// pub fn psbt_wallet_get_balance(wallet: PsbtWalletReq) -> Balance {
//     PsbtFFI::get_balance(wallet.prv, wallet.address_type, wallet.network)
// }
//
// pub fn psbt_wallet_get_txs(wallet: PsbtWalletReq) -> anyhow::Result<Vec<TransactionDetails>> {
//     PsbtFFI::get_transactions(wallet.prv, wallet.address_type, wallet.network)
// }
//
// pub fn psbt_wallet_list_unspent(
//     wallet: PsbtWalletReq,
// ) -> anyhow::Result<Vec<crate::bdk::wallet::LocalUtxo>> {
//     PsbtFFI::list_unspent(wallet.prv, wallet.address_type, wallet.network)
// }
//
// pub fn psbt_wallet_list_unspent_ouput(
//     wallet: PsbtWalletReq,
// ) -> anyhow::Result<Vec<crate::bdk::wallet::LocalUtxo>> {
//     PsbtFFI::list_unspent_outputs(wallet.prv, wallet.address_type, wallet.network)
// }

pub fn psbt_wallet_sign(wallet: PsbtWalletReq, psbt: String, is_multi_sig: bool) -> Option<String> {
    PsbtFFI::sign(
        wallet.prv,
        wallet.address_type,
        wallet.network,
        psbt,
        is_multi_sig,
    )
}

pub fn psbt_util_asm_to_hex(asm: String) -> String {
    asm_to_scriptpubkey(&asm)
}
