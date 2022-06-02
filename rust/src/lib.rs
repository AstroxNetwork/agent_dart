mod bridge_generated; /* AUTO INJECTED BY flutter_rust_bridge. This line may not be accurate, and you can change it according to your needs. */
extern crate core;

use std::ffi::{CStr, CString};
use std::os::raw::c_char;

#[allow(clippy::all)]
#[allow(dead_code)]
mod bls;

#[allow(dead_code)]
mod api;
mod bip32;
mod ed25519;
mod secp256k1;

#[no_mangle]
pub extern "C" fn rust_greeting(to: *const c_char) -> *mut c_char {
    let c_str = unsafe { CStr::from_ptr(to) };
    let recipient = match c_str.to_str() {
        Err(_) => "there",
        Ok(string) => string,
    };

    CString::new("Hello ".to_owned() + recipient)
        .unwrap()
        .into_raw()
}
