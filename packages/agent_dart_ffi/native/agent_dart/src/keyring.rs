use crate::errors::ErrorInfo;
use crate::types::{PhraseToSeedReq, SeedToKeyReq};
use bip32::XPrv;
use bip39::{Language, Mnemonic};

#[derive(Clone, Debug)]
pub struct KeyRingFFI {}

impl KeyRingFFI {
    pub fn phrase_to_seed(req: PhraseToSeedReq) -> Vec<u8> {
        match Mnemonic::parse_in_normalized(Language::English, req.phrase.as_str()) {
            Ok(r) => r.to_seed(&req.password).to_vec(),
            Err(_) => {
                panic!(
                    "{}",
                    ErrorInfo {
                        code: 0u32,
                        message: "Phrase To Seed Error".to_string(),
                    }
                    .to_json()
                )
            }
        }
    }

    pub fn seed_to_key(req: SeedToKeyReq) -> Vec<u8> {
        match XPrv::derive_from_path(
            &req.seed,
            &req.path
                .as_str()
                .parse()
                .map_err(|_| {
                    panic!(
                        "{}",
                        ErrorInfo {
                            code: 0u32,
                            message: "path is not correct".to_string(),
                        }
                        .to_json()
                    )
                })
                .unwrap(),
        ) {
            Ok(r) => r.private_key().to_bytes().to_vec(),
            Err(e) => panic!(
                "{}",
                ErrorInfo {
                    code: 0u32,
                    message: e.to_string(),
                }
                .to_json()
            ),
        }
    }
}
