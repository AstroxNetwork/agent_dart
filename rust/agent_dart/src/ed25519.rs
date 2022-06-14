use crate::types::{ED25519FromSeedReq, ED25519Res, ED25519SignReq, ED25519VerifyReq};
use ed25519_compact::{KeyPair, PublicKey, Seed, Signature};

pub struct ED25519FFI {}

impl ED25519FFI {
    pub fn ed25519_from_blob(req: ED25519FromSeedReq) -> ED25519Res {
        ED25519Res {
            seed: req.seed.clone(),
            public_key: KeyPair::from_seed(
                Seed::from_slice(req.seed.clone().as_slice()).unwrap_or_else(|e| {
                    panic!(
                        "{}",
                        format!("ed25519 seed from slice error: {}", e.to_string())
                    )
                }),
            )
            .pk
            .as_ref()
            .to_vec(),
        }
    }

    pub fn ed25519_sign(req: ED25519SignReq) -> Vec<u8> {
        KeyPair::from_seed(Seed::from_slice(req.seed.as_slice()).unwrap_or_else(|e| {
            panic!(
                "{}",
                format!("ed25519 seed from slice error: {}", e.to_string())
            )
        }))
        .sk
        .sign(req.message.as_slice(), None)
        .as_ref()
        .to_vec()
    }

    pub fn ed25519_verify(req: ED25519VerifyReq) -> bool {
        let peer_public_key = PublicKey::from_slice(req.pub_key.as_slice()).unwrap_or_else(|e| {
            panic!(
                "{}",
                format!("ed25519 public key from error: {}", e.to_string())
            )
        });
        match peer_public_key.verify(
            req.message.as_slice(),
            &Signature::from_slice(req.sig.as_slice()).unwrap_or_else(|e| {
                panic!(
                    "{}",
                    format!("ed25519 signature from error: {}", e.to_string())
                )
            }),
        ) {
            Ok(_) => true,
            Err(_) => false,
        }
    }
}
