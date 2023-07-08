use base64::engine::general_purpose;
use base64::Engine;
use bdk_lite::bitcoin::{
    ecdsa,
    psbt::{Input as bdkInput, PartiallySignedTransaction as bdkPartiallySignedTransaction},
    schnorr::TapTweak,
    secp256k1::{self, Message, Secp256k1, Signing, Verification, XOnlyPublicKey},
    util::sighash::{self, EcdsaSighashType, SchnorrSighashType, SighashCache},
    util::taproot::{TapLeafHash, TapSighashHash},
    LockTime as bdkLockTime, OutPoint as bdkOutPoint, PackedLockTime as bdkPackedLockTime,
    PrivateKey, PublicKey, Script as bdkScript, Sequence as bdkSequence,
    Transaction as bdkTransaction, TxIn as bdkTxIn, TxOut as bdkTxOut, Txid as bdkTxid,
    Witness as bdkWitness,
};
use bdk_lite::miniscript::Descriptor;
use std::str::FromStr;
// use bdk_lite::Wallet;
use bitcoin::hashes::hex::FromHex;
use bitcoin::Network;

// use bdk_lite::KeychainKind;
use sha2::{Digest, Sha256};

pub fn hash_sha256(data: &Vec<u8>) -> Vec<u8> {
    let mut hasher = Sha256::new();
    hasher.update(data);
    let result = hasher.finalize();
    result.to_vec()
}

const UTXO: &str = "0000000000000000000000000000000000000000000000000000000000000000";
const TAG: &str = "BIP0322-signed-message";

pub struct Bip322Wallet {
    pub pubkey: PublicKey,
    pub private_key: PrivateKey,
    pub desc: Descriptor<PublicKey>,
}
pub enum WalletType {
    NativeSegwit,
    Taproot,
}
impl Bip322Wallet {
    pub fn new<C: Signing>(bytes: &Vec<u8>, wallet_type: WalletType, secp: &Secp256k1<C>) -> Self {
        let private_key = PrivateKey::from_slice(bytes.as_slice(), Network::Bitcoin).unwrap();
        let pubkey = private_key.public_key(secp);
        let desc = match wallet_type {
            WalletType::NativeSegwit => Descriptor::new_wpkh(pubkey).unwrap(),
            WalletType::Taproot => Descriptor::new_tr(pubkey, None).unwrap(),
        };

        Self {
            pubkey,
            private_key,
            desc,
        }
    }
}

fn create_to_spend(message: &str, wallet: &Bip322Wallet) -> bdkTxid {
    let tag_hash = hash_sha256(&TAG.as_bytes().to_vec());
    let mut concat_for_result = Vec::new();
    concat_for_result.extend(tag_hash.clone());
    concat_for_result.extend(tag_hash.clone());
    concat_for_result.extend(message.as_bytes().to_vec());
    let result = hash_sha256(&concat_for_result);

    //Create script sig
    let mut script_sig = Vec::new();
    script_sig.extend(hex::decode("0020").unwrap());
    script_sig.extend(result);
    //Tx ins
    let ins = vec![bdkTxIn {
        previous_output: bdkOutPoint {
            txid: UTXO.parse().unwrap(),
            vout: 0xFFFFFFFF,
        },
        script_sig: bdkScript::from_hex(hex::encode(script_sig).as_str()).unwrap(),
        sequence: bdkSequence(0),
        witness: bdkWitness::new(),
    }];

    //Tx outs
    let outs = vec![bdkTxOut {
        value: 0,
        script_pubkey: wallet.desc.script_pubkey(),
    }];

    let tx = bdkTransaction {
        version: 0,
        lock_time: bdkPackedLockTime::from(bdkLockTime::ZERO),
        input: ins,
        output: outs,
    };
    tx.txid()
}

fn create_to_sign_empty(txid: bdkTxid, wallet: &Bip322Wallet) -> bdkPartiallySignedTransaction {
    //Tx ins
    let ins = vec![bdkTxIn {
        previous_output: bdkOutPoint { txid, vout: 0 },
        script_sig: bdkScript::new(),
        sequence: bdkSequence(0),
        witness: bdkWitness::new(),
    }];

    //Tx outs
    let outs = vec![bdkTxOut {
        value: 0,
        script_pubkey: bdkScript::from_str("6a").unwrap(),
    }];

    let tx = bdkTransaction {
        version: 0,
        lock_time: bdkPackedLockTime::from(bdkLockTime::ZERO),
        input: ins,
        output: outs,
    };
    let mut psbt = bdkPartiallySignedTransaction::from_unsigned_tx(tx).unwrap();
    psbt.inputs[0].witness_utxo = Some(bdkTxOut {
        value: 0,
        script_pubkey: wallet.desc.script_pubkey(),
    });
    psbt
}

fn get_base64_signature<C: Signing>(
    to_sign_empty: bdkPartiallySignedTransaction,
    wallet: &Bip322Wallet,
    secp: &Secp256k1<C>,
) -> String {
    let redeem_script = bdkScript::new_v0_p2wpkh(&wallet.pubkey.wpubkey_hash().unwrap());
    let script_code = bdkScript::p2wpkh_script_code(&redeem_script).unwrap();
    let binding = to_sign_empty.unsigned_tx;
    let mut cache = SighashCache::new(&binding);
    let message = cache
        .segwit_signature_hash(0, &script_code, 0, EcdsaSighashType::All)
        .unwrap();
    let message = Message::from_slice(message.as_ref()).unwrap();
    let signature = secp.sign_ecdsa(&message, &wallet.private_key.inner);

    let sig = ecdsa::EcdsaSig {
        sig: signature,
        hash_ty: EcdsaSighashType::All,
    };
    let witness = vec![sig.to_vec(), wallet.pubkey.to_bytes()];

    let result: Vec<u8> = witness_to_vec(witness);
    general_purpose::STANDARD.encode(result)
}

fn get_base64_signature_taproot<C: Signing + Verification>(
    to_sign_empty: &mut bdkPartiallySignedTransaction,
    wallet: &Bip322Wallet,
    secp: &Secp256k1<C>,
) -> String {
    let x_only_pubkey = XOnlyPublicKey::from_slice(&wallet.pubkey.to_bytes()[1..]).unwrap();
    to_sign_empty.inputs[0].tap_internal_key = Some(x_only_pubkey);
    let binding = to_sign_empty.unsigned_tx.clone();
    let cache = SighashCache::new(&binding)
        .taproot_signature_hash(
            0,
            &sighash::Prevouts::All(&[bdkTxOut {
                value: 0,
                script_pubkey: wallet.desc.script_pubkey(),
            }]),
            None,
            None,
            SchnorrSighashType::Default,
        )
        .unwrap();

    sign_psbt_taproot(
        &wallet.private_key.inner,
        None,
        &mut to_sign_empty.inputs[0],
        cache,
        secp,
    )
}
fn witness_to_vec(witness: Vec<Vec<u8>>) -> Vec<u8> {
    let mut ret_val: Vec<u8> = Vec::new();
    ret_val.push(witness.len() as u8);
    for item in witness {
        ret_val.push(item.len() as u8);
        ret_val.extend(item);
    }
    ret_val
}

fn sign_psbt_taproot<C: Signing + Verification>(
    secret_key: &secp256k1::SecretKey,
    leaf_hash: Option<TapLeafHash>,
    psbt_input: &mut bdkInput,
    hash: TapSighashHash,
    secp: &Secp256k1<C>,
) -> String {
    let keypair = secp256k1::KeyPair::from_seckey_slice(secp, secret_key.as_ref()).unwrap();
    let keypair = match leaf_hash {
        None => keypair
            .tap_tweak(secp, psbt_input.tap_merkle_root)
            .to_inner(),
        Some(_) => keypair, // no tweak for script spend
    };
    let sig = secp.sign_schnorr_no_aux_rand(
        &Message::from_slice(hash.to_vec().as_slice()).unwrap(),
        &keypair,
    );
    let witness = vec![sig.as_ref().to_vec()];

    let result: Vec<u8> = witness_to_vec(witness);
    general_purpose::STANDARD.encode(result)
}

pub fn simple_signature_with_segwit(message: &str, bytes: &Vec<u8>) -> String {
    let secp = Secp256k1::new();
    let wallet = Bip322Wallet::new(bytes, WalletType::NativeSegwit, &secp);
    let txid = create_to_spend(message, &wallet);
    let to_sign = create_to_sign_empty(txid, &wallet);
    get_base64_signature(to_sign, &wallet, &secp)
}
pub fn simple_signature_with_taproot(message: &str, bytes: &Vec<u8>) -> String {
    let secp = Secp256k1::new();
    let wallet = Bip322Wallet::new(bytes, WalletType::Taproot, &secp);
    let txid = create_to_spend(message, &wallet);
    let mut to_sign = create_to_sign_empty(txid, &wallet);
    get_base64_signature_taproot(&mut to_sign, &wallet, &secp)
}
