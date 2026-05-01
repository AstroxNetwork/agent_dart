
# Custom Identity Providers Guide

This guide explains how to implement your own `Identity` class in Dart to support hardware wallets or custom signing logic in the AstroxNetwork agent_dart library.

## Overview

The `agent_dart` library provides an abstract `Identity` class that defines the interface for authentication and signing operations. By implementing your own identity class, you can integrate with hardware wallets, custom signing services, or any other authentication mechanism.

## Identity Interface

The core `Identity` interface is defined in `auth.dart` and includes:

```dart
abstract class Identity {
  /// Get the principal represented by this identity
  Principal getPrincipal();

  /// Transform a request into a signed version of the request
  Future<dynamic> transformRequest(HttpAgentRequest request);
}
```

For signing capabilities, you should implement the `SignIdentity` interface:

```dart
abstract class SignIdentity implements Identity {
  /// Returns the public key that would match this identity's signature
  PublicKey getPublicKey();

  /// Signs a blob of data with this identity's private key
  Future<BinaryBlob> sign(BinaryBlob blob);

  // ... other methods
}
```

## Creating a Custom Identity

To create a custom identity, you need to:

1. Create a class that implements the `Identity` interface
2. If you need signing capabilities, implement the `SignIdentity` interface
3. Implement the required methods

### Example: Custom Signing Identity

Here's an example of a custom identity implementation:

```dart
import 'dart:typed_data';
import 'package:agent_dart_base/agent_dart_base.dart';

class CustomSignIdentity implements SignIdentity {
  final Uint8List _privateKey;
  final Uint8List _publicKey;

  CustomSignIdentity({
    required Uint8List privateKey,
    required Uint8List publicKey,
  })  : _privateKey = privateKey,
        _publicKey = publicKey;

  @override
  PublicKey getPublicKey() {
    // Return a PublicKey implementation with your public key
    return CustomPublicKey(_publicKey);
  }

  @override
  Future<Uint8List> sign(Uint8List blob) async {
    // Implement your custom signing logic here
    // This could call a hardware wallet or a remote signing service
    return _customSign(blob);
  }

  Future<Uint8List> _customSign(Uint8List blob) async {
    // Example implementation - replace with your actual signing logic
    // This could be a call to a hardware wallet or a remote service
    return Uint8List.fromList([0x01, 0x02, 0x03]); // Placeholder
  }

  @override
  Principal getPrincipal() {
    // Return the principal associated with this identity
    return Principal.selfAuthenticating(getPublicKey().toDer());
  }

  @override
  Future<dynamic> transformRequest(HttpAgentRequest request) async {
    // Transform the request to include the signature
    final body = request.body;
    final requestId = requestIdOf(body.toJson());

    return {
      ...request.toJson(),
      'body': {
        'content': request.body.toJson(),
        'sender_pubkey': getPublicKey().toDer(),
        'sender_sig': await sign(
          u8aConcat([
            '\x0Aic-request'.plainToU8a(), // Domain separator
            requestId.buffer,
          ]),
        ),
      },
    };
  }
}

class CustomPublicKey implements PublicKey {
  final Uint8List _publicKey;

  CustomPublicKey(this._publicKey);

  @override
  Uint8List toDer() {
    // Convert your public key to DER format
    return _publicKey;
  }
}
```

## Hardware Wallet Integration

To integrate with a hardware wallet, you'll need to:

1. Create a class that implements the `SignIdentity` interface
2. Implement the `sign` method to communicate with your hardware wallet
3. Use the wallet's SDK or API to perform the actual signing

### Example: Hardware Wallet Integration

```dart
import 'dart:typed_data';
import 'package:agent_dart_base/agent_dart_base.dart';
import 'package:hardware_wallet_sdk/hardware_wallet_sdk.dart';

class HardwareWalletIdentity implements SignIdentity {
  final HardwareWallet _wallet;
  final Uint8List _publicKey;

  HardwareWalletIdentity(this._wallet) : _publicKey = _wallet.getPublicKey();

  @override
  PublicKey getPublicKey() {
    return CustomPublicKey(_publicKey);
  }

  @override
  Future<Uint8List> sign(Uint8List blob) async {
    // Use the hardware wallet to sign the data
    return _wallet.sign(blob);
  }

  @override
  Principal getPrincipal() {
    return Principal.selfAuthenticating(getPublicKey().toDer());
  }

  @override
  Future<dynamic> transformRequest(HttpAgentRequest request) async {
    // Transform the request to include the signature
    final body = request.body;
    final requestId = requestIdOf(body.toJson());

    return {
      ...request.toJson(),
      'body': {
        'content': request.body.toJson(),
        'sender_pubkey': getPublicKey().toDer(),
        'sender_sig': await sign(
          u8aConcat([
            '\x0Aic-request'.plainToU8a(), // Domain separator
            requestId.buffer,
          ]),
        ),
      },
    };
  }
}
```

## Using Your Custom Identity

Once you've created your custom identity, you can use it with the agent:

```dart
import 'package:agent_dart_base/agent_dart_base.dart';

void main() async {
  // Create your custom identity
  final customIdentity = CustomSignIdentity(
    privateKey: Uint8List.fromList([...]), // Your private key
    publicKey: Uint8List.fromList([...]),  // Your public key
  );

  // Create an agent with your custom identity
  final agent = Agent(
    identity: customIdentity,
    // Other agent configuration
  );

  // Use the agent to make requests
  final response = await agent.fetch('https://example.com');
  print(response);
}
```

## Best Practices

1. **Security**: Always keep your private keys secure. Never expose them in client-side code.
2. **Error Handling**: Implement proper error handling for signing operations.
3. **Thread Safety**: Ensure your implementation is thread-safe if used in concurrent environments.
4. **Compatibility**: Make sure your implementation follows the same signing conventions as the existing identity implementations.

## Troubleshooting

If you encounter issues with your custom identity:

1. Verify that your public key is correctly formatted in DER format
2. Check that your signing implementation returns the correct signature format
3. Ensure your principal is correctly generated from the public key
4. Verify that the request transformation is properly including the signature

## Conclusion

By implementing custom identity providers, you can extend the functionality of the AstroxNetwork agent_dart library to support a wide range of authentication mechanisms, including hardware wallets and custom signing services.

This guide provides the foundation for creating your own identity implementations. You can adapt the examples provided to fit your specific requirements and integration needs.

