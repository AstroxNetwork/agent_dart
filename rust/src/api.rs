use super::bls::bls12381::bls::{
    core_verify,
    init,
    // BLS_FAIL,
    BLS_OK,
};
use crate::bip32::{bip32_get_key, bip32_to_seed};

use crate::ed25519::{id_from_blob, id_sign, id_verify, IDResult};
use crate::secp256k1::{Secp256k1Identity, Secp256k1IdentityExport, Signature};

pub fn bls_init() -> bool {
    init() == BLS_OK
}

pub fn bls_verify(sig: Vec<u8>, m: Vec<u8>, w: Vec<u8>) -> bool {
    let verify = core_verify(sig.as_slice(), m.as_slice(), w.as_slice());
    verify == BLS_OK
}

pub fn ed25519_from_seed(seed: Vec<u8>) -> IDResult {
    id_from_blob(seed)
}

pub fn ed25519_sign(seed: Vec<u8>, message: Vec<u8>) -> Vec<u8> {
    id_sign(seed, message)
}

pub fn ed25519_verify(message: Vec<u8>, sig: Vec<u8>, pub_key: Vec<u8>) -> bool {
    id_verify(message, sig, pub_key)
}

pub fn secp256k1_from_seed(seed: Vec<u8>) -> Secp256k1IdentityExport {
    Secp256k1IdentityExport::from_raw(Secp256k1Identity::from_seed(seed))
}

pub fn secp256k1_sign(seed: Vec<u8>, msg: Vec<u8>) -> Signature {
    Secp256k1Identity::from_seed(seed)
        .sign(&msg.as_slice())
        .unwrap()
}

pub fn bip32_get_private(phrase: String, password: String, path: String) -> Vec<u8> {
    let seed = bip32_to_seed(phrase, password);
    bip32_get_key(seed, path)
}

pub fn bip32_to_seed_hash(phrase: String, password: String) -> Vec<u8> {
    bip32_to_seed(phrase, password).as_ref().to_vec()
}
