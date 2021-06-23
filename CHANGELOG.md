## 0.0.1

* Initial release

## 0.0.2

* Added `webauth_provider`

## 0.0.3

* Added `Signer` to `Wallet`
* Added `Lock` and `unlock` to Wallet

## 0.0.4
revamp

## 0.0.5
* Added isolate to encrypt/decrypt phrase keystore because `scrypt` in dart is too slow. Thinking about added another ffi method like `ethsign` to complete the job however the `serde_json` is too large to bundle. Related issue: https://github.com/AstroxNetwork/agent_dart/issues/6


