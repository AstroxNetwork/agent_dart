use super::bls::bls12381::bls::{
    core_verify,
    init,
    // BLS_FAIL,
    BLS_OK,
};

use crate::ed25519::{id_from_blob, id_generate, id_sign, id_verify, IDResult};

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

pub fn ed25519_generate() -> IDResult {
    id_generate()
}

pub fn ed25519_sign(seed: Vec<u8>, message: Vec<u8>) -> Vec<u8> {
    id_sign(seed, message)
}

pub fn ed25519_verify(message: Vec<u8>, sig: Vec<u8>, pub_key: Vec<u8>) -> bool {
    id_verify(message, sig, pub_key)
}
