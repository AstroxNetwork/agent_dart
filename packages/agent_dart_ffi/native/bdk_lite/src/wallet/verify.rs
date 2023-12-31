// Bitcoin Dev Kit
// Written in 2021 by Alekos Filini <alekos.filini@gmail.com>
//
// Copyright (c) 2020-2021 Bitcoin Dev Kit Developers
//
// This file is licensed under the Apache License, Version 2.0 <LICENSE-APACHE
// or http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your option.
// You may not use this file except in accordance with one or both of these
// licenses.

//! Verify transactions against the consensus rules

use std::collections::HashMap;
use std::fmt;

use bitcoin::consensus::serialize;
use bitcoin::{OutPoint, Transaction, Txid};

use crate::blockchain::GetTx;
use crate::database::Database;
use crate::error::Error;

/// Verify a transaction against the consensus rules
///
/// This function uses [`bitcoinconsensus`] to verify transactions by fetching the required data
/// either from the [`Database`] or using the [`Blockchain`].
///
/// Depending on the [capabilities](crate::blockchain::Blockchain::get_capabilities) of the
/// [`Blockchain`] backend, the method could fail when called with old "historical" transactions or
/// with unconfirmed transactions that have been evicted from the backend's memory.
///
/// [`Blockchain`]: crate::blockchain::Blockchain
pub fn verify_tx<D: Database, B: GetTx>(
    tx: &Transaction,
    database: &D,
    blockchain: &B,
) -> Result<(), VerifyError> {
    log::debug!("Verifying {}", tx.txid());

    let serialized_tx = serialize(tx);
    let mut tx_cache = HashMap::<_, Transaction>::new();

    for (index, input) in tx.input.iter().enumerate() {
        let prev_tx = if let Some(prev_tx) = tx_cache.get(&input.previous_output.txid) {
            prev_tx.clone()
        } else if let Some(prev_tx) = database.get_raw_tx(&input.previous_output.txid)? {
            prev_tx
        } else if let Some(prev_tx) = blockchain.get_tx(&input.previous_output.txid)? {
            prev_tx
        } else {
            return Err(VerifyError::MissingInputTx(input.previous_output.txid));
        };

        let spent_output = prev_tx
            .output
            .get(input.previous_output.vout as usize)
            .ok_or(VerifyError::InvalidInput(input.previous_output))?;

        bitcoinconsensus::verify(
            &spent_output.script_pubkey.to_bytes(),
            spent_output.value,
            &serialized_tx,
            index,
        )?;

        // Since we have a local cache we might as well cache stuff from the db, as it will very
        // likely decrease latency compared to reading from disk or performing an SQL query.
        tx_cache.insert(prev_tx.txid(), prev_tx);
    }

    Ok(())
}

/// Error during validation of a tx agains the consensus rules
#[derive(Debug)]
pub enum VerifyError {
    /// The transaction being spent is not available in the database or the blockchain client
    MissingInputTx(Txid),
    /// The transaction being spent doesn't have the requested output
    InvalidInput(OutPoint),

    /// Consensus error
    Consensus(bitcoinconsensus::Error),

    /// Generic error
    ///
    /// It has to be wrapped in a `Box` since `Error` has a variant that contains this enum
    Global(Box<Error>),
}

impl fmt::Display for VerifyError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::MissingInputTx(txid) => write!(f, "The transaction being spent is not available in the database or the blockchain client: {}", txid),
            Self::InvalidInput(outpoint) => write!(f, "The transaction being spent doesn't have the requested output: {}", outpoint),
            Self::Consensus(err) => write!(f, "Consensus error: {:?}", err),
            Self::Global(err) => write!(f, "Generic error: {}", err),
        }
    }
}

impl std::error::Error for VerifyError {}

impl From<Error> for VerifyError {
    fn from(other: Error) -> Self {
        VerifyError::Global(Box::new(other))
    }
}
impl_error!(bitcoinconsensus::Error, Consensus, VerifyError);
