use k256::{
    ecdsa::{self, signature::Signer, SigningKey},
    pkcs8::{Document, EncodePublicKey},
    SecretKey,
};

#[derive(Clone, Debug)]
pub struct Signature {
    /// This is the DER-encoded public key.
    pub public_key: Option<Vec<u8>>,
    /// The signature bytes.
    pub signature: Option<Vec<u8>>,
}

#[derive(Clone, Debug)]
pub struct Secp256k1Identity {
    pub private_key: SigningKey,
    pub der_encoded_public_key: Document,
}

#[derive(Clone, Debug)]
pub struct Secp256k1IdentityExport {
    pub private_key_hash: Vec<u8>,
    pub der_encoded_public_key: Vec<u8>,
}

impl Secp256k1Identity {
    pub fn from_seed(seed: Vec<u8>) -> Self {
        match SecretKey::from_be_bytes(seed.as_slice()) {
            Ok(sk) => Secp256k1Identity::from_private_key(sk),
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
    pub fn sign(&self, msg: &[u8]) -> Result<Signature, String> {
        let ecdsa_sig: ecdsa::Signature = self
            .private_key
            .try_sign(msg)
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
        Ok(Signature {
            public_key,
            signature,
        })
    }
}

impl Secp256k1IdentityExport {
    pub fn from_raw(raw: Secp256k1Identity) -> Self {
        Self {
            private_key_hash: raw.private_key.to_bytes().to_vec(),
            der_encoded_public_key: raw.der_encoded_public_key.to_vec(),
        }
    }
}
