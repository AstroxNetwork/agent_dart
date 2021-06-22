use super::bls::bls12381::bls::{
    core_verify,
    init,
    // BLS_FAIL,
    BLS_OK,
};
use ethsign::{keyfile::Crypto, Protected};
use hmac::Hmac;
use pbkdf2::pbkdf2;
use rustc_hex::{FromHex, FromHexError, ToHex};
use sha2::Sha512;
use std::convert::TryInto;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
// use std::str;
type HmacSha512 = Hmac<Sha512>;
const CRYPTO_ITERATIONS: u32 = 10240;

pub fn ext_pbkdf2(data: &[u8], salt: &[u8], rounds: u32) -> Vec<u8> {
    let mut result = [0u8; 64];

    // we cast to usize here - due to the WASM, we'd rather have u32 inputs
    pbkdf2::<HmacSha512>(
        data,
        salt,
        (rounds as usize).try_into().unwrap(),
        &mut result,
    );

    result.to_vec()
}

pub fn get_str(rust_ptr: *const c_char) -> String {
    let c_str = unsafe { CStr::from_ptr(rust_ptr) };
    let result_string = match c_str.to_str() {
        Err(_) => "Error: input string error",
        Ok(string) => string,
    };
    return String::from(result_string);
}

pub fn get_ptr(rust_string: &str) -> *mut c_char {
    CString::new(rust_string).unwrap().into_raw()
}

pub fn get_u8vec_from_ptr(rust_ptr: *const c_char) -> Vec<u8> {
    let message_result: Result<Vec<u8>, FromHexError> = get_str(rust_ptr).from_hex();
    return match message_result {
        Ok(c) => c,
        _ => panic!("Error: get_u8vec_from_ptr failed"),
    };
}
pub fn get_ptr_from_u8vec(u8vec: Vec<u8>) -> *mut c_char {
    let result: String = u8vec.to_hex();
    get_ptr(result.as_str())
}

#[no_mangle]
pub extern "C" fn rust_pbkdf2(
    data: *const c_char,
    salt: *const c_char,
    rounds: u32,
) -> *mut c_char {
    let result_vec = ext_pbkdf2(&get_u8vec_from_ptr(data), &get_u8vec_from_ptr(salt), rounds);
    get_ptr_from_u8vec(result_vec)
}

#[no_mangle]
pub extern "C" fn encrypt_data(data: *const c_char, password: *const c_char) -> *mut c_char {
    let password = Protected::new(get_str(password).into_bytes());
    let result_crypto = Crypto::encrypt(&get_str(data).as_bytes(), &password, CRYPTO_ITERATIONS);
    let crypto: Crypto = match result_crypto {
        Ok(c) => c,
        _ => return get_ptr(""),
    };
    let rust_string = serde_json::to_string(&crypto);
    let cipher_text = match rust_string {
        Ok(c) => c,
        _ => String::from(""),
    };
    get_ptr(&cipher_text)
}

#[no_mangle]
pub extern "C" fn decrypt_data(data: *const c_char, password: *const c_char) -> *mut c_char {
    let password = Protected::new(get_str(password).into_bytes());

    let result_crypto = serde_json::from_str(&get_str(data));
    let crypto: Crypto = match result_crypto {
        Ok(c) => c,
        _ => return get_ptr(""),
    };
    let decrypted_result = crypto.decrypt(&password);
    let decrypted = match decrypted_result {
        Ok(c) => c,
        _ => return get_ptr(""),
    };
    let rust_string = String::from_utf8(decrypted);
    let result_string = match rust_string {
        Ok(string) => string,
        _ => String::from(""),
    };
    get_ptr(&result_string)
}

#[no_mangle]
pub extern "C" fn bls_init() -> *mut c_char {
    let o = init();
    match o == BLS_OK {
        true => get_ptr("true"),
        false => get_ptr("false"),
    }
}

#[no_mangle]
pub extern "C" fn bls_verify(
    sig: *const c_char,
    m: *const c_char,
    w: *const c_char,
) -> *mut c_char {
    let verify = core_verify(
        &get_u8vec_from_ptr(sig),
        &get_u8vec_from_ptr(m),
        &get_u8vec_from_ptr(w),
    );
    match verify == BLS_OK {
        true => get_ptr("true"),
        false => get_ptr("false"),
    }
}

#[no_mangle]
pub extern "C" fn rust_cstr_free(s: *mut c_char) {
    unsafe {
        if s.is_null() {
            return;
        }
        CString::from_raw(s)
    };
}
