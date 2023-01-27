use crate::bls_ffi::BlsFFI;
use crate::ed25519::ED25519FFI;
use crate::keyring::KeyRingFFI;
use crate::keystore::KeystoreFFI;
use crate::p256::{P256IdentityExport, P256FFI};
use crate::schnorr::{SchnorrFFI, SchnorrIdentityExport};
use crate::secp256k1::{Secp256k1FFI, Secp256k1IdentityExport};
use crate::types::{
    AesDecryptReq, AesEncryptReq, BLSVerifyReq, ED25519FromSeedReq, ED25519Res, ED25519SignReq,
    ED25519VerifyReq, KeyDerivedRes, P256FromSeedReq, P256ShareSecretReq, P256SignReq,
    P256SignWithSeedReq, P256VerifyReq, PBKDFDeriveReq, PhraseToSeedReq, SchnorrFromSeedReq,
    SchnorrSignReq, SchnorrSignWithSeedReq, SchnorrVerifyReq, ScriptDeriveReq,
    Secp256k1FromSeedReq, Secp256k1RecoverReq, Secp256k1ShareSecretReq, Secp256k1SignReq,
    Secp256k1SignWithSeedReq, Secp256k1VerifyReq, SeedToKeyReq, SignatureFFI,
};

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

pub fn pbkdf2_derive_key(req: PBKDFDeriveReq) -> KeyDerivedRes {
    KeystoreFFI::pbkdf2_derive_key(req)
}

pub fn scrypt_derive_key(req: ScriptDeriveReq) -> KeyDerivedRes {
    KeystoreFFI::scrypt_derive_key(req)
}
