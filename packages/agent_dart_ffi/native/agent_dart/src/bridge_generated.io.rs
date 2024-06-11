use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_mnemonic_phrase_to_seed(port_: i64, req: *mut wire_PhraseToSeedReq) {
    wire_mnemonic_phrase_to_seed_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_mnemonic_seed_to_key(port_: i64, req: *mut wire_SeedToKeyReq) {
    wire_mnemonic_seed_to_key_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_hex_bytes_to_wif(port_: i64, hex: *mut wire_uint_8_list, network: i32) {
    wire_hex_bytes_to_wif_impl(port_, hex, network)
}

#[no_mangle]
pub extern "C" fn wire_bls_init(port_: i64) {
    wire_bls_init_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_bls_verify(port_: i64, req: *mut wire_BLSVerifyReq) {
    wire_bls_verify_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_ed25519_from_seed(port_: i64, req: *mut wire_ED25519FromSeedReq) {
    wire_ed25519_from_seed_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_ed25519_sign(port_: i64, req: *mut wire_ED25519SignReq) {
    wire_ed25519_sign_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_ed25519_verify(port_: i64, req: *mut wire_ED25519VerifyReq) {
    wire_ed25519_verify_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_secp256k1_from_seed(port_: i64, req: *mut wire_Secp256k1FromSeedReq) {
    wire_secp256k1_from_seed_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_secp256k1_sign(port_: i64, req: *mut wire_Secp256k1SignWithSeedReq) {
    wire_secp256k1_sign_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_secp256k1_sign_with_rng(port_: i64, req: *mut wire_Secp256k1SignWithRngReq) {
    wire_secp256k1_sign_with_rng_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_secp256k1_sign_recoverable(
    port_: i64,
    req: *mut wire_Secp256k1SignWithSeedReq,
) {
    wire_secp256k1_sign_recoverable_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_secp256k1_verify(port_: i64, req: *mut wire_Secp256k1VerifyReq) {
    wire_secp256k1_verify_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_secp256k1_get_shared_secret(
    port_: i64,
    req: *mut wire_Secp256k1ShareSecretReq,
) {
    wire_secp256k1_get_shared_secret_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_secp256k1_recover(port_: i64, req: *mut wire_Secp256k1RecoverReq) {
    wire_secp256k1_recover_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_p256_from_seed(port_: i64, req: *mut wire_P256FromSeedReq) {
    wire_p256_from_seed_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_p256_sign(port_: i64, req: *mut wire_P256SignWithSeedReq) {
    wire_p256_sign_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_p256_verify(port_: i64, req: *mut wire_P256VerifyReq) {
    wire_p256_verify_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_p256_get_shared_secret(port_: i64, req: *mut wire_P256ShareSecretReq) {
    wire_p256_get_shared_secret_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_schnorr_from_seed(port_: i64, req: *mut wire_SchnorrFromSeedReq) {
    wire_schnorr_from_seed_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_schnorr_sign(port_: i64, req: *mut wire_SchnorrSignWithSeedReq) {
    wire_schnorr_sign_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_schnorr_verify(port_: i64, req: *mut wire_SchnorrVerifyReq) {
    wire_schnorr_verify_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_aes_128_ctr_encrypt(port_: i64, req: *mut wire_AesEncryptReq) {
    wire_aes_128_ctr_encrypt_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_aes_128_ctr_decrypt(port_: i64, req: *mut wire_AesDecryptReq) {
    wire_aes_128_ctr_decrypt_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_aes_256_cbc_encrypt(port_: i64, req: *mut wire_AesEncryptReq) {
    wire_aes_256_cbc_encrypt_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_aes_256_cbc_decrypt(port_: i64, req: *mut wire_AesDecryptReq) {
    wire_aes_256_cbc_decrypt_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_aes_256_gcm_encrypt(port_: i64, req: *mut wire_AesEncryptReq) {
    wire_aes_256_gcm_encrypt_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_aes_256_gcm_decrypt(port_: i64, req: *mut wire_AesDecryptReq) {
    wire_aes_256_gcm_decrypt_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_pbkdf2_derive_key(port_: i64, req: *mut wire_PBKDFDeriveReq) {
    wire_pbkdf2_derive_key_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_scrypt_derive_key(port_: i64, req: *mut wire_ScriptDeriveReq) {
    wire_scrypt_derive_key_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_create_blockchain__static_method__Api(
    port_: i64,
    config: *mut wire_BlockchainConfig,
) {
    wire_create_blockchain__static_method__Api_impl(port_, config)
}

#[no_mangle]
pub extern "C" fn wire_get_height__static_method__Api(
    port_: i64,
    blockchain: wire_BlockchainInstance,
) {
    wire_get_height__static_method__Api_impl(port_, blockchain)
}

#[no_mangle]
pub extern "C" fn wire_get_blockchain_hash__static_method__Api(
    port_: i64,
    blockchain_height: u32,
    blockchain: wire_BlockchainInstance,
) {
    wire_get_blockchain_hash__static_method__Api_impl(port_, blockchain_height, blockchain)
}

#[no_mangle]
pub extern "C" fn wire_estimate_fee__static_method__Api(
    port_: i64,
    target: u64,
    blockchain: wire_BlockchainInstance,
) {
    wire_estimate_fee__static_method__Api_impl(port_, target, blockchain)
}

#[no_mangle]
pub extern "C" fn wire_broadcast__static_method__Api(
    port_: i64,
    tx: *mut wire_uint_8_list,
    blockchain: wire_BlockchainInstance,
) {
    wire_broadcast__static_method__Api_impl(port_, tx, blockchain)
}

#[no_mangle]
pub extern "C" fn wire_get_tx__static_method__Api(
    port_: i64,
    tx: *mut wire_uint_8_list,
    blockchain: wire_BlockchainInstance,
) {
    wire_get_tx__static_method__Api_impl(port_, tx, blockchain)
}

#[no_mangle]
pub extern "C" fn wire_create_transaction__static_method__Api(
    port_: i64,
    tx: *mut wire_uint_8_list,
) {
    wire_create_transaction__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_tx_txid__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_tx_txid__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_weight__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_weight__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_size__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_size__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_vsize__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_vsize__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_serialize_tx__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_serialize_tx__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_is_coin_base__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_is_coin_base__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_is_explicitly_rbf__static_method__Api(
    port_: i64,
    tx: *mut wire_uint_8_list,
) {
    wire_is_explicitly_rbf__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_is_lock_time_enabled__static_method__Api(
    port_: i64,
    tx: *mut wire_uint_8_list,
) {
    wire_is_lock_time_enabled__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_version__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_version__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_lock_time__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_lock_time__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_input__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_input__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_output__static_method__Api(port_: i64, tx: *mut wire_uint_8_list) {
    wire_output__static_method__Api_impl(port_, tx)
}

#[no_mangle]
pub extern "C" fn wire_serialize_psbt__static_method__Api(
    port_: i64,
    psbt_str: *mut wire_uint_8_list,
) {
    wire_serialize_psbt__static_method__Api_impl(port_, psbt_str)
}

#[no_mangle]
pub extern "C" fn wire_psbt_txid__static_method__Api(port_: i64, psbt_str: *mut wire_uint_8_list) {
    wire_psbt_txid__static_method__Api_impl(port_, psbt_str)
}

#[no_mangle]
pub extern "C" fn wire_extract_tx__static_method__Api(port_: i64, psbt_str: *mut wire_uint_8_list) {
    wire_extract_tx__static_method__Api_impl(port_, psbt_str)
}

#[no_mangle]
pub extern "C" fn wire_psbt_fee_rate__static_method__Api(
    port_: i64,
    psbt_str: *mut wire_uint_8_list,
) {
    wire_psbt_fee_rate__static_method__Api_impl(port_, psbt_str)
}

#[no_mangle]
pub extern "C" fn wire_psbt_fee_amount__static_method__Api(
    port_: i64,
    psbt_str: *mut wire_uint_8_list,
) {
    wire_psbt_fee_amount__static_method__Api_impl(port_, psbt_str)
}

#[no_mangle]
pub extern "C" fn wire_combine_psbt__static_method__Api(
    port_: i64,
    psbt_str: *mut wire_uint_8_list,
    other: *mut wire_uint_8_list,
) {
    wire_combine_psbt__static_method__Api_impl(port_, psbt_str, other)
}

#[no_mangle]
pub extern "C" fn wire_json_serialize__static_method__Api(
    port_: i64,
    psbt_str: *mut wire_uint_8_list,
) {
    wire_json_serialize__static_method__Api_impl(port_, psbt_str)
}

#[no_mangle]
pub extern "C" fn wire_get_inputs__static_method__Api(port_: i64, psbt_str: *mut wire_uint_8_list) {
    wire_get_inputs__static_method__Api_impl(port_, psbt_str)
}

#[no_mangle]
pub extern "C" fn wire_tx_builder_finish__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
    recipients: *mut wire_list_script_amount,
    txs: *mut wire_list_tx_bytes,
    unspendable: *mut wire_list_out_point,
    foreign_utxos: *mut wire_list_foreign_utxo,
    change_policy: i32,
    manually_selected_only: bool,
    fee_rate: *mut f32,
    fee_absolute: *mut u64,
    drain_wallet: bool,
    drain_to: *mut wire_Script,
    rbf: *mut wire_RbfValue,
    data: *mut wire_uint_8_list,
    shuffle_utxo: *mut bool,
) {
    wire_tx_builder_finish__static_method__Api_impl(
        port_,
        wallet,
        recipients,
        txs,
        unspendable,
        foreign_utxos,
        change_policy,
        manually_selected_only,
        fee_rate,
        fee_absolute,
        drain_wallet,
        drain_to,
        rbf,
        data,
        shuffle_utxo,
    )
}

#[no_mangle]
pub extern "C" fn wire_tx_cal_fee_finish__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
    recipients: *mut wire_list_script_amount,
    txs: *mut wire_list_tx_bytes,
    unspendable: *mut wire_list_out_point,
    foreign_utxos: *mut wire_list_foreign_utxo,
    change_policy: i32,
    manually_selected_only: bool,
    fee_rate: *mut f32,
    fee_absolute: *mut u64,
    drain_wallet: bool,
    drain_to: *mut wire_Script,
    rbf: *mut wire_RbfValue,
    data: *mut wire_uint_8_list,
    shuffle_utxo: *mut bool,
) {
    wire_tx_cal_fee_finish__static_method__Api_impl(
        port_,
        wallet,
        recipients,
        txs,
        unspendable,
        foreign_utxos,
        change_policy,
        manually_selected_only,
        fee_rate,
        fee_absolute,
        drain_wallet,
        drain_to,
        rbf,
        data,
        shuffle_utxo,
    )
}

#[no_mangle]
pub extern "C" fn wire_bump_fee_tx_builder_finish__static_method__Api(
    port_: i64,
    txid: *mut wire_uint_8_list,
    fee_rate: f32,
    allow_shrinking: *mut wire_uint_8_list,
    wallet: wire_WalletInstance,
    enable_rbf: bool,
    keep_change: bool,
    n_sequence: *mut u32,
) {
    wire_bump_fee_tx_builder_finish__static_method__Api_impl(
        port_,
        txid,
        fee_rate,
        allow_shrinking,
        wallet,
        enable_rbf,
        keep_change,
        n_sequence,
    )
}

#[no_mangle]
pub extern "C" fn wire_create_descriptor__static_method__Api(
    port_: i64,
    descriptor: *mut wire_uint_8_list,
    network: i32,
) {
    wire_create_descriptor__static_method__Api_impl(port_, descriptor, network)
}

#[no_mangle]
pub extern "C" fn wire_import_single_wif__static_method__Api(
    port_: i64,
    wif: *mut wire_uint_8_list,
    address_type: *mut wire_uint_8_list,
    network: i32,
) {
    wire_import_single_wif__static_method__Api_impl(port_, wif, address_type, network)
}

#[no_mangle]
pub extern "C" fn wire_new_bip44_descriptor__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    secret_key: *mut wire_uint_8_list,
    network: i32,
) {
    wire_new_bip44_descriptor__static_method__Api_impl(port_, key_chain_kind, secret_key, network)
}

#[no_mangle]
pub extern "C" fn wire_new_bip44_public__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    public_key: *mut wire_uint_8_list,
    network: i32,
    fingerprint: *mut wire_uint_8_list,
) {
    wire_new_bip44_public__static_method__Api_impl(
        port_,
        key_chain_kind,
        public_key,
        network,
        fingerprint,
    )
}

#[no_mangle]
pub extern "C" fn wire_new_bip44_tr_descriptor__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    secret_key: *mut wire_uint_8_list,
    network: i32,
) {
    wire_new_bip44_tr_descriptor__static_method__Api_impl(
        port_,
        key_chain_kind,
        secret_key,
        network,
    )
}

#[no_mangle]
pub extern "C" fn wire_new_bip44_tr_public__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    public_key: *mut wire_uint_8_list,
    network: i32,
    fingerprint: *mut wire_uint_8_list,
) {
    wire_new_bip44_tr_public__static_method__Api_impl(
        port_,
        key_chain_kind,
        public_key,
        network,
        fingerprint,
    )
}

#[no_mangle]
pub extern "C" fn wire_new_bip49_descriptor__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    secret_key: *mut wire_uint_8_list,
    network: i32,
) {
    wire_new_bip49_descriptor__static_method__Api_impl(port_, key_chain_kind, secret_key, network)
}

#[no_mangle]
pub extern "C" fn wire_new_bip49_public__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    public_key: *mut wire_uint_8_list,
    network: i32,
    fingerprint: *mut wire_uint_8_list,
) {
    wire_new_bip49_public__static_method__Api_impl(
        port_,
        key_chain_kind,
        public_key,
        network,
        fingerprint,
    )
}

#[no_mangle]
pub extern "C" fn wire_new_bip84_descriptor__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    secret_key: *mut wire_uint_8_list,
    network: i32,
) {
    wire_new_bip84_descriptor__static_method__Api_impl(port_, key_chain_kind, secret_key, network)
}

#[no_mangle]
pub extern "C" fn wire_new_bip84_public__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    public_key: *mut wire_uint_8_list,
    network: i32,
    fingerprint: *mut wire_uint_8_list,
) {
    wire_new_bip84_public__static_method__Api_impl(
        port_,
        key_chain_kind,
        public_key,
        network,
        fingerprint,
    )
}

#[no_mangle]
pub extern "C" fn wire_new_bip86_descriptor__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    secret_key: *mut wire_uint_8_list,
    network: i32,
) {
    wire_new_bip86_descriptor__static_method__Api_impl(port_, key_chain_kind, secret_key, network)
}

#[no_mangle]
pub extern "C" fn wire_new_bip86_public__static_method__Api(
    port_: i64,
    key_chain_kind: i32,
    public_key: *mut wire_uint_8_list,
    network: i32,
    fingerprint: *mut wire_uint_8_list,
) {
    wire_new_bip86_public__static_method__Api_impl(
        port_,
        key_chain_kind,
        public_key,
        network,
        fingerprint,
    )
}

#[no_mangle]
pub extern "C" fn wire_as_string_private__static_method__Api(
    port_: i64,
    descriptor: wire_BdkDescriptor,
) {
    wire_as_string_private__static_method__Api_impl(port_, descriptor)
}

#[no_mangle]
pub extern "C" fn wire_as_string__static_method__Api(port_: i64, descriptor: wire_BdkDescriptor) {
    wire_as_string__static_method__Api_impl(port_, descriptor)
}

#[no_mangle]
pub extern "C" fn wire_derive_address_at__static_method__Api(
    port_: i64,
    descriptor: wire_BdkDescriptor,
    index: u32,
    network: i32,
) {
    wire_derive_address_at__static_method__Api_impl(port_, descriptor, index, network)
}

#[no_mangle]
pub extern "C" fn wire_create_descriptor_secret__static_method__Api(
    port_: i64,
    network: i32,
    mnemonic: *mut wire_uint_8_list,
    password: *mut wire_uint_8_list,
) {
    wire_create_descriptor_secret__static_method__Api_impl(port_, network, mnemonic, password)
}

#[no_mangle]
pub extern "C" fn wire_create_derived_descriptor_secret__static_method__Api(
    port_: i64,
    network: i32,
    mnemonic: *mut wire_uint_8_list,
    path: *mut wire_uint_8_list,
    password: *mut wire_uint_8_list,
) {
    wire_create_derived_descriptor_secret__static_method__Api_impl(
        port_, network, mnemonic, path, password,
    )
}

#[no_mangle]
pub extern "C" fn wire_descriptor_secret_from_string__static_method__Api(
    port_: i64,
    secret: *mut wire_uint_8_list,
) {
    wire_descriptor_secret_from_string__static_method__Api_impl(port_, secret)
}

#[no_mangle]
pub extern "C" fn wire_extend_descriptor_secret__static_method__Api(
    port_: i64,
    secret: *mut wire_uint_8_list,
    path: *mut wire_uint_8_list,
) {
    wire_extend_descriptor_secret__static_method__Api_impl(port_, secret, path)
}

#[no_mangle]
pub extern "C" fn wire_derive_descriptor_secret__static_method__Api(
    port_: i64,
    secret: *mut wire_uint_8_list,
    path: *mut wire_uint_8_list,
) {
    wire_derive_descriptor_secret__static_method__Api_impl(port_, secret, path)
}

#[no_mangle]
pub extern "C" fn wire_as_secret_bytes__static_method__Api(
    port_: i64,
    secret: *mut wire_uint_8_list,
) {
    wire_as_secret_bytes__static_method__Api_impl(port_, secret)
}

#[no_mangle]
pub extern "C" fn wire_as_public__static_method__Api(port_: i64, secret: *mut wire_uint_8_list) {
    wire_as_public__static_method__Api_impl(port_, secret)
}

#[no_mangle]
pub extern "C" fn wire_get_pub_from_secret_bytes__static_method__Api(
    port_: i64,
    bytes: *mut wire_uint_8_list,
) {
    wire_get_pub_from_secret_bytes__static_method__Api_impl(port_, bytes)
}

#[no_mangle]
pub extern "C" fn wire_create_derivation_path__static_method__Api(
    port_: i64,
    path: *mut wire_uint_8_list,
) {
    wire_create_derivation_path__static_method__Api_impl(port_, path)
}

#[no_mangle]
pub extern "C" fn wire_descriptor_public_from_string__static_method__Api(
    port_: i64,
    public_key: *mut wire_uint_8_list,
) {
    wire_descriptor_public_from_string__static_method__Api_impl(port_, public_key)
}

#[no_mangle]
pub extern "C" fn wire_master_finterprint__static_method__Api(
    port_: i64,
    xpub: *mut wire_uint_8_list,
) {
    wire_master_finterprint__static_method__Api_impl(port_, xpub)
}

#[no_mangle]
pub extern "C" fn wire_create_descriptor_public__static_method__Api(
    port_: i64,
    xpub: *mut wire_uint_8_list,
    path: *mut wire_uint_8_list,
    derive: bool,
) {
    wire_create_descriptor_public__static_method__Api_impl(port_, xpub, path, derive)
}

#[no_mangle]
pub extern "C" fn wire_to_public_string__static_method__Api(
    port_: i64,
    xpub: *mut wire_uint_8_list,
) {
    wire_to_public_string__static_method__Api_impl(port_, xpub)
}

#[no_mangle]
pub extern "C" fn wire_create_script__static_method__Api(
    port_: i64,
    raw_output_script: *mut wire_uint_8_list,
) {
    wire_create_script__static_method__Api_impl(port_, raw_output_script)
}

#[no_mangle]
pub extern "C" fn wire_create_address__static_method__Api(
    port_: i64,
    address: *mut wire_uint_8_list,
) {
    wire_create_address__static_method__Api_impl(port_, address)
}

#[no_mangle]
pub extern "C" fn wire_address_from_script__static_method__Api(
    port_: i64,
    script: *mut wire_Script,
    network: i32,
) {
    wire_address_from_script__static_method__Api_impl(port_, script, network)
}

#[no_mangle]
pub extern "C" fn wire_address_to_script_pubkey__static_method__Api(
    port_: i64,
    address: *mut wire_uint_8_list,
) {
    wire_address_to_script_pubkey__static_method__Api_impl(port_, address)
}

#[no_mangle]
pub extern "C" fn wire_payload__static_method__Api(port_: i64, address: *mut wire_uint_8_list) {
    wire_payload__static_method__Api_impl(port_, address)
}

#[no_mangle]
pub extern "C" fn wire_address_network__static_method__Api(
    port_: i64,
    address: *mut wire_uint_8_list,
) {
    wire_address_network__static_method__Api_impl(port_, address)
}

#[no_mangle]
pub extern "C" fn wire_get_address_type__static_method__Api(
    port_: i64,
    address: *mut wire_uint_8_list,
) {
    wire_get_address_type__static_method__Api_impl(port_, address)
}

#[no_mangle]
pub extern "C" fn wire_create_wallet__static_method__Api(
    port_: i64,
    descriptor: wire_BdkDescriptor,
    change_descriptor: *mut wire_BdkDescriptor,
    network: i32,
    database_config: *mut wire_DatabaseConfig,
) {
    wire_create_wallet__static_method__Api_impl(
        port_,
        descriptor,
        change_descriptor,
        network,
        database_config,
    )
}

#[no_mangle]
pub extern "C" fn wire_get_address__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
    address_index: *mut wire_AddressIndex,
) {
    wire_get_address__static_method__Api_impl(port_, wallet, address_index)
}

#[no_mangle]
pub extern "C" fn wire_get_internal_address__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
    address_index: *mut wire_AddressIndex,
) {
    wire_get_internal_address__static_method__Api_impl(port_, wallet, address_index)
}

#[no_mangle]
pub extern "C" fn wire_sync_wallet__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
    blockchain: wire_BlockchainInstance,
) {
    wire_sync_wallet__static_method__Api_impl(port_, wallet, blockchain)
}

#[no_mangle]
pub extern "C" fn wire_sync_wallet_thread__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
    blockchain: wire_BlockchainInstance,
) {
    wire_sync_wallet_thread__static_method__Api_impl(port_, wallet, blockchain)
}

#[no_mangle]
pub extern "C" fn wire_get_balance__static_method__Api(port_: i64, wallet: wire_WalletInstance) {
    wire_get_balance__static_method__Api_impl(port_, wallet)
}

#[no_mangle]
pub extern "C" fn wire_list_unspent_outputs__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
) {
    wire_list_unspent_outputs__static_method__Api_impl(port_, wallet)
}

#[no_mangle]
pub extern "C" fn wire_get_transactions__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
    include_raw: bool,
) {
    wire_get_transactions__static_method__Api_impl(port_, wallet, include_raw)
}

#[no_mangle]
pub extern "C" fn wire_sign__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
    psbt_str: *mut wire_uint_8_list,
    sign_options: *mut wire_SignOptions,
) {
    wire_sign__static_method__Api_impl(port_, wallet, psbt_str, sign_options)
}

#[no_mangle]
pub extern "C" fn wire_wallet_network__static_method__Api(port_: i64, wallet: wire_WalletInstance) {
    wire_wallet_network__static_method__Api_impl(port_, wallet)
}

#[no_mangle]
pub extern "C" fn wire_list_unspent__static_method__Api(port_: i64, wallet: wire_WalletInstance) {
    wire_list_unspent__static_method__Api_impl(port_, wallet)
}

#[no_mangle]
pub extern "C" fn wire_cache_address__static_method__Api(
    port_: i64,
    wallet: wire_WalletInstance,
    cache_size: u32,
) {
    wire_cache_address__static_method__Api_impl(port_, wallet, cache_size)
}

#[no_mangle]
pub extern "C" fn wire_generate_seed_from_word_count__static_method__Api(
    port_: i64,
    word_count: i32,
) {
    wire_generate_seed_from_word_count__static_method__Api_impl(port_, word_count)
}

#[no_mangle]
pub extern "C" fn wire_generate_seed_from_string__static_method__Api(
    port_: i64,
    mnemonic: *mut wire_uint_8_list,
) {
    wire_generate_seed_from_string__static_method__Api_impl(port_, mnemonic)
}

#[no_mangle]
pub extern "C" fn wire_generate_seed_from_entropy__static_method__Api(
    port_: i64,
    entropy: *mut wire_uint_8_list,
) {
    wire_generate_seed_from_entropy__static_method__Api_impl(port_, entropy)
}

#[no_mangle]
pub extern "C" fn wire_bip322_sign_segwit__static_method__Api(
    port_: i64,
    secret: *mut wire_uint_8_list,
    message: *mut wire_uint_8_list,
) {
    wire_bip322_sign_segwit__static_method__Api_impl(port_, secret, message)
}

#[no_mangle]
pub extern "C" fn wire_bip322_sign_taproot__static_method__Api(
    port_: i64,
    secret: *mut wire_uint_8_list,
    message: *mut wire_uint_8_list,
) {
    wire_bip322_sign_taproot__static_method__Api_impl(port_, secret, message)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_BdkDescriptor() -> wire_BdkDescriptor {
    wire_BdkDescriptor::new_with_null_ptr()
}

#[no_mangle]
pub extern "C" fn new_BlockchainInstance() -> wire_BlockchainInstance {
    wire_BlockchainInstance::new_with_null_ptr()
}

#[no_mangle]
pub extern "C" fn new_WalletInstance() -> wire_WalletInstance {
    wire_WalletInstance::new_with_null_ptr()
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_BdkDescriptor_0() -> *mut wire_BdkDescriptor {
    support::new_leak_box_ptr(wire_BdkDescriptor::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_address_index_0() -> *mut wire_AddressIndex {
    support::new_leak_box_ptr(wire_AddressIndex::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_aes_decrypt_req_0() -> *mut wire_AesDecryptReq {
    support::new_leak_box_ptr(wire_AesDecryptReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_aes_encrypt_req_0() -> *mut wire_AesEncryptReq {
    support::new_leak_box_ptr(wire_AesEncryptReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_blockchain_config_0() -> *mut wire_BlockchainConfig {
    support::new_leak_box_ptr(wire_BlockchainConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_bls_verify_req_0() -> *mut wire_BLSVerifyReq {
    support::new_leak_box_ptr(wire_BLSVerifyReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_bool_0(value: bool) -> *mut bool {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_database_config_0() -> *mut wire_DatabaseConfig {
    support::new_leak_box_ptr(wire_DatabaseConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_ed_25519_from_seed_req_0() -> *mut wire_ED25519FromSeedReq {
    support::new_leak_box_ptr(wire_ED25519FromSeedReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_ed_25519_sign_req_0() -> *mut wire_ED25519SignReq {
    support::new_leak_box_ptr(wire_ED25519SignReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_ed_25519_verify_req_0() -> *mut wire_ED25519VerifyReq {
    support::new_leak_box_ptr(wire_ED25519VerifyReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_electrum_config_0() -> *mut wire_ElectrumConfig {
    support::new_leak_box_ptr(wire_ElectrumConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_esplora_config_0() -> *mut wire_EsploraConfig {
    support::new_leak_box_ptr(wire_EsploraConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_f32_0(value: f32) -> *mut f32 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_p_256_from_seed_req_0() -> *mut wire_P256FromSeedReq {
    support::new_leak_box_ptr(wire_P256FromSeedReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_p_256_share_secret_req_0() -> *mut wire_P256ShareSecretReq {
    support::new_leak_box_ptr(wire_P256ShareSecretReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_p_256_sign_with_seed_req_0() -> *mut wire_P256SignWithSeedReq {
    support::new_leak_box_ptr(wire_P256SignWithSeedReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_p_256_verify_req_0() -> *mut wire_P256VerifyReq {
    support::new_leak_box_ptr(wire_P256VerifyReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_pbkdf_derive_req_0() -> *mut wire_PBKDFDeriveReq {
    support::new_leak_box_ptr(wire_PBKDFDeriveReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_phrase_to_seed_req_0() -> *mut wire_PhraseToSeedReq {
    support::new_leak_box_ptr(wire_PhraseToSeedReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_rbf_value_0() -> *mut wire_RbfValue {
    support::new_leak_box_ptr(wire_RbfValue::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_rpc_config_0() -> *mut wire_RpcConfig {
    support::new_leak_box_ptr(wire_RpcConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_rpc_sync_params_0() -> *mut wire_RpcSyncParams {
    support::new_leak_box_ptr(wire_RpcSyncParams::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_schnorr_from_seed_req_0() -> *mut wire_SchnorrFromSeedReq {
    support::new_leak_box_ptr(wire_SchnorrFromSeedReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_schnorr_sign_with_seed_req_0() -> *mut wire_SchnorrSignWithSeedReq
{
    support::new_leak_box_ptr(wire_SchnorrSignWithSeedReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_schnorr_verify_req_0() -> *mut wire_SchnorrVerifyReq {
    support::new_leak_box_ptr(wire_SchnorrVerifyReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_script_0() -> *mut wire_Script {
    support::new_leak_box_ptr(wire_Script::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_script_derive_req_0() -> *mut wire_ScriptDeriveReq {
    support::new_leak_box_ptr(wire_ScriptDeriveReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_secp_256_k_1_from_seed_req_0() -> *mut wire_Secp256k1FromSeedReq {
    support::new_leak_box_ptr(wire_Secp256k1FromSeedReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_secp_256_k_1_recover_req_0() -> *mut wire_Secp256k1RecoverReq {
    support::new_leak_box_ptr(wire_Secp256k1RecoverReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_secp_256_k_1_share_secret_req_0(
) -> *mut wire_Secp256k1ShareSecretReq {
    support::new_leak_box_ptr(wire_Secp256k1ShareSecretReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_secp_256_k_1_sign_with_rng_req_0(
) -> *mut wire_Secp256k1SignWithRngReq {
    support::new_leak_box_ptr(wire_Secp256k1SignWithRngReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_secp_256_k_1_sign_with_seed_req_0(
) -> *mut wire_Secp256k1SignWithSeedReq {
    support::new_leak_box_ptr(wire_Secp256k1SignWithSeedReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_secp_256_k_1_verify_req_0() -> *mut wire_Secp256k1VerifyReq {
    support::new_leak_box_ptr(wire_Secp256k1VerifyReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_seed_to_key_req_0() -> *mut wire_SeedToKeyReq {
    support::new_leak_box_ptr(wire_SeedToKeyReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_sign_options_0() -> *mut wire_SignOptions {
    support::new_leak_box_ptr(wire_SignOptions::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_sled_db_configuration_0() -> *mut wire_SledDbConfiguration {
    support::new_leak_box_ptr(wire_SledDbConfiguration::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_sqlite_db_configuration_0() -> *mut wire_SqliteDbConfiguration {
    support::new_leak_box_ptr(wire_SqliteDbConfiguration::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_u32_0(value: u32) -> *mut u32 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_u64_0(value: u64) -> *mut u64 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_u8_0(value: u8) -> *mut u8 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_user_pass_0() -> *mut wire_UserPass {
    support::new_leak_box_ptr(wire_UserPass::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_list_foreign_utxo_0(len: i32) -> *mut wire_list_foreign_utxo {
    let wrap = wire_list_foreign_utxo {
        ptr: support::new_leak_vec_ptr(<wire_ForeignUtxo>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_list_out_point_0(len: i32) -> *mut wire_list_out_point {
    let wrap = wire_list_out_point {
        ptr: support::new_leak_vec_ptr(<wire_OutPoint>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_list_script_amount_0(len: i32) -> *mut wire_list_script_amount {
    let wrap = wire_list_script_amount {
        ptr: support::new_leak_vec_ptr(<wire_ScriptAmount>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_list_tx_bytes_0(len: i32) -> *mut wire_list_tx_bytes {
    let wrap = wire_list_tx_bytes {
        ptr: support::new_leak_vec_ptr(<wire_TxBytes>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

#[no_mangle]
pub extern "C" fn drop_opaque_BdkDescriptor(ptr: *const c_void) {
    unsafe {
        Arc::<BdkDescriptor>::decrement_strong_count(ptr as _);
    }
}

#[no_mangle]
pub extern "C" fn share_opaque_BdkDescriptor(ptr: *const c_void) -> *const c_void {
    unsafe {
        Arc::<BdkDescriptor>::increment_strong_count(ptr as _);
        ptr
    }
}

#[no_mangle]
pub extern "C" fn drop_opaque_BlockchainInstance(ptr: *const c_void) {
    unsafe {
        Arc::<BlockchainInstance>::decrement_strong_count(ptr as _);
    }
}

#[no_mangle]
pub extern "C" fn share_opaque_BlockchainInstance(ptr: *const c_void) -> *const c_void {
    unsafe {
        Arc::<BlockchainInstance>::increment_strong_count(ptr as _);
        ptr
    }
}

#[no_mangle]
pub extern "C" fn drop_opaque_WalletInstance(ptr: *const c_void) {
    unsafe {
        Arc::<WalletInstance>::decrement_strong_count(ptr as _);
    }
}

#[no_mangle]
pub extern "C" fn share_opaque_WalletInstance(ptr: *const c_void) -> *const c_void {
    unsafe {
        Arc::<WalletInstance>::increment_strong_count(ptr as _);
        ptr
    }
}

// Section: impl Wire2Api

impl Wire2Api<RustOpaque<BdkDescriptor>> for wire_BdkDescriptor {
    fn wire2api(self) -> RustOpaque<BdkDescriptor> {
        unsafe { support::opaque_from_dart(self.ptr as _) }
    }
}
impl Wire2Api<RustOpaque<BlockchainInstance>> for wire_BlockchainInstance {
    fn wire2api(self) -> RustOpaque<BlockchainInstance> {
        unsafe { support::opaque_from_dart(self.ptr as _) }
    }
}
impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<RustOpaque<WalletInstance>> for wire_WalletInstance {
    fn wire2api(self) -> RustOpaque<WalletInstance> {
        unsafe { support::opaque_from_dart(self.ptr as _) }
    }
}
impl Wire2Api<AddressIndex> for wire_AddressIndex {
    fn wire2api(self) -> AddressIndex {
        match self.tag {
            0 => AddressIndex::NewIndex,
            1 => AddressIndex::LastUnused,
            2 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Peek);
                AddressIndex::Peek {
                    index: ans.index.wire2api(),
                }
            },
            3 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Reset);
                AddressIndex::Reset {
                    index: ans.index.wire2api(),
                }
            },
            _ => unreachable!(),
        }
    }
}
impl Wire2Api<AesDecryptReq> for wire_AesDecryptReq {
    fn wire2api(self) -> AesDecryptReq {
        AesDecryptReq {
            key: self.key.wire2api(),
            iv: self.iv.wire2api(),
            cipher_text: self.cipher_text.wire2api(),
        }
    }
}
impl Wire2Api<AesEncryptReq> for wire_AesEncryptReq {
    fn wire2api(self) -> AesEncryptReq {
        AesEncryptReq {
            key: self.key.wire2api(),
            iv: self.iv.wire2api(),
            message: self.message.wire2api(),
        }
    }
}
impl Wire2Api<BlockchainConfig> for wire_BlockchainConfig {
    fn wire2api(self) -> BlockchainConfig {
        match self.tag {
            0 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Electrum);
                BlockchainConfig::Electrum {
                    config: ans.config.wire2api(),
                }
            },
            1 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Esplora);
                BlockchainConfig::Esplora {
                    config: ans.config.wire2api(),
                }
            },
            2 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Rpc);
                BlockchainConfig::Rpc {
                    config: ans.config.wire2api(),
                }
            },
            _ => unreachable!(),
        }
    }
}
impl Wire2Api<BLSVerifyReq> for wire_BLSVerifyReq {
    fn wire2api(self) -> BLSVerifyReq {
        BLSVerifyReq {
            signature: self.signature.wire2api(),
            message: self.message.wire2api(),
            public_key: self.public_key.wire2api(),
        }
    }
}

impl Wire2Api<RustOpaque<BdkDescriptor>> for *mut wire_BdkDescriptor {
    fn wire2api(self) -> RustOpaque<BdkDescriptor> {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<RustOpaque<BdkDescriptor>>::wire2api(*wrap).into()
    }
}
impl Wire2Api<AddressIndex> for *mut wire_AddressIndex {
    fn wire2api(self) -> AddressIndex {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<AddressIndex>::wire2api(*wrap).into()
    }
}
impl Wire2Api<AesDecryptReq> for *mut wire_AesDecryptReq {
    fn wire2api(self) -> AesDecryptReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<AesDecryptReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<AesEncryptReq> for *mut wire_AesEncryptReq {
    fn wire2api(self) -> AesEncryptReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<AesEncryptReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<BlockchainConfig> for *mut wire_BlockchainConfig {
    fn wire2api(self) -> BlockchainConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<BlockchainConfig>::wire2api(*wrap).into()
    }
}
impl Wire2Api<BLSVerifyReq> for *mut wire_BLSVerifyReq {
    fn wire2api(self) -> BLSVerifyReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<BLSVerifyReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<bool> for *mut bool {
    fn wire2api(self) -> bool {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<DatabaseConfig> for *mut wire_DatabaseConfig {
    fn wire2api(self) -> DatabaseConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<DatabaseConfig>::wire2api(*wrap).into()
    }
}
impl Wire2Api<ED25519FromSeedReq> for *mut wire_ED25519FromSeedReq {
    fn wire2api(self) -> ED25519FromSeedReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ED25519FromSeedReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<ED25519SignReq> for *mut wire_ED25519SignReq {
    fn wire2api(self) -> ED25519SignReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ED25519SignReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<ED25519VerifyReq> for *mut wire_ED25519VerifyReq {
    fn wire2api(self) -> ED25519VerifyReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ED25519VerifyReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<ElectrumConfig> for *mut wire_ElectrumConfig {
    fn wire2api(self) -> ElectrumConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ElectrumConfig>::wire2api(*wrap).into()
    }
}
impl Wire2Api<EsploraConfig> for *mut wire_EsploraConfig {
    fn wire2api(self) -> EsploraConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<EsploraConfig>::wire2api(*wrap).into()
    }
}
impl Wire2Api<f32> for *mut f32 {
    fn wire2api(self) -> f32 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<P256FromSeedReq> for *mut wire_P256FromSeedReq {
    fn wire2api(self) -> P256FromSeedReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<P256FromSeedReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<P256ShareSecretReq> for *mut wire_P256ShareSecretReq {
    fn wire2api(self) -> P256ShareSecretReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<P256ShareSecretReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<P256SignWithSeedReq> for *mut wire_P256SignWithSeedReq {
    fn wire2api(self) -> P256SignWithSeedReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<P256SignWithSeedReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<P256VerifyReq> for *mut wire_P256VerifyReq {
    fn wire2api(self) -> P256VerifyReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<P256VerifyReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<PBKDFDeriveReq> for *mut wire_PBKDFDeriveReq {
    fn wire2api(self) -> PBKDFDeriveReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<PBKDFDeriveReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<PhraseToSeedReq> for *mut wire_PhraseToSeedReq {
    fn wire2api(self) -> PhraseToSeedReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<PhraseToSeedReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<RbfValue> for *mut wire_RbfValue {
    fn wire2api(self) -> RbfValue {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<RbfValue>::wire2api(*wrap).into()
    }
}
impl Wire2Api<RpcConfig> for *mut wire_RpcConfig {
    fn wire2api(self) -> RpcConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<RpcConfig>::wire2api(*wrap).into()
    }
}
impl Wire2Api<RpcSyncParams> for *mut wire_RpcSyncParams {
    fn wire2api(self) -> RpcSyncParams {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<RpcSyncParams>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SchnorrFromSeedReq> for *mut wire_SchnorrFromSeedReq {
    fn wire2api(self) -> SchnorrFromSeedReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SchnorrFromSeedReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SchnorrSignWithSeedReq> for *mut wire_SchnorrSignWithSeedReq {
    fn wire2api(self) -> SchnorrSignWithSeedReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SchnorrSignWithSeedReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SchnorrVerifyReq> for *mut wire_SchnorrVerifyReq {
    fn wire2api(self) -> SchnorrVerifyReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SchnorrVerifyReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Script> for *mut wire_Script {
    fn wire2api(self) -> Script {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Script>::wire2api(*wrap).into()
    }
}
impl Wire2Api<ScriptDeriveReq> for *mut wire_ScriptDeriveReq {
    fn wire2api(self) -> ScriptDeriveReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ScriptDeriveReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Secp256k1FromSeedReq> for *mut wire_Secp256k1FromSeedReq {
    fn wire2api(self) -> Secp256k1FromSeedReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Secp256k1FromSeedReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Secp256k1RecoverReq> for *mut wire_Secp256k1RecoverReq {
    fn wire2api(self) -> Secp256k1RecoverReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Secp256k1RecoverReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Secp256k1ShareSecretReq> for *mut wire_Secp256k1ShareSecretReq {
    fn wire2api(self) -> Secp256k1ShareSecretReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Secp256k1ShareSecretReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Secp256k1SignWithRngReq> for *mut wire_Secp256k1SignWithRngReq {
    fn wire2api(self) -> Secp256k1SignWithRngReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Secp256k1SignWithRngReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Secp256k1SignWithSeedReq> for *mut wire_Secp256k1SignWithSeedReq {
    fn wire2api(self) -> Secp256k1SignWithSeedReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Secp256k1SignWithSeedReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Secp256k1VerifyReq> for *mut wire_Secp256k1VerifyReq {
    fn wire2api(self) -> Secp256k1VerifyReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Secp256k1VerifyReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SeedToKeyReq> for *mut wire_SeedToKeyReq {
    fn wire2api(self) -> SeedToKeyReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SeedToKeyReq>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SignOptions> for *mut wire_SignOptions {
    fn wire2api(self) -> SignOptions {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SignOptions>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SledDbConfiguration> for *mut wire_SledDbConfiguration {
    fn wire2api(self) -> SledDbConfiguration {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SledDbConfiguration>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SqliteDbConfiguration> for *mut wire_SqliteDbConfiguration {
    fn wire2api(self) -> SqliteDbConfiguration {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SqliteDbConfiguration>::wire2api(*wrap).into()
    }
}
impl Wire2Api<u32> for *mut u32 {
    fn wire2api(self) -> u32 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<u64> for *mut u64 {
    fn wire2api(self) -> u64 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<u8> for *mut u8 {
    fn wire2api(self) -> u8 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<UserPass> for *mut wire_UserPass {
    fn wire2api(self) -> UserPass {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<UserPass>::wire2api(*wrap).into()
    }
}

impl Wire2Api<DatabaseConfig> for wire_DatabaseConfig {
    fn wire2api(self) -> DatabaseConfig {
        match self.tag {
            0 => DatabaseConfig::Memory,
            1 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Sqlite);
                DatabaseConfig::Sqlite {
                    config: ans.config.wire2api(),
                }
            },
            2 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Sled);
                DatabaseConfig::Sled {
                    config: ans.config.wire2api(),
                }
            },
            _ => unreachable!(),
        }
    }
}
impl Wire2Api<ED25519FromSeedReq> for wire_ED25519FromSeedReq {
    fn wire2api(self) -> ED25519FromSeedReq {
        ED25519FromSeedReq {
            seed: self.seed.wire2api(),
        }
    }
}
impl Wire2Api<ED25519SignReq> for wire_ED25519SignReq {
    fn wire2api(self) -> ED25519SignReq {
        ED25519SignReq {
            seed: self.seed.wire2api(),
            message: self.message.wire2api(),
        }
    }
}
impl Wire2Api<ED25519VerifyReq> for wire_ED25519VerifyReq {
    fn wire2api(self) -> ED25519VerifyReq {
        ED25519VerifyReq {
            sig: self.sig.wire2api(),
            message: self.message.wire2api(),
            pub_key: self.pub_key.wire2api(),
        }
    }
}
impl Wire2Api<ElectrumConfig> for wire_ElectrumConfig {
    fn wire2api(self) -> ElectrumConfig {
        ElectrumConfig {
            url: self.url.wire2api(),
            socks5: self.socks5.wire2api(),
            retry: self.retry.wire2api(),
            timeout: self.timeout.wire2api(),
            stop_gap: self.stop_gap.wire2api(),
            validate_domain: self.validate_domain.wire2api(),
        }
    }
}
impl Wire2Api<EsploraConfig> for wire_EsploraConfig {
    fn wire2api(self) -> EsploraConfig {
        EsploraConfig {
            base_url: self.base_url.wire2api(),
            proxy: self.proxy.wire2api(),
            concurrency: self.concurrency.wire2api(),
            stop_gap: self.stop_gap.wire2api(),
            timeout: self.timeout.wire2api(),
        }
    }
}

impl Wire2Api<ForeignUtxo> for wire_ForeignUtxo {
    fn wire2api(self) -> ForeignUtxo {
        ForeignUtxo {
            outpoint: self.outpoint.wire2api(),
            txout: self.txout.wire2api(),
        }
    }
}

impl Wire2Api<Vec<ForeignUtxo>> for *mut wire_list_foreign_utxo {
    fn wire2api(self) -> Vec<ForeignUtxo> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}
impl Wire2Api<Vec<OutPoint>> for *mut wire_list_out_point {
    fn wire2api(self) -> Vec<OutPoint> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}
impl Wire2Api<Vec<ScriptAmount>> for *mut wire_list_script_amount {
    fn wire2api(self) -> Vec<ScriptAmount> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}
impl Wire2Api<Vec<TxBytes>> for *mut wire_list_tx_bytes {
    fn wire2api(self) -> Vec<TxBytes> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}

impl Wire2Api<OutPoint> for wire_OutPoint {
    fn wire2api(self) -> OutPoint {
        OutPoint {
            txid: self.txid.wire2api(),
            vout: self.vout.wire2api(),
        }
    }
}
impl Wire2Api<P256FromSeedReq> for wire_P256FromSeedReq {
    fn wire2api(self) -> P256FromSeedReq {
        P256FromSeedReq {
            seed: self.seed.wire2api(),
        }
    }
}
impl Wire2Api<P256ShareSecretReq> for wire_P256ShareSecretReq {
    fn wire2api(self) -> P256ShareSecretReq {
        P256ShareSecretReq {
            seed: self.seed.wire2api(),
            public_key_raw_bytes: self.public_key_raw_bytes.wire2api(),
        }
    }
}
impl Wire2Api<P256SignWithSeedReq> for wire_P256SignWithSeedReq {
    fn wire2api(self) -> P256SignWithSeedReq {
        P256SignWithSeedReq {
            msg: self.msg.wire2api(),
            seed: self.seed.wire2api(),
        }
    }
}
impl Wire2Api<P256VerifyReq> for wire_P256VerifyReq {
    fn wire2api(self) -> P256VerifyReq {
        P256VerifyReq {
            message_hash: self.message_hash.wire2api(),
            signature_bytes: self.signature_bytes.wire2api(),
            public_key_bytes: self.public_key_bytes.wire2api(),
        }
    }
}
impl Wire2Api<PBKDFDeriveReq> for wire_PBKDFDeriveReq {
    fn wire2api(self) -> PBKDFDeriveReq {
        PBKDFDeriveReq {
            password: self.password.wire2api(),
            salt: self.salt.wire2api(),
            c: self.c.wire2api(),
        }
    }
}
impl Wire2Api<PhraseToSeedReq> for wire_PhraseToSeedReq {
    fn wire2api(self) -> PhraseToSeedReq {
        PhraseToSeedReq {
            phrase: self.phrase.wire2api(),
            password: self.password.wire2api(),
        }
    }
}
impl Wire2Api<RbfValue> for wire_RbfValue {
    fn wire2api(self) -> RbfValue {
        match self.tag {
            0 => RbfValue::RbfDefault,
            1 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Value);
                RbfValue::Value(ans.field0.wire2api())
            },
            _ => unreachable!(),
        }
    }
}
impl Wire2Api<RpcConfig> for wire_RpcConfig {
    fn wire2api(self) -> RpcConfig {
        RpcConfig {
            url: self.url.wire2api(),
            auth_cookie: self.auth_cookie.wire2api(),
            auth_user_pass: self.auth_user_pass.wire2api(),
            network: self.network.wire2api(),
            wallet_name: self.wallet_name.wire2api(),
            sync_params: self.sync_params.wire2api(),
        }
    }
}
impl Wire2Api<RpcSyncParams> for wire_RpcSyncParams {
    fn wire2api(self) -> RpcSyncParams {
        RpcSyncParams {
            start_script_count: self.start_script_count.wire2api(),
            start_time: self.start_time.wire2api(),
            force_start_time: self.force_start_time.wire2api(),
            poll_rate_sec: self.poll_rate_sec.wire2api(),
        }
    }
}
impl Wire2Api<SchnorrFromSeedReq> for wire_SchnorrFromSeedReq {
    fn wire2api(self) -> SchnorrFromSeedReq {
        SchnorrFromSeedReq {
            seed: self.seed.wire2api(),
        }
    }
}
impl Wire2Api<SchnorrSignWithSeedReq> for wire_SchnorrSignWithSeedReq {
    fn wire2api(self) -> SchnorrSignWithSeedReq {
        SchnorrSignWithSeedReq {
            msg: self.msg.wire2api(),
            seed: self.seed.wire2api(),
            aux_rand: self.aux_rand.wire2api(),
        }
    }
}
impl Wire2Api<SchnorrVerifyReq> for wire_SchnorrVerifyReq {
    fn wire2api(self) -> SchnorrVerifyReq {
        SchnorrVerifyReq {
            message_hash: self.message_hash.wire2api(),
            signature_bytes: self.signature_bytes.wire2api(),
            public_key_bytes: self.public_key_bytes.wire2api(),
        }
    }
}
impl Wire2Api<Script> for wire_Script {
    fn wire2api(self) -> Script {
        Script {
            internal: self.internal.wire2api(),
        }
    }
}
impl Wire2Api<ScriptAmount> for wire_ScriptAmount {
    fn wire2api(self) -> ScriptAmount {
        ScriptAmount {
            script: self.script.wire2api(),
            amount: self.amount.wire2api(),
        }
    }
}
impl Wire2Api<ScriptDeriveReq> for wire_ScriptDeriveReq {
    fn wire2api(self) -> ScriptDeriveReq {
        ScriptDeriveReq {
            password: self.password.wire2api(),
            salt: self.salt.wire2api(),
            n: self.n.wire2api(),
            p: self.p.wire2api(),
            r: self.r.wire2api(),
        }
    }
}
impl Wire2Api<Secp256k1FromSeedReq> for wire_Secp256k1FromSeedReq {
    fn wire2api(self) -> Secp256k1FromSeedReq {
        Secp256k1FromSeedReq {
            seed: self.seed.wire2api(),
        }
    }
}
impl Wire2Api<Secp256k1RecoverReq> for wire_Secp256k1RecoverReq {
    fn wire2api(self) -> Secp256k1RecoverReq {
        Secp256k1RecoverReq {
            message_pre_hashed: self.message_pre_hashed.wire2api(),
            signature_bytes: self.signature_bytes.wire2api(),
            chain_id: self.chain_id.wire2api(),
        }
    }
}
impl Wire2Api<Secp256k1ShareSecretReq> for wire_Secp256k1ShareSecretReq {
    fn wire2api(self) -> Secp256k1ShareSecretReq {
        Secp256k1ShareSecretReq {
            seed: self.seed.wire2api(),
            public_key_raw_bytes: self.public_key_raw_bytes.wire2api(),
        }
    }
}
impl Wire2Api<Secp256k1SignWithRngReq> for wire_Secp256k1SignWithRngReq {
    fn wire2api(self) -> Secp256k1SignWithRngReq {
        Secp256k1SignWithRngReq {
            msg: self.msg.wire2api(),
            private_bytes: self.private_bytes.wire2api(),
        }
    }
}
impl Wire2Api<Secp256k1SignWithSeedReq> for wire_Secp256k1SignWithSeedReq {
    fn wire2api(self) -> Secp256k1SignWithSeedReq {
        Secp256k1SignWithSeedReq {
            msg: self.msg.wire2api(),
            seed: self.seed.wire2api(),
        }
    }
}
impl Wire2Api<Secp256k1VerifyReq> for wire_Secp256k1VerifyReq {
    fn wire2api(self) -> Secp256k1VerifyReq {
        Secp256k1VerifyReq {
            message_hash: self.message_hash.wire2api(),
            signature_bytes: self.signature_bytes.wire2api(),
            public_key_bytes: self.public_key_bytes.wire2api(),
        }
    }
}
impl Wire2Api<SeedToKeyReq> for wire_SeedToKeyReq {
    fn wire2api(self) -> SeedToKeyReq {
        SeedToKeyReq {
            seed: self.seed.wire2api(),
            path: self.path.wire2api(),
        }
    }
}
impl Wire2Api<SignOptions> for wire_SignOptions {
    fn wire2api(self) -> SignOptions {
        SignOptions {
            trust_witness_utxo: self.trust_witness_utxo.wire2api(),
            assume_height: self.assume_height.wire2api(),
            allow_all_sighashes: self.allow_all_sighashes.wire2api(),
            remove_partial_sigs: self.remove_partial_sigs.wire2api(),
            try_finalize: self.try_finalize.wire2api(),
            finalize_mine_only: self.finalize_mine_only.wire2api(),
            sign_with_tap_internal_key: self.sign_with_tap_internal_key.wire2api(),
            allow_grinding: self.allow_grinding.wire2api(),
        }
    }
}
impl Wire2Api<SledDbConfiguration> for wire_SledDbConfiguration {
    fn wire2api(self) -> SledDbConfiguration {
        SledDbConfiguration {
            path: self.path.wire2api(),
            tree_name: self.tree_name.wire2api(),
        }
    }
}
impl Wire2Api<SqliteDbConfiguration> for wire_SqliteDbConfiguration {
    fn wire2api(self) -> SqliteDbConfiguration {
        SqliteDbConfiguration {
            path: self.path.wire2api(),
        }
    }
}
impl Wire2Api<TxBytes> for wire_TxBytes {
    fn wire2api(self) -> TxBytes {
        TxBytes {
            tx_id: self.tx_id.wire2api(),
            bytes: self.bytes.wire2api(),
        }
    }
}
impl Wire2Api<TxOutForeign> for wire_TxOutForeign {
    fn wire2api(self) -> TxOutForeign {
        TxOutForeign {
            value: self.value.wire2api(),
            script_pubkey: self.script_pubkey.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
impl Wire2Api<UserPass> for wire_UserPass {
    fn wire2api(self) -> UserPass {
        UserPass {
            username: self.username.wire2api(),
            password: self.password.wire2api(),
        }
    }
}

// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_BdkDescriptor {
    ptr: *const core::ffi::c_void,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_BlockchainInstance {
    ptr: *const core::ffi::c_void,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_WalletInstance {
    ptr: *const core::ffi::c_void,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_AesDecryptReq {
    key: *mut wire_uint_8_list,
    iv: *mut wire_uint_8_list,
    cipher_text: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_AesEncryptReq {
    key: *mut wire_uint_8_list,
    iv: *mut wire_uint_8_list,
    message: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_BLSVerifyReq {
    signature: *mut wire_uint_8_list,
    message: *mut wire_uint_8_list,
    public_key: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ED25519FromSeedReq {
    seed: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ED25519SignReq {
    seed: *mut wire_uint_8_list,
    message: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ED25519VerifyReq {
    sig: *mut wire_uint_8_list,
    message: *mut wire_uint_8_list,
    pub_key: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ElectrumConfig {
    url: *mut wire_uint_8_list,
    socks5: *mut wire_uint_8_list,
    retry: u8,
    timeout: *mut u8,
    stop_gap: u64,
    validate_domain: bool,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_EsploraConfig {
    base_url: *mut wire_uint_8_list,
    proxy: *mut wire_uint_8_list,
    concurrency: *mut u8,
    stop_gap: u64,
    timeout: *mut u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ForeignUtxo {
    outpoint: wire_OutPoint,
    txout: wire_TxOutForeign,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_foreign_utxo {
    ptr: *mut wire_ForeignUtxo,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_out_point {
    ptr: *mut wire_OutPoint,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_script_amount {
    ptr: *mut wire_ScriptAmount,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_tx_bytes {
    ptr: *mut wire_TxBytes,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_OutPoint {
    txid: *mut wire_uint_8_list,
    vout: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_P256FromSeedReq {
    seed: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_P256ShareSecretReq {
    seed: *mut wire_uint_8_list,
    public_key_raw_bytes: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_P256SignWithSeedReq {
    msg: *mut wire_uint_8_list,
    seed: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_P256VerifyReq {
    message_hash: *mut wire_uint_8_list,
    signature_bytes: *mut wire_uint_8_list,
    public_key_bytes: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_PBKDFDeriveReq {
    password: *mut wire_uint_8_list,
    salt: *mut wire_uint_8_list,
    c: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_PhraseToSeedReq {
    phrase: *mut wire_uint_8_list,
    password: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RpcConfig {
    url: *mut wire_uint_8_list,
    auth_cookie: *mut wire_uint_8_list,
    auth_user_pass: *mut wire_UserPass,
    network: i32,
    wallet_name: *mut wire_uint_8_list,
    sync_params: *mut wire_RpcSyncParams,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RpcSyncParams {
    start_script_count: u64,
    start_time: u64,
    force_start_time: bool,
    poll_rate_sec: u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SchnorrFromSeedReq {
    seed: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SchnorrSignWithSeedReq {
    msg: *mut wire_uint_8_list,
    seed: *mut wire_uint_8_list,
    aux_rand: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SchnorrVerifyReq {
    message_hash: *mut wire_uint_8_list,
    signature_bytes: *mut wire_uint_8_list,
    public_key_bytes: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Script {
    internal: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ScriptAmount {
    script: wire_Script,
    amount: u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ScriptDeriveReq {
    password: *mut wire_uint_8_list,
    salt: *mut wire_uint_8_list,
    n: u32,
    p: u32,
    r: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Secp256k1FromSeedReq {
    seed: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Secp256k1RecoverReq {
    message_pre_hashed: *mut wire_uint_8_list,
    signature_bytes: *mut wire_uint_8_list,
    chain_id: *mut u8,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Secp256k1ShareSecretReq {
    seed: *mut wire_uint_8_list,
    public_key_raw_bytes: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Secp256k1SignWithRngReq {
    msg: *mut wire_uint_8_list,
    private_bytes: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Secp256k1SignWithSeedReq {
    msg: *mut wire_uint_8_list,
    seed: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Secp256k1VerifyReq {
    message_hash: *mut wire_uint_8_list,
    signature_bytes: *mut wire_uint_8_list,
    public_key_bytes: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SeedToKeyReq {
    seed: *mut wire_uint_8_list,
    path: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SignOptions {
    trust_witness_utxo: bool,
    assume_height: *mut u32,
    allow_all_sighashes: bool,
    remove_partial_sigs: bool,
    try_finalize: bool,
    finalize_mine_only: bool,
    sign_with_tap_internal_key: bool,
    allow_grinding: bool,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SledDbConfiguration {
    path: *mut wire_uint_8_list,
    tree_name: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SqliteDbConfiguration {
    path: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_TxBytes {
    tx_id: *mut wire_uint_8_list,
    bytes: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_TxOutForeign {
    value: u64,
    script_pubkey: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_UserPass {
    username: *mut wire_uint_8_list,
    password: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_AddressIndex {
    tag: i32,
    kind: *mut AddressIndexKind,
}

#[repr(C)]
pub union AddressIndexKind {
    NewIndex: *mut wire_AddressIndex_NewIndex,
    LastUnused: *mut wire_AddressIndex_LastUnused,
    Peek: *mut wire_AddressIndex_Peek,
    Reset: *mut wire_AddressIndex_Reset,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_AddressIndex_NewIndex {}

#[repr(C)]
#[derive(Clone)]
pub struct wire_AddressIndex_LastUnused {}

#[repr(C)]
#[derive(Clone)]
pub struct wire_AddressIndex_Peek {
    index: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_AddressIndex_Reset {
    index: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_BlockchainConfig {
    tag: i32,
    kind: *mut BlockchainConfigKind,
}

#[repr(C)]
pub union BlockchainConfigKind {
    Electrum: *mut wire_BlockchainConfig_Electrum,
    Esplora: *mut wire_BlockchainConfig_Esplora,
    Rpc: *mut wire_BlockchainConfig_Rpc,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_BlockchainConfig_Electrum {
    config: *mut wire_ElectrumConfig,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_BlockchainConfig_Esplora {
    config: *mut wire_EsploraConfig,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_BlockchainConfig_Rpc {
    config: *mut wire_RpcConfig,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DatabaseConfig {
    tag: i32,
    kind: *mut DatabaseConfigKind,
}

#[repr(C)]
pub union DatabaseConfigKind {
    Memory: *mut wire_DatabaseConfig_Memory,
    Sqlite: *mut wire_DatabaseConfig_Sqlite,
    Sled: *mut wire_DatabaseConfig_Sled,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DatabaseConfig_Memory {}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DatabaseConfig_Sqlite {
    config: *mut wire_SqliteDbConfiguration,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DatabaseConfig_Sled {
    config: *mut wire_SledDbConfiguration,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RbfValue {
    tag: i32,
    kind: *mut RbfValueKind,
}

#[repr(C)]
pub union RbfValueKind {
    RbfDefault: *mut wire_RbfValue_RbfDefault,
    Value: *mut wire_RbfValue_Value,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RbfValue_RbfDefault {}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RbfValue_Value {
    field0: u32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_BdkDescriptor {
    fn new_with_null_ptr() -> Self {
        Self {
            ptr: core::ptr::null(),
        }
    }
}
impl NewWithNullPtr for wire_BlockchainInstance {
    fn new_with_null_ptr() -> Self {
        Self {
            ptr: core::ptr::null(),
        }
    }
}

impl NewWithNullPtr for wire_WalletInstance {
    fn new_with_null_ptr() -> Self {
        Self {
            ptr: core::ptr::null(),
        }
    }
}
impl Default for wire_AddressIndex {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_AddressIndex {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_AddressIndex_Peek() -> *mut AddressIndexKind {
    support::new_leak_box_ptr(AddressIndexKind {
        Peek: support::new_leak_box_ptr(wire_AddressIndex_Peek {
            index: Default::default(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_AddressIndex_Reset() -> *mut AddressIndexKind {
    support::new_leak_box_ptr(AddressIndexKind {
        Reset: support::new_leak_box_ptr(wire_AddressIndex_Reset {
            index: Default::default(),
        }),
    })
}

impl NewWithNullPtr for wire_AesDecryptReq {
    fn new_with_null_ptr() -> Self {
        Self {
            key: core::ptr::null_mut(),
            iv: core::ptr::null_mut(),
            cipher_text: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_AesDecryptReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_AesEncryptReq {
    fn new_with_null_ptr() -> Self {
        Self {
            key: core::ptr::null_mut(),
            iv: core::ptr::null_mut(),
            message: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_AesEncryptReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl Default for wire_BlockchainConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_BlockchainConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_BlockchainConfig_Electrum() -> *mut BlockchainConfigKind {
    support::new_leak_box_ptr(BlockchainConfigKind {
        Electrum: support::new_leak_box_ptr(wire_BlockchainConfig_Electrum {
            config: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_BlockchainConfig_Esplora() -> *mut BlockchainConfigKind {
    support::new_leak_box_ptr(BlockchainConfigKind {
        Esplora: support::new_leak_box_ptr(wire_BlockchainConfig_Esplora {
            config: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_BlockchainConfig_Rpc() -> *mut BlockchainConfigKind {
    support::new_leak_box_ptr(BlockchainConfigKind {
        Rpc: support::new_leak_box_ptr(wire_BlockchainConfig_Rpc {
            config: core::ptr::null_mut(),
        }),
    })
}

impl NewWithNullPtr for wire_BLSVerifyReq {
    fn new_with_null_ptr() -> Self {
        Self {
            signature: core::ptr::null_mut(),
            message: core::ptr::null_mut(),
            public_key: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_BLSVerifyReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl Default for wire_DatabaseConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_DatabaseConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_DatabaseConfig_Sqlite() -> *mut DatabaseConfigKind {
    support::new_leak_box_ptr(DatabaseConfigKind {
        Sqlite: support::new_leak_box_ptr(wire_DatabaseConfig_Sqlite {
            config: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_DatabaseConfig_Sled() -> *mut DatabaseConfigKind {
    support::new_leak_box_ptr(DatabaseConfigKind {
        Sled: support::new_leak_box_ptr(wire_DatabaseConfig_Sled {
            config: core::ptr::null_mut(),
        }),
    })
}

impl NewWithNullPtr for wire_ED25519FromSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_ED25519FromSeedReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ED25519SignReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
            message: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_ED25519SignReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ED25519VerifyReq {
    fn new_with_null_ptr() -> Self {
        Self {
            sig: core::ptr::null_mut(),
            message: core::ptr::null_mut(),
            pub_key: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_ED25519VerifyReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ElectrumConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            url: core::ptr::null_mut(),
            socks5: core::ptr::null_mut(),
            retry: Default::default(),
            timeout: core::ptr::null_mut(),
            stop_gap: Default::default(),
            validate_domain: Default::default(),
        }
    }
}

impl Default for wire_ElectrumConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_EsploraConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            base_url: core::ptr::null_mut(),
            proxy: core::ptr::null_mut(),
            concurrency: core::ptr::null_mut(),
            stop_gap: Default::default(),
            timeout: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_EsploraConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ForeignUtxo {
    fn new_with_null_ptr() -> Self {
        Self {
            outpoint: Default::default(),
            txout: Default::default(),
        }
    }
}

impl Default for wire_ForeignUtxo {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_OutPoint {
    fn new_with_null_ptr() -> Self {
        Self {
            txid: core::ptr::null_mut(),
            vout: Default::default(),
        }
    }
}

impl Default for wire_OutPoint {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_P256FromSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_P256FromSeedReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_P256ShareSecretReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
            public_key_raw_bytes: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_P256ShareSecretReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_P256SignWithSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            msg: core::ptr::null_mut(),
            seed: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_P256SignWithSeedReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_P256VerifyReq {
    fn new_with_null_ptr() -> Self {
        Self {
            message_hash: core::ptr::null_mut(),
            signature_bytes: core::ptr::null_mut(),
            public_key_bytes: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_P256VerifyReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_PBKDFDeriveReq {
    fn new_with_null_ptr() -> Self {
        Self {
            password: core::ptr::null_mut(),
            salt: core::ptr::null_mut(),
            c: Default::default(),
        }
    }
}

impl Default for wire_PBKDFDeriveReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_PhraseToSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            phrase: core::ptr::null_mut(),
            password: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_PhraseToSeedReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl Default for wire_RbfValue {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_RbfValue {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_RbfValue_Value() -> *mut RbfValueKind {
    support::new_leak_box_ptr(RbfValueKind {
        Value: support::new_leak_box_ptr(wire_RbfValue_Value {
            field0: Default::default(),
        }),
    })
}

impl NewWithNullPtr for wire_RpcConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            url: core::ptr::null_mut(),
            auth_cookie: core::ptr::null_mut(),
            auth_user_pass: core::ptr::null_mut(),
            network: Default::default(),
            wallet_name: core::ptr::null_mut(),
            sync_params: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_RpcConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_RpcSyncParams {
    fn new_with_null_ptr() -> Self {
        Self {
            start_script_count: Default::default(),
            start_time: Default::default(),
            force_start_time: Default::default(),
            poll_rate_sec: Default::default(),
        }
    }
}

impl Default for wire_RpcSyncParams {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SchnorrFromSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_SchnorrFromSeedReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SchnorrSignWithSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            msg: core::ptr::null_mut(),
            seed: core::ptr::null_mut(),
            aux_rand: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_SchnorrSignWithSeedReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SchnorrVerifyReq {
    fn new_with_null_ptr() -> Self {
        Self {
            message_hash: core::ptr::null_mut(),
            signature_bytes: core::ptr::null_mut(),
            public_key_bytes: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_SchnorrVerifyReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Script {
    fn new_with_null_ptr() -> Self {
        Self {
            internal: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_Script {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ScriptAmount {
    fn new_with_null_ptr() -> Self {
        Self {
            script: Default::default(),
            amount: Default::default(),
        }
    }
}

impl Default for wire_ScriptAmount {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ScriptDeriveReq {
    fn new_with_null_ptr() -> Self {
        Self {
            password: core::ptr::null_mut(),
            salt: core::ptr::null_mut(),
            n: Default::default(),
            p: Default::default(),
            r: Default::default(),
        }
    }
}

impl Default for wire_ScriptDeriveReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Secp256k1FromSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_Secp256k1FromSeedReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Secp256k1RecoverReq {
    fn new_with_null_ptr() -> Self {
        Self {
            message_pre_hashed: core::ptr::null_mut(),
            signature_bytes: core::ptr::null_mut(),
            chain_id: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_Secp256k1RecoverReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Secp256k1ShareSecretReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
            public_key_raw_bytes: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_Secp256k1ShareSecretReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Secp256k1SignWithRngReq {
    fn new_with_null_ptr() -> Self {
        Self {
            msg: core::ptr::null_mut(),
            private_bytes: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_Secp256k1SignWithRngReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Secp256k1SignWithSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            msg: core::ptr::null_mut(),
            seed: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_Secp256k1SignWithSeedReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Secp256k1VerifyReq {
    fn new_with_null_ptr() -> Self {
        Self {
            message_hash: core::ptr::null_mut(),
            signature_bytes: core::ptr::null_mut(),
            public_key_bytes: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_Secp256k1VerifyReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SeedToKeyReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
            path: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_SeedToKeyReq {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SignOptions {
    fn new_with_null_ptr() -> Self {
        Self {
            trust_witness_utxo: Default::default(),
            assume_height: core::ptr::null_mut(),
            allow_all_sighashes: Default::default(),
            remove_partial_sigs: Default::default(),
            try_finalize: Default::default(),
            finalize_mine_only: Default::default(),
            sign_with_tap_internal_key: Default::default(),
            allow_grinding: Default::default(),
        }
    }
}

impl Default for wire_SignOptions {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SledDbConfiguration {
    fn new_with_null_ptr() -> Self {
        Self {
            path: core::ptr::null_mut(),
            tree_name: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_SledDbConfiguration {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SqliteDbConfiguration {
    fn new_with_null_ptr() -> Self {
        Self {
            path: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_SqliteDbConfiguration {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_TxBytes {
    fn new_with_null_ptr() -> Self {
        Self {
            tx_id: core::ptr::null_mut(),
            bytes: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_TxBytes {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_TxOutForeign {
    fn new_with_null_ptr() -> Self {
        Self {
            value: Default::default(),
            script_pubkey: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_TxOutForeign {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_UserPass {
    fn new_with_null_ptr() -> Self {
        Self {
            username: core::ptr::null_mut(),
            password: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_UserPass {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
