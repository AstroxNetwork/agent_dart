
# Identity Reference for Agent Dart

This document provides a reference for creating and using Identity and Principal classes in the Agent Dart library.

---

## Creating a Principal

A Principal represents an identity in the Internet Computer Protocol (ICP). There are several ways to create a Principal:

### From String (Text Format)

```dart
import 'package:agent_dart_base/agent_dart_base.dart';

// Create a Principal from a text string
Principal principal = Principal.fromText('2chl6-4hpzw-vqaaa-aaaaa-c');
```

### From Hex String

```dart
// Create a Principal from a hex string
Principal principal = Principal.fromHex('EFCDAB000000000001');
```

### From Uint8List

```dart
// Create a Principal from a Uint8List
Uint8List principalBytes = Uint8List.fromList([0xEF, 0xCD, 0xAB, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]);
Principal principal = Principal(principalBytes);
```

### Special Principals

```dart
// Create an anonymous Principal
Principal anonymous = Principal.anonymous();

// Create a self-authenticating Principal from a public key
Uint8List publicKey = Uint8List.fromList([...]);
Principal selfAuthenticating = Principal.selfAuthenticating(publicKey);
```

---

## Creating an Ed25519KeyIdentity

An Ed25519KeyIdentity represents an Ed25519 cryptographic key pair for signing operations.

### Generate a New Identity

```dart
import 'package:agent_dart_base/agent_dart_base.dart';

// Generate a new Ed25519KeyIdentity
Future<void> createIdentity() async {
  Ed25519KeyIdentity identity = await Ed25519KeyIdentity.generate();
  print('Generated identity: ${identity.toJson()}');
}
```

### From Key Pair

```dart
// Create from a public key and private key
Uint8List publicKey = Uint8List.fromList([...]);
Uint8List privateKey = Uint8List.fromList([...]);
Ed25519KeyIdentity identity = Ed25519KeyIdentity.fromKeyPair(publicKey, privateKey);
```

### From JSON

```dart
// Create from JSON representation
String json = '[publicKeyHex, privateKeyHex]';
Ed25519KeyIdentity identity = Ed25519KeyIdentity.fromJSON(json);
```

### From Seed Phrase (Internet Identity)

```dart
// Recover an identity from an Internet Identity seed phrase
Future<void> recoverFromSeedPhrase() async {
  String phrase = 'your seed phrase here';
  Ed25519KeyIdentityRecoveredFromII result = await Ed25519KeyIdentity.recoverFromIISeedPhrase(phrase);
  print('Recovered identity: ${result.identity.toJson()}');
}
```

---

## Using the Identity

Once you have an identity, you can use it to sign messages and get its principal:

```dart
// Get the principal associated with the identity
Principal principal = identity.getPrincipal();

// Sign a message
Future<void> signMessage() async {
  Uint8List message = Uint8List.fromList([...]);
  Uint8List signature = await identity.sign(message);
  print('Signature: ${signature.toHex()}');
}
```

---

## Summary

- **Principal**: Represents an identity in the ICP network, can be created from various formats
- **Ed25519KeyIdentity**: Represents an Ed25519 cryptographic key pair for signing operations
- **Key Methods**:
  - `Principal.fromText()`: Create from text string
  - `Principal.fromHex()`: Create from hex string
  - `Ed25519KeyIdentity.generate()`: Generate a new identity
  - `Ed25519KeyIdentity.fromKeyPair()`: Create from key pair
  - `Ed25519KeyIdentity.fromJSON()`: Create from JSON
  - `identity.getPrincipal()`: Get the principal associated with an identity
  - `identity.sign()`: Sign a message with the identity

---

## Complete Example

Here's a complete example of creating a Principal and an Ed25519KeyIdentity:

```dart
import 'package:agent_dart_base/agent_dart_base.dart';

Future<void> main() async {
  // Create a Principal from text
  Principal principal = Principal.fromText('2chl6-4hpzw-vqaaa-aaaaa-c');
  print('Principal: ${principal.toText()}');

  // Generate a new Ed25519KeyIdentity
  Ed25519KeyIdentity identity = await Ed25519KeyIdentity.generate();
  print('Generated identity: ${identity.toJson()}');

  // Get the principal from the identity
  Principal identityPrincipal = identity.getPrincipal();
  print('Identity principal: ${identityPrincipal.toText()}');

  // Sign a message
  Uint8List message = Uint8List.fromList([...]);
  Uint8List signature = await identity.sign(message);
  print('Signature: ${signature.toHex()}');
}
```

