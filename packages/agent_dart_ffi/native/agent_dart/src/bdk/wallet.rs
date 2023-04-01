use crate::bdk::psbt::PartiallySignedTransaction;
use crate::bdk::types::{AddressIndex, AddressInfo};
use crate::psbt::get_descriptor_from_ad_type;

use bdk::bitcoin::Network;
use bdk::SignOptions;
use bdk::{Error as BdkError, Wallet};

use std::borrow::BorrowMut;

/// A Bitcoin wallet.
/// The Wallet acts as a way of coherently interfacing with output descriptors and related transactions. Its main components are:
///     1. Output descriptors from which it can derive addresses.
///     2. A Database where it tracks transactions and utxos related to the descriptors.
///     3. Signers that can contribute signatures to addresses instantiated from the descriptors.
#[derive(Debug)]
pub struct WalletInstance {
    prv: String,
    address_type: String,
    wallet: Wallet,
}

impl WalletInstance {
    pub fn new(prv: String, address_type: String, network: Option<String>) -> Self {
        let de = get_descriptor_from_ad_type(prv.clone(), address_type.clone(), network)
            .expect("Cannot get descriptor from address type");
        let wallet =
            Wallet::new_no_persist(de, None, Network::Bitcoin).expect("TODO: panic message");
        Self {
            prv,
            address_type,
            wallet,
        }
    }
    pub fn get_wallet(&mut self) -> &mut Wallet {
        self.wallet.borrow_mut()
    }

    /// Return the balance, meaning the sum of this wallet’s unspent outputs’ values. Note that this method only operates
    /// on the internal database, which first needs to be Wallet.sync manually.
    // pub fn get_balance(&mut self) -> Balance {
    //     let b = self.get_wallet().get_balance();
    //     Balance::from(b)
    // }

    // Return a derived address using the internal (change) descriptor.
    ///
    /// If the wallet doesn't have an internal descriptor it will use the external descriptor.
    ///
    /// see [`AddressIndex`] for available address index selection strategies. If none of the keys
    /// in the descriptor are derivable (i.e. does not end with /*) then the same address will always
    /// be returned for any [`AddressIndex`].
    pub(crate) fn get_internal_address(&mut self, address_index: AddressIndex) -> AddressInfo {
        let a = self.get_wallet().get_internal_address(address_index.into());
        AddressInfo::from(a)
    }

    pub fn get_address(&mut self, address_index: AddressIndex) -> AddressInfo {
        let a = self.get_wallet().get_address(address_index.into());
        AddressInfo::from(a)
    }

    // /// Return the list of transactions made and received by the wallet. Note that this method only operate on the internal database, which first needs to be [Wallet.sync] manually.
    // pub fn list_transactions(&mut self) -> Result<Vec<TransactionDetails>, BdkError> {
    //     let txs = self.get_wallet().list_transactions(true);
    //     Ok(txs.iter().map(|t| TransactionDetails::from(t)).collect())
    // }
    // // Return the list of unspent outputs of this wallet. Note that this method only operates on the internal database,
    // // which first needs to be Wallet.sync manually.
    // pub fn list_unspent(&mut self) -> Result<Vec<LocalUtxo>, BdkError> {
    //     let unspents = self.get_wallet().list_unspent();
    //     Ok(unspents
    //         .iter()
    //         .map(|u| LocalUtxo::from_utxo(u, self.get_wallet().network()))
    //         .collect())
    // }
    pub fn sign(&mut self, psbt: &PartiallySignedTransaction) -> Result<bool, BdkError> {
        let mut psbt = psbt.internal.lock().unwrap();
        self.get_wallet().sign(&mut psbt, SignOptions::default())
    }
}

//
// /// Unspent outputs of this wallet
// pub struct LocalUtxo {
//     /// Reference to a transaction output
//     pub outpoint: OutPoint,
//     ///Transaction output
//     pub txout: TxOut,
//     ///Whether this UTXO is spent or not
//     pub is_spent: bool,
// }
// // This trait is used to convert the bdk TxOut type with field `script_pubkey: Script`
// // into the bdk-ffi TxOut type which has a field `address: String` instead
// trait NetworkLocalUtxo {
//     fn from_utxo(x: &bdk::LocalUtxo, network: bdk::bitcoin::Network) -> LocalUtxo;
// }
// impl NetworkLocalUtxo for LocalUtxo {
//     fn from_utxo(x: &bdk::LocalUtxo, network: bdk::bitcoin::Network) -> LocalUtxo {
//         LocalUtxo {
//             outpoint: OutPoint {
//                 txid: x.clone().outpoint.txid.to_string(),
//                 vout: x.clone().outpoint.vout,
//             },
//             txout: TxOut {
//                 value: x.clone().txout.value,
//                 address: bdk::bitcoin::util::address::Address::from_script(
//                     &x.txout.script_pubkey,
//                     network,
//                 )
//                 .unwrap()
//                 .to_string(),
//             },
//             is_spent: x.clone().is_spent,
//         }
//     }
// }
