use bip32::XPrv;
use bip39::{Language, Mnemonic};

pub fn bip32_to_seed(phrase: String, password: String) -> [u8; 64] {
    match Mnemonic::parse_in_normalized(Language::English, phrase.as_str()) {
        Ok(r) => r.to_seed(&password),
        Err(e) => {
            panic!("{}", e.to_string())
        }
    }
}

pub fn bip32_get_key(seed: [u8; 64], path: String) -> Vec<u8> {
    let child_path = path.as_str();
    let child_xprv = XPrv::derive_from_path(&seed, &child_path.parse().unwrap()).unwrap();
    child_xprv.private_key().to_bytes().to_vec()
}
