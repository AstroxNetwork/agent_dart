# Getting started

Add `agent_dart` to your Dart or Flutter application:

```yaml
dependencies:
  agent_dart: ^1.0.0-dev.40
```

Import the package:

```dart
import 'package:agent_dart/agent_dart.dart';
```

## Connect to a canister

For most apps, create an `AgentFactory` from a canister ID, replica URL, and Candid service definition:

```dart
final factory = await AgentFactory.createAgent(
  canisterId: 'ryjl3-tyaaa-aaaaa-aaaba-cai',
  url: 'https://icp-api.io',
  idl: idlFactory,
  debug: false,
);

final actor = factory.actor;
```

Use `debug: true` only when connecting to a local replica. In debug mode the agent fetches a root key from the replica, which is useful locally but should not be enabled for mainnet.

## Anonymous calls

If no identity is supplied, the factory uses `AnonymousIdentity`. Anonymous identities can query public canister methods but cannot sign update calls that require authentication.

```dart
final anonymous = const AnonymousIdentity();
final principal = anonymous.getPrincipal();
```

## Signed calls

Use a signing identity when the canister method needs an authenticated caller:

```dart
final identity = await Ed25519KeyIdentity.generate(null);
final factory = await AgentFactory.createAgent(
  canisterId: canisterIdText,
  url: 'https://icp-api.io',
  idl: idlFactory,
  identity: identity,
  debug: false,
);
```

Persist generated identities carefully. `Ed25519KeyIdentity.toJson()` exports private key material, so store it only in secure storage.
