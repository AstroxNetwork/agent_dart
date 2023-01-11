use crate::types::{P256FromSeedReq, P256ShareSecretReq, P256SignReq, P256VerifyReq, SignatureFFI};
use p256::ecdsa::signature::{RandomizedSigner, Signature as P256Sig, Verifier};
use p256::ecdsa::{Signature, SigningKey, VerifyingKey};
use p256::elliptic_curve::pkcs8::{DecodePublicKey, Document, EncodePublicKey};
use p256::elliptic_curve::rand_core::OsRng;
use p256::{NistP256, PublicKey, SecretKey};

#[derive(Clone, Debug)]
pub struct P256FFI {
    pub private_key: SigningKey,
    pub der_encoded_public_key: Document,
}

#[derive(Clone, Debug)]
pub struct P256IdentityExport {
    pub private_key_hash: Vec<u8>,
    pub der_encoded_public_key: Vec<u8>,
}

impl P256IdentityExport {
    pub fn from_raw(raw: P256FFI) -> Self {
        Self {
            private_key_hash: raw.private_key.to_bytes().to_vec(),
            der_encoded_public_key: raw.der_encoded_public_key.to_vec(),
        }
    }
}

impl P256FFI {
    pub fn verify_signature(req: P256VerifyReq) -> bool {
        let signature: Signature;

        if req.signature_bytes.len() == 64 {
            signature = Signature::from_bytes(req.signature_bytes.as_slice())
                .expect("Signature is not valid");
        } else {
            signature = Signature::from_der(req.signature_bytes.as_slice())
                .expect("Signature is not valid");
        }

        let verifying_key = VerifyingKey::from_public_key_der(req.public_key_bytes.as_slice())
            .expect("VerifyingKey is not valid");
        verifying_key
            .verify(req.message_hash.as_slice(), &signature)
            .is_ok()
    }
    pub fn from_seed(req: P256FromSeedReq) -> Self {
        match SecretKey::from_be_bytes(req.seed.as_slice()) {
            Ok(sk) => P256FFI::from_private_key(sk),
            Err(err) => {
                panic!("{}", err.to_string())
            }
        }
    }

    pub fn from_private_key(private_key: SecretKey) -> Self {
        let public_key = private_key.public_key();

        let der_encoded_public_key = public_key
            .to_public_key_der()
            .expect("Cannot DER encode secp256k1 public key.");
        Self {
            private_key: private_key.into(),
            der_encoded_public_key,
        }
    }
    pub fn sign(&self, req: P256SignReq) -> Result<SignatureFFI, String> {
        // let ecdsa_sig: Signature = self.private_key.sign(req.msg.as_slice());
        // let  rng = OsRng;
        // let mut aux_rand = [0u8; 32];
        // rng.fill_bytes(&mut aux_rand);
        let ecdsa_sig: Signature = self.private_key.sign_with_rng(OsRng, req.msg.as_slice());

        let r = ecdsa_sig.r().as_ref().to_bytes();
        let s = ecdsa_sig.s().as_ref().to_bytes();
        let mut bytes = [0u8; 64];
        if r.len() > 32 || s.len() > 32 {
            return Err("Cannot create secp256k1 signature: malformed signature.".to_string());
        }
        bytes[(32 - r.len())..32].clone_from_slice(&r);
        bytes[32 + (32 - s.len())..].clone_from_slice(&s);
        let signature = Some(bytes.to_vec());
        let public_key = Some(self.der_encoded_public_key.as_ref().to_vec());
        Ok(SignatureFFI {
            public_key,
            signature,
        })
    }

    pub fn get_share_secret(req: P256ShareSecretReq) -> Result<Vec<u8>, String> {
        // assert_eq!(req.public_key_bytes.len(), 65);
        match SecretKey::from_be_bytes(req.seed.as_slice()) {
            Ok(sk) => {
                let dh = p256::ecdh::diffie_hellman::<NistP256>(
                    sk.to_nonzero_scalar(),
                    PublicKey::from_sec1_bytes(req.public_key_raw_bytes.clone().as_slice())
                        .map_err(|e| panic!("{}", format!("der pub key error: {}", e.to_string())))
                        .unwrap()
                        .as_affine(),
                );
                Ok(dh.raw_secret_bytes().to_vec())
            }
            Err(err) => {
                panic!("{}", err.to_string())
            }
        }
    }
}
