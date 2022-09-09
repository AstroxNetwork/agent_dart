#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

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

typedef struct wire_Secp256k1VerifyReq {
  struct wire_uint_8_list *message_hash;
  struct wire_uint_8_list *signature_bytes;
  struct wire_uint_8_list *public_key_bytes;
} wire_Secp256k1VerifyReq;

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

typedef struct wire_KeccakReq {
  struct wire_uint_8_list *message;
} wire_KeccakReq;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

typedef int64_t Chunk;

#define BMASK ((1 << BASEBITS) - 1)

#define HMASK ((1 << HBITS) - 1)



#define TMASK ((1 << TBITS) - 1)

#define MCONST 140737475470229501

void store_dart_post_cobject(DartPostCObjectFnType ptr);

void wire_mnemonic_phrase_to_seed(int64_t port_, struct wire_PhraseToSeedReq *req);

void wire_mnemonic_seed_to_key(int64_t port_, struct wire_SeedToKeyReq *req);

void wire_bls_init(int64_t port_);

void wire_bls_verify(int64_t port_, struct wire_BLSVerifyReq *req);

void wire_ed25519_from_seed(int64_t port_, struct wire_ED25519FromSeedReq *req);

void wire_ed25519_sign(int64_t port_, struct wire_ED25519SignReq *req);

void wire_ed25519_verify(int64_t port_, struct wire_ED25519VerifyReq *req);

void wire_secp256k1_from_seed(int64_t port_, struct wire_Secp256k1FromSeedReq *req);

void wire_secp256k1_sign(int64_t port_, struct wire_Secp256k1SignWithSeedReq *req);

void wire_secp256k1_verify(int64_t port_, struct wire_Secp256k1VerifyReq *req);

void wire_aes_128_ctr_encrypt(int64_t port_, struct wire_AesEncryptReq *req);

void wire_aes_128_ctr_decrypt(int64_t port_, struct wire_AesDecryptReq *req);

void wire_pbkdf2_derive_key(int64_t port_, struct wire_PBKDFDeriveReq *req);

void wire_scrypt_derive_key(int64_t port_, struct wire_ScriptDeriveReq *req);

void wire_keccak256_encode(int64_t port_, struct wire_KeccakReq *req);

struct wire_AesDecryptReq *new_box_autoadd_aes_decrypt_req_0(void);

struct wire_AesEncryptReq *new_box_autoadd_aes_encrypt_req_0(void);

struct wire_BLSVerifyReq *new_box_autoadd_bls_verify_req_0(void);

struct wire_ED25519FromSeedReq *new_box_autoadd_ed_25519_from_seed_req_0(void);

struct wire_ED25519SignReq *new_box_autoadd_ed_25519_sign_req_0(void);

struct wire_ED25519VerifyReq *new_box_autoadd_ed_25519_verify_req_0(void);

struct wire_KeccakReq *new_box_autoadd_keccak_req_0(void);

struct wire_PBKDFDeriveReq *new_box_autoadd_pbkdf_derive_req_0(void);

struct wire_PhraseToSeedReq *new_box_autoadd_phrase_to_seed_req_0(void);

struct wire_ScriptDeriveReq *new_box_autoadd_script_derive_req_0(void);

struct wire_Secp256k1FromSeedReq *new_box_autoadd_secp_256_k_1_from_seed_req_0(void);

struct wire_Secp256k1SignWithSeedReq *new_box_autoadd_secp_256_k_1_sign_with_seed_req_0(void);

struct wire_Secp256k1VerifyReq *new_box_autoadd_secp_256_k_1_verify_req_0(void);

struct wire_SeedToKeyReq *new_box_autoadd_seed_to_key_req_0(void);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

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
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_verify);
    dummy_var ^= ((int64_t) (void*) wire_aes_128_ctr_encrypt);
    dummy_var ^= ((int64_t) (void*) wire_aes_128_ctr_decrypt);
    dummy_var ^= ((int64_t) (void*) wire_pbkdf2_derive_key);
    dummy_var ^= ((int64_t) (void*) wire_scrypt_derive_key);
    dummy_var ^= ((int64_t) (void*) wire_keccak256_encode);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_aes_decrypt_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_aes_encrypt_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_bls_verify_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ed_25519_from_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ed_25519_sign_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ed_25519_verify_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_keccak_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_pbkdf_derive_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_phrase_to_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_script_derive_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_secp_256_k_1_from_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_secp_256_k_1_sign_with_seed_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_secp_256_k_1_verify_req_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_seed_to_key_req_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}