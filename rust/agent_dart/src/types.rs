use serde::Serialize;

#[derive(Clone, Debug, Serialize)]
pub struct CreatePhraseReq {
    pub length: u8,
}

#[derive(Clone, Debug, Serialize)]
pub struct PhraseToSeedReq {
    pub phrase: String,
    pub password: String,
}

#[derive(Clone, Debug, Serialize)]
pub struct SeedToKeyReq {
    pub seed: Vec<u8>,
    pub path: String,
}

#[derive(Clone, Debug, Serialize)]
pub struct BLSVerifyReq {
    pub signature: Vec<u8>,
    pub message: Vec<u8>,
    pub public_key: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct ED25519FromSeedReq {
    pub seed: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct ED25519SignReq {
    pub seed: Vec<u8>,
    pub message: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct ED25519VerifyReq {
    pub sig: Vec<u8>,
    pub message: Vec<u8>,
    pub pub_key: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct ED25519Res {
    pub seed: Vec<u8>,
    pub public_key: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct Secp256k1VerifyReq {
    pub message_hash: Vec<u8>,
    pub signature_bytes: Vec<u8>,
    pub public_key_bytes: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct Secp256k1ShareSecretReq {
    pub seed: Vec<u8>,
    pub public_key_der_bytes: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct Secp256k1FromSeedReq {
    pub seed: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct Secp256k1SignReq {
    pub msg: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct Secp256k1SignWithSeedReq {
    pub msg: Vec<u8>,
    pub seed: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct AesEncryptReq {
    pub key: Vec<u8>,
    pub iv: Vec<u8>,
    pub message: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct AesDecryptReq {
    pub key: Vec<u8>,
    pub iv: Vec<u8>,
    pub cipher_text: Vec<u8>,
}

/// Error type for the AES symmetric encryption
#[derive(Debug)]
pub enum SymmError {
    InvalidKey,
    InvalidNonce,
    SourceDestinationMismatch,
}

#[derive(Clone, Debug)]
pub struct KeyDerivedRes {
    pub left_bits: Vec<u8>,
    pub right_bits: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct ScriptDeriveReq {
    pub password: Vec<u8>,
    pub salt: Vec<u8>,
    pub n: u32,
    pub p: u32,
    pub r: u32,
}

pub struct PBKDFDeriveReq {
    pub password: Vec<u8>,
    pub salt: Vec<u8>,
    pub c: u32,
}

pub struct MACDeriveReq {
    pub derived_left_bits: Vec<u8>,
    pub cipher_text: Vec<u8>,
}
