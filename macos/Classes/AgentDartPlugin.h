#import <FlutterMacOS/FlutterMacOS.h>

@interface AgentDartPlugin : NSObject<FlutterPlugin>
@end
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

#define MC_SHA2 2

#define MC_SHA3 3

#define SHA256 32

#define SHA384 48

#define SHA512 64

#define HASH224 28

#define HASH256 32

#define HASH384 48

#define HASH512 64

#define SHAKE128 16

#define SHAKE256 32

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

#define MAXPIN 10000

#define PBLEN 14

#define CURVE_COF_I 0

#define CURVE_B_I 4

#define USE_GLV true

#define USE_GS_G2 true

#define USE_GS_GT true

#define GT_STRONG false

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef int64_t Chunk;

#define BMASK ((1 << BASEBITS) - 1)

#define HMASK ((1 << HBITS) - 1)



#define TMASK ((1 << TBITS) - 1)

#define MCONST 140737475470229501

char *rust_greeting(const char *to);

void wire_bls_init(int64_t port_);

void wire_bls_verify(int64_t port_,
                     struct wire_uint_8_list *sig,
                     struct wire_uint_8_list *m,
                     struct wire_uint_8_list *w);

void wire_ed25519_from_seed(int64_t port_, struct wire_uint_8_list *seed);

void wire_ed25519_sign(int64_t port_,
                       struct wire_uint_8_list *seed,
                       struct wire_uint_8_list *message);

void wire_ed25519_verify(int64_t port_,
                         struct wire_uint_8_list *message,
                         struct wire_uint_8_list *sig,
                         struct wire_uint_8_list *pub_key);

void wire_secp256k1_from_seed(int64_t port_, struct wire_uint_8_list *seed);

void wire_secp256k1_sign(int64_t port_,
                         struct wire_uint_8_list *seed,
                         struct wire_uint_8_list *msg);

void wire_bip32_get_private(int64_t port_,
                            struct wire_uint_8_list *phrase,
                            struct wire_uint_8_list *password,
                            struct wire_uint_8_list *path);

void wire_bip32_to_seed_hash(int64_t port_,
                             struct wire_uint_8_list *phrase,
                             struct wire_uint_8_list *password);

struct wire_uint_8_list *new_uint_8_list(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_bls_init);
    dummy_var ^= ((int64_t) (void*) wire_bls_verify);
    dummy_var ^= ((int64_t) (void*) wire_ed25519_from_seed);
    dummy_var ^= ((int64_t) (void*) wire_ed25519_sign);
    dummy_var ^= ((int64_t) (void*) wire_ed25519_verify);
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_from_seed);
    dummy_var ^= ((int64_t) (void*) wire_secp256k1_sign);
    dummy_var ^= ((int64_t) (void*) wire_bip32_get_private);
    dummy_var ^= ((int64_t) (void*) wire_bip32_to_seed_hash);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}