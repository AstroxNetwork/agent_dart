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

use bitcoin::secp256k1::{All, Secp256k1};
use bitcoin::{LockTime, Script, Sequence};

use miniscript::{MiniscriptKey, Satisfier, ToPublicKey};

/// Trait to check if a value is below the dust limit.
/// We are performing dust value calculation for a given script public key using rust-bitcoin to
/// keep it compatible with network dust rate
// we implement this trait to make sure we don't mess up the comparison with off-by-one like a <
// instead of a <= etc.
pub trait IsDust {
    /// Check whether or not a value is below dust limit
    fn is_dust(&self, script: &Script) -> bool;
}

impl IsDust for u64 {
    fn is_dust(&self, script: &Script) -> bool {
        *self < script.dust_value().to_sat()
    }
}

pub struct After {
    pub current_height: Option<u32>,
    pub assume_height_reached: bool,
}

impl After {
    pub(crate) fn new(current_height: Option<u32>, assume_height_reached: bool) -> After {
        After {
            current_height,
            assume_height_reached,
        }
    }
}

pub(crate) fn check_nsequence_rbf(rbf: Sequence, csv: Sequence) -> bool {
    // The RBF value must enable relative timelocks
    if !rbf.is_relative_lock_time() {
        return false;
    }

    // Both values should be represented in the same unit (either time-based or
    // block-height based)
    if rbf.is_time_locked() != csv.is_time_locked() {
        return false;
    }

    // The value should be at least `csv`
    if rbf < csv {
        return false;
    }

    true
}

impl<Pk: MiniscriptKey + ToPublicKey> Satisfier<Pk> for After {
    fn check_after(&self, n: LockTime) -> bool {
        if let Some(current_height) = self.current_height {
            current_height >= n.to_consensus_u32()
        } else {
            self.assume_height_reached
        }
    }
}

pub struct Older {
    pub current_height: Option<u32>,
    pub create_height: Option<u32>,
    pub assume_height_reached: bool,
}

impl Older {
    pub(crate) fn new(
        current_height: Option<u32>,
        create_height: Option<u32>,
        assume_height_reached: bool,
    ) -> Older {
        Older {
            current_height,
            create_height,
            assume_height_reached,
        }
    }
}

impl<Pk: MiniscriptKey + ToPublicKey> Satisfier<Pk> for Older {
    fn check_older(&self, n: Sequence) -> bool {
        if let Some(current_height) = self.current_height {
            // TODO: test >= / >
            current_height
                >= self
                    .create_height
                    .unwrap_or(0)
                    .checked_add(n.to_consensus_u32())
                    .expect("Overflowing addition")
        } else {
            self.assume_height_reached
        }
    }
}

pub(crate) type SecpCtx = Secp256k1<All>;
