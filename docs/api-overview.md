# API overview

## Principals

`Principal` represents Internet Computer principals for users, canisters, and other IC entities.

Common operations:

- `Principal.fromText(text)` parses canonical text such as `aaaaa-aa`.
- `Principal.selfAuthenticating(publicKey)` derives a caller principal from a public key.
- `principal.toText()` returns canonical textual form.
- `principal.toAccountId()` derives an ICP ledger account identifier.

## Identities

`Identity` describes anything that can transform outgoing agent requests. `AnonymousIdentity` sends unsigned requests, while `SignIdentity` signs requests and derives a self-authenticating principal.

`Ed25519KeyIdentity` is the main signing identity:

- `Ed25519KeyIdentity.generate(seed)` creates a new identity from a 32-byte seed or random seed.
- `Ed25519KeyIdentity.fromJSON(json)` restores an exported identity.
- `identity.sign(blob)` signs request bytes.
- `identity.getPrincipal()` returns the caller principal.

## HTTP agent

`HttpAgent` implements the low-level IC agent interface. It sends query, update, read-state, and status requests to a replica.

Typical app code uses `AgentFactory`, which creates and configures an `HttpAgent` and actor together.

## Actors

`Actor` and `CanisterActor` turn a Candid `Service` into callable Dart methods.

- `Actor.createActor(service, config)` creates a canister actor.
- `actor.getFunc(name)` returns an `ActorMethod` for a Candid method.
- `ActorMethod.call(args)` invokes the method with default options.
- `ActorMethod.withOptions(options, args)` overrides call configuration for one invocation.

## Wallet and ledger helpers

The wallet package contains typed Candid models and helpers for ICP ledger operations. These models convert between Dart objects and the map/list shapes expected by Candid encoding.
