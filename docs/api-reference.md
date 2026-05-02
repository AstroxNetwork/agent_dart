
# Agent Dart API Reference

Agent Dart is a library for connecting Dart and Flutter applications to the Internet Computer blockchain. It provides a Dart implementation of the agent-rs and agent-js libraries, enabling mobile apps to interact with canisters on the Internet Computer.

---

## Table of Contents
1. [Core Classes](#core-classes)
2. [Agent Initialization](#agent-initialization)
3. [Making Calls to Canisters](#making-calls-to-canisters)
4. [Querying Canisters](#querying-canisters)
5. [Reading Canister State](#reading-canister-state)
6. [Canister Management](#canister-management)
7. [Authentication](#authentication)
8. [Utilities](#utilities)

---

## Core Classes

### Agent
The `Agent` class is the core interface for interacting with the Internet Computer.

```dart
abstract class Agent {
  /// Returns the principal ID associated with this agent
  Future<Principal> getPrincipal();

  /// Send a read state query to the replica
  Future<ReadStateResponse> readState(
    Principal effectiveCanisterId,
    ReadStateOptions options,
    Identity? identity,
  );

  /// Send a call request to a canister
  Future<SubmitResponse> callRequest(
    Principal canisterId,
    CallOptions fields,
    Identity? identity,
  );

  /// Query the status endpoint of the replica
  Future<Map> status();

  /// Send a query call to a canister
  Future<QueryResponse> query(
    Principal canisterId,
    QueryFields options,
    Identity? identity,
  );

  /// Fetch the root key from the replica
  Future<BinaryBlob> fetchRootKey();
}
```

### HttpAgent
The `HttpAgent` class implements the `Agent` interface and is the primary agent type used for HTTP-based interactions.

```dart
class HttpAgent implements Agent {
  /// Create an HttpAgent from a URI
  factory HttpAgent.fromUri(Uri uri, {HttpAgentOptions? options});

  /// Create an HttpAgent with default settings
  HttpAgent({
    HttpAgentOptions? options,
    String? defaultProtocol,
    String? defaultHost,
    int? defaultPort,
  });
}
```

---

## Agent Initialization

### Creating an HttpAgent

```dart
import 'package:agent_dart/agent_dart.dart';

// Create an agent pointing to the mainnet
final agent = HttpAgent.fromUri(
  Uri.parse('https://ic0.app'),
  options: HttpAgentOptions(
    identity: AnonymousIdentity(), // or use a specific identity
  ),
);

// Create an agent pointing to a local replica
final localAgent = HttpAgent.fromUri(
  Uri.parse('http://localhost:8000'),
  options: HttpAgentOptions(
    identity: AnonymousIdentity(),
  ),
);
```

### Creating an Actor

```dart
import 'package:agent_dart/agent_dart.dart';

// Create an actor for a specific canister
final actor = Actor.createActor(
  idl, // Your Candid IDL service
  ActorConfig(
    canisterId: Principal.fromText('your-canister-id'),
    agent: agent,
  ),
);
```

---

## Making Calls to Canisters

### CallOptions
Options for making a call to a canister.

```dart
class CallOptions {
  const CallOptions({
    required this.methodName,
    required this.arg, // Binary encoded argument
    this.effectiveCanisterId,
    this.callSync = true,
  });

  final String methodName;
  final BinaryBlob arg;
  final Principal? effectiveCanisterId;
  final bool callSync;
}
```

### Making a Call

```dart
// Prepare the call options
final callOptions = CallOptions(
  methodName: 'increment',
  arg: BinaryBlob.fromList([]), // Empty argument for this example
);

// Make the call
final result = await agent.callRequest(
  Principal.fromText('your-canister-id'),
  callOptions,
  identity: AnonymousIdentity(),
);
```

---

## Querying Canisters

### QueryFields
Options for querying a canister.

```dart
class QueryFields {
  const QueryFields({required this.methodName, this.arg});

  final String methodName;
  final BinaryBlob? arg;
}
```

### Making a Query

```dart
// Prepare the query options
final queryOptions = QueryFields(
  methodName: 'getCount',
  arg: BinaryBlob.fromList([]), // Empty argument for this example
);

// Make the query
final response = await agent.query(
  Principal.fromText('your-canister-id'),
  queryOptions,
  identity: AnonymousIdentity(),
);

// Handle the response
if (response.status == QueryResponseStatus.replied) {
  final result = decodeReturnValue([CType.Int()], response.reply!.arg!);
  print('Query result: $result');
} else if (response.status == QueryResponseStatus.rejected) {
  print('Query rejected with code: ${response.rejectCode}');
  print('Message: ${response.rejectMessage}');
}
```

---

## Reading Canister State

### ReadStateOptions
Options for reading canister state.

```dart
class ReadStateOptions {
  const ReadStateOptions({required this.paths});

  final List<List<BinaryBlob>> paths;
}
```

### Reading State

```dart
// Define paths to read
final paths = [
  [BinaryBlob.fromList([1, 2, 3])], // Example path
];

// Read state
final stateResponse = await agent.readState(
  Principal.fromText('your-canister-id'),
  ReadStateOptions(paths: paths),
  identity: AnonymousIdentity(),
);

// Use the certificate
final certificate = stateResponse.certificate;
```

---

## Canister Management

### Creating a Canister

```dart
// Create a new canister
final canisterId = await Actor.createCanister(
  CallConfig(
    agent: agent,
  ),
);

// Install code on the canister
await Actor.install(
  FieldOptions(
    module: BinaryBlob.fromList(wasmBytes), // Your WASM bytes
    mode: CanisterInstallMode.install.name,
  ),
  ActorConfig(
    canisterId: canisterId,
    agent: agent,
  ),
);
```

### Creating and Installing a Canister

```dart
// Create and install a canister in one step
final newActor = await Actor.createAndInstallCanister(
  service, // Your Candid service
  FieldOptions(
    module: BinaryBlob.fromList(wasmBytes),
    mode: CanisterInstallMode.install.name,
  ),
  CallConfig(
    agent: agent,
  ),
);
```

---

## Authentication

### Identity Types

Agent Dart supports different identity types:

```dart
// Anonymous identity
final anonymousIdentity = AnonymousIdentity();

// Identity with principal
final principalIdentity = PrincipalIdentity(Principal.fromText('your-principal'));
```

### Using Authentication

```dart
// Use an identity when making calls
final result = await agent.callRequest(
  Principal.fromText('your-canister-id'),
  CallOptions(
    methodName: 'authenticatedMethod',
    arg: BinaryBlob.fromList([]),
  ),
  identity: principalIdentity,
);
```

---

## Utilities

### Principal
Represents a principal ID on the Internet Computer.

```dart
final principal = Principal.fromText('your-principal-id');
final text = principal.toText();
```

### BinaryBlob
Represents binary data.

```dart
final blob = BinaryBlob.fromList([1, 2, 3]);
final hex = blobToHex(blob);
```

### Encoding/Decoding
Agent Dart uses CBOR encoding for communication.

```dart
import 'package:agent_dart/agent_dart.dart';

// Encode data
final encoded = IDL.encode([CType.Int()], [42]);

// Decode data
final decoded = IDL.decode([CType.Int()], encoded);
```

---

## Examples

### Simple Counter Example

```dart
import 'package:agent_dart/agent_dart.dart';

// Initialize agent
final agent = HttpAgent.fromUri(Uri.parse('https://ic0.app'));

// Create actor
final actor = Actor.createActor(
  CounterService(), // Your Candid service
  ActorConfig(
    canisterId: Principal.fromText('your-canister-id'),
    agent: agent,
  ),
);

// Increment counter
await actor.increment();

// Get counter value
final count = await actor.getCount();
print('Current count: $count');
```

---

## Error Handling

Agent Dart provides several error types for handling issues:

```dart
try {
  // Make a call
  final result = await agent.callRequest(...);
} on ActorCallError catch (e) {
  print('Actor call error: ${e.message}');
} on QueryCallRejectedError catch (e) {
  print('Query rejected: ${e.rejectCode} - ${e.rejectMessage}');
} on UpdateCallRejectedError catch (e) {
  print('Update rejected: ${e.requestId}');
} on AgentFetchError catch (e) {
  print('Agent fetch error: ${e.statusCode} - ${e.statusText}');
}
```

---

## Conclusion

Agent Dart provides a comprehensive API for connecting Dart and Flutter applications to the Internet Computer. It supports all the core functionality needed to interact with canisters, including:

- Creating agents and actors
- Making synchronous and asynchronous calls
- Querying canisters
- Reading canister state
- Managing canisters
- Authentication
- Error handling

The library is designed to be similar to the JavaScript agent-js library, making it easier for developers familiar with that API to transition to Dart.

