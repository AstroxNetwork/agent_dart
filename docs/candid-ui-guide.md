
# Candid UI Guide for agent_dart

This guide explains how developers can use `agent_dart` to parse Candid interfaces and dynamically generate UI elements for interacting with Internet Computer canisters.

## Overview

The `agent_dart` library provides robust support for parsing Candid interfaces and creating UI components that interact with Internet Computer canisters. The library includes:

1. **Candid IDL Parser**: Parses Candid interface definitions into Dart types
2. **Canister Actor System**: Creates actors that can call canister methods
3. **UI Generation Utilities**: Helps create dynamic UI elements based on Candid interfaces

## Basic Concepts

### 1. Candid Interface Definition

Candid interfaces define the methods and data types available on a canister. In `agent_dart`, these are represented using the `IDL` (Interface Description Language) system:

```dart
import 'package:agent_dart_base/agent_dart_base.dart';

Service myService() {
  return IDL.Service({
    'getData': IDL.Func([], [IDL.Text], ['query']),
    'updateData': IDL.Func([IDL.Text], [], []),
  });
}
```

### 2. Canister Actor

A `CanisterActor` is created from an IDL definition and can be used to call canister methods:

```dart
final actor = CanisterActor(
  ActorConfig(
    canisterId: Principal.fromText('your-canister-id'),
    agent: HttpAgent(),
  ),
  myService(),
);
```

## UI Generation with Candid

### 1. Dynamic UI Components

The library provides utilities to generate UI components based on Candid interfaces. Here's how to create a dynamic UI for a canister:

```dart
import 'package:flutter/material.dart';
import 'package:agent_dart_base/agent_dart_base.dart';

class CanisterUI extends StatefulWidget {
  final CanisterActor actor;
  final Service idl;

  const CanisterUI({Key? key, required this.actor, required this.idl})
      : super(key: key);

  @override
  _CanisterUIState createState() => _CanisterUIState();
}

class _CanisterUIState extends State<CanisterUI> {
  String? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canister UI')),
      body: Column(
        children: [
          // Display current data
          if (data != null) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Current data: $data'),
            ),
          ],

          // Get data button
          ElevatedButton(
            onPressed: () async {
              try {
                final result = await widget.actor.getFunc('getData')!.call([]);
                setState(() {
                  data = result as String?;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: Text('Get Data'),
          ),

          // Update data form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'New data',
                hintText: 'Enter new data',
              ),
              onSubmitted: (value) async {
                try {
                  await widget.actor.getFunc('updateData')!.call([value]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### 2. Type-Safe UI Generation

For more complex interfaces, you can use the `IDL` system to generate type-safe UI components:

```dart
// Define your service interface
Service myService() {
  return IDL.Service({
    'getUser': IDL.Func(
      [IDL.Principal],
      [IDL.Record({
        'name': IDL.Text,
        'email': IDL.Text,
        'balance': IDL.Nat,
      })],
      ['query'],
    ),
    'transfer': IDL.Func(
      [
        IDL.Principal,
        IDL.Principal,
        IDL.Nat,
      ],
      [],
      [],
    ),
  });
}

// Create actor
final actor = CanisterActor(
  ActorConfig(
    canisterId: Principal.fromText('your-canister-id'),
    agent: HttpAgent(),
  ),
  myService(),
);

// Use in UI
ElevatedButton(
  onPressed: () async {
    try {
      final user = await actor.getFunc('getUser')!.call([Principal.anonymous()]);
      // user is now a Map<String, dynamic> with type-safe access
      final userName = user['name'] as String;
      final userEmail = user['email'] as String;
      final userBalance = user['balance'] as BigInt;
    } catch (e) {
      // Handle error
    }
  },
  child: Text('Get User'),
)
```

## Advanced UI Patterns

### 1. Dynamic Form Generation

For forms that need to match the input parameters of a canister method:

```dart
Widget buildMethodForm(String methodName, List<CType> inputTypes) {
  return Column(
    children: inputTypes.map<Widget>((type) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: _buildInputWidget(type),
      );
    }).toList(),
  );
}

Widget _buildInputWidget(CType type) {
  // Implement type-specific input widgets
  if (type is TextClass) {
    return TextField(decoration: InputDecoration(labelText: 'Text Input'));
  } else if (type is NatClass) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Number Input'),
    );
  } else if (type is PrincipalClass) {
    return TextField(
      decoration: InputDecoration(labelText: 'Principal Input'),
    );
  }
  // Add more type handlers as needed
  return Text('Unsupported type');
}
```

### 2. Response Handling

For handling complex response types:

```dart
Future<void> handleResponse(dynamic response, CType responseType) async {
  if (responseType is RecordClass) {
    final record = response as Map<String, dynamic>;
    // Process record fields
    for (final field in record.entries) {
      final fieldType = responseType.fields[field.key]!;
      final value = field.value;
      // Handle each field based on its type
    }
  } else if (responseType is VecClass) {
    final list = response as List<dynamic>;
    // Process list items
  }
  // Add more type handlers as needed
}
```

## Complete Example: Counter App UI

Here's a complete example of a counter app UI that uses Candid interfaces:

```dart
import 'package:flutter/material.dart';
import 'package:agent_dart_base/agent_dart_base.dart';

class CounterApp extends StatefulWidget {
  final CanisterActor actor;

  const CounterApp({Key? key, required this.actor}) : super(key: key);

  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int? counterValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter: ${counterValue ?? 'Loading...'}',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final result = await widget.actor.getFunc('increment')!.call([]);
                      setState(() {
                        counterValue = result as int?;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  child: Text('Increment'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final result = await widget.actor.getFunc('decrement')!.call([]);
                      setState(() {
                        counterValue = result as int?;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  child: Text('Decrement'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## Best Practices

1. **Type Safety**: Always use the type-safe methods provided by the `IDL` system to ensure your UI components match the canister interface.

2. **Error Handling**: Implement robust error handling for all canister calls to provide good user feedback.

3. **State Management**: Use Flutter's state management to keep your UI in sync with the canister state.

4. **Loading States**: Always show loading indicators while waiting for canister responses.

5. **Validation**: Validate user input before making canister calls to prevent errors.

## Summary

The `agent_dart` library provides powerful tools for creating UI components that interact with Internet Computer canisters:

- Parse Candid interfaces into Dart types
- Create canister actors that can call methods
- Generate dynamic UI components based on interface definitions
- Handle complex data types and responses

By following the patterns shown in this guide, developers can create rich, type-safe UI experiences for their Internet Computer applications.

## Next Steps

1. Explore the [agent_dart examples](https://github.com/AstroxNetwork/agent_dart_examples) for more complete implementations
2. Check out the [candid_dart](https://github.com/AstroxNetwork/candid_dart) tool for automated Candid interface generation
3. Refer to the [agent_dart documentation](https://pub.dev/documentation/agent_dart/latest/) for API details
