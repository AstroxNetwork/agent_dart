use crate::types::{
    Secp256k1FromSeedReq, Secp256k1RecoverReq, Secp256k1ShareSecretReq, Secp256k1SignReq,
    Secp256k1VerifyReq, SignatureFFI,
};
use std::convert::TryFrom;

use k256::ecdsa::signature::hazmat::PrehashSigner;
use k256::ecdsa::signature::{Signer, Verifier};
use k256::ecdsa::{recoverable, signature, Signature, SigningKey, VerifyingKey};

use k256::elliptic_curve::sec1::ToEncodedPoint;
use k256::pkcs8::DecodePublicKey;
use k256::{
    ecdsa,
    pkcs8::{Document, EncodePublicKey},
    FieldBytes, PublicKey, Secp256k1, SecretKey,
};

#[derive(Clone, Debug)]
pub struct Secp256k1FFI {
    pub private_key: SigningKey,
    pub der_encoded_public_key: Document,
}

#[derive(Clone, Debug)]
pub struct Secp256k1IdentityExport {
    pub private_key_hash: Vec<u8>,
    pub der_encoded_public_key: Vec<u8>,
}

impl Secp256k1IdentityExport {
    pub fn from_raw(raw: Secp256k1FFI) -> Self {
        Self {
            private_key_hash: raw.private_key.to_bytes().to_vec(),
            der_encoded_public_key: raw.der_encoded_public_key.to_vec(),
        }
    }
}

impl Secp256k1FFI {
    pub fn verify_signature(req: Secp256k1VerifyReq) -> bool {
        let signature: Signature = signature::Signature::from_bytes(req.signature_bytes.as_slice())
            .expect("Signature is not valid");

        let verifying_key = VerifyingKey::from_public_key_der(req.public_key_bytes.as_slice())
            .expect("VerifyingKey is not valid");
        verifying_key
            .verify(req.message_hash.as_slice(), &signature)
            .is_ok()
    }
    pub fn from_seed(req: Secp256k1FromSeedReq) -> Self {
        match SecretKey::from_be_bytes(req.seed.as_slice()) {
            Ok(sk) => Secp256k1FFI::from_private_key(sk),
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
    pub fn sign(&self, req: Secp256k1SignReq) -> Result<SignatureFFI, String> {
        let ecdsa_sig: ecdsa::Signature = self
            .private_key
            .try_sign(req.msg.as_slice())
            .map_err(|err| format!("Cannot create secp256k1 signature: {}", err))?;
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

    pub fn sign_recoverable(&self, req: Secp256k1SignReq) -> Result<SignatureFFI, String> {
        let ecdsa_sig: recoverable::Signature =
            self.private_key
                .sign_prehash(req.msg.as_slice())
                .map_err(|err| format!("Cannot create secp256k1 signature: {}", err))?;
        let r = ecdsa_sig.r().as_ref().to_bytes();
        let s = ecdsa_sig.s().as_ref().to_bytes();
        let v = u8::from(ecdsa_sig.recovery_id());

        let mut bytes = [0u8; 65];
        if r.len() > 32 || s.len() > 32 {
            return Err("Cannot create secp256k1 signature: malformed signature.".to_string());
        }
        bytes[0..32].clone_from_slice(&r);
        bytes[32..64].clone_from_slice(&s);
        bytes[64] = v;
        let signature = Some(bytes.to_vec());
        let public_key = Some(self.der_encoded_public_key.as_ref().to_vec());
        Ok(SignatureFFI {
            public_key,
            signature,
        })
    }

    pub fn recover_pub_key(req: Secp256k1RecoverReq) -> Result<Vec<u8>, String> {
        let r: Vec<u8> = req.signature_bytes[0..32].to_vec();
        let mut s: Vec<u8> = req.signature_bytes[32..64].to_vec();
        let mut v: u8;
        if req.signature_bytes.len() >= 65 {
            v = req.signature_bytes[64];
        } else {
            v = req.signature_bytes[32] >> 7;
            s[0] &= 0x7f;
        };
        if v < 27 {
            v = v + 27;
        }

        let mut bytes = [0u8; 65];
        if r.len() > 32 || s.len() > 32 {
            return Err("Cannot create secp256k1 signature: malformed signature.".to_string());
        }
        bytes[0..32].clone_from_slice(&r);
        bytes[32..64].clone_from_slice(&s);
        bytes[64] = calculate_sig_recovery(v, req.chain_id);

        let ecdsa_sig = match recoverable::Signature::try_from(bytes.as_slice()) {
            Ok(r) => r,
            Err(err) => {
                panic!("Cannot recover signature because: {}", err)
            }
        };

        let pubkey = ecdsa_sig
            .recover_verifying_key_from_digest_bytes(FieldBytes::from_slice(
                req.message_pre_hashed.as_slice(),
            ))
            .map_err(|err| format!("Cannot recover public key because: {}", err))?;

        Ok(pubkey.to_encoded_point(false).as_bytes().to_vec())
    }

    pub fn get_share_secret(req: Secp256k1ShareSecretReq) -> Result<Vec<u8>, String> {
        // assert_eq!(req.public_key_bytes.len(), 65);
        match SecretKey::from_be_bytes(req.seed.as_slice()) {
            Ok(sk) => {
                let dh = k256::ecdh::diffie_hellman::<Secp256k1>(
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

pub fn calculate_sig_recovery(v: u8, chain_id: Option<u8>) -> u8 {
    if v == 0 || v == 1 {
        return v;
    }

    return if chain_id.is_none() {
        v - 27
    } else {
        v - (chain_id.unwrap() * 2 + 35)
    };
}
