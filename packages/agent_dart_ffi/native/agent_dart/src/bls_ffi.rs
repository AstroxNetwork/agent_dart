use crate::bls::bls12381::bls::{core_verify, init, BLS_OK};
use crate::types::BLSVerifyReq;

pub struct BlsFFI {}

impl BlsFFI {
    pub fn bls_init() -> bool {
        init() == BLS_OK
    }

    pub fn bls_verify(req: BLSVerifyReq) -> bool {
        let verify = core_verify(
            req.signature.as_slice(),
            req.message.as_slice(),
            req.public_key.as_slice(),
        );
        verify == BLS_OK
    }
}
