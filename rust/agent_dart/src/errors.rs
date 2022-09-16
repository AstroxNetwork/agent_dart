/// Error information
use serde::*;
#[derive(Debug, Clone, Ord, PartialOrd, Eq, PartialEq, Serialize)]
pub struct ErrorInfo {
    /// Error code
    pub code: u32,
    /// Error message
    pub message: String,
}

impl ErrorInfo {
    pub fn to_json(&self) -> String {
        serde_json::to_string(self).unwrap()
    }
}
