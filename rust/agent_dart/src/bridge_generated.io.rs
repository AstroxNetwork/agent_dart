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
pub extern "C" fn wire_schnorr_from_seed(port_: i64, req: *mut wire_Secp256k1FromSeedReq) {
    wire_schnorr_from_seed_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_schnorr_sign(port_: i64, req: *mut wire_SchnorrSignWithSeedReq) {
    wire_schnorr_sign_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_schnorr_verify(port_: i64, req: *mut wire_Secp256k1VerifyReq) {
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
pub extern "C" fn wire_pbkdf2_derive_key(port_: i64, req: *mut wire_PBKDFDeriveReq) {
    wire_pbkdf2_derive_key_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_scrypt_derive_key(port_: i64, req: *mut wire_ScriptDeriveReq) {
    wire_scrypt_derive_key_impl(port_, req)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_aes_decrypt_req_0() -> *mut wire_AesDecryptReq {
    support::new_leak_box_ptr(wire_AesDecryptReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_aes_encrypt_req_0() -> *mut wire_AesEncryptReq {
    support::new_leak_box_ptr(wire_AesEncryptReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_bls_verify_req_0() -> *mut wire_BLSVerifyReq {
    support::new_leak_box_ptr(wire_BLSVerifyReq::new_with_null_ptr())
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
pub extern "C" fn new_box_autoadd_pbkdf_derive_req_0() -> *mut wire_PBKDFDeriveReq {
    support::new_leak_box_ptr(wire_PBKDFDeriveReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_phrase_to_seed_req_0() -> *mut wire_PhraseToSeedReq {
    support::new_leak_box_ptr(wire_PhraseToSeedReq::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_schnorr_sign_with_seed_req_0() -> *mut wire_SchnorrSignWithSeedReq
{
    support::new_leak_box_ptr(wire_SchnorrSignWithSeedReq::new_with_null_ptr())
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
pub extern "C" fn new_box_autoadd_secp_256_k_1_share_secret_req_0(
) -> *mut wire_Secp256k1ShareSecretReq {
    support::new_leak_box_ptr(wire_Secp256k1ShareSecretReq::new_with_null_ptr())
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
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
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
impl Wire2Api<BLSVerifyReq> for wire_BLSVerifyReq {
    fn wire2api(self) -> BLSVerifyReq {
        BLSVerifyReq {
            signature: self.signature.wire2api(),
            message: self.message.wire2api(),
            public_key: self.public_key.wire2api(),
        }
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
impl Wire2Api<BLSVerifyReq> for *mut wire_BLSVerifyReq {
    fn wire2api(self) -> BLSVerifyReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<BLSVerifyReq>::wire2api(*wrap).into()
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
impl Wire2Api<SchnorrSignWithSeedReq> for *mut wire_SchnorrSignWithSeedReq {
    fn wire2api(self) -> SchnorrSignWithSeedReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SchnorrSignWithSeedReq>::wire2api(*wrap).into()
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
impl Wire2Api<Secp256k1ShareSecretReq> for *mut wire_Secp256k1ShareSecretReq {
    fn wire2api(self) -> Secp256k1ShareSecretReq {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Secp256k1ShareSecretReq>::wire2api(*wrap).into()
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
impl Wire2Api<SchnorrSignWithSeedReq> for wire_SchnorrSignWithSeedReq {
    fn wire2api(self) -> SchnorrSignWithSeedReq {
        SchnorrSignWithSeedReq {
            msg: self.msg.wire2api(),
            seed: self.seed.wire2api(),
            aux_rand: self.aux_rand.wire2api(),
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
impl Wire2Api<Secp256k1ShareSecretReq> for wire_Secp256k1ShareSecretReq {
    fn wire2api(self) -> Secp256k1ShareSecretReq {
        Secp256k1ShareSecretReq {
            seed: self.seed.wire2api(),
            public_key_raw_bytes: self.public_key_raw_bytes.wire2api(),
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

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

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
pub struct wire_SchnorrSignWithSeedReq {
    msg: *mut wire_uint_8_list,
    seed: *mut wire_uint_8_list,
    aux_rand: *mut wire_uint_8_list,
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
pub struct wire_Secp256k1ShareSecretReq {
    seed: *mut wire_uint_8_list,
    public_key_raw_bytes: *mut wire_uint_8_list,
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
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
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

impl NewWithNullPtr for wire_AesDecryptReq {
    fn new_with_null_ptr() -> Self {
        Self {
            key: core::ptr::null_mut(),
            iv: core::ptr::null_mut(),
            cipher_text: core::ptr::null_mut(),
        }
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

impl NewWithNullPtr for wire_BLSVerifyReq {
    fn new_with_null_ptr() -> Self {
        Self {
            signature: core::ptr::null_mut(),
            message: core::ptr::null_mut(),
            public_key: core::ptr::null_mut(),
        }
    }
}

impl NewWithNullPtr for wire_ED25519FromSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
        }
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

impl NewWithNullPtr for wire_ED25519VerifyReq {
    fn new_with_null_ptr() -> Self {
        Self {
            sig: core::ptr::null_mut(),
            message: core::ptr::null_mut(),
            pub_key: core::ptr::null_mut(),
        }
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

impl NewWithNullPtr for wire_PhraseToSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            phrase: core::ptr::null_mut(),
            password: core::ptr::null_mut(),
        }
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

impl NewWithNullPtr for wire_Secp256k1FromSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
        }
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

impl NewWithNullPtr for wire_Secp256k1SignWithSeedReq {
    fn new_with_null_ptr() -> Self {
        Self {
            msg: core::ptr::null_mut(),
            seed: core::ptr::null_mut(),
        }
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

impl NewWithNullPtr for wire_SeedToKeyReq {
    fn new_with_null_ptr() -> Self {
        Self {
            seed: core::ptr::null_mut(),
            path: core::ptr::null_mut(),
        }
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
