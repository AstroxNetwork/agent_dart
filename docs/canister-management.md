
# Canister Management with agent_dart

This guide provides examples of how to use the `agent_dart` library to manage canisters on the Internet Computer Protocol (ICP).

## Prerequisites

Before using the examples below, make sure you have:
- The `agent_dart` package installed
- An HTTP agent configured with your ICP identity
- Basic understanding of Dart programming
- Familiarity with the Internet Computer Protocol and canister lifecycle

## Creating Canisters

There are several ways to create canisters using the `agent_dart` library:

### Basic Canister Creation

You can create a basic provisional canister using the `Actor.createCanister` method:

```dart
import 'package:agent_dart_base/agent/actor.dart';
import 'package:agent_dart_base/agent/http/types.dart';
import 'package:agent_dart_base/agent/http/agent.dart';
import 'package:agent_dart_base/identity/anonymous.dart';

Future<void> createBasicCanister() async {
  // Create an HTTP agent with an anonymous identity
  final agent = HttpAgent(
    defaultHost: 'icp-api.io',
    defaultPort: 443,
    options: const HttpAgentOptions(identity: AnonymousIdentity()),
  );

  // Create a provisional canister
  final canisterId = await Actor.createCanister(
    CallConfig(agent: agent),
  );

  print('Created provisional canister with ID: ${canisterId.toText()}');
}
```

### Canister Creation with Cycles

You can create a canister with a specific amount of cycles using the management canister:

```dart
import 'package:agent_dart_base/agent/actor.dart';
import 'package:agent_dart_base/agent/http/types.dart';
import 'package:agent_dart_base/agent/http/agent.dart';
import 'package:agent_dart_base/identity/anonymous.dart';
import 'package:agent_dart_base/agent/canisters/management.dart';
import 'package:agent_dart_base/candid/idl.dart';
import 'package:agent_dart_base/principal/principal.dart';

Future<void> createCanisterWithCycles() async {
  // Create an HTTP agent with an anonymous identity
  final agent = HttpAgent(
    defaultHost: 'icp-api.io',
    defaultPort: 443,
    options: const HttpAgentOptions(identity: AnonymousIdentity()),
  );

  // Get the management canister actor
  final managementCanister = getManagementCanister(
    CallConfig(agent: agent),
  );

  // Create a canister with cycles
  final result = await managementCanister.getFunc('provisional_create_canister_with_cycles')!.call([
    {
      'amount': 1000000000000, // 10 billion cycles
      'settings': {
        'compute_allocation': 1000000000, // 1 billion cycles
        'memory_allocation': 1000000000, // 1 billion cycles
      }
    }
  ]);

  final canisterId = Principal.from(result['canister_id']);
  print('Created canister with ID: ${canisterId.toText()}');
}
```

## Installing Code on a Canister

To install code on a canister, you can use the `Actor.install` method. This method allows you to install, reinstall, or upgrade canister code:

```dart
import 'package:agent_dart_base/agent/actor.dart';
import 'package:agent_dart_base/agent/http/types.dart';
import 'package:agent_dart_base/agent/http/agent.dart';
import 'package:agent_dart_base/identity/anonymous.dart';
import 'package:agent_dart_base/agent/canisters/management.dart';
import 'package:typed_data/typed_data.dart';

Future<void> installCodeExample() async {
  // Create an HTTP agent with an anonymous identity
  final agent = HttpAgent(
    defaultHost: 'icp-api.io',
    defaultPort: 443,
    options: const HttpAgentOptions(identity: AnonymousIdentity()),
  );

  // Load your WASM module (replace with your actual module)
  final wasmModule = Uint8List.fromList([...yourWasmModuleBytes]);

  // Create a canister
  final canisterId = await Actor.createCanister(
    CallConfig(agent: agent),
  );

  // Install code on the canister
  await Actor.install(
    FieldOptions(
      wasmModule,
      mode: CanisterInstallMode.install.name, // Can be 'install', 'reinstall', or 'upgrade'
    ),
    ActorConfig(
      agent: agent,
      canisterId: canisterId,
    ),
  );

  print('Successfully installed code on canister ${canisterId.toText()}');
}
```

## Canister Install Modes

The `agent_dart` library supports three different modes for installing canister code:

1. **Install**: Creates a new canister with the provided code
2. **Reinstall**: Replaces the existing code in a canister with new code
3. **Upgrade**: Updates the existing code in a canister with new code

```dart
// Example of different install modes
await Actor.install(
  FieldOptions(
    wasmModule,
    mode: CanisterInstallMode.install.name, // Create new canister
    // mode: CanisterInstallMode.reinstall.name, // Replace existing code
    // mode: CanisterInstallMode.upgrade.name, // Update existing code
  ),
  ActorConfig(
    agent: agent,
    canisterId: canisterId,
  ),
);
```

## Creating and Installing a Canister in One Step

You can create a canister and install code in a single step using `Actor.createAndInstallCanister`:

```dart
import 'package:agent_dart_base/agent/actor.dart';
import 'package:agent_dart_base/agent/http/types.dart';
import 'package:agent_dart_base/agent/http/agent.dart';
import 'package:agent_dart_base/identity/anonymous.dart';
import 'package:agent_dart_base/agent/canisters/management.dart';
import 'package:agent_dart_base/candid/idl.dart';
import 'package:typed_data/typed_data.dart';

Future<void> createAndInstallExample() async {
  // Create an HTTP agent with an anonymous identity
  final agent = HttpAgent(
    defaultHost: 'icp-api.io',
    defaultPort: 443,
    options: const HttpAgentOptions(identity: AnonymousIdentity()),
  );

  // Define your canister interface
  final idl = IDL.Service({
    'greet': IDL.Func([], [IDL.Text], []),
  });

  // Load your WASM module (replace with your actual module)
  final wasmModule = Uint8List.fromList([...yourWasmModuleBytes]);

  // Create and install a canister in one step
  final canister = await Actor.createAndInstallCanister(
    idl,
    FieldOptions(
      wasmModule,
      mode: CanisterInstallMode.install.name,
    ),
    CallConfig(agent: agent),
  );

  print('Created and installed canister with ID: ${Actor.canisterIdOf(canister).toText()}');
}
```

## Using the Management Canister

The management canister provides advanced functionality for canister lifecycle management:

```dart
import 'package:agent_dart_base/agent/actor.dart';
import 'package:agent_dart_base/agent/http/types.dart';
import 'package:agent_dart_base/agent/http/agent.dart';
import 'package:agent_dart_base/identity/anonymous.dart';
import 'package:agent_dart_base/agent/canisters/management.dart';
import 'package:agent_dart_base/candid/idl.dart';
import 'package:agent_dart_base/principal/principal.dart';

Future<void> useManagementCanisterExample() async {
  // Create an HTTP agent with an anonymous identity
  final agent = HttpAgent(
    defaultHost: 'icp-api.io',
    defaultPort: 443,
    options: const HttpAgentOptions(identity: AnonymousIdentity()),
  );

  // Get the management canister actor
  final managementCanister = getManagementCanister(
    CallConfig(agent: agent),
  );

  // Create a canister with cycles using the management canister
  final result = await managementCanister.getFunc('provisional_create_canister_with_cycles')!.call([
    {
      'amount': 1000000000000, // 10 billion cycles
      'settings': {
        'compute_allocation': 1000000000, // 1 billion cycles
        'memory_allocation': 1000000000, // 1 billion cycles
      }
    }
  ]);

  final canisterId = Principal.from(result['canister_id']);
  print('Created canister with ID: ${canisterId.toText()}');
}
```

## Stopping and Starting Canisters

While the `agent_dart` library doesn't directly expose methods for stopping and starting canisters, you can use the Candid interface directly:

```dart
import 'package:agent_dart_base/agent/http/types.dart';
import 'package:agent_dart_base/agent/http/agent.dart';
import 'package:agent_dart_base/identity/anonymous.dart';
import 'package:agent_dart_base/candid/candid.dart';
import 'package:agent_dart_base/principal/principal.dart';

Future<void> stopAndStartCanister() async {
  // Create an HTTP agent with an anonymous identity
  final agent = HttpAgent(
    defaultHost: 'icp-api.io',
    defaultPort: 443,
    options: const HttpAgentOptions(identity: AnonymousIdentity()),
  );

  // Management canister ID (usually the system canister)
  final managementCanisterId = Principal.fromText('aaaaa-aa');

  // Stop a canister
  final stopResult = await agent.callRequest(
    managementCanisterId,
    CallOptions(
      methodName: 'stop_canister',
      arg: encodeArg([
        {'canister_id': Principal.fromText('your-canister-id')},
      ], [
        IDL.Record({
          'canister_id': IDL.Principal,
        }),
      ]),
    ),
  );

  print('Stopped canister');

  // Start a canister
  final startResult = await agent.callRequest(
    managementCanisterId,
    CallOptions(
      methodName: 'start_canister',
      arg: encodeArg([
        {'canister_id': Principal.fromText('your-canister-id')},
      ], [
        IDL.Record({
          'canister_id': IDL.Principal,
        }),
      ]),
    ),
  );

  print('Started canister');
}
```

## Error Handling

When working with canister management, it's important to implement proper error handling:

```dart
import 'package:agent_dart_base/agent/actor.dart';
import 'package:agent_dart_base/agent/http/types.dart';
import 'package:agent_dart_base/agent/http/agent.dart';
import 'package:agent_dart_base/identity/anonymous.dart';
import 'package:agent_dart_base/agent/canisters/management.dart';
import 'package:agent_dart_base/agent/errors.dart';
import 'package:typed_data/typed_data.dart';

Future<void> createCanisterWithErrorHandling() async {
  try {
    // Create an HTTP agent with an anonymous identity
    final agent = HttpAgent(
      defaultHost: 'icp-api.io',
      defaultPort: 443,
      options: const HttpAgentOptions(identity: AnonymousIdentity()),
    );

    // Create a canister
    final canisterId = await Actor.createCanister(
      CallConfig(agent: agent),
    );

    print('Created canister with ID: ${canisterId.toText()}');

    // Load your WASM module (replace with your actual module)
    final wasmModule = Uint8List.fromList([...yourWasmModuleBytes]);

    // Install code on the canister
    await Actor.install(
      FieldOptions(
        wasmModule,
        mode: CanisterInstallMode.install.name,
      ),
      ActorConfig(
        agent: agent,
        canisterId: canisterId,
      ),
    );

    print('Successfully installed code on canister ${canisterId.toText()}');
  } catch (e) {
    print('Error during canister management: $e');
    // Handle different types of errors appropriately
    if (e is AgentFetchError) {
      print('Network or agent error: ${e.message}');
      // Handle network issues, timeouts, etc.
    } else if (e is ActorCallError) {
      print('Canister call error: ${e.message}');
      // Handle canister-specific errors
    } else {
      print('Unexpected error: $e');
      // Handle other unexpected errors
    }
  }
}
```

## Common Error Types

1. **AgentFetchError**: Occurs when there are network issues or problems with the agent
2. **ActorCallError**: Occurs when there are issues with canister calls
3. **Timeout errors**: When operations take too long to complete
4. **Provisional canister timeout**: When code isn't installed within 24 hours
5. **Invalid arguments**: When invalid parameters are passed to canister methods

## Summary

The `agent_dart` library provides comprehensive tools for managing canisters on the Internet Computer Protocol:

1. **Create Canisters**: Use `Actor.createCanister` to create new canisters with or without cycles
2. **Install Code**: Use `Actor.install` to install, reinstall, or upgrade canister code with different modes
3. **Create and Install**: Use `Actor.createAndInstallCanister` to create and install a canister in one step
4. **Management Canister**: Use the management canister for advanced operations like:
   - Creating canisters with custom settings
   - Creating canisters with specific amounts of cycles
   - Directly calling management canister methods
5. **Canister Lifecycle**: While not directly exposed in the library, you can use the Candid interface to:
   - Stop and start canisters
   - Configure canister settings

## Final Notes

- Always implement proper error handling when working with canister management operations
- Be aware of the provisional canister time limit (24 hours) before installing code
- Consider using the management canister for advanced operations when needed
- For production use, ensure you have proper authentication and authorization
- Monitor canister performance and resource usage to avoid unexpected costs

