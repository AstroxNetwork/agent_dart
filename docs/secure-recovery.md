
# Secure Seed Phrase Management Guide for AstroxNetwork/agent_dart

## Introduction

This guide provides best practices for securely using the `recoverFromIISeedPhrase` method in a Flutter application environment. The `recoverFromIISeedPhrase` method allows you to recover an identity from a seed phrase, which is essential for restoring access to your account.

## Understanding the Method

The `recoverFromIISeedPhrase` method in `Ed25519KeyIdentity` class is designed to recover an identity from a BIP-39 mnemonic seed phrase. It extracts the user number and the mnemonic phrase, then derives an identity using the SLIP-0010 standard.

### Key Considerations

1. **BIP-39 Compliance**: The seed phrase must be a valid BIP-39 mnemonic phrase.
2. **User Number**: The method supports an optional user number prefix (e.g., "123456 my mnemonic phrase").
3. **Derivation Path**: The method uses a specific derivation path (`m/44'/223'/0'/0'/0'`) to derive the identity.

## Secure Implementation in Flutter

### Step 1: Validate the Seed Phrase

Before using the `recoverFromIISeedPhrase` method, ensure the seed phrase is valid:

```dart
import 'package:agent_dart_base/wallet/phrase.dart';

Future<void> validateSeedPhrase(String seedPhrase) async {
  try {
    final phrase = Phrase.fromString(seedPhrase);
    print('Seed phrase is valid: ${phrase.mnemonic}');
  } catch (e) {
    print('Invalid seed phrase: $e');
    // Handle the error appropriately, e.g., show an error message to the user
  }
}
```

### Step 2: Recover Identity Safely

Use the `recoverFromIISeedPhrase` method to recover an identity:

```dart
import 'package:agent_dart_base/identity/ed25519.dart';

Future<void> recoverIdentity(String seedPhrase) async {
  try {
    final identity = await Ed25519KeyIdentity.recoverFromIISeedPhrase(seedPhrase);
    print('Successfully recovered identity with user number: ${identity.userNumber}');
    // Use the identity for further operations
  } catch (e) {
    print('Failed to recover identity: $e');
    // Handle the error appropriately
  }
}
```

### Step 3: Secure Storage of Seed Phrases

Never store seed phrases in plain text. Use secure storage mechanisms:

- **Encryption**: Encrypt the seed phrase using a strong encryption algorithm.
- **Keychain Services**: Utilize platform-specific secure storage solutions like the iOS Keychain or Android Keystore.
- **Biometric Authentication**: Combine seed phrase recovery with biometric verification.

### Example: Using Flutter Secure Storage

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> storeSeedPhraseSecurely(String seedPhrase) async {
  await storage.write(key: 'seedPhrase', value: seedPhrase);
}

Future<String?> retrieveSeedPhraseSecurely() async {
  return await storage.read(key: 'seedPhrase');
}
```

### Step 4: User Input Validation

Ensure user input is validated before processing:

```dart
Future<void> validateAndRecover(String userInput) async {
  // Check if the input contains a user number and a seed phrase
  if (!userInput.contains(' ')) {
    print('Invalid format: User number and seed phrase are required.');
    return;
  }

  // Validate and recover
  await recoverIdentity(userInput);
}
```

## Security Best Practices

### 1. Never Log or Display Seed Phrases

- Ensure seed phrases are never logged or displayed in plain text.
- Use secure input fields with visual masking.

### 2. Use Secure Communication

- Ensure all communication involving seed phrases is encrypted.
- Use HTTPS for all network requests.

### 3. Regular Security Audits

- Regularly audit your code for potential vulnerabilities.
- Keep the `agent_dart` library updated to the latest version.

### 4. User Education

- Educate users on the importance of securely storing their seed phrases.
- Provide clear instructions on how to securely backup and restore their accounts.

## Example: Full Secure Recovery Flow

Here's an example of a complete secure recovery flow in a Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:agent_dart_base/identity/ed25519.dart';
import 'package:agent_dart_base/wallet/phrase.dart';

class RecoveryScreen extends StatefulWidget {
  @override
  _RecoveryScreenState createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final TextEditingController _seedPhraseController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> _recoverIdentity() async {
    final seedPhrase = _seedPhraseController.text.trim();

    if (seedPhrase.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seed phrase cannot be empty.')),
      );
      return;
    }

    try {
      // Validate the seed phrase
      final phrase = Phrase.fromString(seedPhrase);
      print('Seed phrase is valid: ${phrase.mnemonic}');

      // Recover the identity
      final identity = await Ed25519KeyIdentity.recoverFromIISeedPhrase(seedPhrase);
      print('Successfully recovered identity with user number: ${identity.userNumber}');

      // Store securely
      await _storage.write(key: 'recoveredIdentity', value: identity.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Identity recovered successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recover Identity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _seedPhraseController,
              decoration: InputDecoration(
                labelText: 'Enter your seed phrase',
                hintText: 'e.g., 123456 my mnemonic phrase',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _recoverIdentity,
              child: Text('Recover Identity'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Conclusion

By following these best practices, you can securely implement the `recoverFromIISeedPhrase` method in your Flutter application. Always prioritize security and user education to protect sensitive data.

### Summary
- Validate seed phrases before processing.
- Use secure storage mechanisms.
- Never log or display seed phrases in plain text.
- Regularly audit your code and keep libraries updated.
- Educate users on secure practices.

This guide ensures that you can safely and securely use the `recoverFromIISeedPhrase` method in your Flutter app environment.
