<!-- Copyright 2022 The AstroX author. All rights reserved.
Use of this source code is governed by an Apache license
that can be found in the LICENSE file. -->

# Changelog

## 1.0.0-dev.22

- Correct invalid plugin references by marking FFI plugins.
- Remove duplicate `ios_AgentDart.framework`.

## 1.0.0-dev.21

- Upgrade FRB to 1.82.6.
- Improve the FFI helper when finding dynamic libraries.
- Improve how CMake bundle libraries on Windows and Linux.

## 1.0.0-dev.20

- Fix Darwin frameworks fetching during `pod install`.

## 1.0.0-dev.19

- Fix Darwin frameworks initialization during `pod install`.

## 1.0.0-dev.18

- Upgrade FRB and roll new artifacts to all platforms.
- Requires Dart 3.0.
- Revert `identityProviderDefault` to `https://identity.ic0.app`.

## 1.0.0-dev.17

- Fix composite query support in actor.ts.

## 1.0.0-dev.16

- Support composite_query in candid.

## 1.0.0-dev.15

- Support for Dart 3.0.

## 1.0.0-dev.14

- Send `methodName` into `pollForResponse`.
- Rename `Predicate` to `PollPredicate`.
- Rename `PollingResponseDoneException` to `PollingResponseNoReplyException`.
- Retry failed `call`, `query`, `read_state`, `status` requests.

## 1.0.0-dev.13

- Add HttpAgent.`fromUri` factory.

## 1.0.0-dev.12

- Add `canisterId` and `caller` for `PollingResponseException`.
- Declare return types for fields and methods.

## 1.0.0-dev.11

- Unify optional `password` for encrypt/decrypt methods.

## 1.0.0-dev.10

- Migrate `ic0.app` to `icp0.io`.
- Default to empty password for encrypt/decrypt Cbor messages.

## 1.0.0-dev.9

- Provide AES-256-GCM encryption/decryption instead of `AES-256-CBC`. (#54)

## 1.0.0-dev.8

- `BigInt` for polling exceptions' reject code. (#49)
- Add `Actor.createActorMethod`.
- Support secp256k1 from FFI.
- Add `CoinType`.

## 1.0.0-dev.7

- Fix RecordClass `covariant`.

## 1.0.0-dev.6

- `bnToHex` not produce `0x` by default.
- `hexFixLength` and `isHex` now use named arguments.
- Remove `isHexString` and `isHexadecimal`.
- Allow to configure `include0x` with `toHex`.
- Add `secp256K1SignRecoverable` with FFI upgrade.

## 1.0.0-dev.5

- Fix `isHex` and `isTestChain`.
- Remove `IdentityDescriptor`.

## 1.0.0-dev.4

- Improve all import/export sorts.
- Add `@immutable` as much as possible.
- Better construct for `RosettaTransaction` and `RecClass`.
- Make `PrimitiveType`'s constructor private.
- Constraint Android API support range to 23~32.

## 1.0.0-dev.3

- Use the correct super class for `HttpAgentCallRequest`. (#39)

## 1.0.0-dev.2

- Tweak ignored files for pub.dev.

## 1.0.0-dev.1

- Support FFI asynchronized methods with Rust bindings.
- Consist all namings, fields and constructors, including:
  - `fromMap` -> `fromJson`
  - `toJSON` -> `toJson`
- Better throws when exceptions occurred.
- Remove unused codes.

## 0.1.24+1

- Add the `cbor` argument for `defaultFetch` to allow non-cbor requests.
- Fix `rosetta` requests.

## 0.1.24

- Add `CurveType` for signers.
- Add `bits` getters for `FixedIntClass` and `FixedNatClass`.
- Adopt `Platform.environment` for Flutter 3.

## 0.1.23+1

- Fix issues when encoding `OptClass`.

## 0.1.23

- Add `encryptCborPhrase` method.

## 0.1.22+1

- **🩹 HotFix 🩹** Remove invalid asserts with `defaultFetch`. (#19)
- Remove unused tests.

## 0.1.22

- **💡 BREAKING CHANGE 💡** Fix fetch method type.
- Remove unused files.
- Use structured polling exceptions.
- Improve defaultFetch.
- Add `decryptCborPhrase`.

## 0.1.21

- Fix function name typos.
- Support `toJson` to candid.

## 0.1.20

- Remove unused files and functions.

## 0.1.19+4

- Use `archive: 3.3.0`.

## 0.1.19+3

- Use `Isolate.spawn` and Isolate.exit` to optimize isolate functions.

## 0.1.19+2

- Fix http request when IC returns dual headers using Flutter web.

## 0.1.19+1

- Skip...

## 0.1.19

- Use latest api of ledger.
- Fix encoder.

## 0.1.18

- Add identity from pem.

## 0.1.17+1

- Fix type annotation applied to dart 2.15.0.

## 0.1.17

- Add `CanisterId` class.
- Fix rosetta api.
- Prevent secp256k1 weak signatures.
- Fix build scripts.

## 0.1.16+2

- Add `fromStorage` to auth_client.

## 0.1.16+1

- Fix rosetta with latest mainnet APIs.
- Fix cbor with primitive types.
- Format all files.

## 0.1.16

- Add principal to accountId.
- Add Flutter web support.
- Regroup project structure.
- Fix archiver overriding.
- Fix bls on io.
- Fix test compatible with Flutter web.

## 0.1.15+2

- Fix build scripts incase `dylib` not found.

## 0.1.15+1

- Fix secp256k1 signature verifier.

## 0.1.15

- Add Windows FFI support.
- **IMPORTANT** Fix candid parser with `BigInt` and others.

## 0.1.14+1

- Add archiver.
- Fix padding issue on signing method.

## 0.1.14

- Minor Fix fetch and keysmith.

## 0.1.13

- **Breaking** separating `auth_provider` to standalone `agent_dart_auth` package.

## 0.1.12

- Expose `AgentFactory`.
- Fix Cbor with `List<int>` casting.

## 0.1.11

- Fix secp256k1 signature length.

## 0.1.10

- Add Secp256k1 Identity
- Add ledger with send and getBalance.

## 0.1.9

- **BREAKING** the `auth_client` flow is a little bit change
  due to Internet Identity service won't give correct
  identity using local webpage like we use `webAuthProvider` here.
- How ever we keep the provider here,
  because we may have other Identity Provider to give other solution.
  But we managed to change `auth_client` a bit.

## 0.1.8

- Fix Uri parser, added `path` to auth_client.

## 0.1.7

- Use `blsSync` instead of async isolation.

## 0.1.6

- Fix cbordecode in the Delegation.
- Apply rosetta-api to current docker specs.

## 0.1.5

- **BREAKING** remove `ICPSigner.fromPrivatekey` and added `ICPSigner.fromSeed`
- Won't support import privatekey to signer anymore, may separate different signer,
  eg: `Secp256k1Signer` or `SchnorrSigner` in the future supporting different coin specs.

## 0.1.4

- Add sourceType of II, plugWallet, keysmith with different settings
  since they use different derivePath to generate seed.
- Add `Signer.importPhrase` to use settings above
- Add related tests

## 0.1.3

- Fix delegation request sign and request_id.

## 0.1.2

- Fix delegation chain `transformRequest`.

## 0.1.1

- Fix error decoding.
- Follow `agent-js` latest features.
- Fix README.

## 0.1.0

- Linting and first milestone finished

## 0.0.7

- Add `Ed25519KeyIdentity.recoverFromIISeedPhrase`.

## 0.0.6

- fix encode/decode

## 0.0.5

- Add isolate to encrypt/decrypt phrase keystore because `scrypt` in dart is too slow.
  Thinking about added another FFI method like `ethsign`
  to complete the job however the `serde_json` is too large to bundle.
  Related issue: https://github.com/AstroxNetwork/agent_dart/issues/6

## 0.0.4

- Revamp.

## 0.0.3

- Add `Signer` to `Wallet`.
- Add `Lock` and `unlock` to Wallet.

## 0.0.2

- Add `webauth_provider`.

## 0.0.1

- Initial release.
