
# Getting Started with Flutter and agent_dart

This guide explains how to integrate the [AstroxNetwork/agent_dart](https://github.com/AstroxNetwork/agent_dart) package into your Flutter project.

---

## 1. Adding agent_dart to your Flutter Project

To use agent_dart in your Flutter project, add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  agent_dart: ^latest_version  # Replace with the latest published version
```

After adding the dependency, run:

```bash
flutter pub get
```

---

## 2. Initializing an Agent in Flutter

Here's a simple example of how to initialize an `Agent` inside a Flutter widget's state:

```dart
import 'package:flutter/material.dart';
import 'package:agent_dart/agent_dart.dart';

class AgentExample extends StatefulWidget {
  const AgentExample({super.key});

  @override
  State<AgentExample> createState() => _AgentExampleState();
}

class _AgentExampleState extends State<AgentExample> {
  late Agent agent;

  @override
  void initState() {
    super.initState();
    // Initialize the agent with your configuration
    agent = Agent(
      name: "MyFlutterAgent",
      // Add any other required configuration parameters
      // For example:
      // apiKey: "your_api_key_here",
      // baseUrl: "https://api.example.com",
    );

    // Start the agent
    agent.start();
  }

  @override
  void dispose() {
    // Clean up the agent when the widget is disposed
    agent.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agent Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Agent is running'),
            ElevatedButton(
              onPressed: () {
                // Example of calling an agent method
                agent.sendMessage("Hello, Agent!");
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 3. Important Notes

1. **Configuration**: Make sure to provide all required configuration parameters when initializing the agent. Check the [agent_dart documentation](https://github.com/AstroxNetwork/agent_dart) for the complete list of available options.

2. **Error Handling**: Implement proper error handling for agent operations, especially when dealing with network requests or API calls.

3. **State Management**: Since the agent is initialized in the widget's state, it will be automatically cleaned up when the widget is disposed.

4. **Platform Compatibility**: Ensure that the agent_dart package is compatible with your Flutter version and target platforms.

---

## 4. Next Steps

- Explore the [agent_dart API documentation](https://github.com/AstroxNetwork/agent_dart) for more advanced features
- Integrate the agent with your app's business logic
- Customize the agent behavior to fit your application's requirements

---

## 5. Summary

This guide provided a basic introduction to integrating the agent_dart package into your Flutter application. You should now be able to:

1. Add agent_dart to your Flutter project's dependencies
2. Initialize an Agent instance in your Flutter widgets
3. Start and stop the agent as needed
4. Begin exploring the agent's capabilities

For more advanced usage, refer to the [agent_dart documentation](https://github.com/AstroxNetwork/agent_dart).

