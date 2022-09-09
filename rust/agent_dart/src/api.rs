use crate::bls_ffi::BlsFFI;
use crate::ed25519::ED25519FFI;
use crate::keyring::KeyRingFFI;
use crate::keystore::KeystoreFFI;
use crate::secp256k1::{Secp256k1FFI, Secp256k1IdentityExport, SignatureFFI};
use crate::sha::Keccak256FFI;
use crate::types::{
    AesDecryptReq, AesEncryptReq, BLSVerifyReq, CreatePhraseReq, ED25519FromSeedReq, ED25519Res,
    ED25519SignReq, ED25519VerifyReq, KeccakReq, KeyDerivedRes, PBKDFDeriveReq, PhraseToSeedReq,
    ScriptDeriveReq, Secp256k1FromSeedReq, Secp256k1SignReq, Secp256k1SignWithSeedReq,
    Secp256k1VerifyReq, SeedToKeyReq, SymmError,
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

pub fn secp256k1_verify(req: Secp256k1VerifyReq) -> bool {
    Secp256k1FFI::verify_signature(req)
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

pub fn pbkdf2_derive_key(req: PBKDFDeriveReq) -> KeyDerivedRes {
    KeystoreFFI::pbkdf2_derive_key(req)
}

pub fn scrypt_derive_key(req: ScriptDeriveReq) -> KeyDerivedRes {
    KeystoreFFI::scrypt_derive_key(req)
}

/// ----------------
/// keccak
/// ----------------
pub fn keccak256_encode(req: KeccakReq) -> Vec<u8> {
    Keccak256FFI::encode(req.message)
}
