use bdk::bitcoin::consensus::Decodable;
use bdk::bitcoin::hashes::hex::ToHex;
use bdk::bitcoin::psbt::serialize::Serialize;
use bdk::bitcoin::util::psbt::PartiallySignedTransaction as BdkPartiallySignedTransaction;
use bdk::bitcoin::Transaction as BdkTransaction;
use bdk::psbt::PsbtUtils;
use bdk::{Error as BdkError, FeeRate};
use flutter_rust_bridge::RustOpaque;
use std::io::Cursor;
use std::str::FromStr;
use std::sync::{Arc, Mutex};

#[derive(Debug)]
pub struct PartiallySignedTransaction {
    pub internal: Mutex<BdkPartiallySignedTransaction>,
}

impl PartiallySignedTransaction {
    pub(crate) fn new(psbt_base64: String) -> Result<Self, BdkError> {
        let psbt = BdkPartiallySignedTransaction::from_str(&psbt_base64)
            .expect("Can not get psbt from base64");
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
    pub(crate) fn extract_tx(&self) -> Arc<Transaction> {
        let tx = self.internal.lock().unwrap().clone().extract_tx();
        Arc::new(Transaction { internal: tx })
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
}

#[derive(Debug)]
pub struct Transaction {
    pub(crate) internal: BdkTransaction,
}

impl From<RustOpaque<Transaction>> for Transaction {
    fn from(tx: RustOpaque<Transaction>) -> Self {
        let vec = tx.serialize();
        let tx_ = Transaction::new(vec);
        match tx_ {
            Ok(e) => e,
            Err(_) => panic!("Invalid transaction"),
        }
    }
}

impl From<Transaction> for RustOpaque<Transaction> {
    fn from(tx: Transaction) -> Self {
        RustOpaque::new(tx)
    }
}
impl Transaction {
    pub fn new(transaction_bytes: Vec<u8>) -> Result<Self, BdkError> {
        let mut decoder = Cursor::new(transaction_bytes);
        let tx: BdkTransaction =
            BdkTransaction::consensus_decode(&mut decoder).expect("Can not decode transaction");
        Ok(Transaction { internal: tx })
    }

    pub fn serialize(&self) -> Vec<u8> {
        self.internal.serialize()
    }
}
