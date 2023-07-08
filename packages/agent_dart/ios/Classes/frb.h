#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

#define ECB 0

#define CBC 1

#define CFB1 2

#define CFB2 3

#define CFB4 5

#define OFB1 14

#define OFB2 15

#define OFB4 17

#define OFB8 21

#define OFB16 29

#define CTR1 30

#define CTR2 31

#define CTR4 33

#define CTR8 37

#define CTR16 45

#define CHUNK 64

#define MODBYTES 48

#define BASEBITS 58

#define NLEN (1 + (((8 * MODBYTES) - 1) / BASEBITS))

#define DNLEN (2 * NLEN)

#define HBITS (BASEBITS / 2)



#define BIGBITS (MODBYTES * 8)





#define BLS_OK 0

#define BLS_FAIL -1

#define WEIERSTRASS 0

#define EDWARDS 1

#define MONTGOMERY 2

#define NOT 0

#define BN 1

#define BLS12 2

#define BLS24 3

#define BLS48 4

#define D_TYPE 0

#define M_TYPE 1

#define POSITIVEX 0

#define NEGATIVEX 1

#define CURVETYPE WEIERSTRASS

#define CURVE_A 0

#define CURVE_PAIRING_TYPE BLS12

#define SEXTIC_TWIST M_TYPE

#define SIGN_OF_X NEGATIVEX

#define ATE_BITS 65

#define G2_TABLE 69

#define HTC_ISO 11

#define HTC_ISO_G2 3

#define ALLOW_ALT_COMPRESS true

#define HASH_TYPE 32

#define AESKEY 16

#define NOT_SPECIAL 0

#define PSEUDO_MERSENNE 1

#define MONTGOMERY_FRIENDLY 2

#define GENERALISED_MERSENNE 3

#define NEGATOWER 0

#define POSITOWER 1

#define MODBITS 381

#define PM1D2 1

#define RIADZ 11

#define RIADZG2A -2

#define RIADZG2B -1

#define MODTYPE NOT_SPECIAL

#define QNRI 0

#define TOWER NEGATOWER

#define FEXCESS (((int32_t)1 << 25) - 1)



#define BIG_ENDIAN_SIGN false

#define ZERO 0

#define ONE 1

#define SPARSEST 2

#define SPARSER 3

#define SPARSE 4

#define DENSE 5





#define BAD_PARAMS -11

#define INVALID_POINT -14

#define WRONG_ORDER -18

#define BAD_PIN -19

#define SHA256 32

#define SHA384 48

#define SHA512 64

#define MAXPIN 10000

#define PBLEN 14

#define CURVE_COF_I 0

#define CURVE_B_I 4

#define USE_GLV true

#define USE_GS_G2 true

#define USE_GS_GT true

#define GT_STRONG false

#define MC_SHA2 2

#define MC_SHA3 3

#define HASH224 28

#define HASH256 32

#define HASH384 48

#define HASH512 64

#define SHAKE128 16

#define SHAKE256 32

#define KEY_LENGTH 32

#define KEY_LENGTH_AES (KEY_LENGTH / 2)

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_PhraseToSeedReq {
  struct wire_uint_8_list *phrase;
  struct wire_uint_8_list *password;
} wire_PhraseToSeedReq;

typedef struct wire_SeedToKeyReq {
  struct wire_uint_8_list *seed;
  struct wire_uint_8_list *path;
} wire_SeedToKeyReq;

typedef struct wire_BLSVerifyReq {
  struct wire_uint_8_list *signature;
  struct wire_uint_8_list *message;
  struct wire_uint_8_list *public_key;
} wire_BLSVerifyReq;

typedef struct wire_ED25519FromSeedReq {
  struct wire_uint_8_list *seed;
} wire_ED25519FromSeedReq;

typedef struct wire_ED25519SignReq {
  struct wire_uint_8_list *seed;
  struct wire_uint_8_list *message;
} wire_ED25519SignReq;

typedef struct wire_ED25519VerifyReq {
  struct wire_uint_8_list *sig;
  struct wire_uint_8_list *message;
  struct wire_uint_8_list *pub_key;
} wire_ED25519VerifyReq;

typedef struct wire_Secp256k1FromSeedReq {
  struct wire_uint_8_list *seed;
} wire_Secp256k1FromSeedReq;

typedef struct wire_Secp256k1SignWithSeedReq {
  struct wire_uint_8_list *msg;
  struct wire_uint_8_list *seed;
} wire_Secp256k1SignWithSeedReq;

typedef struct wire_Secp256k1SignWithRngReq {
  struct wire_uint_8_list *msg;
  struct wire_uint_8_list *private_bytes;
} wire_Secp256k1SignWithRngReq;

typedef struct wire_Secp256k1VerifyReq {
  struct wire_uint_8_list *message_hash;
  struct wire_uint_8_list *signature_bytes;
  struct wire_uint_8_list *public_key_bytes;
} wire_Secp256k1VerifyReq;

typedef struct wire_Secp256k1ShareSecretReq {
  struct wire_uint_8_list *seed;
  struct wire_uint_8_list *public_key_raw_bytes;
} wire_Secp256k1ShareSecretReq;

typedef struct wire_Secp256k1RecoverReq {
  struct wire_uint_8_list *message_pre_hashed;
  struct wire_uint_8_list *signature_bytes;
  uint8_t *chain_id;
} wire_Secp256k1RecoverReq;

typedef struct wire_P256FromSeedReq {
  struct wire_uint_8_list *seed;
} wire_P256FromSeedReq;

typedef struct wire_P256SignWithSeedReq {
  struct wire_uint_8_list *msg;
  struct wire_uint_8_list *seed;
} wire_P256SignWithSeedReq;

typedef struct wire_P256VerifyReq {
  struct wire_uint_8_list *message_hash;
  struct wire_uint_8_list *signature_bytes;
  struct wire_uint_8_list *public_key_bytes;
} wire_P256VerifyReq;

typedef struct wire_P256ShareSecretReq {
  struct wire_uint_8_list *seed;
  struct wire_uint_8_list *public_key_raw_bytes;
} wire_P256ShareSecretReq;

typedef struct wire_SchnorrFromSeedReq {
  struct wire_uint_8_list *seed;
} wire_SchnorrFromSeedReq;

typedef struct wire_SchnorrSignWithSeedReq {
  struct wire_uint_8_list *msg;
  struct wire_uint_8_list *seed;
  struct wire_uint_8_list *aux_rand;
} wire_SchnorrSignWithSeedReq;

typedef struct wire_SchnorrVerifyReq {
  struct wire_uint_8_list *message_hash;
  struct wire_uint_8_list *signature_bytes;
  struct wire_uint_8_list *public_key_bytes;
} wire_SchnorrVerifyReq;

typedef struct wire_AesEncryptReq {
  struct wire_uint_8_list *key;
  struct wire_uint_8_list *iv;
  struct wire_uint_8_list *message;
} wire_AesEncryptReq;

typedef struct wire_AesDecryptReq {
  struct wire_uint_8_list *key;
  struct wire_uint_8_list *iv;
  struct wire_uint_8_list *cipher_text;
} wire_AesDecryptReq;

typedef struct wire_PBKDFDeriveReq {
  struct wire_uint_8_list *password;
  struct wire_uint_8_list *salt;
  uint32_t c;
} wire_PBKDFDeriveReq;

typedef struct wire_ScriptDeriveReq {
  struct wire_uint_8_list *password;
  struct wire_uint_8_list *salt;
  uint32_t n;
  uint32_t p;
  uint32_t r;
} wire_ScriptDeriveReq;

typedef struct wire_ElectrumConfig {
  struct wire_uint_8_list *url;
  struct wire_uint_8_list *socks5;
  uint8_t retry;
  uint8_t *timeout;
  uint64_t stop_gap;
  bool validate_domain;
} wire_ElectrumConfig;

typedef struct wire_BlockchainConfig_Electrum {
  struct wire_ElectrumConfig *config;
} wire_BlockchainConfig_Electrum;

typedef struct wire_EsploraConfig {
  struct wire_uint_8_list *base_url;
  struct wire_uint_8_list *proxy;
  uint8_t *concurrency;
  uint64_t stop_gap;
  uint64_t *timeout;
} wire_EsploraConfig;

typedef struct wire_BlockchainConfig_Esplora {
  struct wire_EsploraConfig *config;
} wire_BlockchainConfig_Esplora;

typedef struct wire_UserPass {
  struct wire_uint_8_list *username;
  struct wire_uint_8_list *password;
} wire_UserPass;

typedef struct wire_RpcSyncParams {
  uint64_t start_script_count;
  uint64_t start_time;
  bool force_start_time;
  uint64_t poll_rate_sec;
} wire_RpcSyncParams;

typedef struct wire_RpcConfig {
  struct wire_uint_8_list *url;
  struct wire_uint_8_list *auth_cookie;
  struct wire_UserPass *auth_user_pass;
  int32_t network;
  struct wire_uint_8_list *wallet_name;
  struct wire_RpcSyncParams *sync_params;
} wire_RpcConfig;

typedef struct wire_BlockchainConfig_Rpc {
  struct wire_RpcConfig *config;
} wire_BlockchainConfig_Rpc;

typedef union BlockchainConfigKind {
  struct wire_BlockchainConfig_Electrum *Electrum;
  struct wire_BlockchainConfig_Esplora *Esplora;
  struct wire_BlockchainConfig_Rpc *Rpc;
} BlockchainConfigKind;

typedef struct wire_BlockchainConfig {
  int32_t tag;
  union BlockchainConfigKind *kind;
} wire_BlockchainConfig;

typedef struct wire_BlockchainInstance {
  const void *ptr;
} wire_BlockchainInstance;

typedef struct wire_WalletInstance {
  const void *ptr;
} wire_WalletInstance;

typedef struct wire_Script {
  struct wire_uint_8_list *internal;
} wire_Script;

typedef struct wire_ScriptAmount {
  struct wire_Script script;
  uint64_t amount;
} wire_ScriptAmount;

typedef struct wire_list_script_amount {
  struct wire_ScriptAmount *ptr;
  int32_t len;
} wire_list_script_amount;

typedef struct wire_TxBytes {
  struct wire_uint_8_list *tx_id;
  struct wire_uint_8_list *bytes;
} wire_TxBytes;

typedef struct wire_list_tx_bytes {
  struct wire_TxBytes *ptr;
  int32_t len;
} wire_list_tx_bytes;

typedef struct wire_OutPoint {
  struct wire_uint_8_list *txid;
  uint32_t vout;
} wire_OutPoint;

typedef struct wire_list_out_point {
  struct wire_OutPoint *ptr;
  int32_t len;
} wire_list_out_point;

typedef struct wire_TxOutForeign {
  uint64_t value;
  struct wire_uint_8_list *script_pubkey;
} wire_TxOutForeign;

typedef struct wire_ForeignUtxo {
  struct wire_OutPoint outpoint;
  struct wire_TxOutForeign txout;
} wire_ForeignUtxo;

typedef struct wire_list_foreign_utxo {
  struct wire_ForeignUtxo *ptr;
  int32_t len;
} wire_list_foreign_utxo;

typedef struct wire_RbfValue_RbfDefault {

} wire_RbfValue_RbfDefault;

typedef struct wire_RbfValue_Value {
  uint32_t field0;
} wire_RbfValue_Value;

typedef union RbfValueKind {
  struct wire_RbfValue_RbfDefault *RbfDefault;
  struct wire_RbfValue_Value *Value;
} RbfValueKind;

typedef struct wire_RbfValue {
  int32_t tag;
  union RbfValueKind *kind;
} wire_RbfValue;

typedef struct wire_BdkDescriptor {
  const void *ptr;
} wire_BdkDescriptor;

typedef struct wire_DatabaseConfig_Memory {

} wire_DatabaseConfig_Memory;

typedef struct wire_SqliteDbConfiguration {
  struct wire_uint_8_list *path;
} wire_SqliteDbConfiguration;

typedef struct wire_DatabaseConfig_Sqlite {
  struct wire_SqliteDbConfiguration *config;
} wire_DatabaseConfig_Sqlite;

typedef struct wire_SledDbConfiguration {
  struct wire_uint_8_list *path;
  struct wire_uint_8_list *tree_name;
} wire_SledDbConfiguration;

typedef struct wire_DatabaseConfig_Sled {
  struct wire_SledDbConfiguration *config;
} wire_DatabaseConfig_Sled;

typedef union DatabaseConfigKind {
  struct wire_DatabaseConfig_Memory *Memory;
  struct wire_DatabaseConfig_Sqlite *Sqlite;
  struct wire_DatabaseConfig_Sled *Sled;
} DatabaseConfigKind;

typedef struct wire_DatabaseConfig {
  int32_t tag;
  union DatabaseConfigKind *kind;
} wire_DatabaseConfig;

typedef struct wire_AddressIndex_New {

} wire_AddressIndex_New;

typedef struct wire_AddressIndex_LastUnused {

} wire_AddressIndex_LastUnused;

typedef struct wire_AddressIndex_Peek {
  uint32_t index;
} wire_AddressIndex_Peek;

typedef struct wire_AddressIndex_Reset {
  uint32_t index;
} wire_AddressIndex_Reset;

typedef union AddressIndexKind {
  struct wire_AddressIndex_New *New;
  struct wire_AddressIndex_LastUnused *LastUnused;
  struct wire_AddressIndex_Peek *Peek;
  struct wire_AddressIndex_Reset *Reset;
} AddressIndexKind;

typedef struct wire_AddressIndex {
  int32_t tag;
  union AddressIndexKind *kind;
} wire_AddressIndex;

typedef struct wire_SignOptions {
  bool trust_witness_utxo;
  uint32_t *assume_height;
  bool allow_all_sighashes;
  bool remove_partial_sigs;
  bool try_finalize;
  bool sign_with_tap_internal_key;
  bool allow_grinding;
} wire_SignOptions;

typedef struct DartCObject *WireSyncReturn;

typedef int64_t Chunk;

#define BMASK ((1 << BASEBITS) - 1)

#define HMASK ((1 << HBITS) - 1)



#define TMASK ((1 << TBITS) - 1)

#define MCONST 140737475470229501

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_mnemonic_phrase_to_seed(int64_t port_, struct wire_PhraseToSeedReq *req);

void wire_mnemonic_seed_to_key(int64_t port_, struct wire_SeedToKeyReq *req);

void wire_bls_init(int64_t port_);

void wire_bls_verify(int64_t port_, struct wire_BLSVerifyReq *req);

void wire_ed25519_from_seed(int64_t port_, struct wire_ED25519FromSeedReq *req);

void wire_ed25519_sign(int64_t port_, struct wire_ED25519SignReq *req);

void wire_ed25519_verify(int64_t port_, struct wire_ED25519VerifyReq *req);

void wire_secp256k1_from_seed(int64_t port_, struct wire_Secp256k1FromSeedReq *req);

void wire_secp256k1_sign(int64_t port_, struct wire_Secp256k1SignWithSeedReq *req);

void wire_secp256k1_sign_with_rng(int64_t port_, struct wire_Secp256k1SignWithRngReq *req);

void wire_secp256k1_sign_recoverable(int64_t port_, struct wire_Secp256k1SignWithSeedReq *req);

void wire_secp256k1_verify(int64_t port_, struct wire_Secp256k1VerifyReq *req);

void wire_secp256k1_get_shared_secret(int64_t port_, struct wire_Secp256k1ShareSecretReq *req);

void wire_secp256k1_recover(int64_t port_, struct wire_Secp256k1RecoverReq *req);

void wire_p256_from_seed(int64_t port_, struct wire_P256FromSeedReq *req);

void wire_p256_sign(int64_t port_, struct wire_P256SignWithSeedReq *req);

void wire_p256_verify(int64_t port_, struct wire_P256VerifyReq *req);

void wire_p256_get_shared_secret(int64_t port_, struct wire_P256ShareSecretReq *req);

void wire_schnorr_from_seed(int64_t port_, struct wire_SchnorrFromSeedReq *req);

void wire_schnorr_sign(int64_t port_, struct wire_SchnorrSignWithSeedReq *req);

void wire_schnorr_verify(int64_t port_, struct wire_SchnorrVerifyReq *req);

void wire_aes_128_ctr_encrypt(int64_t port_, struct wire_AesEncryptReq *req);

void wire_aes_128_ctr_decrypt(int64_t port_, struct wire_AesDecryptReq *req);

void wire_aes_256_cbc_encrypt(int64_t port_, struct wire_AesEncryptReq *req);

void wire_aes_256_cbc_decrypt(int64_t port_, struct wire_AesDecryptReq *req);

void wire_aes_256_gcm_encrypt(int64_t port_, struct wire_AesEncryptReq *req);

void wire_aes_256_gcm_decrypt(int64_t port_, struct wire_AesDecryptReq *req);

void wire_pbkdf2_derive_key(int64_t port_, struct wire_PBKDFDeriveReq *req);

void wire_scrypt_derive_key(int64_t port_, struct wire_ScriptDeriveReq *req);

void wire_create_blockchain__static_method__Api(int64_t port_,
                                                struct wire_BlockchainConfig *config);

void wire_get_height__static_method__Api(int64_t port_, struct wire_BlockchainInstance blockchain);

void wire_get_blockchain_hash__static_method__Api(int64_t port_,
                                                  uint32_t blockchain_height,
                                                  struct wire_BlockchainInstance blockchain);

void wire_estimate_fee__static_method__Api(int64_t port_,
                                           uint64_t target,
                                           struct wire_BlockchainInstance blockchain);

void wire_broadcast__static_method__Api(int64_t port_,
                                        struct wire_uint_8_list *tx,
                                        struct wire_BlockchainInstance blockchain);

void wire_get_tx__static_method__Api(int64_t port_,
                                     struct wire_uint_8_list *tx,
                                     struct wire_BlockchainInstance blockchain);

void wire_create_transaction__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_tx_txid__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_weight__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_size__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_vsize__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_serialize_tx__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_is_coin_base__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_is_explicitly_rbf__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_is_lock_time_enabled__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_version__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_lock_time__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_input__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_output__static_method__Api(int64_t port_, struct wire_uint_8_list *tx);

void wire_serialize_psbt__static_method__Api(int64_t port_, struct wire_uint_8_list *psbt_str);

void wire_psbt_txid__static_method__Api(int64_t port_, struct wire_uint_8_list *psbt_str);

void wire_extract_tx__static_method__Api(int64_t port_, struct wire_uint_8_list *psbt_str);

void wire_psbt_fee_rate__static_method__Api(int64_t port_, struct wire_uint_8_list *psbt_str);

void wire_psbt_fee_amount__static_method__Api(int64_t port_, struct wire_uint_8_list *psbt_str);

void wire_combine_psbt__static_method__Api(int64_t port_,
                                           struct wire_uint_8_list *psbt_str,
                                           struct wire_uint_8_list *other);

void wire_json_serialize__static_method__Api(int64_t port_, struct wire_uint_8_list *psbt_str);

void wire_get_inputs__static_method__Api(int64_t port_, struct wire_uint_8_list *psbt_str);

void wire_tx_builder_finish__static_method__Api(int64_t port_,
                                                struct wire_WalletInstance wallet,
                                                struct wire_list_script_amount *recipients,
                                                struct wire_list_tx_bytes *txs,
                                                struct wire_list_out_point *unspendable,
                                                struct wire_list_foreign_utxo *foreign_utxos,
                                                int32_t change_policy,
                                                bool manually_selected_only,
                                                float *fee_rate,
                                                uint64_t *fee_absolute,
                                                bool drain_wallet,
                                                struct wire_Script *drain_to,
                                                struct wire_RbfValue *rbf,
                                                struct wire_uint_8_list *data,
                                                bool *shuffle_utxo);

void wire_tx_cal_fee_finish__static_method__Api(int64_t port_,
                                                struct wire_WalletInstance wallet,
                                                struct wire_list_script_amount *recipients,
                                                struct wire_list_tx_bytes *txs,
                                                struct wire_list_out_point *unspendable,
                                                struct wire_list_foreign_utxo *foreign_utxos,
                                                int32_t change_policy,
                                                bool manually_selected_only,
                                                float *fee_rate,
                                                uint64_t *fee_absolute,
                                                bool drain_wallet,
                                                struct wire_Script *drain_to,
                                                struct wire_RbfValue *rbf,
                                                struct wire_uint_8_list *data,
                                                bool *shuffle_utxo);

void wire_bump_fee_tx_builder_finish__static_method__Api(int64_t port_,
                                                         struct wire_uint_8_list *txid,
                                                         float fee_rate,
                                                         struct wire_uint_8_list *allow_shrinking,
                                                         struct wire_WalletInstance wallet,
                                                         bool enable_rbf,
                                                         bool keep_change,
                                                         uint32_t *n_sequence);

void wire_create_descriptor__static_method__Api(int64_t port_,
                                                struct wire_uint_8_list *descriptor,
                                                int32_t network);

void wire_new_bip44_descriptor__static_method__Api(int64_t port_,
                                                   int32_t key_chain_kind,
                                                   struct wire_uint_8_list *secret_key,
                                                   int32_t network);

void wire_new_bip44_public__static_method__Api(int64_t port_,
                                               int32_t key_chain_kind,
                                               struct wire_uint_8_list *public_key,
                                               int32_t network,
                                               struct wire_uint_8_list *fingerprint);

void wire_new_bip49_descriptor__static_method__Api(int64_t port_,
                                                   int32_t key_chain_kind,
                                                   struct wire_uint_8_list *secret_key,
                                                   int32_t network);

void wire_new_bip49_public__static_method__Api(int64_t port_,
                                               int32_t key_chain_kind,
                                               struct wire_uint_8_list *public_key,
                                               int32_t network,
                                               struct wire_uint_8_list *fingerprint);

void wire_new_bip84_descriptor__static_method__Api(int64_t port_,
                                                   int32_t key_chain_kind,
                                                   struct wire_uint_8_list *secret_key,
                                                   int32_t network);

void wire_new_bip84_public__static_method__Api(int64_t port_,
                                               int32_t key_chain_kind,
                                               struct wire_uint_8_list *public_key,
                                               int32_t network,
                                               struct wire_uint_8_list *fingerprint);

void wire_new_bip86_descriptor__static_method__Api(int64_t port_,
                                                   int32_t key_chain_kind,
                                                   struct wire_uint_8_list *secret_key,
                                                   int32_t network);

void wire_new_bip86_public__static_method__Api(int64_t port_,
                                               int32_t key_chain_kind,
                                               struct wire_uint_8_list *public_key,
                                               int32_t network,
                                               struct wire_uint_8_list *fingerprint);

void wire_as_string_private__static_method__Api(int64_t port_,
                                                struct wire_BdkDescriptor descriptor);

void wire_as_string__static_method__Api(int64_t port_, struct wire_BdkDescriptor descriptor);

void wire_derive_address_at__static_method__Api(int64_t port_,
                                                struct wire_BdkDescriptor descriptor,
                                                uint32_t index,
                                                int32_t network);

void wire_create_descriptor_secret__static_method__Api(int64_t port_,
                                                       int32_t network,
                                                       struct wire_uint_8_list *mnemonic,
                                                       struct wire_uint_8_list *password);

void wire_create_derived_descriptor_secret__static_method__Api(int64_t port_,
                                                               int32_t network,
                                                               struct wire_uint_8_list *mnemonic,
                                                               struct wire_uint_8_list *path,
                                                               struct wire_uint_8_list *password);

void wire_descriptor_secret_from_string__static_method__Api(int64_t port_,
                                                            struct wire_uint_8_list *secret);

void wire_extend_descriptor_secret__static_method__Api(int64_t port_,
                                                       struct wire_uint_8_list *secret,
                                                       struct wire_uint_8_list *path);

void wire_derive_descriptor_secret__static_method__Api(int64_t port_,
                                                       struct wire_uint_8_list *secret,
                                                       struct wire_uint_8_list *path);

void wire_as_secret_bytes__static_method__Api(int64_t port_, struct wire_uint_8_list *secret);

void wire_as_public__static_method__Api(int64_t port_, struct wire_uint_8_list *secret);

void wire_get_pub_from_secret_bytes__static_method__Api(int64_t port_,
                                                        struct wire_uint_8_list *bytes);

void wire_create_derivation_path__static_method__Api(int64_t port_, struct wire_uint_8_list *path);

void wire_descriptor_public_from_string__static_method__Api(int64_t port_,
                                                            struct wire_uint_8_list *public_key);

void wire_master_finterprint__static_method__Api(int64_t port_, struct wire_uint_8_list *xpub);

void wire_create_descriptor_public__static_method__Api(int64_t port_,
                                                       struct wire_uint_8_list *xpub,
                                                       struct wire_uint_8_list *path,
                                                       bool derive);

void wire_to_public_string__static_method__Api(int64_t port_, struct wire_uint_8_list *xpub);

void wire_create_script__static_method__Api(int64_t port_,
                                            struct wire_uint_8_list *raw_output_script);

void wire_create_address__static_method__Api(int64_t port_, struct wire_uint_8_list *address);

void wire_address_from_script__static_method__Api(int64_t port_,
                                                  struct wire_Script *script,
                                                  int32_t network);

void wire_address_to_script_pubkey__static_method__Api(int64_t port_,
                                                       struct wire_uint_8_list *address);

void wire_payload__static_method__Api(int64_t port_, struct wire_uint_8_list *address);

void wire_address_network__static_method__Api(int64_t port_, struct wire_uint_8_list *address);

void wire_get_address_type__static_method__Api(int64_t port_, struct wire_uint_8_list *address);

void wire_create_wallet__static_method__Api(int64_t port_,
                                            struct wire_BdkDescriptor descriptor,
                                            struct wire_BdkDescriptor *change_descriptor,
                                            int32_t network,
                                            struct wire_DatabaseConfig *database_config);

void wire_get_address__static_method__Api(int64_t port_,
                                          struct wire_WalletInstance wallet,
                                          struct wire_AddressIndex *address_index);

void wire_get_internal_address__static_method__Api(int64_t port_,
                                                   struct wire_WalletInstance wallet,
                                                   struct wire_AddressIndex *address_index);

void wire_sync_wallet__static_method__Api(int64_t port_,
                                          struct wire_WalletInstance wallet,
                                          struct wire_BlockchainInstance blockchain);

void wire_sync_wallet_thread__static_method__Api(int64_t port_,
                                                 struct wire_WalletInstance wallet,
                                                 struct wire_BlockchainInstance blockchain);

void wire_get_balance__static_method__Api(int64_t port_, struct wire_WalletInstance wallet);

void wire_list_unspent_outputs__static_method__Api(int64_t port_,
                                                   struct wire_WalletInstance wallet);

void wire_get_transactions__static_method__Api(int64_t port_,
                                               struct wire_WalletInstance wallet,
                                               bool include_raw);

void wire_sign__static_method__Api(int64_t port_,
                                   struct wire_WalletInstance wallet,
                                   struct wire_uint_8_list *psbt_str,
                                   struct wire_SignOptions *sign_options);

void wire_wallet_network__static_method__Api(int64_t port_, struct wire_WalletInstance wallet);

void wire_list_unspent__static_method__Api(int64_t port_, struct wire_WalletInstance wallet);

void wire_cache_address__static_method__Api(int64_t port_,
                                            struct wire_WalletInstance wallet,
                                            uint32_t cache_size);

void wire_generate_seed_from_word_count__static_method__Api(int64_t port_, int32_t word_count);

void wire_generate_seed_from_string__static_method__Api(int64_t port_,
                                                        struct wire_uint_8_list *mnemonic);

void wire_generate_seed_from_entropy__static_method__Api(int64_t port_,
                                                         struct wire_uint_8_list *entropy);

void wire_bip322_sign_segwit__static_method__Api(int64_t port_,
                                                 struct wire_uint_8_list *secret,
                                                 struct wire_uint_8_list *message);

void wire_bip322_sign_taproot__static_method__Api(int64_t port_,
                                                  struct wire_uint_8_list *secret,
                                                  struct wire_uint_8_list *message);

struct wire_BdkDescriptor new_BdkDescriptor(void);

struct wire_BlockchainInstance new_BlockchainInstance(void);

struct wire_WalletInstance new_WalletInstance(void);

struct wire_BdkDescriptor *new_box_autoadd_BdkDescriptor_0(void);

struct wire_AddressIndex *new_box_autoadd_address_index_0(void);

struct wire_AesDecryptReq *new_box_autoadd_aes_decrypt_req_0(void);

struct wire_AesEncryptReq *new_box_autoadd_aes_encrypt_req_0(void);

struct wire_BlockchainConfig *new_box_autoadd_blockchain_config_0(void);

struct wire_BLSVerifyReq *new_box_autoadd_bls_verify_req_0(void);

bool *new_box_autoadd_bool_0(bool value);

struct wire_DatabaseConfig *new_box_autoadd_database_config_0(void);

struct wire_ED25519FromSeedReq *new_box_autoadd_ed_25519_from_seed_req_0(void);

struct wire_ED25519SignReq *new_box_autoadd_ed_25519_sign_req_0(void);

struct wire_ED25519VerifyReq *new_box_autoadd_ed_25519_verify_req_0(void);

struct wire_ElectrumConfig *new_box_autoadd_electrum_config_0(void);

struct wire_EsploraConfig *new_box_autoadd_esplora_config_0(void);

float *new_box_autoadd_f32_0(float value);

struct wire_P256FromSeedReq *new_box_autoadd_p_256_from_seed_req_0(void);

struct wire_P256ShareSecretReq *new_box_autoadd_p_256_share_secret_req_0(void);

struct wire_P256SignWithSeedReq *new_box_autoadd_p_256_sign_with_seed_req_0(void);

struct wire_P256VerifyReq *new_box_autoadd_p_256_verify_req_0(void);

struct wire_PBKDFDeriveReq *new_box_autoadd_pbkdf_derive_req_0(void);

struct wire_PhraseToSeedReq *new_box_autoadd_phrase_to_seed_req_0(void);

struct wire_RbfValue *new_box_autoadd_rbf_value_0(void);

struct wire_RpcConfig *new_box_autoadd_rpc_config_0(void);

struct wire_RpcSyncParams *new_box_autoadd_rpc_sync_params_0(void);

struct wire_SchnorrFromSeedReq *new_box_autoadd_schnorr_from_seed_req_0(void);

struct wire_SchnorrSignWithSeedReq *new_box_autoadd_schnorr_sign_with_seed_req_0(void);

struct wire_SchnorrVerifyReq *new_box_autoadd_schnorr_verify_req_0(void);

struct wire_Script *new_box_autoadd_script_0(void);

struct wire_ScriptDeriveReq *new_box_autoadd_script_derive_req_0(void);

struct wire_Secp256k1FromSeedReq *new_box_autoadd_secp_256_k_1_from_seed_req_0(void);

struct wire_Secp256k1RecoverReq *new_box_autoadd_secp_256_k_1_recover_req_0(void);

struct wire_Secp256k1ShareSecretReq *new_box_autoadd_secp_256_k_1_share_secret_req_0(void);

struct wire_Secp256k1SignWithRngReq *new_box_autoadd_secp_256_k_1_sign_with_rng_req_0(void);

struct wire_Secp256k1SignWithSeedReq *new_box_autoadd_secp_256_k_1_sign_with_seed_req_0(void);

struct wire_Secp256k1VerifyReq *new_box_autoadd_secp_256_k_1_verify_req_0(void);

struct wire_SeedToKeyReq *new_box_autoadd_seed_to_key_req_0(void);

struct wire_SignOptions *new_box_autoadd_sign_options_0(void);

struct wire_SledDbConfiguration *new_box_autoadd_sled_db_configuration_0(void);

struct wire_SqliteDbConfiguration *new_box_autoadd_sqlite_db_configuration_0(void);

uint32_t *new_box_autoadd_u32_0(uint32_t value);

uint64_t *new_box_autoadd_u64_0(uint64_t value);

uint8_t *new_box_autoadd_u8_0(uint8_t value);

struct wire_UserPass *new_box_autoadd_user_pass_0(void);

struct wire_list_foreign_utxo *new_list_foreign_utxo_0(int32_t len);

struct wire_list_out_point *new_list_out_point_0(int32_t len);

struct wire_list_script_amount *new_list_script_amount_0(int32_t len);

struct wire_list_tx_bytes *new_list_tx_bytes_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void drop_opaque_BdkDescriptor(const void *ptr);

const void *share_opaque_BdkDescriptor(const void *ptr);

void drop_opaque_BlockchainInstance(const void *ptr);

const void *share_opaque_BlockchainInstance(const void *ptr);

void drop_opaque_WalletInstance(const void *ptr);

const void *share_opaque_WalletInstance(const void *ptr);

union AddressIndexKind *inflate_AddressIndex_Peek(void);

union AddressIndexKind *inflate_AddressIndex_Reset(void);

union BlockchainConfigKind *inflate_BlockchainConfig_Electrum(void);

union BlockchainConfigKind *inflate_BlockchainConfig_Esplora(void);

union BlockchainConfigKind *inflate_BlockchainConfig_Rpc(void);

union DatabaseConfigKind *inflate_DatabaseConfig_Sqlite(void);

union DatabaseConfigKind *inflate_DatabaseConfig_Sled(void);

union RbfValueKind *inflate_RbfValue_Value(void);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_mnemonic_phrase_to_seed);
    dummy_var ^= ((int64_t) (void*) wire_mnemonic_seed_to_key);
    dummy_var ^= ((int64_t) (void*) wire_bls_init);
    dummy_var ^= ((int64_t) (void*) wire_bls_verify);
    dummy_var ^= ((int64_t) (void*) wire_ed25519_from_seed);
    dummy_var ^= ((int64_t) (void*) wire_ed25519_sign);
    dummy_var ^= ((int64_t) (void*) wire_ed25519_verify);
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_from_seed);
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_sign);
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_sign_with_rng);
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_sign_recoverable);
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_verify);
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_get_shared_secret);
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_recover);
    dummy_var ^= ((int64_t) (void*) wire_p256_from_seed);
    dummy_var ^= ((int64_t) (void*) wire_p256_sign);
    dummy_var ^= ((int64_t) (void*) wire_p256_verify);
    dummy_var ^= ((int64_t) (void*) wire_p256_get_shared_secret);
    dummy_var ^= ((int64_t) (void*) wire_schnorr_from_seed);
    dummy_var ^= ((int64_t) (void*) wire_schnorr_sign);
    dummy_var ^= ((int64_t) (void*) wire_schnorr_verify);
    dummy_var ^= ((int64_t) (void*) wire_aes_128_ctr_encrypt);
    dummy_var ^= ((int64_t) (void*) wire_aes_128_ctr_decrypt);
    dummy_var ^= ((int64_t) (void*) wire_aes_256_cbc_encrypt);
    dummy_var ^= ((int64_t) (void*) wire_aes_256_cbc_decrypt);
    dummy_var ^= ((int64_t) (void*) wire_aes_256_gcm_encrypt);
    dummy_var ^= ((int64_t) (void*) wire_aes_256_gcm_decrypt);
    dummy_var ^= ((int64_t) (void*) wire_pbkdf2_derive_key);
    dummy_var ^= ((int64_t) (void*) wire_scrypt_derive_key);
    dummy_var ^= ((int64_t) (void*) wire_create_blockchain__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_height__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_blockchain_hash__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_estimate_fee__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_broadcast__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_tx__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_create_transaction__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_tx_txid__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_weight__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_size__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_vsize__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_serialize_tx__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_is_coin_base__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_is_explicitly_rbf__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_is_lock_time_enabled__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_version__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_lock_time__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_input__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_output__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_serialize_psbt__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_psbt_txid__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_extract_tx__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_psbt_fee_rate__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_psbt_fee_amount__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_combine_psbt__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_json_serialize__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_inputs__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_tx_builder_finish__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_tx_cal_fee_finish__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_bump_fee_tx_builder_finish__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_create_descriptor__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_new_bip44_descriptor__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_new_bip44_public__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_new_bip49_descriptor__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_new_bip49_public__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_new_bip84_descriptor__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_new_bip84_public__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_new_bip86_descriptor__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_new_bip86_public__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_as_string_private__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_as_string__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_derive_address_at__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_create_descriptor_secret__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_create_derived_descriptor_secret__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_descriptor_secret_from_string__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_extend_descriptor_secret__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_derive_descriptor_secret__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_as_secret_bytes__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_as_public__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_pub_from_secret_bytes__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_create_derivation_path__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_descriptor_public_from_string__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_master_finterprint__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_create_descriptor_public__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_to_public_string__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_create_script__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_create_address__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_address_from_script__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_address_to_script_pubkey__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_payload__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_address_network__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_address_type__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_create_wallet__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_address__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_internal_address__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_sync_wallet__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_sync_wallet_thread__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_balance__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_list_unspent_outputs__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_get_transactions__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_sign__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_wallet_network__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_list_unspent__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_cache_address__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_generate_seed_from_word_count__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_generate_seed_from_string__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_generate_seed_from_entropy__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_bip322_sign_segwit__static_method__Api);
    dummy_var ^= ((int64_t) (void*) wire_bip322_sign_taproot__static_method__Api);
    dummy_var ^= ((int64_t) (void*) new_BdkDescriptor);
    dummy_var ^= ((int64_t) (void*) new_BlockchainInstance);
    dummy_var ^= ((int64_t) (void*) new_WalletInstance);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_BdkDescriptor_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_address_index_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_aes_decrypt_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_aes_encrypt_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_blockchain_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_bls_verify_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_bool_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_database_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ed_25519_from_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ed_25519_sign_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ed_25519_verify_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_electrum_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_esplora_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_f32_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_p_256_from_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_p_256_share_secret_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_p_256_sign_with_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_p_256_verify_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_pbkdf_derive_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_phrase_to_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_rbf_value_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_rpc_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_rpc_sync_params_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_schnorr_from_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_schnorr_sign_with_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_schnorr_verify_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_script_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_script_derive_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_secp_256_k_1_from_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_secp_256_k_1_recover_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_secp_256_k_1_share_secret_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_secp_256_k_1_sign_with_rng_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_secp_256_k_1_sign_with_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_secp_256_k_1_verify_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_seed_to_key_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_sign_options_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_sled_db_configuration_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_sqlite_db_configuration_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u32_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u64_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u8_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_user_pass_0);
    dummy_var ^= ((int64_t) (void*) new_list_foreign_utxo_0);
    dummy_var ^= ((int64_t) (void*) new_list_out_point_0);
    dummy_var ^= ((int64_t) (void*) new_list_script_amount_0);
    dummy_var ^= ((int64_t) (void*) new_list_tx_bytes_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) drop_opaque_BdkDescriptor);
    dummy_var ^= ((int64_t) (void*) share_opaque_BdkDescriptor);
    dummy_var ^= ((int64_t) (void*) drop_opaque_BlockchainInstance);
    dummy_var ^= ((int64_t) (void*) share_opaque_BlockchainInstance);
    dummy_var ^= ((int64_t) (void*) drop_opaque_WalletInstance);
    dummy_var ^= ((int64_t) (void*) share_opaque_WalletInstance);
    dummy_var ^= ((int64_t) (void*) inflate_AddressIndex_Peek);
    dummy_var ^= ((int64_t) (void*) inflate_AddressIndex_Reset);
    dummy_var ^= ((int64_t) (void*) inflate_BlockchainConfig_Electrum);
    dummy_var ^= ((int64_t) (void*) inflate_BlockchainConfig_Esplora);
    dummy_var ^= ((int64_t) (void*) inflate_BlockchainConfig_Rpc);
    dummy_var ^= ((int64_t) (void*) inflate_DatabaseConfig_Sqlite);
    dummy_var ^= ((int64_t) (void*) inflate_DatabaseConfig_Sled);
    dummy_var ^= ((int64_t) (void*) inflate_RbfValue_Value);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
