
# Crypto Methods Reference Guide

This document provides a reference guide for the BLS and Secp256k1 cryptographic implementations in the Agent Dart library.

---

## Table of Contents
1. [BLS Implementation](#bls-implementation)
   - [How to Import](#how-to-import-bls)
   - [Basic Initialization](#basic-initialization-bls)
   - [Key Methods](#key-methods-bls)

2. [Secp256k1 Implementation](#secp256k1-implementation)
   - [How to Import](#how-to-import-secp256k1)
   - [Basic Initialization](#basic-initialization-secp256k1)
   - [Key Classes](#key-classes-secp256k1)
   - [Key Methods](#key-methods-secp256k1)

---

## BLS Implementation

### How to Import BLS
To use the BLS implementation, import the `agent_dart_base` package:

```dart
import 'package:agent_dart_base/agent/bls.dart';
```

### Basic Initialization BLS
Initialize the BLS module before using it:

```dart
final bls = AgentBLS();
await bls.blsInit(); // Initialize the BLS module
```

### Key Methods BLS
The BLS implementation provides the following key methods:

```dart
/// Verify a BLS signature
/// @param pk Public key
/// @param sig Signature
/// @param msg Message to verify
/// @return true if signature is valid, false otherwise
Future<bool> blsVerify(Uint8List pk, Uint8List sig, Uint8List msg);
```

---

## Secp256k1 Implementation

### How to Import Secp256k1
To use the Secp256k1 implementation, import the relevant classes:

```dart
import 'package:agent_dart_base/identity/secp256k1.dart';
import 'package:agent_dart_base/identity/identity.dart';
```

### Basic Initialization Secp256k1
The Secp256k1 implementation is initialized automatically when you create key pairs or identities.

### Key Classes Secp256k1
The Secp256k1 implementation includes these key classes:

1. **Secp256k1KeyPair**: Represents a key pair with public and secret keys
2. **Secp256k1KeyIdentity**: Represents a key identity with signing capabilities
3. **Secp256k1PublicKey**: Represents a public key

### Key Methods Secp256k1

#### Secp256k1KeyIdentity
```dart
/// Create a key identity from a JSON string
/// @param json JSON string containing public and private keys
/// @return Secp256k1KeyIdentity
factory Secp256k1KeyIdentity.fromJSON(String json);

/// Create a key identity from a parsed JSON list
/// @param obj List containing public and private keys
/// @return Secp256k1KeyIdentity
factory Secp256k1KeyIdentity.fromParsedJson(List<String> obj);

/// Create a key identity from a key pair
/// @param publicKey Public key
/// @param privateKey Private key
/// @return Secp256k1KeyIdentity
factory Secp256k1KeyIdentity.fromKeyPair(BinaryBlob publicKey, BinaryBlob privateKey);

/// Sign a message with the private key
/// @param blob Message to sign
/// @return Signature
Future<Uint8List> sign(Uint8List blob);

/// Get the public key
Secp256k1PublicKey getPublicKey();
```

#### Secp256k1PublicKey
```dart
/// Create a public key from raw bytes
/// @param rawKey Raw public key bytes
/// @return Secp256k1PublicKey
factory Secp256k1PublicKey.fromRaw(BinaryBlob rawKey);

/// Create a public key from DER encoded bytes
/// @param derKey DER encoded public key
/// @return Secp256k1PublicKey
factory Secp256k1PublicKey.fromDer(BinaryBlob derKey);

/// Convert to DER format
Uint8List toDer();

/// Get raw public key bytes
Uint8List toRaw();
```

#### Utility Methods
```dart
/// Sign a message with a secret key
/// @param message Message to sign
/// @param secretKey Secret key
/// @return Signature
Uint8List signSecp256k1(String message, BinaryBlob secretKey);

/// Sign a message asynchronously with a seed
/// @param blob Message to sign
/// @param seed Seed for signing
/// @return Signature
Future<Uint8List> signSecp256k1Async(Uint8List blob, Uint8List seed);

/// Verify a signature
/// @param message Message
/// @param signature Signature
/// @param publicKey Public key
/// @return true if signature is valid, false otherwise
bool verifySecp256k1(String message, Uint8List signature, Secp256k1PublicKey publicKey);

/// Recover public key from signature
/// @param preHashedMessage Pre-hashed message
/// @param signature Signature
/// @return Recovered public key
Future<Uint8List> recoverSecp256k1PubKey(Uint8List preHashedMessage, Uint8List signature);

/// Get shared secret
/// @param privateKey Private key
/// @param rawPublicKey Raw public key
/// @return Shared secret
Future<Uint8List> getECShareSecret(Uint8List privateKey, Uint8List rawPublicKey);
```

---

## Package Dependencies
The crypto implementations depend on the following packages:

- `agent_dart_base` (main package)
- `agent_dart_ffi` (for FFI bindings)
- `pointycastle` (for cryptographic operations)

To use these implementations, add the following to your `pubspec.yaml`:

```yaml
dependencies:
  agent_dart: ^latest-version
  # or if you need direct access to the base package:
  # agent_dart_base: ^latest-version
```

---

## Usage Example
Here's a basic example of how to use the Secp256k1 implementation:

```dart
import 'package:agent_dart_base/identity/secp256k1.dart';

void main() async {
  // Create a key identity from JSON
  final json = '["publicKeyHex", "privateKeyHex"]';
  final identity = Secp256k1KeyIdentity.fromJSON(json);

  // Sign a message
  final message = Uint8List.fromList([0x01, 0x02, 0x03]);
  final signature = await identity.sign(message);

  // Verify the signature
  final isValid = verifySecp256k1(
    message.toString(),
    signature,
    identity.getPublicKey()
  );

  print('Signature valid: $isValid');
}
```

---

## Notes
- Make sure to initialize the BLS module before using it.
- The Secp256k1 implementation uses FFI bindings for performance-critical operations.
- For production use, ensure proper error handling and validation of inputs.
