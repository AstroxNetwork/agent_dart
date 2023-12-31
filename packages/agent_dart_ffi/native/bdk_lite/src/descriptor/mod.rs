// Bitcoin Dev Kit
// Written in 2020 by Alekos Filini <alekos.filini@gmail.com>
//
// Copyright (c) 2020-2021 Bitcoin Dev Kit Developers
//
// This file is licensed under the Apache License, Version 2.0 <LICENSE-APACHE
// or http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your option.
// You may not use this file except in accordance with one or both of these
// licenses.

//! Descriptors
//!
//! This module contains generic utilities to work with descriptors, plus some re-exported types
//! from [`miniscript`].

use std::collections::BTreeMap;

use bitcoin::util::bip32::{ChildNumber, DerivationPath, ExtendedPubKey, Fingerprint, KeySource};
use bitcoin::util::{psbt, taproot};
use bitcoin::{secp256k1, PublicKey, XOnlyPublicKey};
use bitcoin::{Network, TxOut};

use miniscript::descriptor::{
    DefiniteDescriptorKey, DescriptorSecretKey, DescriptorType, InnerXKey, SinglePubKey,
};
pub use miniscript::{
    descriptor::DescriptorXKey, descriptor::KeyMap, descriptor::Wildcard, Descriptor,
    DescriptorPublicKey, Legacy, Miniscript, ScriptContext, Segwitv0,
};
use miniscript::{ForEachKey, MiniscriptKey, TranslatePk};

use crate::descriptor::policy::BuildSatisfaction;

pub mod checksum;
#[doc(hidden)]
pub mod dsl;
pub mod error;
pub mod policy;
pub mod template;

pub use self::checksum::calc_checksum;
use self::checksum::calc_checksum_bytes;
pub use self::error::Error as DescriptorError;
pub use self::policy::Policy;
use self::template::DescriptorTemplateOut;
use crate::keys::{IntoDescriptorKey, KeyError};
use crate::wallet::signer::SignersContainer;
use crate::wallet::utils::SecpCtx;

/// Alias for a [`Descriptor`] that can contain extended keys using [`DescriptorPublicKey`]
pub type ExtendedDescriptor = Descriptor<DescriptorPublicKey>;

/// Alias for a [`Descriptor`] that contains extended **derived** keys
pub type DerivedDescriptor = Descriptor<DefiniteDescriptorKey>;

/// Alias for the type of maps that represent derivation paths in a [`psbt::Input`] or
/// [`psbt::Output`]
///
/// [`psbt::Input`]: bitcoin::util::psbt::Input
/// [`psbt::Output`]: bitcoin::util::psbt::Output
pub type HdKeyPaths = BTreeMap<secp256k1::PublicKey, KeySource>;

/// Alias for the type of maps that represent taproot key origins in a [`psbt::Input`] or
/// [`psbt::Output`]
///
/// [`psbt::Input`]: bitcoin::util::psbt::Input
/// [`psbt::Output`]: bitcoin::util::psbt::Output
pub type TapKeyOrigins = BTreeMap<bitcoin::XOnlyPublicKey, (Vec<taproot::TapLeafHash>, KeySource)>;

/// Trait for types which can be converted into an [`ExtendedDescriptor`] and a [`KeyMap`] usable by a wallet in a specific [`Network`]
pub trait IntoWalletDescriptor {
    /// Convert to wallet descriptor
    fn into_wallet_descriptor(
        self,
        secp: &SecpCtx,
        network: Network,
    ) -> Result<(ExtendedDescriptor, KeyMap), DescriptorError>;
}

impl IntoWalletDescriptor for &str {
    fn into_wallet_descriptor(
        self,
        secp: &SecpCtx,
        network: Network,
    ) -> Result<(ExtendedDescriptor, KeyMap), DescriptorError> {
        let descriptor = match self.split_once('#') {
            Some((desc, original_checksum)) => {
                let checksum = calc_checksum_bytes(desc)?;
                if original_checksum.as_bytes() != checksum {
                    return Err(DescriptorError::InvalidDescriptorChecksum);
                }
                desc
            }
            None => self,
        };

        ExtendedDescriptor::parse_descriptor(secp, descriptor)?
            .into_wallet_descriptor(secp, network)
    }
}

impl IntoWalletDescriptor for &String {
    fn into_wallet_descriptor(
        self,
        secp: &SecpCtx,
        network: Network,
    ) -> Result<(ExtendedDescriptor, KeyMap), DescriptorError> {
        self.as_str().into_wallet_descriptor(secp, network)
    }
}

impl IntoWalletDescriptor for ExtendedDescriptor {
    fn into_wallet_descriptor(
        self,
        secp: &SecpCtx,
        network: Network,
    ) -> Result<(ExtendedDescriptor, KeyMap), DescriptorError> {
        (self, KeyMap::default()).into_wallet_descriptor(secp, network)
    }
}

impl IntoWalletDescriptor for (ExtendedDescriptor, KeyMap) {
    fn into_wallet_descriptor(
        self,
        secp: &SecpCtx,
        network: Network,
    ) -> Result<(ExtendedDescriptor, KeyMap), DescriptorError> {
        use crate::keys::DescriptorKey;

        struct Translator<'s, 'd> {
            secp: &'s SecpCtx,
            descriptor: &'d ExtendedDescriptor,
            network: Network,
        }

        impl<'s, 'd>
            miniscript::Translator<DescriptorPublicKey, miniscript::DummyKey, DescriptorError>
            for Translator<'s, 'd>
        {
            fn pk(
                &mut self,
                pk: &DescriptorPublicKey,
            ) -> Result<miniscript::DummyKey, DescriptorError> {
                let secp = &self.secp;

                let (_, _, networks) = if self.descriptor.is_taproot() {
                    let descriptor_key: DescriptorKey<miniscript::Tap> =
                        pk.clone().into_descriptor_key()?;
                    descriptor_key.extract(secp)?
                } else if self.descriptor.is_witness() {
                    let descriptor_key: DescriptorKey<miniscript::Segwitv0> =
                        pk.clone().into_descriptor_key()?;
                    descriptor_key.extract(secp)?
                } else {
                    let descriptor_key: DescriptorKey<miniscript::Legacy> =
                        pk.clone().into_descriptor_key()?;
                    descriptor_key.extract(secp)?
                };

                if networks.contains(&self.network) {
                    Ok(miniscript::DummyKey)
                } else {
                    Err(DescriptorError::Key(KeyError::InvalidNetwork))
                }
            }
            fn sha256(
                &mut self,
                _sha256: &<DescriptorPublicKey as MiniscriptKey>::Sha256,
            ) -> Result<miniscript::DummySha256Hash, DescriptorError> {
                Ok(Default::default())
            }
            fn hash256(
                &mut self,
                _hash256: &<DescriptorPublicKey as MiniscriptKey>::Hash256,
            ) -> Result<miniscript::DummyHash256Hash, DescriptorError> {
                Ok(Default::default())
            }
            fn ripemd160(
                &mut self,
                _ripemd160: &<DescriptorPublicKey as MiniscriptKey>::Ripemd160,
            ) -> Result<miniscript::DummyRipemd160Hash, DescriptorError> {
                Ok(Default::default())
            }
            fn hash160(
                &mut self,
                _hash160: &<DescriptorPublicKey as MiniscriptKey>::Hash160,
            ) -> Result<miniscript::DummyHash160Hash, DescriptorError> {
                Ok(Default::default())
            }
        }

        // check the network for the keys
        self.0.translate_pk(&mut Translator {
            secp,
            network,
            descriptor: &self.0,
        })?;

        Ok(self)
    }
}

impl IntoWalletDescriptor for DescriptorTemplateOut {
    fn into_wallet_descriptor(
        self,
        _secp: &SecpCtx,
        network: Network,
    ) -> Result<(ExtendedDescriptor, KeyMap), DescriptorError> {
        struct Translator {
            network: Network,
        }

        impl miniscript::Translator<DescriptorPublicKey, DescriptorPublicKey, DescriptorError>
            for Translator
        {
            fn pk(
                &mut self,
                pk: &DescriptorPublicKey,
            ) -> Result<DescriptorPublicKey, DescriptorError> {
                // workaround for xpubs generated by other key types, like bip39: since when the
                // conversion is made one network has to be chosen, what we generally choose
                // "mainnet", but then override the set of valid networks to specify that all of
                // them are valid. here we reset the network to make sure the wallet struct gets a
                // descriptor with the right network everywhere.
                let pk = match pk {
                    DescriptorPublicKey::XPub(ref xpub) => {
                        let mut xpub = xpub.clone();
                        xpub.xkey.network = self.network;

                        DescriptorPublicKey::XPub(xpub)
                    }
                    other => other.clone(),
                };

                Ok(pk)
            }
            miniscript::translate_hash_clone!(
                DescriptorPublicKey,
                DescriptorPublicKey,
                DescriptorError
            );
        }

        let (desc, keymap, networks) = self;

        if !networks.contains(&network) {
            return Err(DescriptorError::Key(KeyError::InvalidNetwork));
        }

        // fixup the network for keys that need it in the descriptor
        let translated = desc.translate_pk(&mut Translator { network })?;
        // ...and in the key map
        let fixed_keymap = keymap
            .into_iter()
            .map(|(mut k, mut v)| {
                match (&mut k, &mut v) {
                    (DescriptorPublicKey::XPub(xpub), DescriptorSecretKey::XPrv(xprv)) => {
                        xpub.xkey.network = network;
                        xprv.xkey.network = network;
                    }
                    (_, DescriptorSecretKey::Single(key)) => {
                        key.key.network = network;
                    }
                    _ => {}
                }

                (k, v)
            })
            .collect();

        Ok((translated, fixed_keymap))
    }
}

/// Wrapper for `IntoWalletDescriptor` that performs additional checks on the keys contained in the
/// descriptor
pub(crate) fn into_wallet_descriptor_checked<T: IntoWalletDescriptor>(
    inner: T,
    secp: &SecpCtx,
    network: Network,
) -> Result<(ExtendedDescriptor, KeyMap), DescriptorError> {
    let (descriptor, keymap) = inner.into_wallet_descriptor(secp, network)?;

    // Ensure the keys don't contain any hardened derivation steps or hardened wildcards
    let descriptor_contains_hardened_steps = descriptor.for_any_key(|k| {
        if let DescriptorPublicKey::XPub(DescriptorXKey {
            derivation_path,
            wildcard,
            ..
        }) = k
        {
            return *wildcard == Wildcard::Hardened
                || derivation_path.into_iter().any(ChildNumber::is_hardened);
        }

        false
    });
    if descriptor_contains_hardened_steps {
        return Err(DescriptorError::HardenedDerivationXpub);
    }

    // Run miniscript's sanity check, which will look for duplicated keys and other potential
    // issues
    descriptor.sanity_check()?;

    Ok((descriptor, keymap))
}

#[doc(hidden)]
/// Used internally mainly by the `descriptor!()` and `fragment!()` macros
pub trait CheckMiniscript<Ctx: miniscript::ScriptContext> {
    fn check_miniscript(&self) -> Result<(), miniscript::Error>;
}

impl<Ctx: miniscript::ScriptContext, Pk: miniscript::MiniscriptKey> CheckMiniscript<Ctx>
    for miniscript::Miniscript<Pk, Ctx>
{
    fn check_miniscript(&self) -> Result<(), miniscript::Error> {
        Ctx::check_global_validity(self)?;

        Ok(())
    }
}

/// Trait implemented on [`Descriptor`]s to add a method to extract the spending [`policy`]
pub trait ExtractPolicy {
    /// Extract the spending [`policy`]
    fn extract_policy(
        &self,
        signers: &SignersContainer,
        psbt: BuildSatisfaction,
        secp: &SecpCtx,
    ) -> Result<Option<Policy>, DescriptorError>;
}

pub(crate) trait XKeyUtils {
    fn root_fingerprint(&self, secp: &SecpCtx) -> Fingerprint;
}

impl<T> XKeyUtils for DescriptorXKey<T>
where
    T: InnerXKey,
{
    fn root_fingerprint(&self, secp: &SecpCtx) -> Fingerprint {
        match self.origin {
            Some((fingerprint, _)) => fingerprint,
            None => self.xkey.xkey_fingerprint(secp),
        }
    }
}

pub(crate) trait DescriptorMeta {
    fn is_witness(&self) -> bool;
    fn is_taproot(&self) -> bool;
    fn get_extended_keys(&self) -> Result<Vec<DescriptorXKey<ExtendedPubKey>>, DescriptorError>;
    fn derive_from_hd_keypaths<'s>(
        &self,
        hd_keypaths: &HdKeyPaths,
        secp: &'s SecpCtx,
    ) -> Option<DerivedDescriptor>;
    fn derive_from_tap_key_origins<'s>(
        &self,
        tap_key_origins: &TapKeyOrigins,
        secp: &'s SecpCtx,
    ) -> Option<DerivedDescriptor>;
    fn derive_from_psbt_key_origins<'s>(
        &self,
        key_origins: BTreeMap<Fingerprint, (&DerivationPath, SinglePubKey)>,
        secp: &'s SecpCtx,
    ) -> Option<DerivedDescriptor>;
    fn derive_from_psbt_input<'s>(
        &self,
        psbt_input: &psbt::Input,
        utxo: Option<TxOut>,
        secp: &'s SecpCtx,
    ) -> Option<DerivedDescriptor>;
}

impl DescriptorMeta for ExtendedDescriptor {
    fn is_witness(&self) -> bool {
        matches!(
            self.desc_type(),
            DescriptorType::Wpkh
                | DescriptorType::ShWpkh
                | DescriptorType::Wsh
                | DescriptorType::ShWsh
                | DescriptorType::ShWshSortedMulti
                | DescriptorType::WshSortedMulti
        )
    }

    fn is_taproot(&self) -> bool {
        self.desc_type() == DescriptorType::Tr
    }

    fn get_extended_keys(&self) -> Result<Vec<DescriptorXKey<ExtendedPubKey>>, DescriptorError> {
        let mut answer = Vec::new();

        self.for_each_key(|pk| {
            if let DescriptorPublicKey::XPub(xpub) = pk {
                answer.push(xpub.clone());
            }

            true
        });

        Ok(answer)
    }

    fn derive_from_psbt_key_origins<'s>(
        &self,
        key_origins: BTreeMap<Fingerprint, (&DerivationPath, SinglePubKey)>,
        secp: &'s SecpCtx,
    ) -> Option<DerivedDescriptor> {
        // Ensure that deriving `xpub` with `path` yields `expected`
        let verify_key = |xpub: &DescriptorXKey<ExtendedPubKey>,
                          path: &DerivationPath,
                          expected: &SinglePubKey| {
            let derived = xpub
                .xkey
                .derive_pub(secp, path)
                .expect("The path should never contain hardened derivation steps")
                .public_key;

            match expected {
                SinglePubKey::FullKey(pk) if &PublicKey::new(derived) == pk => true,
                SinglePubKey::XOnly(pk) if &XOnlyPublicKey::from(derived) == pk => true,
                _ => false,
            }
        };

        let mut path_found = None;

        // using `for_any_key` should make this stop as soon as we return `true`
        self.for_any_key(|key| {
            if let DescriptorPublicKey::XPub(xpub) = key {
                // Check if the key matches one entry in our `key_origins`. If it does, `matches()` will
                // return the "prefix" that matched, so we remove that prefix from the full path
                // found in `key_origins` and save it in `derive_path`. We expect this to be a derivation
                // path of length 1 if the key is `wildcard` and an empty path otherwise.
                let root_fingerprint = xpub.root_fingerprint(secp);
                let derive_path = key_origins
                    .get_key_value(&root_fingerprint)
                    .and_then(|(fingerprint, (path, expected))| {
                        xpub.matches(&(*fingerprint, (*path).clone()), secp)
                            .zip(Some((path, expected)))
                    })
                    .and_then(|(prefix, (full_path, expected))| {
                        let derive_path = full_path
                            .into_iter()
                            .skip(prefix.into_iter().count())
                            .cloned()
                            .collect::<DerivationPath>();

                        // `derive_path` only contains the replacement index for the wildcard, if present, or
                        // an empty path for fixed descriptors. To verify the key we also need the normal steps
                        // that come before the wildcard, so we take them directly from `xpub` and then append
                        // the final index
                        if verify_key(
                            xpub,
                            &xpub.derivation_path.extend(derive_path.clone()),
                            expected,
                        ) {
                            Some(derive_path)
                        } else {
                            log::debug!(
                                "Key `{}` derived with {} yields an unexpected key",
                                root_fingerprint,
                                derive_path
                            );
                            None
                        }
                    });

                match derive_path {
                    Some(path) if xpub.wildcard != Wildcard::None && path.len() == 1 => {
                        // Ignore hardened wildcards
                        if let ChildNumber::Normal { index } = path[0] {
                            path_found = Some(index);
                            return true;
                        }
                    }
                    Some(path) if xpub.wildcard == Wildcard::None && path.is_empty() => {
                        path_found = Some(0);
                        return true;
                    }
                    _ => {}
                }
            }

            false
        });

        path_found.map(|path| self.at_derivation_index(path))
    }

    fn derive_from_hd_keypaths<'s>(
        &self,
        hd_keypaths: &HdKeyPaths,
        secp: &'s SecpCtx,
    ) -> Option<DerivedDescriptor> {
        // "Convert" an hd_keypaths map to the format required by `derive_from_psbt_key_origins`
        let key_origins = hd_keypaths
            .iter()
            .map(|(pk, (fingerprint, path))| {
                (
                    *fingerprint,
                    (path, SinglePubKey::FullKey(PublicKey::new(*pk))),
                )
            })
            .collect();
        self.derive_from_psbt_key_origins(key_origins, secp)
    }

    fn derive_from_tap_key_origins<'s>(
        &self,
        tap_key_origins: &TapKeyOrigins,
        secp: &'s SecpCtx,
    ) -> Option<DerivedDescriptor> {
        // "Convert" a tap_key_origins map to the format required by `derive_from_psbt_key_origins`
        let key_origins = tap_key_origins
            .iter()
            .map(|(pk, (_, (fingerprint, path)))| (*fingerprint, (path, SinglePubKey::XOnly(*pk))))
            .collect();
        self.derive_from_psbt_key_origins(key_origins, secp)
    }

    fn derive_from_psbt_input<'s>(
        &self,
        psbt_input: &psbt::Input,
        utxo: Option<TxOut>,
        secp: &'s SecpCtx,
    ) -> Option<DerivedDescriptor> {
        if let Some(derived) = self.derive_from_hd_keypaths(&psbt_input.bip32_derivation, secp) {
            return Some(derived);
        }
        if let Some(derived) = self.derive_from_tap_key_origins(&psbt_input.tap_key_origins, secp) {
            return Some(derived);
        }
        if self.has_wildcard() {
            // We can't try to bruteforce the derivation index, exit here
            return None;
        }

        let descriptor = self.at_derivation_index(0);
        match descriptor.desc_type() {
            // TODO: add pk() here
            DescriptorType::Pkh
            | DescriptorType::Wpkh
            | DescriptorType::ShWpkh
            | DescriptorType::Tr
                if utxo.is_some()
                    && descriptor.script_pubkey() == utxo.as_ref().unwrap().script_pubkey =>
            {
                Some(descriptor)
            }
            DescriptorType::Bare | DescriptorType::Sh | DescriptorType::ShSortedMulti
                if psbt_input.redeem_script.is_some()
                    && &descriptor.explicit_script().unwrap()
                        == psbt_input.redeem_script.as_ref().unwrap() =>
            {
                Some(descriptor)
            }
            DescriptorType::Wsh
            | DescriptorType::ShWsh
            | DescriptorType::ShWshSortedMulti
            | DescriptorType::WshSortedMulti
                if psbt_input.witness_script.is_some()
                    && &descriptor.explicit_script().unwrap()
                        == psbt_input.witness_script.as_ref().unwrap() =>
            {
                Some(descriptor)
            }
            _ => None,
        }
    }
}
