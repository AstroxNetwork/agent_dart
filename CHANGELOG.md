## 0.0.1

- Initial release

## 0.0.2

- Added `webauth_provider`

## 0.0.3

- Added `Signer` to `Wallet`
- Added `Lock` and `unlock` to Wallet

## 0.0.4

revamp

## 0.0.5

- Added isolate to encrypt/decrypt phrase keystore because `scrypt` in dart is too slow. Thinking about added another ffi method like `ethsign` to complete the job however the `serde_json` is too large to bundle. Related issue: https://github.com/AstroxNetwork/agent_dart/issues/6

## 0.0.6

- fix encode/decode

## 0.0.7

- added `static Ed25519KeyIdentityRecoveredFromII Ed25519KeyIdentity.recoverFromIISeedPhrase(String s)`

## 0.1.0

- linting and first milestone finished

## 0.1.1

- fix error decoding
- follow `agent-js` latest features
- fix readme

## 0.1.2

- fix delegation chain transformRequest

## 0.1.3

- fix delegation request sign and request_id

## 0.1.4

- added sourceType of II, plugWallet, keysmith with different settings since they use different derivePath to generate seed
- added `Signer.importPhrase` to use settings above
- added related tests

## 0.1.5

- **BREAKING** remove `ICPSigner.fromPrivatekey` and added `ICPSigner.fromSeed`
- Won't support import privatekey to signer anymore, may separate different signer, eg: `Secp256k1Signer` or `SchnorrSigner` in the future supporting different coin specs.

## 0.1.6

- Fix cbordecode in the Delegation
- Apply rosetta-api to current docker specs

## 0.1.7

- Use `blsSync` instead of async isolation

## 0.1.8

- fixed uri parser, added `path` to auth_client

## 0.1.9

- **BREAKING** the `auth_client` flow is a little bit change due to Internet Identity service won't give correct identity using local webpage like we use `webAuthProvider` here
- How ever we keep the provider here, because we may have other Identity Provider to give other solution.
- But we managed to change `auth_client` a bit.

## 0.1.10

- Added Secp256k1 Identity
- Added ledger with send and getBalance

## 0.1.11

- Fixed secp256k1 signature length

## 0.1.12

- Expose AgentFactory
- Fix Cbor with List<int> casting

## 0.1.13

- **Breaking** separating `auth_provider` to standalone `agent_dart_auth` package

## 0.1.14

- Minor Fix fetch and keysmith

## 0.1.14+1

- added archiver
- fix padding issue on signing method

## 0.1.15

- added Windows ffi support
- **IMPORTANT** fix candid parser with BigInt and others

## 0.1.15+1

- fix secp256k1 signature verifier

## 0.1.15+2

- fix build scripts incase dylib not found

## 0.1.16

- added principal to accountId
- added flutter web support
- regroup project structure
- fixed archiver overriding
- fixed bls on io
- fixed test compatible with flutter web

## 0.1.16+1

- fixed rosetta with latest mainnet apis
- fixed cbor with primitive types
- dart fmt all files

## 0.1.16+2

- added fromStorage to auth_client

## 0.1.17

- added CanisterId class
- fix rosetta api
- prevent secp256k1 weak signatures
- fix build scripts

## 0.1.17+1
- fix type annotation applied to dart 2.15.0

## 0.1.18
- added identity from pem
