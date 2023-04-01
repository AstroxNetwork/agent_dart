// use alloc::sync::Arc;
// use bdk::bitcoin::hashes::Hash;
// use bdk::bitcoin::psbt::Input;
// use bdk::bitcoin::schnorr::TapTweak;
// use bdk::bitcoin::secp256k1::Message;
// use bdk::bitcoin::util::taproot;
// use bdk::signer::*;
// use bdk::*;
// use bitcoin::secp256k1::{All, Secp256k1};
// use bitcoin::util::psbt;
// use bitcoin::*;
// use core::str::FromStr;
//
// pub(crate) type SecpCtx = Secp256k1<All>;
//
// pub fn sign_psbt_ecdsa(
//     secret_key: &secp256k1::SecretKey,
//     pubkey: PublicKey,
//     psbt_input: &mut Input,
//     hash: Sighash,
//     hash_ty: EcdsaSighashType,
//     allow_grinding: bool,
// ) -> Result<&mut Input, String> {
//     let secp: &SecpCtx = &Default::default();
//     let msg = Message::from_slice(&hash.into_inner()).expect("invalid sighash message");
//     let sig = if allow_grinding {
//         secp.sign_ecdsa_low_r(&msg, secret_key)
//     } else {
//         secp.sign_ecdsa(&msg, secret_key)
//     };
//     secp.verify_ecdsa(&msg, &sig, &pubkey.inner)
//         .expect("invalid or corrupted ecdsa signature");
//
//     let final_signature = EcdsaSig { sig, hash_ty };
//     psbt_input.partial_sigs.insert(pubkey, final_signature);
//     Ok(psbt_input)
// }
//
// pub fn sign_psbt_schnorr(
//     secret_key: &secp256k1::SecretKey,
//     pubkey: XOnlyPublicKey,
//     psbt_input: &mut Input,
//     leaf_hash: Option<taproot::TapLeafHash>,
//     hash: taproot::TapSighashHash,
//     hash_ty: SchnorrSighashType,
// ) -> Result<&mut Input, secp256k1::Error> {
//     let secp: &SecpCtx = &Default::default();
//     let mut keypair = KeyPair::from_seckey_slice(secp, secret_key.as_ref())?;
//
//     if let Some(lh) = leaf_hash {
//         keypair = keypair
//             .tap_tweak(secp, psbt_input.tap_merkle_root)?
//             .to_inner();
//         psbt_input.tap_script_sigs.insert(
//             (pubkey, lh),
//             SchnorrSig {
//                 sig: secp.sign_schnorr(&Message::from_slice(&hash.into_inner()[..])?, &keypair),
//                 hash_ty,
//             },
//         );
//     } else {
//         psbt_input.tap_key_sig = Some(SchnorrSig {
//             sig: secp.sign_schnorr(&Message::from_slice(&hash.into_inner()[..])?, &keypair),
//             hash_ty,
//         });
//     }
//
//     Ok(psbt_input)
// }
