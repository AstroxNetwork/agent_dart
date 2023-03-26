use crate::types::{
    AesDecryptReq, AesEncryptReq, KeyDerivedRes, MACDeriveReq, PBKDFDeriveReq, ScriptDeriveReq,
};
use aes::cipher::generic_array::GenericArray;
use aes::cipher::{FromBlockCipher, StreamCipher};
use aes::{Aes128, Aes128Ctr, Aes256, NewBlockCipher};

use block_modes::block_padding::Pkcs7;
use block_modes::{BlockMode, Cbc};

use hmac::Hmac;
use pbkdf2::pbkdf2;
use sha2::Sha256;

use aes_gcm::aead::Aead;
use aes_gcm::{Aes256Gcm, KeyInit, Nonce};

pub const KEY_LENGTH: usize = 32;
pub const KEY_LENGTH_AES: usize = KEY_LENGTH / 2;

type Aes256Cbc = Cbc<Aes256, Pkcs7>;

#[derive(Clone, Debug)]
pub struct KeystoreFFI {}

impl KeystoreFFI {
    /// Encrypt a message (CTR mode).
    ///
    /// Key (`k`) length and initialisation vector (`iv`) length have to be 16 bytes each.
    /// An error is returned if the input lengths are invalid.
    pub fn encrypt_128_ctr(req: AesEncryptReq) -> Vec<u8> {
        let plain_len = req.message.len();

        let mut ciphertext = vec![0u8; plain_len];

        if req.key.len() != 16 {
            panic!("SymmError::InvalidKey")
        }
        if req.iv.len() != 16 {
            panic!("SymmError::InvalidNonce")
        }

        let key = GenericArray::from_slice(req.key.as_slice());
        let nonce = GenericArray::from_slice(req.iv.as_slice());

        (ciphertext.as_mut_slice()).copy_from_slice(req.message.as_slice());
        let cipher = Aes128::new(&key);
        let mut cipher_ctr = Aes128Ctr::from_block_cipher(cipher, &nonce);
        cipher_ctr.apply_keystream(ciphertext.as_mut_slice());
        ciphertext.to_vec()
    }

    pub fn encrypt_256_cbc(req: AesEncryptReq) -> Vec<u8> {
        let plain_len = req.message.len();

        let c_mod = plain_len % 256;

        let mut text = vec![0u8; plain_len + 256 - c_mod];

        if req.key.len() != 32 {
            panic!("SymmError::InvalidKey")
        }
        if req.iv.len() != 16 {
            panic!("SymmError::InvalidNonce")
        }

        text[0..plain_len].copy_from_slice(req.message.as_slice());

        let cipher = Aes256Cbc::new_from_slices(req.key.as_slice(), req.iv.as_slice())
            .expect("aes 256 cbc failed");

        cipher
            .encrypt(&mut text, plain_len)
            .expect("Cannot encrypt")
            .to_vec()
    }

    pub fn encrypt_256_gcm(req: AesEncryptReq) -> Vec<u8> {
        let plain_len = req.message.len();

        let mut text = vec![0u8; plain_len];

        if req.key.len() != 32 {
            panic!("SymmError::InvalidKey")
        }
        if req.iv.len() != 12 {
            panic!("SymmError::InvalidNonce")
        }

        text[0..plain_len].copy_from_slice(req.message.as_slice());

        let cipher = Aes256Gcm::new_from_slice(req.key.as_slice()).expect("cannot create cipher");
        let nonce = Nonce::from_slice(req.iv.as_slice());

        cipher
            .encrypt(nonce, text.as_slice())
            .expect("Cannot encrypt")
            .to_vec()
    }

    /// Decrypt a message (CTR mode).
    ///
    /// Key (`k`) length and initialisation vector (`iv`) length have to be 16 bytes each.
    /// An error is returned if the input lengths are invalid.
    pub fn decrypt_128_ctr(req: AesDecryptReq) -> Vec<u8> {
        // This is symmetrical encryption, so those are equivalent operations
        KeystoreFFI::encrypt_128_ctr(AesEncryptReq {
            key: req.key,
            iv: req.iv,
            message: req.cipher_text,
        })
    }

    pub fn decrypt_256_cbc(req: AesDecryptReq) -> Vec<u8> {
        if req.key.len() != 32 {
            panic!("SymmError::InvalidKey")
        }
        if req.iv.len() != 16 {
            panic!("SymmError::InvalidNonce")
        }
        let mut buf = req.cipher_text;

        let cipher = Aes256Cbc::new_from_slices(req.key.as_slice(), req.iv.as_slice())
            .expect("aes 256 cbc failed");

        cipher.decrypt(&mut buf).expect("Cannot decrypt").to_vec()
    }

    pub fn decrypt_256_gcm(req: AesDecryptReq) -> Vec<u8> {
        if req.key.len() != 32 {
            panic!("SymmError::InvalidKey")
        }
        if req.iv.len() != 12 {
            panic!("SymmError::InvalidNonce")
        }
        let buf = req.cipher_text;

        let cipher = Aes256Gcm::new_from_slice(req.key.as_slice()).expect("cannot create cipher");
        let nonce = Nonce::from_slice(req.iv.as_slice());

        cipher
            .decrypt(nonce, buf.as_slice())
            .expect("Cannot decrypt")
            .to_vec()
    }

    pub fn scrypt_derive_key(req: ScriptDeriveReq) -> KeyDerivedRes {
        let log_n = (32 - req.n.leading_zeros() - 1) as u8;
        let mut derived_key = vec![0u8; KEY_LENGTH];
        let scrypt_params = scrypt::Params::new(log_n, req.r, req.p).expect("Scrypt new failed");
        scrypt::scrypt(
            req.password.as_slice(),
            req.salt.as_slice(),
            &scrypt_params,
            &mut derived_key,
        )
        .expect("derived_key is long enough; qed");
        let derived_left_bits = &derived_key[0..KEY_LENGTH_AES];
        let derived_right_bits = &derived_key[KEY_LENGTH_AES..KEY_LENGTH];
        KeyDerivedRes {
            left_bits: derived_left_bits.to_vec(),
            right_bits: derived_right_bits.to_vec(),
        }
    }

    pub fn pbkdf2_derive_key(req: PBKDFDeriveReq) -> KeyDerivedRes {
        let mut derived_key = [0u8; KEY_LENGTH];
        pbkdf2::<Hmac<Sha256>>(
            req.password.as_slice(),
            req.salt.as_slice(),
            req.c,
            &mut derived_key,
        );
        let derived_right_bits = &derived_key[0..KEY_LENGTH_AES];
        let derived_left_bits = &derived_key[KEY_LENGTH_AES..KEY_LENGTH];

        KeyDerivedRes {
            left_bits: derived_left_bits.to_vec(),
            right_bits: derived_right_bits.to_vec(),
        }
    }

    #[allow(dead_code)]
    pub fn derive_mac(req: MACDeriveReq) -> Vec<u8> {
        let mut mac = vec![0u8; KEY_LENGTH_AES + req.cipher_text.len()];
        mac[0..KEY_LENGTH_AES].copy_from_slice(req.derived_left_bits.as_slice());
        mac[KEY_LENGTH_AES..req.cipher_text.len() + KEY_LENGTH_AES]
            .copy_from_slice(req.cipher_text.as_slice());
        mac
    }
}
