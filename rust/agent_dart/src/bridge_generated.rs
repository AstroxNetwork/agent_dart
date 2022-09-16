#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case,
    clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.45.0.

use crate::api::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::*;

// Section: imports

use crate::secp256k1::Secp256k1IdentityExport;
use crate::secp256k1::SignatureFFI;
use crate::types::AesDecryptReq;
use crate::types::AesEncryptReq;
use crate::types::BLSVerifyReq;
use crate::types::ED25519FromSeedReq;
use crate::types::ED25519Res;
use crate::types::ED25519SignReq;
use crate::types::ED25519VerifyReq;
use crate::types::KeyDerivedRes;
use crate::types::PBKDFDeriveReq;
use crate::types::PhraseToSeedReq;
use crate::types::ScriptDeriveReq;
use crate::types::Secp256k1FromSeedReq;
use crate::types::Secp256k1SignWithSeedReq;
use crate::types::Secp256k1VerifyReq;
use crate::types::SeedToKeyReq;

// Section: wire functions

fn wire_mnemonic_phrase_to_seed_impl(
    port_: MessagePort,
    req: impl Wire2Api<PhraseToSeedReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "mnemonic_phrase_to_seed",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(mnemonic_phrase_to_seed(api_req))
        },
    )
}
fn wire_mnemonic_seed_to_key_impl(
    port_: MessagePort,
    req: impl Wire2Api<SeedToKeyReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "mnemonic_seed_to_key",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(mnemonic_seed_to_key(api_req))
        },
    )
}
fn wire_bls_init_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "bls_init",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| Ok(bls_init()),
    )
}
fn wire_bls_verify_impl(port_: MessagePort, req: impl Wire2Api<BLSVerifyReq> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "bls_verify",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(bls_verify(api_req))
        },
    )
}
fn wire_ed25519_from_seed_impl(
    port_: MessagePort,
    req: impl Wire2Api<ED25519FromSeedReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "ed25519_from_seed",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(ed25519_from_seed(api_req))
        },
    )
}
fn wire_ed25519_sign_impl(port_: MessagePort, req: impl Wire2Api<ED25519SignReq> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "ed25519_sign",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(ed25519_sign(api_req))
        },
    )
}
fn wire_ed25519_verify_impl(port_: MessagePort, req: impl Wire2Api<ED25519VerifyReq> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "ed25519_verify",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(ed25519_verify(api_req))
        },
    )
}
fn wire_secp256k1_from_seed_impl(
    port_: MessagePort,
    req: impl Wire2Api<Secp256k1FromSeedReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "secp256k1_from_seed",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(secp256k1_from_seed(api_req))
        },
    )
}
fn wire_secp256k1_sign_impl(
    port_: MessagePort,
    req: impl Wire2Api<Secp256k1SignWithSeedReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "secp256k1_sign",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(secp256k1_sign(api_req))
        },
    )
}
fn wire_secp256k1_verify_impl(
    port_: MessagePort,
    req: impl Wire2Api<Secp256k1VerifyReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "secp256k1_verify",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(secp256k1_verify(api_req))
        },
    )
}
fn wire_aes_128_ctr_encrypt_impl(
    port_: MessagePort,
    req: impl Wire2Api<AesEncryptReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "aes_128_ctr_encrypt",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(aes_128_ctr_encrypt(api_req))
        },
    )
}
fn wire_aes_128_ctr_decrypt_impl(
    port_: MessagePort,
    req: impl Wire2Api<AesDecryptReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "aes_128_ctr_decrypt",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(aes_128_ctr_decrypt(api_req))
        },
    )
}
fn wire_pbkdf2_derive_key_impl(
    port_: MessagePort,
    req: impl Wire2Api<PBKDFDeriveReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "pbkdf2_derive_key",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(pbkdf2_derive_key(api_req))
        },
    )
}
fn wire_scrypt_derive_key_impl(
    port_: MessagePort,
    req: impl Wire2Api<ScriptDeriveReq> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "scrypt_derive_key",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_req = req.wire2api();
            move |task_callback| Ok(scrypt_derive_key(api_req))
        },
    )
}
// Section: wrapper structs

// Section: static checks

// Section: allocate functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        (!self.is_null()).then(|| self.wire2api())
    }
}

impl Wire2Api<u32> for u32 {
    fn wire2api(self) -> u32 {
        self
    }
}
impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

// Section: impl IntoDart

impl support::IntoDart for ED25519Res {
    fn into_dart(self) -> support::DartAbi {
        vec![self.seed.into_dart(), self.public_key.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for ED25519Res {}

impl support::IntoDart for KeyDerivedRes {
    fn into_dart(self) -> support::DartAbi {
        vec![self.left_bits.into_dart(), self.right_bits.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for KeyDerivedRes {}

impl support::IntoDart for Secp256k1IdentityExport {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.private_key_hash.into_dart(),
            self.der_encoded_public_key.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for Secp256k1IdentityExport {}

impl support::IntoDart for SignatureFFI {
    fn into_dart(self) -> support::DartAbi {
        vec![self.public_key.into_dart(), self.signature.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for SignatureFFI {}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
#[cfg(not(target_family = "wasm"))]
pub use io::*;
