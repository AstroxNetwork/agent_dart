// use crate::api::ScriptAmount;
// use crate::bdk::wallet::SyncOption;
use serde::Serialize;

#[derive(Clone, Debug)]
pub struct SignatureFFI {
    /// This is the DER-encoded public key.
    pub public_key: Option<Vec<u8>>,
    /// The signature bytes.
    pub signature: Option<Vec<u8>>,
}

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
pub struct Secp256k1RecoverReq {
    pub message_pre_hashed: Vec<u8>,
    pub signature_bytes: Vec<u8>,
    pub chain_id: Option<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct Secp256k1ShareSecretReq {
    pub seed: Vec<u8>,
    pub public_key_raw_bytes: Vec<u8>,
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
pub struct Secp256k1SignWithRngReq {
    pub msg: Vec<u8>,
    pub private_bytes: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct P256VerifyReq {
    pub message_hash: Vec<u8>,
    pub signature_bytes: Vec<u8>,
    pub public_key_bytes: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct P256ShareSecretReq {
    pub seed: Vec<u8>,
    pub public_key_raw_bytes: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct P256FromSeedReq {
    pub seed: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct P256SignReq {
    pub msg: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct SchnorrVerifyReq {
    pub message_hash: Vec<u8>,
    pub signature_bytes: Vec<u8>,
    pub public_key_bytes: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct SchnorrShareSecretReq {
    pub seed: Vec<u8>,
    pub public_key_raw_bytes: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct SchnorrFromSeedReq {
    pub seed: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct SchnorrSignReq {
    pub msg: Vec<u8>,
    pub aux_rand: Option<Vec<u8>>,
}

#[derive(Clone, Debug, Serialize)]
pub struct Secp256k1SignWithSeedReq {
    pub msg: Vec<u8>,
    pub seed: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct P256SignWithSeedReq {
    pub msg: Vec<u8>,
    pub seed: Vec<u8>,
}

#[derive(Clone, Debug, Serialize)]
pub struct SchnorrSignWithSeedReq {
    pub msg: Vec<u8>,
    pub seed: Vec<u8>,
    pub aux_rand: Option<Vec<u8>>,
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

// /// Error type for the AES symmetric encryption
// #[derive(Clone, Debug)]
// pub enum SymmError {
//     InvalidKey,
//     InvalidNonce,
//     SourceDestinationMismatch,
// }

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
//
// #[derive(Clone, Debug, Serialize)]
// pub struct PsbtToTxidReq {
//     pub psbt_str: String,
// }
//
// #[derive(Clone, Debug, Serialize)]
// pub struct PsbtToTxReq {
//     pub psbt_str: String,
// }
//
// #[derive(Clone, Debug, Serialize)]
// pub struct PsbtFromUnsignedTxReq {
//     pub bytes: Vec<u8>,
// }
// #[derive(Clone, Debug, Serialize)]
// pub struct PsbtFreeRateReq {
//     pub psbt_str: String,
// }
//
// #[derive(Clone, Debug, Serialize)]
// pub struct PsbtFreeAmountReq {
//     pub psbt_str: String,
// }
//
// #[derive(Clone, Debug, Serialize)]
// pub struct PsbtCombineReq {
//     pub psbt_str: String,
//     pub other: String,
// }
//
// type Txid = String;
//
// pub struct OutPoint {
//     /// The referenced transaction's txid.
//     pub txid: Txid,
//     /// The index of the referenced output in its transaction's vout.
//     pub vout: u32,
// }
//
// #[derive(Clone, Debug, Serialize)]
// pub struct GetAddressReq {
//     pub public_key: String,
//     pub network: Option<String>,
// }
//
// #[derive(Clone, Debug, Serialize)]
// pub struct PsbtWalletReq {
//     pub prv: String,
//     pub address_type: String,
//     pub network: Option<String>,
// }
