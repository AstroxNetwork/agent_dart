use k256::pkcs8::der::Encode;
use sha3::digest::Update;
use sha3::{Digest, Keccak256};

pub struct Keccak256FFI {}

impl Keccak256FFI {
    pub fn encode(data: Vec<u8>) -> Vec<u8> {
        let mut hasher = Keccak256::default();
        Digest::update(&mut hasher, data.as_slice());
        let result = hasher.finalize();
        result.to_vec()
    }
}
