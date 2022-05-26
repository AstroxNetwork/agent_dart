# agent_dart
[![pub package](https://img.shields.io/pub/v/agent_dart?color=42a012&include_prereleases&label=dev&logo=dart&style=flat-square)](https://pub.dev/packages/agent_dart)  [![GitHub license](https://img.shields.io/github/license/AstroxNetwork/agent_dart?style=flat-square)](https://github.com/AstroxNetwork/agent_dart/blob/master/LICENSE) ![Discord](https://img.shields.io/discord/845497925298815036?color=purple&label=Discord)



An agent library built for Internet Computer, a plugin package for dart and flutter apps. 

**Community: [https://discord.gg/aNzRuePmUY](https://discord.gg/aNzRuePmUY)** 

---
## 🌈 Add it to your flutter app

```bash
# Flutter App
flutter pub add agent_dart
```
---
## ⚡️ Quick start for development
1. git clone and install [Prerequisites](#prerequisites), check your flutter env by doing:

   ```
   flutter doctor -v
   ```
2. 👉 **MUST DO: Bootstrap your project**
   ```
   ./scripts/bootstrap.sh
   ```

3. To run tests:
   ```
   flutter test
   ```
4. To run example, follow [instructions](example/README.md) under `example` folder
---

## 📃 Table of content

   1. [Table of content](#table-of-content)
   2. [Prerequisites](#prerequisites)
   3. [Resources](#resources)
   4. [Motivation](#motivation)
   5. [Milestones](#milestones)
   6. [Contributing](#contributing)
   7. [Reference and related projects](#reference-and-related-projects)
   8. [FAQ](#faq)
   
---

## 🚦 Prerequisites
* [Flutter](https://flutter.dev/docs/get-started/install) version in the `agent_dart/pubspec.yaml`
* [CMake](https://cmake.org/) v3.2.0 or later
* [Xcode](https://developer.apple.com/xcode/) (10.12) or later (Running on macOS or iOS)
* [Android NDK](https://developer.android.com/studio/projects/install-ndk) version `21.4.7075529` (Running on Android)
* [Rust](https://www.rust-lang.org/) version 1.51+
* [Node.js](https://nodejs.org/) v15.0 or later, TBD


---
## 🧰 Resources
### 📖 Documentation
- [Reference on pub.dev](https://pub.dev/documentation/agent_dart/latest/)
- Docs site, coming in a few weeks...
### 🔧 Helpers/Tooling
- [candid_dart](https://github.com/AstroxNetwork/candid_dart), an automated candid builder for Dart classes
- [agent_dart_auth](https://github.com/AstroxNetwork/agent_dart_auth), an extension plugin for authorization, used for Internet-Identity authorization. 
### 💡 Examples
- [simple counter](https://github.com/AstroxNetwork/agent_dart_examples/tree/main/counter), a simple counter demostrate how to use agent_dart, a backend canister within
- [auth counter](https://github.com/AstroxNetwork/agent_dart_examples/tree/main/auth_counter), a counter needs user's authorization from Internet-Identity, demostrate how to combine with [agent_dart_auth](https://github.com/AstroxNetwork/agent_dart_auth)
- [ledger_app](https://github.com/AstroxNetwork/agent_dart_examples/tree/main/ledger_app), a ledger app demostrate how to import seedphrase and make transactions.  
---

## 🧘‍♂️ Motivation

The Internet Computer is powered by blockchain and its major impact is to bring WebApp to be truly decentralized. However, we are in the mobile internet era, even we can use Safari or Chrome on our cell phones. But most average people, not crypto enthusiasts, are likely to use native mobile apps, major users are there. 

It's important to attract these people to use Dapps of Internet Computer, by providing stable, fast, and fully integrated to Dfinity's blockchain. We likely to provide further solution to balancing the "Decentralization" and "Efficiency". But first things first, we have to make mobile native apps work.

`agent-rs` and `agent-js` are the actual lower level client-SDKs, just like `ether.js` or `web3.js` of Ethereum's ecosystem. This library is aiming to port and replicate features from them. And this library is mainly for mobile apps to connect canisters, not deploying contracts (you can do that if you want, but use dart directly).

We have tried our best to migrate most interface styles just like Javascript version, but there are limitations and differences between different programming languages, we will document them as much as possible.

---
## 🏆 Milestones
- Milestone 1: ✅ Core features/libraries implementation. 
- Milestone 2: ✅ Enhanced built tool and more example apps 
- Milestone 3: 👷 Documentation and community driven development 

---

## 👨‍💻 Contributing

By contributing to agent_dart, you agree that your contributions will be licensed under its MIT License.

0. Fork this library and add your own branch.
   like this:
    ```
    {github_id}/{feat|fix|test|dep}-{detail}
    ```
1. Install [Prerequisites](#Prerequisites)
    

2. Build rust dependencies for all supported platform (macOS, iOS, Android, windows, linux)

    ```shell
    $ sh ./scripts/bootstrap
    ```

3. Start example
   
   Read instruction first, then run

    ```shell
    $ cd example
    $ flutter run
    ```

4. Test (Unit Test and Integration Test)
    ```shell
    $ flutter test
    ```

5. Commit and make a pull request, process is TBD for now. We will use CI to automate

---

## 🔗 Reference and related projects
Feel free to list your project here, you can submit [here]()

* Official libraries from Dfinity's team:
  - [agent-rs](https://github.com/dfinity/agent-rs)
  - [agent-js](https://github.com/dfinity/agent-js)
* DApps
  - [Distrikt](https://distrikt.io/)
  - [ICPBox](https://www.icpbox.org/)
* Wallets
  - [ICWallet](https://icwallet.org/)

---

## ⚠️ FAQ

### Build rust libraries for iOS/MacOS
- All rust method have to be written inside `SwiftAgentDartPlugin.swift`, to avoid tree shaking of latest release build by XCode.
- The `agent_dart_podspec` should change accordingly when this repo goes 1.0.0


### Network problem in iOS and MacOS

- If you run example or build a flutter app, you may come up with this:
  
```bash
[macOS] SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)
```

- Go to `macos/Runner/` of macOS and `ios/Runner`
- Edit  `DebugProfile.entitlements` and `ReleaseProfile.entitlements`,
Add following: 

```
<key>com.apple.security.network.client</key>
<true/>
```

