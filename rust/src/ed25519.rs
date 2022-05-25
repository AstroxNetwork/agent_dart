use ring::rand::SecureRandom;
use ring::signature;
use ring::signature::{Ed25519KeyPair, KeyPair};

pub struct IDResult {
    pub seed: Vec<u8>,
    pub public_key: Vec<u8>,
}

pub fn id_from_blob(blob: Vec<u8>) -> IDResult {
    match Ed25519KeyPair::from_seed_unchecked(blob.as_slice()) {
        Ok(result) => IDResult {
            seed: blob,
            public_key: result.public_key().as_ref().to_vec(),
        },
        Err(_) => panic!("id_from_blob error"),
    }
}

pub fn id_generate() -> IDResult {
    let mut randoms: [u8; 32] = [0; 32];
    let sr = ring::rand::SystemRandom::new();
    sr.fill(&mut randoms).unwrap();
    let pkcs8 = Ed25519KeyPair::generate_pkcs8(&sr).unwrap();
    let blob = pkcs8.as_ref();
    match Ed25519KeyPair::from_pkcs8(blob.clone()) {
        Ok(result) => IDResult {
            seed: blob.clone().to_vec(),
            public_key: result.public_key().as_ref().to_vec(),
        },
        Err(_) => panic!("id_from_blob error"),
    }
}

pub fn id_sign(seed: Vec<u8>, message: Vec<u8>) -> Vec<u8> {
    match Ed25519KeyPair::from_seed_unchecked(seed.as_slice()) {
        Ok(result) => result.sign(message.as_slice()).as_ref().to_vec(),
        Err(_) => panic!("id_from_blob error"),
    }
}

pub fn id_verify(message: Vec<u8>, sig: Vec<u8>, pub_key: Vec<u8>) -> bool {
    let peer_public_key =
        signature::UnparsedPublicKey::new(&signature::ED25519, pub_key.as_slice());
    peer_public_key
        .verify(message.as_slice(), sig.as_slice())
        .is_ok()
}
