# Agent Dart

[![Pub](https://img.shields.io/pub/v/agent_dart?color=42a012&include_prereleases&logo=dart&style=flat-square)](https://pub.dev/packages/agent_dart)
[![License](https://img.shields.io/github/license/AstroxNetwork/agent_dart?style=flat-square)](https://github.com/AstroxNetwork/agent_dart/blob/main/LICENSE)

An agent library built for Internet Computer for Dart and Flutter apps.

**Join the Discord channel: [![Discord](https://img.shields.io/discord/845497925298815036?color=purple&logo=discord&style=flat-square)](https://discord.gg/aNzRuePmUY)**

---

## 📃 Table of content

- [Agent Dart](#agent-dart)
  - [📃 Table of content](#-table-of-content)
  - [⚡️ Quick start](#️-quick-start)
    - [For Dart/Flutter app](#for-dartflutter-app)
      - [For iOS projects](#for-ios-projects)
    - [For developing the plugin](#for-developing-the-plugin)
  - [🚦 Prerequisites](#-prerequisites)
  - [🧰 Resources](#-resources)
    - [📖 Documentation](#-documentation)
    - [🔧 Helpers/Tooling](#-helperstooling)
    - [💡 Examples](#-examples)
  - [🧘‍♂️ Motivation](#️-motivation)
  - [🏆 Milestones](#-milestones)
  - [👨‍💻 Contributing](#-contributing)
  - [🔗 Reference and related projects](#-reference-and-related-projects)
  - [⚠️ FAQ](#️-faq)
    - [Build rust libraries for iOS/MacOS](#build-rust-libraries-for-iosmacos)
    - [Network problem in macOS](#network-problem-in-macos)

---

## ⚡️ Quick start

### For Dart/Flutter app

The latest stable version is:
![pub](https://img.shields.io/pub/v/agent_dart?color=42a012&logo=dart&style=flat-square)

```yaml
dependencies:
  agent_dart: ^latest-version
```

#### For iOS projects

When you're using the plugin in your Flutter projects that contains iOS platform,
make sure you've done the following setup the build settings.

1. Open `ios/Runner.xcworkspace`.
2. Select `Runner` on left folder view, and `Project -> Runner`.
3. Select `Build Settings`, `All`, `Combined` and type `strip style` in the filter input field.
4. Switch `Strip Style` and select `Non-Global Symbols`.

![Settings](https://user-images.githubusercontent.com/15884415/190084879-a20e51c5-3a5d-44e2-9ddd-d098f6a587df.png)

### For developing the plugin

1. Clone and follow [Prerequisites](#-prerequisites), and make sure your Flutter installed properly.

2. **MUST DO: Bootstrap your project**

```shell
./scripts/bootstrap.sh
```

## 🚦 Prerequisites

- [CMake](https://cmake.org/) v3.2+
- [Xcode](https://developer.apple.com/xcode/) v13+
- [Rust](https://www.rust-lang.org/) v1.64+
- [Node.js](https://nodejs.org/) v16+

## 🧰 Resources

### 📖 Documentation

- [Reference on pub.dev](https://pub.dev/documentation/agent_dart/latest/)
- Docs site, WIP...

### 🔧 Helpers/Tooling

- [candid_dart](https://github.com/AstroxNetwork/candid_dart),
  an automated candid builder for Dart classes
- [agent_dart_auth](https://github.com/AstroxNetwork/agent_dart_auth),
  an extension plugin for authorization, used for Internet-Identity authorization.

### 💡 Examples

- [simple counter](https://github.com/AstroxNetwork/agent_dart_examples/tree/main/counter),
  a simple counter demonstrate how to use agent_dart, a backend canister within.
- [auth counter](https://github.com/AstroxNetwork/agent_dart_examples/tree/main/auth_counter),
  a counter needs user's authorization from Internet-Identity,
  demonstrate how to combine with [agent_dart_auth](https://github.com/AstroxNetwork/agent_dart_auth).
- [ledger_app](https://github.com/AstroxNetwork/agent_dart_examples/tree/main/ledger_app),
  a ledger app demonstrate how to import seed-phrase and make transactions.

## 🧘‍♂️ Motivation

The Internet Computer is powered by blockchain and its major impact is to bring WebApp to be truly decentralized.
However, we are in the mobile internet era, even we can use Safari or Chrome on our cell phones.
But most average people, not crypto enthusiasts, are likely to use native mobile apps, major users are there.

It's important to attract these people to use DApps of Internet Computer,
by providing stable, fast, and fully integrated to Dfinity's blockchain.
We likely to provide further solution to balancing the "Decentralization" and "Efficiency".
But first things first, we have to make mobile native apps work.

`agent-rs` and `agent-js` are the actual lower level client-SDKs,
just like `ether.js` or `web3.js` of Ethereum's ecosystem.
This library is aiming to port and replicate features from them.
And this library is mainly for mobile apps to connect canisters,
not deploying contracts (you can do that if you want, but use dart directly).

We have tried our best to migrate most interface styles just like Javascript version,
but there are limitations and differences between different programming languages,
we will document them as much as possible.

## 🏆 Milestones

- Milestone 1: ✅ Core features/libraries implementation.
- Milestone 2: ✅ Enhanced built tool and more example apps
- Milestone 3: 👷 Documentation and community driven development

## 👨‍💻 Contributing

By contributing to agent_dart, you agree that your contributions will be licensed under its MIT License.

1. Fork this library and add your own branch like `{feat|fix|test|dep}-{detail}`.

2. Follow the [Prerequisites](#-prerequisites).

3. Build rust dependencies for all supported platforms:

```shell
sh ./scripts/bootstrap
```

4. Start the example.

```shell
cd example
flutter run
```

5. Tests. (Unit Test and Integration Test)

```shell
flutter test
```

6. Commit and make a pull request.

## 🔗 Reference and related projects

Feel free to list your project here, you can submit here.

- Official libraries from Dfinity's team:
  - [agent-rs](https://github.com/dfinity/agent-rs)
  - [agent-js](https://github.com/dfinity/agent-js)
- DApps
  - [Distrikt](https://distrikt.io/)
  - [ICPBox](https://www.icpbox.org/)
- Wallets
  - [ICWallet](https://icwallet.org/)

## ⚠️ FAQ

### Build rust libraries for iOS/MacOS

- All rust method have to be written inside `SwiftAgentDartPlugin.swift` to avoid tree shaking by XCode.

### Network problem in macOS

- If you run example or build a flutter app, you may come up with this:

```
[macOS] SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)
```

- Go to `macos/Runner` of macOS.
- Add following in `DebugProfile.entitlements` and `ReleaseProfile.entitlements`:

```plist
<key>com.apple.security.network.client</key>
<true/>
```
