
# State Management for Internet Computer Apps

## Introduction

When building Flutter applications that interact with the Internet Computer (IC) network using the AstroxNetwork/agent_dart package, effective state management is crucial. This guide explains how to use Flutter state management solutions like Provider and Riverpod to handle agent state and IC interactions.

---

## Using Provider for State Management

### 1. Setup Provider

Add the Provider package to your `pubspec.yaml`:

```yaml
dependencies:
  provider: ^6.0.5
```

### 2. Create a State Class

Define a class to hold your agent state:

```dart
class AgentState with ChangeNotifier {
  final Agent _agent;
  bool _isLoading = false;
  String? _error;
  dynamic _result;

  AgentState(this._agent);

  bool get isLoading => _isLoading;
  String? get error => _error;
  dynamic get result => _result;

  Future<void> callICFunction() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _result = await _agent.callICFunction();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 3. Wrap Your App with Provider

In your main app file:

```dart
void main() async {
  final agent = Agent(); // Initialize your agent
  final agentState = AgentState(agent);

  runApp(
    ChangeNotifierProvider(
      create: (context) => agentState,
      child: MyApp(),
    ),
  );
}
```

### 4. Access State in Widgets

Access and react to state changes:

```dart
class ICInteractionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final agentState = Provider.of<AgentState>(context, listen: true);

    return Column(
      children: [
        if (agentState.isLoading) CircularProgressIndicator(),
        if (agentState.error != null)
          Text('Error: ${agentState.error}', style: TextStyle(color: Colors.red)),
        if (agentState.result != null)
          Text('Result: ${agentState.result}'),
        ElevatedButton(
          onPressed: agentState.callICFunction,
          child: Text('Call IC Function'),
        ),
      ],
    );
  }
}
```

---

## Using Riverpod for State Management

### 1. Setup Riverpod

Add the Riverpod package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
```

### 2. Create a Provider

Define a provider for your agent state:

```dart
final agentProvider = StateNotifierProvider<AgentNotifier, AgentState>((ref) {
  final agent = Agent(); // Initialize your agent
  return AgentNotifier(agent);
});

class AgentNotifier extends StateNotifier<AgentState> {
  AgentNotifier(this._agent) : super(AgentState(_agent));

  final Agent _agent;

  Future<void> callICFunction() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _agent.callICFunction();
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

class AgentState {
  final bool isLoading;
  final String? error;
  final dynamic result;

  AgentState(this._agent, {this.isLoading = false, this.error, this.result});

  AgentState copyWith({
    bool? isLoading,
    String? error,
    dynamic result,
  }) {
    return AgentState(
      _agent,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }
}
```

### 3. Use the Provider in Your App

Wrap your app with the ProviderScope:

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 4. Access State in Widgets

Access and react to state changes:

```dart
class ICInteractionWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentState = ref.watch(agentProvider);

    return Column(
      children: [
        if (agentState.isLoading) CircularProgressIndicator(),
        if (agentState.error != null)
          Text('Error: ${agentState.error}', style: TextStyle(color: Colors.red)),
        if (agentState.result != null)
          Text('Result: ${agentState.result}'),
        ElevatedButton(
          onPressed: () => ref.read(agentProvider.notifier).callICFunction(),
          child: Text('Call IC Function'),
        ),
      ],
    );
  }
}
```

---

## Best Practices for IC State Management

1. **Error Handling**: Always implement comprehensive error handling for IC calls
2. **Loading States**: Show appropriate loading indicators during network operations
3. **State Updates**: Update UI only when necessary to improve performance
4. **Thread Safety**: Ensure all IC interactions happen on the correct isolate/thread
5. **Cleanup**: Dispose resources when widgets are disposed
6. **Debouncing**: For frequent operations, consider debouncing to avoid excessive calls
7. **Retry Logic**: Implement retry mechanisms for failed IC calls

---

## Example: Full IC Interaction Flow with Riverpod

Here's a more complete example with additional state management features:

```dart
final icCallProvider = StateNotifierProvider<ICCallNotifier, ICState>((ref) {
  return ICCallNotifier();
});

class ICCallNotifier extends StateNotifier<ICState> {
  ICCallNotifier() : super(ICState.initial());

  Future<void> executeCall() async {
    state = state.copyWith(status: ICStatus.loading);

    try {
      final result = await agent.executeCall();
      state = state.copyWith(
        status: ICStatus.success,
        result: result,
        lastCalledAt: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        status: ICStatus.error,
        error: e.toString(),
        lastError: DateTime.now(),
      );
      rethrow;
    }
  }
}

class ICState {
  final ICStatus status;
  final dynamic result;
  final String? error;
  final DateTime? lastCalledAt;
  final DateTime? lastError;

  ICState({
    required this.status,
    this.result,
    this.error,
    this.lastCalledAt,
    this.lastError,
  });

  factory ICState.initial() => ICState(status: ICStatus.initial);

  ICState copyWith({
    ICStatus? status,
    dynamic result,
    String? error,
    DateTime? lastCalledAt,
    DateTime? lastError,
  }) {
    return ICState(
      status: status ?? this.status,
      result: result ?? this.result,
      error: error ?? this.error,
      lastCalledAt: lastCalledAt ?? this.lastCalledAt,
      lastError: lastError ?? this.lastError,
    );
  }
}

enum ICStatus { initial, loading, success, error }
```

---

## Conclusion

Both Provider and Riverpod provide robust solutions for managing state in Flutter applications interacting with the Internet Computer:

- **Provider** is simpler and good for basic state management needs
- **Riverpod** offers better performance and more advanced features for complex applications

Choose the solution that best fits your application's requirements and complexity level.

### Summary

This guide has covered:
1. Setting up state management with Provider and Riverpod
2. Creating state classes for IC interactions
3. Implementing proper error handling and loading states
4. Best practices for IC state management
5. Complete examples for both state management solutions


This foundation will help you build reliable Flutter applications that effectively interact with the Internet Computer network.

---
### Completed state management guide for [AstroxNetwork/agent_dart]

