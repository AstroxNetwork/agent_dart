use crate::types::{SchnorrFromSeedReq, SchnorrSignReq, SchnorrVerifyReq, SignatureFFI};
use k256::ecdsa::digest::{Digest, FixedOutput};
use k256::elliptic_curve::rand_core::{OsRng, RngCore};
use k256::schnorr::signature::{Signature, Verifier};
use k256::schnorr::{SigningKey, VerifyingKey};
use sha2::Sha256;

#[derive(Clone)]
pub struct SchnorrFFI {
    pub private_key: SigningKey,
    pub public_key: VerifyingKey,
}

#[derive(Clone, Debug)]
pub struct SchnorrIdentityExport {
    pub private_key_hash: Vec<u8>,
    pub public_key_hash: Vec<u8>,
}

impl SchnorrIdentityExport {
    pub fn from_raw(raw: SchnorrFFI) -> Self {
        Self {
            private_key_hash: raw.private_key.to_bytes().to_vec(),
            public_key_hash: raw.public_key.to_bytes().to_vec(),
        }
    }
}

impl SchnorrFFI {
    pub fn verify_signature(req: SchnorrVerifyReq) -> bool {
        let signature =
            Signature::from_bytes(req.signature_bytes.as_slice()).expect("Signature is not valid");
        let verifying_key = VerifyingKey::from_bytes(req.public_key_bytes.as_slice())
            .expect("VerifyingKey is not valid");
        verifying_key
            .verify(req.message_hash.as_slice(), &signature)
            .is_ok()
    }

    pub fn from_seed(req: SchnorrFromSeedReq) -> Self {
        match SigningKey::from_bytes(req.seed.as_slice()) {
            Ok(sk) => SchnorrFFI::from_signing_key(sk),
            Err(err) => {
                panic!("{}", err.to_string())
            }
        }
    }

    pub fn from_signing_key(signing_key: SigningKey) -> Self {
        Self {
            private_key: signing_key.clone(),
            public_key: signing_key.verifying_key().clone(),
        }
    }
    pub fn sign(&self, req: SchnorrSignReq) -> Result<SignatureFFI, String> {
        let sig;
        let bytes = Sha256::new_with_prefix(req.msg.as_slice());

        let mut aux_rand = [0u8; 32];
        if req.aux_rand.is_none() {
            let mut rng = OsRng;
            rng.fill_bytes(&mut aux_rand);
        } else {
            aux_rand[0..32].clone_from_slice(req.aux_rand.unwrap().as_slice());
        }
        sig = self
            .private_key
            .try_sign_prehashed(&bytes.finalize_fixed().into(), &aux_rand)
            .map_err(|err| format!("Cannot create schnorr signature: {}", err))?;

        let signature = Some(sig.as_bytes().to_vec());
        let public_key = Some(self.public_key.to_bytes().to_vec());
        Ok(SignatureFFI {
            public_key,
            signature,
        })
    }
}
