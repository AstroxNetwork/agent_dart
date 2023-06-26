use bdk_lite::bitcoin::consensus::Decodable;
use bdk_lite::bitcoin::hashes::hex::ToHex;
use bdk_lite::bitcoin::psbt::serialize::Serialize;
use bdk_lite::bitcoin::util::psbt::PartiallySignedTransaction as BdkPartiallySignedTransaction;
use bdk_lite::bitcoin::Transaction as BdkTransaction;

use bdk_lite::psbt::PsbtUtils;
use bdk_lite::{Error as BdkError, FeeRate};
use std::borrow::Borrow;
use std::io::Cursor;
use std::ops::Deref;
use std::str::FromStr;
use std::sync::{Arc, Mutex};

use crate::bdk::types::{TxIn, TxOut};

#[derive(Debug)]
pub struct PartiallySignedTransaction {
    pub internal: Mutex<BdkPartiallySignedTransaction>,
}

impl PartiallySignedTransaction {
    pub(crate) fn new(psbt_base64: String) -> Result<Self, BdkError> {
        let psbt: BdkPartiallySignedTransaction =
            BdkPartiallySignedTransaction::from_str(psbt_base64.borrow())?;
        Ok(PartiallySignedTransaction {
            internal: Mutex::new(psbt),
        })
    }

    pub(crate) fn serialize(&self) -> String {
        let psbt = self.internal.lock().unwrap().clone();
        psbt.to_string()
    }

    pub(crate) fn txid(&self) -> String {
        let tx = self.internal.lock().unwrap().clone().extract_tx();
        let txid = tx.txid();
        txid.to_hex()
    }

    /// Return the transaction.
    pub(crate) fn extract_tx(&self) -> Transaction {
        let tx = self.internal.lock().unwrap().clone().extract_tx();
        Transaction { internal: tx }
    }

    /// Combines this PartiallySignedTransaction with other PSBT as described by BIP 174.
    ///
    /// In accordance with BIP 174 this function is commutative i.e., `A.combine(B) == B.combine(A)`
    pub(crate) fn combine(
        &self,
        other: Arc<PartiallySignedTransaction>,
    ) -> Result<Arc<PartiallySignedTransaction>, BdkError> {
        let other_psbt = other.internal.lock().unwrap().clone();
        let mut original_psbt = self.internal.lock().unwrap().clone();

        original_psbt.combine(other_psbt)?;
        Ok(Arc::new(PartiallySignedTransaction {
            internal: Mutex::new(original_psbt),
        }))
    }

    /// The total transaction fee amount, sum of input amounts minus sum of output amounts, in Sats.
    /// If the PSBT is missing a TxOut for an input returns None.
    pub(crate) fn fee_amount(&self) -> Option<u64> {
        self.internal.lock().unwrap().fee_amount()
    }

    /// The transaction's fee rate. This value will only be accurate if calculated AFTER the
    /// `PartiallySignedTransaction` is finalized and all witness/signature data is added to the
    /// transaction.
    /// If the PSBT is missing a TxOut for an input returns None.
    pub(crate) fn fee_rate(&self) -> Option<Arc<FeeRate>> {
        self.internal.lock().unwrap().fee_rate().map(Arc::new)
    }

    /// Serialize the PSBT data structure as a String of JSON.
    pub(crate) fn json_serialize(&self) -> String {
        let psbt = self.internal.lock().unwrap();
        serde_json::to_string(psbt.deref()).unwrap()
    }

    pub(crate) fn get_inputs(&self) -> Vec<TxOut> {
        let psbt = self.internal.lock().unwrap();
        let tx = psbt.clone().extract_tx();
        let mut outs: Vec<TxOut> = vec![];
        for (n, _) in tx.input.iter().enumerate() {
            let done = &psbt.inputs.get(n).expect("Out of Range");
            if done.witness_utxo.is_some() {
                outs.push(TxOut::from(&done.witness_utxo.clone().unwrap()))
            }
        }
        outs
    }
}

#[derive(Debug)]
pub struct Transaction {
    pub(crate) internal: BdkTransaction,
}

impl From<String> for Transaction {
    fn from(tx: String) -> Self {
        let tx_: BdkTransaction = serde_json::from_str(&tx).expect("Invalid Transaction");
        Transaction { internal: tx_ }
    }
}
impl From<Transaction> for String {
    fn from(tx: Transaction) -> Self {
        match serde_json::to_string(&tx.internal) {
            Ok(e) => e,
            Err(e) => panic!("Unable to deserialize the Tranaction {:?}", e),
        }
    }
}

impl From<BdkTransaction> for Transaction {
    fn from(tx: BdkTransaction) -> Self {
        Transaction { internal: tx }
    }
}

impl Transaction {
    pub fn new(transaction_bytes: Vec<u8>) -> Result<Self, BdkError> {
        let mut decoder = Cursor::new(transaction_bytes);
        let tx: BdkTransaction = BdkTransaction::consensus_decode(&mut decoder)?;
        Ok(Transaction { internal: tx })
    }
    pub fn txid(&self) -> String {
        self.internal.txid().to_string()
    }

    pub fn weight(&self) -> u64 {
        self.internal.weight() as u64
    }

    pub fn size(&self) -> u64 {
        self.internal.size() as u64
    }

    pub fn vsize(&self) -> u64 {
        self.internal.vsize() as u64
    }

    pub fn serialize(&self) -> Vec<u8> {
        self.internal.serialize()
    }

    pub fn is_coin_base(&self) -> bool {
        self.internal.is_coin_base()
    }

    pub fn is_explicitly_rbf(&self) -> bool {
        self.internal.is_explicitly_rbf()
    }

    pub fn is_lock_time_enabled(&self) -> bool {
        self.internal.is_lock_time_enabled()
    }

    pub fn version(&self) -> i32 {
        self.internal.version
    }

    pub fn lock_time(&self) -> u32 {
        self.internal.lock_time.0
    }
    pub fn input(&self) -> Vec<TxIn> {
        self.internal.input.iter().map(|x| x.into()).collect()
    }

    pub fn output(&self) -> Vec<TxOut> {
        self.internal.output.iter().map(|x| x.into()).collect()
    }
}
