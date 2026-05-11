# Generating API reference

agent_dart uses Dart's standard documentation generator.

From the repository root, bootstrap dependencies first:

```shell
dart pub get
cd packages/agent_dart_base && dart pub get
cd ../agent_dart && flutter pub get
```

Generate docs for the base package:

```shell
cd packages/agent_dart_base
dart doc .
```

Generate docs for the Flutter plugin package:

```shell
cd packages/agent_dart
flutter pub get
dart doc .
```

The generated site is written to each package's `doc/api` directory. For released versions, pub.dev also builds and hosts the API reference automatically:

<https://pub.dev/documentation/agent_dart/latest/>


## GitHub Pages workflow

This repository also includes `.github/workflows/docs.yml`, which builds the guide pages and generated Dart API reference into a single GitHub Pages artifact. After maintainers enable GitHub Pages for GitHub Actions, pushes to `main` can publish:

- guide pages from `docs/`
- `agent_dart` API reference
- `agent_dart_base` API reference

The workflow can also be run manually from the GitHub Actions tab with `workflow_dispatch`.
