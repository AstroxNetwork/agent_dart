//========Psbt==========
use bdk::bitcoin::hashes::hex::ToHex;
use bdk::bitcoin::secp256k1::Secp256k1;
use bdk::bitcoin::{Address as BdkAddress, OutPoint as BdkOutPoint, Txid};
use bdk::bitcoin::{AddressType, Network, PublicKey};
use bdk::descriptor::{Descriptor, DescriptorPublicKey};
use bdk::miniscript::{MiniscriptKey, ToPublicKey};

use bdk::wallet::tx_builder::ChangeSpendPolicy;
use bdk::{bitcoin, Wallet};
use bitcoin::blockdata::opcodes as Opcode;
use bitcoin::blockdata::script::Builder as BtcScriptBuilder;

use std::str::FromStr;
use std::sync::{Arc, Mutex};

use crate::bdk::psbt::{PartiallySignedTransaction, Transaction};
use crate::bdk::types::{
    AddressIndex, AddressInfo, BdkTxBuilderResult, BitcoinAddress, Script, ScriptAmount,
    TransactionDetails,
};
use crate::bdk::wallet::WalletInstance;
use crate::types::{OutPoint, PsbtWalletReq};

#[derive(Clone, Debug)]
pub struct PsbtFFI {}

impl PsbtFFI {
    pub fn psbt_to_txid(psbt_str: String) -> anyhow::Result<String, anyhow::Error> {
        let psbt = PartiallySignedTransaction::new(psbt_str);
        return match psbt {
            Ok(e) => Ok(e.txid()),
            Err(e) => anyhow::bail!("{:?}", e),
        };
    }

    pub fn extract_tx(psbt_str: String) -> anyhow::Result<Vec<u8>, anyhow::Error> {
        let psbt = PartiallySignedTransaction::new(psbt_str);
        return match psbt {
            Ok(e) => Ok(e.extract_tx().serialize()),
            Err(e) => anyhow::bail!("{:?}", e),
        };
    }
    pub fn get_psbt_fee_rate(psbt_str: String) -> Option<f32> {
        let psbt = PartiallySignedTransaction::new(psbt_str);
        match psbt.unwrap().fee_rate() {
            None => None,
            Some(e) => Some(e.as_sat_per_vb()),
        }
    }
    pub fn get_fee_amount(psbt_str: String) -> Option<u64> {
        let psbt = PartiallySignedTransaction::new(psbt_str);
        psbt.unwrap().fee_amount()
    }
    pub fn combine_psbt(psbt_str: String, other: String) -> anyhow::Result<String, anyhow::Error> {
        let psbt = PartiallySignedTransaction::new(psbt_str).unwrap();
        let other = PartiallySignedTransaction::new(other).unwrap();
        return match psbt.combine(Arc::new(other)) {
            Ok(e) => Ok(e.serialize()),
            Err(e) => anyhow::bail!("{:?}", e),
        };
    }

    //=========Transaction===========
    pub fn new_transaction(tx: Vec<u8>) -> anyhow::Result<Vec<u8>, anyhow::Error> {
        let res = Transaction::new(tx);
        match res {
            Ok(e) => Ok(e.serialize()),
            Err(e) => anyhow::bail!("{:?}", e),
        }
    }
    pub fn get_txid(tx: Vec<u8>) -> anyhow::Result<String, anyhow::Error> {
        let res = Transaction::new(tx);
        match res {
            Ok(e) => Ok(e.internal.txid().to_hex()),
            Err(e) => anyhow::bail!("{:?}", e),
        }
    }

    //======== Address ===========
    pub fn get_address_type(address: String) -> anyhow::Result<String, anyhow::Error> {
        let res = BdkAddress::from_str(&address);
        match res {
            Ok(e) => Ok(e.address_type().unwrap().to_string()),
            Err(e) => anyhow::bail!("{:?}", e),
        }
    }

    pub fn get_address_script(address: String) -> anyhow::Result<Vec<u8>, anyhow::Error> {
        let res = BdkAddress::from_str(&address);
        match res {
            Ok(e) => Ok(e.script_pubkey().to_bytes()),
            Err(e) => anyhow::bail!("{:?}", e),
        }
    }

    pub fn get_address_from_pubkey(
        public_key: String,
        network: Option<Network>,
    ) -> anyhow::Result<BitcoinAddress, anyhow::Error> {
        let res = PublicKey::from_str(&public_key);
        match res {
            Ok(e) => {
                let internal_key = e.to_x_only_pubkey();
                let secp = Secp256k1::verification_only();
                let p2tr =
                    BdkAddress::p2tr(&secp, internal_key, None, Network::Bitcoin).to_string();
                let p2pkh = BdkAddress::p2pkh(&e, network.unwrap_or(Network::Bitcoin)).to_string();

                let compressed;
                if e.is_uncompressed() {
                    compressed = PublicKey::from_slice(&e.inner.serialize())?.clone();
                } else {
                    compressed = PublicKey::from(e.clone());
                }

                let p2wpkh = BdkAddress::p2wpkh(&compressed, network.unwrap_or(Network::Bitcoin))
                    .unwrap()
                    .to_string();
                let p2sh_p2wpkh =
                    BdkAddress::p2shwpkh(&compressed, network.unwrap_or(Network::Bitcoin))
                        .unwrap()
                        .to_string();
                Ok(BitcoinAddress {
                    p2tr,
                    p2pkh,
                    p2wpkh,
                    p2sh_p2wpkh,
                })
            }
            Err(e) => anyhow::bail!("{:?}", e),
        }
    }

    pub fn tx_builder_finish(
        wallet_req: PsbtWalletReq,
        recipients: Vec<ScriptAmount>,
        utxos: Vec<OutPoint>,
        unspendable: Vec<OutPoint>,
        manually_selected_only: bool,
        only_spend_change: bool,
        do_not_spend_change: bool,
        fee_rate: Option<f32>,
        fee_absolute: Option<u64>,
        drain_wallet: bool,
        drain_to: Option<String>,
        enable_rbf: bool,
        n_sequence: Option<u32>,
        data: Vec<u8>,
    ) -> anyhow::Result<BdkTxBuilderResult, anyhow::Error> {
        // should pass in path to choose template
        let mut binding =
            WalletInstance::new(wallet_req.prv, wallet_req.address_type, wallet_req.network);
        let mut tx_builder = binding.get_wallet().build_tx();

        for e in recipients {
            let script = Script::from_hex(e.script).unwrap();
            tx_builder.add_recipient(script.script, e.amount);
        }
        if do_not_spend_change {
            tx_builder.change_policy(ChangeSpendPolicy::ChangeForbidden);
        }
        if only_spend_change {
            tx_builder.change_policy(ChangeSpendPolicy::OnlyChange);
        }
        tx_builder.change_policy(ChangeSpendPolicy::ChangeAllowed);
        if !utxos.is_empty() {
            let bdk_utxos: Vec<BdkOutPoint> = utxos
                .iter()
                .map(|e| BdkOutPoint::new(Txid::from_str(&e.txid).unwrap(), e.vout))
                .collect();
            let utxos: &[BdkOutPoint] = &bdk_utxos;
            tx_builder.add_utxos(utxos).unwrap();
        }
        if !unspendable.is_empty() {
            let bdk_unspendable: Vec<BdkOutPoint> = unspendable
                .iter()
                .map(|e| BdkOutPoint::new(Txid::from_str(&e.txid).unwrap(), e.vout))
                .collect();
            tx_builder.unspendable(bdk_unspendable);
        }
        if manually_selected_only {
            tx_builder.manually_selected_only();
        }
        if let Some(sat_per_vb) = fee_rate {
            tx_builder.fee_rate(bdk::FeeRate::from_sat_per_vb(sat_per_vb));
        }
        if let Some(fee_amount) = fee_absolute {
            tx_builder.fee_absolute(fee_amount);
        }
        if drain_wallet {
            tx_builder.drain_wallet();
        }
        if let Some(script_) = drain_to {
            let script = Script::from_hex(script_).unwrap();
            tx_builder.drain_to(script.script);
        }
        if enable_rbf {
            tx_builder.enable_rbf();
        }
        if let Some(n_sequence) = n_sequence {
            tx_builder.enable_rbf_with_sequence(bdk::bitcoin::Sequence(n_sequence));
        }
        if !data.is_empty() {
            tx_builder.add_data(data.as_slice());
        }

        return match tx_builder.finish() {
            Ok(e) => Ok(BdkTxBuilderResult(
                Arc::new(PartiallySignedTransaction {
                    internal: Mutex::new(e.0),
                })
                .serialize(),
                TransactionDetails::from(&e.1),
            )),
            Err(e) => anyhow::bail!("{:?}", e),
        };
    }

    pub fn get_address(
        prv: String,
        address_type: String,
        network: Option<String>,
        address_index: AddressIndex,
    ) -> AddressInfo {
        let mut wallet = WalletInstance::new(prv, address_type, network);
        wallet.get_address(address_index)
    }
    pub fn get_internalized_address(
        prv: String,
        address_type: String,
        network: Option<String>,
        address_index: AddressIndex,
    ) -> AddressInfo {
        let mut wallet = WalletInstance::new(prv, address_type, network);
        wallet.get_internal_address(address_index)
    }

    // pub fn get_balance(prv: String, address_type: String, network: Option<String>) -> Balance {
    //     let mut wallet = WalletInstance::new(prv, address_type, network);
    //     wallet.get_balance()
    // }
    //
    // //Return the list of unspent outputs of this wallet
    // pub fn list_unspent_outputs(
    //     prv: String,
    //     address_type: String,
    //     network: Option<String>,
    // ) -> anyhow::Result<Vec<crate::bdk::wallet::LocalUtxo>, anyhow::Error> {
    //     let mut wallet = WalletInstance::new(prv, address_type, network);
    //     match wallet.list_unspent() {
    //         Ok(e) => Ok(e),
    //         Err(e) => anyhow::bail!("{:?}", e),
    //     }
    // }
    //
    // pub fn get_transactions(
    //     prv: String,
    //     address_type: String,
    //     network: Option<String>,
    // ) -> anyhow::Result<Vec<TransactionDetails>, anyhow::Error> {
    //     let mut wallet = WalletInstance::new(prv, address_type, network);
    //     match wallet.list_transactions() {
    //         Ok(e) => Ok(e),
    //         Err(e) => anyhow::bail!("{:?}", e),
    //     }
    // }

    pub fn sign(
        prv: String,
        address_type: String,
        network: Option<String>,
        psbt_str: String,
        is_multi_sig: bool,
    ) -> Option<String> {
        let mut wallet = WalletInstance::new(prv, address_type, network);
        let psbt = match PartiallySignedTransaction::new(psbt_str) {
            Ok(e) => e,
            Err(e) => panic!("{:?}", e),
        };
        return match wallet.sign(&psbt).unwrap() {
            true => Some(psbt.serialize()),
            false => {
                if is_multi_sig {
                    Some(psbt.serialize())
                } else {
                    None
                }
            }
        };
    }

    // pub fn get_network(prv: String, address_type: String) -> Network {
    //     let mut wallet = WalletInstance::new(prv, address_type,network);
    //     wallet.network().into()
    // }

    // pub fn list_unspent(
    //     prv: String,
    //     address_type: String,
    //     network: Option<String>,
    // ) -> anyhow::Result<Vec<crate::bdk::wallet::LocalUtxo>, anyhow::Error> {
    //     let mut wallet = WalletInstance::new(prv, address_type, network);
    //     match wallet.list_unspent() {
    //         Ok(e) => Ok(e),
    //         Err(e) => anyhow::bail!("{:?}", e),
    //     }
    // }
}

pub fn get_descriptor_from_ad_type(
    prv: String,
    address_type: String,
    network: Option<String>,
) -> anyhow::Result<Descriptor<DescriptorPublicKey>> {
    let network = match network {
        Some(e) => match e.as_str() {
            "mainnet" => Network::Bitcoin,
            "testnet" => Network::Testnet,
            "regtest" => Network::Regtest,
            _ => Network::Bitcoin,
        },
        None => Network::Bitcoin,
    };
    let key = bitcoin::PrivateKey::from_slice(&hex::decode(prv).unwrap().as_slice(), network)?;
    let (de, _km, _network) = match AddressType::from_str(&address_type).unwrap() {
        AddressType::P2pkh => bdk::descriptor!(pkh(key))?,
        AddressType::P2sh => bdk::descriptor!(sh(wpkh(key)))?,
        AddressType::P2wpkh => bdk::descriptor!(wpkh(key))?,
        AddressType::P2tr => bdk::descriptor!(tr(key))?,
        _ => {
            panic!("not supported")
        }
    };
    Ok(de)
}

pub fn get_wallet(prv: String, address_type: String, network: Option<String>) -> Wallet {
    let de = get_descriptor_from_ad_type(prv, address_type, network)
        .expect("Cannot get descriptor from address type");
    Wallet::new_no_persist(de, None, Network::Bitcoin).expect("TODO: panic message")
}

pub fn asm_to_scriptpubkey(asm: &str) -> String {
    let mut builder = BtcScriptBuilder::new();

    for ins in asm.split(' ') {
        match ins {
            "OP_PUSHNUM_1" => builder = builder.push_opcode(Opcode::all::OP_PUSHNUM_1),
            "OP_PUSHBYTES_32" => builder = builder.push_opcode(Opcode::all::OP_PUSHBYTES_32),
            "OP_TRUE" => builder = builder.push_opcode(Opcode::OP_TRUE),
            "OP_FALSE" => builder = builder.push_opcode(Opcode::OP_FALSE),
            "OP_DUP" => builder = builder.push_opcode(Opcode::all::OP_DUP),
            "OP_HASH160" => builder = builder.push_opcode(Opcode::all::OP_HASH160),
            "OP_EQUALVERIFY" => builder = builder.push_opcode(Opcode::all::OP_EQUALVERIFY),
            "OP_CHECKSIG" => builder = builder.push_opcode(Opcode::all::OP_CHECKSIG),
            _ => {
                if let Ok(v) = u64::from_str(ins) {
                    let mut buf = Vec::new();
                    buf.extend_from_slice(&v.to_le_bytes());
                    builder = builder.push_slice(&buf)
                } else {
                    builder = builder.push_slice(&hex::decode(ins).unwrap())
                }
            }
        };
    }
    builder.into_script().to_hex()
}
