use crate::bdk::blockchain::BlockchainInstance;
use crate::bdk::descriptor::BdkDescriptor;
use crate::bdk::psbt::PartiallySignedTransaction;
use bdk_lite::database::{AnyDatabase, AnyDatabaseConfig, ConfigurableDatabase};
// use bdk_lite::descriptor::{Descriptor, IntoWalletDescriptor};
use bdk_lite::{Error as BdkError, Error, SyncOptions};
use bdk_lite::{SignOptions as BdkSignOptions, Wallet as BdkWallet};
// use bitcoin::hashes::hex::ToHex;
// use bdk_lite::descriptor::Descriptor;
// use bdk_lite::miniscript::descriptor::ConversionError;
// use bdk_lite::miniscript::TranslatePk;
// use bdk_lite::signer::SignerId;
// use bitcoin::PublicKey;
// use bdk_lite::miniscript::DefiniteDescriptorKey;
use flutter_rust_bridge::RustOpaque;
use std::ops::Deref;
use std::sync::{Arc, Mutex, MutexGuard};

use crate::bdk::types::{
    AddressIndex, AddressInfo, Balance, KeychainKind, OutPoint, Progress, ProgressHolder,
    TransactionDetails, TxOut,
};

/// A Bitcoin wallet.
/// The Wallet acts as a way of coherently interfacing with output descriptors and related transactions. Its main components are:
///     1. Output descriptors from which it can derive addresses.
///     2. A Database where it tracks transactions and utxos related to the descriptors.
///     3. Signers that can contribute signatures to addresses instantiated from the descriptors.
#[derive(Debug)]
pub struct WalletInstance {
    pub wallet_mutex: Mutex<BdkWallet<AnyDatabase>>,
}
impl From<WalletInstance> for RustOpaque<WalletInstance> {
    fn from(wallet: WalletInstance) -> Self {
        RustOpaque::new(wallet)
    }
}
impl WalletInstance {
    pub fn new(
        descriptor: Arc<RustOpaque<BdkDescriptor>>,
        change_descriptor: Option<Arc<RustOpaque<BdkDescriptor>>>,
        network: bdk_lite::bitcoin::Network,
        database_config: DatabaseConfig,
    ) -> Result<Self, BdkError> {
        let database = AnyDatabase::from_config(&database_config.into()).unwrap();
        let descriptor: String = descriptor.as_string_private();
        let change_descriptor: Option<String> = change_descriptor.map(|d| d.as_string_private());

        let wallet_mutex = Mutex::new(
            BdkWallet::new(&descriptor, change_descriptor.as_ref(), network, database).unwrap(),
        );
        Ok(WalletInstance { wallet_mutex })
    }

    // pub fn new_single(
    //     descriptor: String,
    //     change_descriptor: Option<String>,
    //     network: bdk_lite::bitcoin::Network,
    //     database_config: DatabaseConfig,
    // ) -> Result<Self, BdkError> {
    //     let database = AnyDatabase::from_config(&database_config.into()).unwrap();
    //     let wallet_mutex = Mutex::new(
    //         BdkWallet::new(&descriptor, change_descriptor.as_ref(), network, database).unwrap(),
    //     );
    //     Ok(WalletInstance { wallet_mutex })
    // }

    pub fn get_wallet(&self) -> MutexGuard<BdkWallet<AnyDatabase>> {
        self.wallet_mutex.lock().expect("wallet")
    }

    pub fn sync(&self, blockchain: &BlockchainInstance, progress: Option<Box<dyn Progress>>) {
        let bdk_sync_option: SyncOptions = if let Some(p) = progress {
            SyncOptions {
                progress: Some(Box::new(ProgressHolder { progress: p })
                    as Box<(dyn bdk_lite::blockchain::Progress + 'static)>),
            }
        } else {
            SyncOptions { progress: None }
        };
        let blockchain = blockchain.get_blockchain();
        self.get_wallet()
            .sync(blockchain.deref(), bdk_sync_option)
            .unwrap()
    }
    /// Return the balance, meaning the sum of this wallet’s unspent outputs’ values. Note that this method only operates
    /// on the internal database, which first needs to be Wallet.sync manually.
    pub fn get_balance(&self) -> Result<Balance, BdkError> {
        self.get_wallet().get_balance().map(|b| b.into())
    }

    // Return a derived address using the internal (change) descriptor.
    ///
    /// If the wallet doesn't have an internal descriptor it will use the external descriptor.
    ///
    /// see [`AddressIndex`] for available address index selection strategies. If none of the keys
    /// in the descriptor are derivable (i.e. does not end with /*) then the same address will always
    /// be returned for any [`AddressIndex`].
    pub(crate) fn get_internal_address(
        &self,
        address_index: AddressIndex,
    ) -> Result<AddressInfo, BdkError> {
        self.get_wallet()
            .get_internal_address(address_index.into())
            .map(AddressInfo::from)
    }
    pub fn get_address(&self, address_index: AddressIndex) -> Result<AddressInfo, BdkError> {
        self.get_wallet()
            .get_address(address_index.into())
            .map(AddressInfo::from)
    }

    /// Return the list of transactions made and received by the wallet. Note that this method only operate on the internal database, which first needs to be [Wallet.sync] manually.
    pub fn list_transactions(
        &self,
        include_raw: bool,
    ) -> Result<Vec<TransactionDetails>, BdkError> {
        let transaction_details = self.get_wallet().list_transactions(include_raw).unwrap();
        Ok(transaction_details
            .iter()
            .map(TransactionDetails::from)
            .collect())
    }
    // Return the list of unspent outputs of this wallet. Note that this method only operates on the internal database,
    // which first needs to be Wallet.sync manually.
    pub fn list_unspent(&self) -> Result<Vec<LocalUtxo>, BdkError> {
        let unspents = self.get_wallet().list_unspent()?;
        Ok(unspents.into_iter().map(LocalUtxo::from).collect())
    }

    pub fn cache_address(&self, cache_size: u32) -> Result<bool, Error> {
        self.get_wallet().ensure_addresses_cached(cache_size)
    }

    pub(crate) fn sign(
        &self,
        psbt: &PartiallySignedTransaction,
        sign_options: Option<SignOptions>,
    ) -> Result<bool, BdkError> {
        let mut psbt = psbt.internal.lock().unwrap();
        self.get_wallet().sign(
            &mut psbt,
            sign_options.map(SignOptions::into).unwrap_or_default(),
        )
    }
}

/// Options for a software signer
///
/// Adjust the behavior of our software signers and the way a transaction is finalized
#[derive(Debug, Clone, Default)]
pub struct SignOptions {
    /// Whether the signer should trust the `witness_utxo`, if the `non_witness_utxo` hasn't been
    /// provided
    ///
    /// Defaults to `false` to mitigate the "SegWit bug" which should trick the wallet into
    /// paying a fee larger than expected.
    ///
    /// Some wallets, especially if relatively old, might not provide the `non_witness_utxo` for
    /// SegWit transactions in the PSBT they generate: in those cases setting this to `true`
    /// should correctly produce a signature, at the expense of an increased trust in the creator
    /// of the PSBT.
    ///
    /// For more details see: <https://blog.trezor.io/details-of-firmware-updates-for-trezor-one-version-1-9-1-and-trezor-model-t-version-2-3-1-1eba8f60f2dd>
    pub trust_witness_utxo: bool,

    /// Whether the wallet should assume a specific height has been reached when trying to finalize
    /// a transaction
    ///
    /// The wallet will only "use" a timelock to satisfy the spending policy of an input if the
    /// timelock height has already been reached. This option allows overriding the "current height" to let the
    /// wallet use timelocks in the future to spend a coin.
    pub assume_height: Option<u32>,

    /// Whether the signer should use the `sighash_type` set in the PSBT when signing, no matter
    /// what its value is
    ///
    /// Defaults to `false` which will only allow signing using `SIGHASH_ALL`.
    pub allow_all_sighashes: bool,

    /// Whether to remove partial signatures from the PSBT inputs while finalizing PSBT.
    ///
    /// Defaults to `true` which will remove partial signatures during finalization.
    pub remove_partial_sigs: bool,

    /// Whether to try finalizing the PSBT after the inputs are signed.
    ///
    /// Defaults to `true` which will try finalizing PSBT after inputs are signed.
    pub try_finalize: bool,

    /// Whether to try finalizing the PSBT after the inputs are signed.
    ///
    /// Defaults to `true` which will try finalizing PSBT of Mine.
    pub finalize_mine_only: bool,
    // Specifies which Taproot script-spend leaves we should sign for. This option is
    // ignored if we're signing a non-taproot PSBT.
    //
    // Defaults to All, i.e., the wallet will sign all the leaves it has a key for.
    // TODO pub tap_leaves_options: TapLeavesOptions,
    /// Whether we should try to sign a taproot transaction with the taproot internal key
    /// or not. This option is ignored if we're signing a non-taproot PSBT.
    ///
    /// Defaults to `true`, i.e., we always try to sign with the taproot internal key.
    pub sign_with_tap_internal_key: bool,

    /// Whether we should grind ECDSA signature to ensure signing with low r
    /// or not.
    /// Defaults to `true`, i.e., we always grind ECDSA signature to sign with low r.
    pub allow_grinding: bool,
}

impl From<SignOptions> for BdkSignOptions {
    fn from(sign_options: SignOptions) -> Self {
        BdkSignOptions {
            trust_witness_utxo: sign_options.trust_witness_utxo,
            assume_height: sign_options.assume_height,
            allow_all_sighashes: sign_options.allow_all_sighashes,
            remove_partial_sigs: sign_options.remove_partial_sigs,
            try_finalize: sign_options.try_finalize,
            finalize_mine_only: sign_options.finalize_mine_only,
            tap_leaves_options: Default::default(),
            sign_with_tap_internal_key: sign_options.sign_with_tap_internal_key,
            allow_grinding: sign_options.allow_grinding,
        }
    }
}

/// Unspent outputs of this wallet
pub struct LocalUtxo {
    /// Reference to a transaction output
    pub outpoint: OutPoint,
    ///Transaction output
    pub txout: TxOut,
    ///Whether this UTXO is spent or not
    pub is_spent: bool,
    pub keychain: KeychainKind,
}

impl From<bdk_lite::LocalUtxo> for LocalUtxo {
    fn from(local_utxo: bdk_lite::LocalUtxo) -> Self {
        LocalUtxo {
            outpoint: OutPoint {
                txid: local_utxo.outpoint.txid.to_string(),
                vout: local_utxo.outpoint.vout,
            },
            txout: TxOut {
                value: local_utxo.clone().txout.value,
                script_pubkey: local_utxo.clone().txout.script_pubkey.into(),
            },
            keychain: local_utxo.keychain.into(),
            is_spent: local_utxo.is_spent,
        }
    }
}
///Configuration type for a SqliteDatabase database
pub struct SqliteDbConfiguration {
    ///Main directory of the db
    pub path: String,
}
///Configuration type for a sled Tree database
pub struct SledDbConfiguration {
    ///Main directory of the db
    pub path: String,
    ///Name of the database tree, a separated namespace for the data
    pub tree_name: String,
}
/// Type that can contain any of the database configurations defined by the library
/// This allows storing a single configuration that can be loaded into an DatabaseConfig
/// instance. Wallets that plan to offer users the ability to switch blockchain backend at runtime
/// will find this particularly useful.
pub enum DatabaseConfig {
    Memory,
    ///Simple key-value embedded database based on sled
    Sqlite {
        config: SqliteDbConfiguration,
    },
    ///Sqlite embedded database using rusqlite
    Sled {
        config: SledDbConfiguration,
    },
}
impl From<DatabaseConfig> for AnyDatabaseConfig {
    fn from(config: DatabaseConfig) -> Self {
        match config {
            DatabaseConfig::Memory => AnyDatabaseConfig::Memory(()),
            DatabaseConfig::Sqlite { config } => {
                AnyDatabaseConfig::Sqlite(bdk_lite::database::any::SqliteDbConfiguration {
                    path: config.path,
                })
            }
            DatabaseConfig::Sled { config } => {
                AnyDatabaseConfig::Sled(bdk_lite::database::any::SledDbConfiguration {
                    path: config.path,
                    tree_name: config.tree_name,
                })
            }
        }
    }
}

#[cfg(test)]
mod test {

    use crate::bdk::descriptor::BdkDescriptor;
    use crate::bdk::wallet::{AddressIndex, DatabaseConfig, WalletInstance};
    use bdk_lite::bitcoin::Network;
    use flutter_rust_bridge::RustOpaque;
    use std::sync::Arc;

    #[test]
    fn test_peek_reset_address() {
        let test_wpkh = "wpkh(tprv8hwWMmPE4BVNxGdVt3HhEERZhondQvodUY7Ajyseyhudr4WabJqWKWLr4Wi2r26CDaNCQhhxEftEaNzz7dPGhWuKFU4VULesmhEfZYyBXdE/0/*)";
        let descriptor =
            RustOpaque::new(BdkDescriptor::new(test_wpkh.to_string(), Network::Regtest).unwrap());
        let change_descriptor = RustOpaque::new(
            BdkDescriptor::new(
                test_wpkh.to_string().replace("/0/*", "/1/*"),
                Network::Regtest,
            )
            .unwrap(),
        );

        let wallet = WalletInstance::new(
            Arc::new(descriptor),
            Some(Arc::new(change_descriptor)),
            Network::Regtest,
            DatabaseConfig::Memory,
        )
        .unwrap();

        assert_eq!(
            wallet
                .get_address(AddressIndex::Peek { index: 2 })
                .unwrap()
                .address,
            "bcrt1q5g0mq6dkmwzvxscqwgc932jhgcxuqqkjv09tkj"
        );

        assert_eq!(
            wallet
                .get_address(AddressIndex::Peek { index: 1 })
                .unwrap()
                .address,
            "bcrt1q0xs7dau8af22rspp4klya4f7lhggcnqfun2y3a"
        );

        // new index still 0
        assert_eq!(
            wallet.get_address(AddressIndex::New).unwrap().address,
            "bcrt1qqjn9gky9mkrm3c28e5e87t5akd3twg6xezp0tv"
        );

        // new index now 1
        assert_eq!(
            wallet.get_address(AddressIndex::New).unwrap().address,
            "bcrt1q0xs7dau8af22rspp4klya4f7lhggcnqfun2y3a"
        );

        // new index now 2
        assert_eq!(
            wallet.get_address(AddressIndex::New).unwrap().address,
            "bcrt1q5g0mq6dkmwzvxscqwgc932jhgcxuqqkjv09tkj"
        );

        // peek index 1
        assert_eq!(
            wallet
                .get_address(AddressIndex::Peek { index: 1 })
                .unwrap()
                .address,
            "bcrt1q0xs7dau8af22rspp4klya4f7lhggcnqfun2y3a"
        );

        // reset to index 0
        assert_eq!(
            wallet
                .get_address(AddressIndex::Reset { index: 0 })
                .unwrap()
                .address,
            "bcrt1qqjn9gky9mkrm3c28e5e87t5akd3twg6xezp0tv"
        );

        // new index 1 again
        assert_eq!(
            wallet.get_address(AddressIndex::New).unwrap().address,
            "bcrt1q0xs7dau8af22rspp4klya4f7lhggcnqfun2y3a"
        );
    }
    #[test]
    fn test_get_address() {
        let test_wpkh = "wpkh(tprv8hwWMmPE4BVNxGdVt3HhEERZhondQvodUY7Ajyseyhudr4WabJqWKWLr4Wi2r26CDaNCQhhxEftEaNzz7dPGhWuKFU4VULesmhEfZYyBXdE/0/*)";
        let descriptor =
            RustOpaque::new(BdkDescriptor::new(test_wpkh.to_string(), Network::Regtest).unwrap());
        let change_descriptor = RustOpaque::new(
            BdkDescriptor::new(
                test_wpkh.to_string().replace("/0/*", "/1/*"),
                Network::Regtest,
            )
            .unwrap(),
        );

        let wallet = WalletInstance::new(
            Arc::new(descriptor),
            Some(Arc::new(change_descriptor)),
            Network::Regtest,
            DatabaseConfig::Memory,
        )
        .unwrap();

        assert_eq!(
            wallet.get_address(AddressIndex::New).unwrap().address,
            "bcrt1qqjn9gky9mkrm3c28e5e87t5akd3twg6xezp0tv"
        );

        assert_eq!(
            wallet.get_address(AddressIndex::New).unwrap().address,
            "bcrt1q0xs7dau8af22rspp4klya4f7lhggcnqfun2y3a"
        );

        assert_eq!(
            wallet
                .get_address(AddressIndex::LastUnused)
                .unwrap()
                .address,
            "bcrt1q0xs7dau8af22rspp4klya4f7lhggcnqfun2y3a"
        );

        assert_eq!(
            wallet
                .get_internal_address(AddressIndex::New)
                .unwrap()
                .address,
            "bcrt1qpmz73cyx00r4a5dea469j40ax6d6kqyd67nnpj"
        );

        assert_eq!(
            wallet
                .get_internal_address(AddressIndex::New)
                .unwrap()
                .address,
            "bcrt1qaux734vuhykww9632v8cmdnk7z2mw5lsf74v6k"
        );

        assert_eq!(
            wallet
                .get_internal_address(AddressIndex::LastUnused)
                .unwrap()
                .address,
            "bcrt1qaux734vuhykww9632v8cmdnk7z2mw5lsf74v6k"
        );
    }
}
