
# Contributing to agent_dart

Thank you for your interest in contributing to the agent_dart project! We welcome contributions from the community to help improve and expand this project.

## Getting Started

### Prerequisites

Before you begin, make sure you have the following installed:
- [Git](https://git-scm.com/downloads)
- [Dart SDK](https://dart.dev/get-dart)
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (optional, but recommended for testing)

### Forking the Repository

1. Fork the [agent_dart repository](https://github.com/AstroxNetwork/agent_dart) on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/agent_dart.git
   cd agent_dart
   ```

### Setting Up the Project

1. Add the original repository as an upstream remote:
   ```bash
   git remote add upstream https://github.com/AstroxNetwork/agent_dart.git
   ```

2. Install dependencies:
   ```bash
   dart pub get
   ```

## Branching Strategy

We follow a simple branching strategy:

- **main**: The production branch with stable code
- **feature/***: For new features or significant changes
- **bugfix/***: For bug fixes
- **hotfix/***: For urgent bug fixes in production

## Pull Request Naming Conventions

Please follow these naming conventions for your pull requests:

1. **Prefix**: Use one of these prefixes based on the type of change:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation changes
   - `style:` for code style changes
   - `refactor:` for code refactoring
   - `test:` for adding tests
   - `chore:` for maintenance tasks

2. **Description**: Include a clear and concise description of the changes made

3. **Example**:
   ```
   feat: add new agent configuration options
   This PR adds support for custom agent configuration through environment variables
   ```

## Running Tests Locally

To run tests locally, use the following commands:

### Running All Tests
```bash
dart test
```

### Running Specific Test Files
```bash
dart test test/agent_test.dart
```

### Running Tests with Coverage
```bash
dart test --coverage
```

### Running Tests in Watch Mode
```bash
dart test --watch
```

## Code Style

We follow the Dart style guide. Make sure your code follows these conventions:

1. Use consistent indentation (2 spaces)
2. Follow Dart naming conventions (camelCase for variables and methods, PascalCase for classes)
3. Keep lines under 120 characters where possible
4. Add appropriate comments for complex logic

## Submitting Changes

1. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit them with descriptive messages:
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

3. Push your changes to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

4. Open a pull request from your fork to the main repository

## Reporting Issues

If you encounter any issues or have suggestions for improvement, please open an issue on the [GitHub Issues](https://github.com/AstroxNetwork/agent_dart/issues) page.

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
