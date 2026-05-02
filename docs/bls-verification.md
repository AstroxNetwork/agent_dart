
# BLS Signature Verification Guide for AstroxNetwork/agent_dart

This guide explains how to use the `AgentBLS` class in the AstroxNetwork/agent_dart package to verify BLS signatures.

## Overview

BLS (Boneh-Lynn-Shacham) signatures are a type of threshold signature scheme that allows multiple parties to jointly sign a message without revealing their individual keys. The `AgentBLS` class provides functionality to verify BLS signatures in Dart applications.

## Prerequisites

Before using the BLS verification functionality, you need to:

1. Add the `agent_dart_base` package to your `pubspec.yaml`:
```yaml
dependencies:
  agent_dart_base: ^<latest_version>
```

2. Initialize the BLS library by calling `blsInit()` before any verification operations.

## Basic Usage

### 1. Initialize the BLS Library

```dart
import 'package:agent_dart_base/agent_dart_base.dart';

void main() async {
  // Create an instance of AgentBLS
  final AgentBLS bls = AgentBLS();

  // Initialize the BLS library
  final bool isInitialized = await bls.blsInit();

  if (!isInitialized) {
    print('Failed to initialize BLS library');
    return;
  }

  // Now you can perform signature verification
}
```

### 2. Verify a BLS Signature

To verify a BLS signature, you need three components:
- Public key (`pk`)
- Signature (`sig`)
- Message (`msg`)

```dart
import 'dart:typed_data';

Future<void> verifySignature() async {
  // Example values (replace with your actual values)
  final String publicKeyHex =
    'a7623a93cdb56c4d23d99c14216afaab3dfd6d4f9eb3db23d038280b6d5cb2caaee2a19dd92c9df7001dede23bf036bc0f33982dfb41e8fa9b8e96b5dc3e83d55ca4dd146c7eb2e8b6859cb5a5db815db86810b8d12cee1588b5dbf34a4dc9a5';

  final String signatureHex =
    'b89e13a212c830586eaa9ad53946cd968718ebecc27eda849d9232673dcd4f440e8b5df39bf14a88048c15e16cbcaabe';

  final String message = 'hello';

  // Convert hex strings to Uint8List
  final Uint8List pk = Uint8List.fromList(
    publicKeyHex.split('').where((c) => c != ' ').map((c) => int.parse(c, radix: 16)).toList()
  );

  final Uint8List sig = Uint8List.fromList(
    signatureHex.split('').where((c) => c != ' ').map((c) => int.parse(c, radix: 64)).toList()
  );

  final Uint8List msg = message.codeUnits;

  // Verify the signature
  final bool isValid = await bls.blsVerify(pk, sig, msg);

  print('Signature is ${isValid ? 'valid' : 'invalid'}');
}
```

### 3. Helper Methods for Hex Conversion

For convenience, you can use these helper methods to convert hex strings to Uint8List:

```dart
Uint8List hexToUint8List(String hexString) {
  return Uint8List.fromList(
    hexString.split('').where((c) => c != ' ').map((c) => int.parse(c, radix: 16)).toList()
  );
}

Uint8List hexToUint8ListForSignature(String hexString) {
  // For signatures, we need to parse in base 64 (radix: 64)
  return Uint8List.fromList(
    hexString.split('').where((c) => c != ' ').map((c) => int.parse(c, radix: 64)).toList()
  );
}
```

## Complete Example

Here's a complete example that demonstrates how to verify a BLS signature:

```dart
import 'dart:typed_data';
import 'package:agent_dart_base/agent_dart_base.dart';

Future<void> main() async {
  // Initialize BLS
  final AgentBLS bls = AgentBLS();
  final bool isInitialized = await bls.blsInit();

  if (!isInitialized) {
    print('Failed to initialize BLS library');
    return;
  }

  // Example values
  final String publicKeyHex =
    'a7623a93cdb56c4d23d99c14216afaab3dfd6d4f9eb3db23d038280b6d5cb2caaee2a19dd92c9df7001dede23bf036bc0f33982dfb41e8fa9b8e96b5dc3e83d55ca4dd146c7eb2e8b6859cb5a5db815db86810b8d12cee1588b5dbf34a4dc9a5';

  final String signatureHex =
    'b89e13a212c830586eaa9ad53946cd968718ebecc27eda849d9232673dcd4f440e8b5df39bf14a88048c15e16cbcaabe';

  final String message = 'hello';

  // Convert hex strings to Uint8List
  final Uint8List pk = hexToUint8List(publicKeyHex);
  final Uint8List sig = hexToUint8ListForSignature(signatureHex);
  final Uint8List msg = message.codeUnits;

  // Verify the signature
  final bool isValid = await bls.blsVerify(pk, sig, msg);

  print('Message: $message');
  print('Signature is ${isValid ? 'valid' : 'invalid'}');
}

Uint8List hexToUint8List(String hexString) {
  return Uint8List.fromList(
    hexString.split('').where((c) => c != ' ').map((c) => int.parse(c, radix: 16)).toList()
  );
}

Uint8List hexToUint8ListForSignature(String hexString) {
  return Uint8List.fromList(
    hexString.split('').where((c) => c != ' ').map((c) => int.parse(c, radix: 64)).toList()
  );
}
```

## Error Handling

When verifying BLS signatures, you should handle potential errors:

```dart
try {
  final bool isValid = await bls.blsVerify(pk, sig, msg);
  if (!isValid) {
    print('Signature verification failed');
  }
} catch (e) {
  print('Error during signature verification: $e');
}
```

## Notes

1. The BLS library must be initialized before any verification operations.
2. The public key, signature, and message must be provided as Uint8List objects.
3. For production use, consider adding proper error handling and validation of input data.
4. The example uses hardcoded hex values for demonstration. In a real application, you would use actual public keys, signatures, and messages.

## Summary

The `AgentBLS` class provides a simple interface for verifying BLS signatures in Dart applications. By following the steps in this guide, you can integrate BLS signature verification into your applications to ensure message authenticity and integrity.

Completed BLS verification guide for [AstroxNetwork/agent_dart].
