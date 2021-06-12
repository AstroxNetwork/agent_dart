# agent_dart

This repo is built for Internet Computer, using Dart-lang as its agent client which allows dart/flutter apps can interact with Dfinity's blockchain directly.

# Quick start

1. git clone
2. install latest flutter and rust env
3. 
   ```
   cd example && flutter run

   ```


## Motivation

The Internet Computer is powered by blockchain and its major impact is to bring WebApp to be truly decentralized. However, we are in the mobile internet era, even we can use Safari or Chrome on our cell phones. But most average people, not crypto enthusiasts, are likely to use native mobile apps, major users are there. 

It's important to attract these people to use Dapps of Internet Computer, by providing stable, fast, and fully integrated to Dfinity's blockchain. We likely to provide further solution to balancing the "Decentralization" and "Efficiency". But first things first, we have to make mobile native apps work.

`agent-rs` and `agent-js` are the actual lower level client-SDKs, just like `ether.js` or `web3.js` of Ethereum's ecosystem. This library is aiming to port and replicate features from them. And this library is mainly for mobile apps to connect canisters, not deploying contracts (you can do that if you want, but use dart directly).

We have tried our best to migrate most interface styles just like Javascript version, but there are limitations and differences between different programming languages, we will document them as much as possible.

## Related material

Other libraries in other programming languages:
- [agent-rs](https://github.com/dfinity/agent-rs)
- [agent-js](https://github.com/dfinity/agent-js)



## Appendix

### dart
TBD
### iOS
- All rust method have to be written inside `SwiftAgentDartPlugin.swift`, to avoid tree shaking of latest release build by XCode.
- The `agent_dart_podspec` should change accordingly when this repo goes 1.0.0

### macos

- open Xcode and build

[macOS] SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)
Add
```
<key>com.apple.security.network.client</key>
<true/>
```
To file `DebugProfile.entitlements` and `ReleaseProfile.entitlements` under directory macos/Runner/

### Example
TBD