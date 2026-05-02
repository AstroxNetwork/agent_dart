
# Astrox vs Ethers.js: Key Differences

## Introduction

This guide provides a comparison for Ethereum developers transitioning to the Internet Computer (IC) using Astrox Network's `agent_dart` library. We'll compare key concepts from Ethers.js to their equivalents in Astrox.

---

## Provider vs HttpAgent

### Ethers.js Provider
- **Purpose**: Connects to Ethereum nodes to read data and send transactions
- **Types**:
  - `JsonRpcProvider`: Connects to JSON-RPC endpoints
  - `Web3Provider`: Connects to Ethereum nodes via WebSocket
- **Key Features**:
  - Asynchronous data fetching
  - Transaction signing and sending
  - Event listening capabilities
  - Supports multiple Ethereum networks

### Astrox HttpAgent
- **Purpose**: Connects to the Internet Computer (IC) to interact with canisters
- **Key Features**:
  ```dart
  import 'package:astrox/agent.dart';

  final agent = HttpAgent(
    url: 'https://ic0.app', // IC endpoint
    // Optional: Add custom headers or authentication
  );
  ```
  - **Canister Interaction**: Fetch data from canisters using `agent.query()`
  - **Transaction Submission**: Submit updates to canisters using `agent.update()`
  - **Async Operations**: Similar async pattern to Ethers.js
  - **Network Flexibility**: Can connect to different IC endpoints

---

## Wallet vs Identity

### Ethers.js Wallet
- **Purpose**: Manages private keys and signs transactions
- **Key Features**:
  - Private key management
  - Transaction signing
  - Derived addresses
  - Supports multiple wallet types (HD wallets, hardware wallets)

### Astrox Identity
- **Purpose**: Manages authentication and authorization for IC interactions
- **Key Features**:
  ```dart
  final identity = LocalIdentity.fromSeedBytes(seedBytes);
  final agent = HttpAgent(url: 'https://ic0.app');
  agent.setIdentity(identity);
  ```
  - **Authentication**: Uses IC authentication mechanisms
  - **Key Management**: Handles IC-specific authentication keys
  - **Canister Access**: Grants access to specific canisters
  - **Derived Keys**: Generates IC-compatible authentication keys

---

## Key Differences Summary

| Feature          | Ethers.js Provider | Astrox HttpAgent |
|------------------|--------------------|------------------|
| Network          | Ethereum           | Internet Computer|
| Primary Use      | Blockchain data    | Canister data    |
| Connection Method| JSON-RPC/WebSocket | HTTP/HTTPS       |
| Transaction Type | Ethereum txs       | IC update calls  |

| Feature          | Ethers.js Wallet   | Astrox Identity  |
|------------------|--------------------|------------------|
| Key Type         | Ethereum private key | IC authentication key |
| Primary Use      | Signing Ethereum txs | IC authentication |
| Network          | Ethereum           | Internet Computer|
| Key Management   | HD wallets, hardware | IC-specific auth |

---

## Migration Guide

1. **Replace Provider with HttpAgent**:
   ```dart
   // Ethers.js
   const provider = new ethers.providers.JsonRpcProvider('ETH_RPC_URL');

   // Astrox
   final agent = HttpAgent(url: 'IC_ENDPOINT');
   ```

2. **Replace Wallet with Identity**:
   ```dart
   // Ethers.js
   const wallet = new ethers.Wallet(privateKey);

   // Astrox
   final identity = LocalIdentity.fromSeedBytes(seedBytes);
   agent.setIdentity(identity);
   ```

3. **Update Transaction Patterns**:
   - Replace `provider.sendTransaction()` with `agent.update()`
   - Replace `wallet.signTransaction()` with identity-based authentication

---

## Example: Reading Data

### Ethers.js
```javascript
const balance = await provider.getBalance(address);
```

### Astrox
```dart
final canisterId = 'your-canister-id';
final result = await agent.query(canisterId, 'get_balance');
```

---

## Example: Sending Transactions

### Ethers.js
```javascript
const tx = await wallet.sendTransaction({
  to: recipient,
  value: ethers.utils.parseEther('1.0')
});
```

### Astrox
```dart
final updateResult = await agent.update(canisterId, 'transfer', [
  recipient,
  BigInt.from(1000000000) // 1 ICPT equivalent
]);
```

---

## Conclusion

This guide provides a foundation for Ethereum developers transitioning to the Internet Computer using Astrox's Dart SDK. While the core concepts of data fetching and transaction signing remain similar, the implementation details and network protocols differ significantly between Ethereum and the IC ecosystem.

For more details, refer to the [Astrox Network documentation](https://astrox.network) and the [Internet Computer SDK documentation](https://internetcomputer.org/docs).

