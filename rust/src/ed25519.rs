use crate::types::{ED25519FromSeedReq, ED25519Res, ED25519SignReq, ED25519VerifyReq};
use ed25519_dalek::Keypair;
use ring::{
    signature,
    signature::{Ed25519KeyPair, KeyPair},
};

pub struct ED25519FFI {}

impl ED25519FFI {
    pub fn ed25519_from_blob(req: ED25519FromSeedReq) -> ED25519Res {
        match Ed25519KeyPair::from_seed_unchecked(req.seed.as_slice()) {
            Ok(result) => ED25519Res {
                seed: req.seed,
                public_key: result.public_key().as_ref().to_vec(),
            },
            Err(e) => panic!("{}", format!("ed25519_from_seed error: {}", e.to_string())),
        }
    }

    pub fn ed25519_sign(req: ED25519SignReq) -> Vec<u8> {
        match Ed25519KeyPair::from_seed_unchecked(req.seed.as_slice()) {
            Ok(result) => result.sign(req.message.as_slice()).as_ref().to_vec(),
            Err(e) => panic!("{}", format!("ed25519_sign error: {}", e.to_string())),
        }
    }

    pub fn ed25519_verify(req: ED25519VerifyReq) -> bool {
        let peer_public_key =
            signature::UnparsedPublicKey::new(&signature::ED25519, req.pub_key.as_slice());
        match peer_public_key.verify(req.message.as_slice(), req.sig.as_slice()) {
            Ok(_) => true,
            Err(_) => false,
        }
    }
}
