mod bridge_generated; /* AUTO INJECTED BY flutter_rust_bridge. This line may not be accurate, and you can change it according to your needs. */
extern crate core;

mod api;
mod bls_ffi;
mod errors;
mod keyring;
mod types;

#[allow(clippy::all)]
#[allow(dead_code)]
mod bls;
mod ed25519;
mod keystore;
mod secp256k1;
mod sha;

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert_eq!(result, 4);
    }
}
