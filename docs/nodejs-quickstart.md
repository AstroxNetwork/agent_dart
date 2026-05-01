
# Node.js Quickstart Guide for AstroxNetwork/agent_dart

This guide provides a step-by-step tutorial for using the AstroxNetwork/agent_dart library in a pure Node.js backend environment.

---

## Prerequisites

- Node.js (v16 or higher)
- npm or yarn package manager

---

## Installation

1. **Create a new Node.js project** (if you don't have one already):
   ```bash
   mkdir my-agent-app
   cd my-agent-app
   npm init -y
   ```

2. **Install the AstroxNetwork/agent_dart package**:
   ```bash
   npm install @astroxnetwork/agent_dart
   ```

---

## Basic Setup

### Import the required modules

```javascript
const { HttpAgent } = require('@astroxnetwork/agent_dart');
```

---

## Initializing the HttpAgent

### Basic Initialization

```javascript
// Initialize the HttpAgent with your configuration
const agent = new HttpAgent({
    network: 'your_network_name',
    wallet: {
        privateKey: 'your_private_key_here',
        address: 'your_wallet_address'
    },
    rpcUrl: 'https://your-rpc-endpoint.com'
});
```

### Connecting to the Network

```javascript
// Connect to the network
async function connect() {
    try {
        await agent.connect();
        console.log('Successfully connected to the network');
    } catch (error) {
        console.error('Error connecting to the network:', error);
    }
}

// Call the connect function
connect();
```

---

## Using the HttpAgent

### Sending Transactions

```javascript
async function sendTransaction() {
    try {
        const tx = await agent.sendTransaction({
            to: 'recipient_address',
            amount: 1000000000, // Example amount in wei
            data: '0x...' // Optional transaction data
        });
        console.log('Transaction sent:', tx);
    } catch (error) {
        console.error('Error sending transaction:', error);
    }
}

// Call the sendTransaction function
sendTransaction();
```

---

## Error Handling

Always handle potential errors when using the HttpAgent:

```javascript
async function handleTransaction() {
    try {
        // Your transaction logic here
    } catch (error) {
        if (error.code === 'NETWORK_ERROR') {
            console.error('Network error occurred:', error.message);
        } else if (error.code === 'INVALID_PARAMS') {
            console.error('Invalid parameters:', error.message);
        } else {
            console.error('Unexpected error:', error);
        }
    }
}
```

---

## Best Practices

1. **Environment Variables**: Store sensitive information like private keys and RPC endpoints in environment variables.
2. **Error Handling**: Implement robust error handling to manage network issues and transaction failures.
3. **Logging**: Use logging to track agent activity and debug issues.
4. **Configuration**: Keep your configuration separate from your codebase for easy updates and maintenance.

---

## Example: Full Application Setup

Here's a more complete example of setting up a Node.js application with the AstroxNetwork/agent_dart library:

```javascript
require('dotenv').config();
const { HttpAgent } = require('@astroxnetwork/agent_dart');

// Load environment variables
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RPC_URL = process.env.RPC_URL;
const NETWORK = process.env.NETWORK;

// Initialize the agent
const agent = new HttpAgent({
    network: NETWORK,
    wallet: {
        privateKey: PRIVATE_KEY,
    },
    rpcUrl: RPC_URL
});

// Connect to the network
async function initializeAgent() {
    try {
        await agent.connect();
        console.log('Agent connected successfully');
    } catch (error) {
        console.error('Failed to connect:', error);
        process.exit(1);
    }
}

// Example transaction function
async function exampleTransaction() {
    try {
        const tx = await agent.sendTransaction({
            to: 'recipient_address',
            amount: 1000000000,
            data: '0x1234567890'
        });
        console.log('Transaction successful:', tx);
    } catch (error) {
        console.error('Transaction failed:', error);
    }
}

// Initialize and run
initializeAgent()
    .then(() => exampleTransaction())
    .catch(err => console.error('Initialization failed:', err));
```

---

## Troubleshooting

- **Connection Issues**: Ensure your RPC endpoint is correct and accessible.
- **Private Key Errors**: Double-check your private key format and permissions.
- **Network Configuration**: Verify your network settings match the blockchain network you're targeting.

---

## Further Reading

- [AstroxNetwork Documentation](https://docs.astroxnetwork.com)
- [Node.js Documentation](https://nodejs.org/en/docs/)
