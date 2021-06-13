# agent_dart

An agent library built for Internet Computer, a plugin package for dart and flutter apps. Developers can build ones to interact with Dfinity's blockchain directly.

---

## Table of content
   1. [Quick start](#quick-start)
   2. [Motivation](#motivation)
      1. [Milestones](#milestones)
      2. [Documentation](#documentation)
      3. [Contribution guideline](#contribution-guideline)
   3. [Reference and related projects](#reference-and-related-projects)
   4. [FAQ](#faq)
      1. [Build rust libraries for iOS/macOS](#build-rust-libraries-for-iosmacos)
      2. [Network problem in iOS and macOS](#network-problem-in-ios-and-macos)
---

## Quick start 

1. git clone
2. install latest flutter and rust env
3. To run example, follow [instructions](example/README.md) under `example` folder
4. To run tests:
   ```
   flutter test
   ```
---

## Motivation

The Internet Computer is powered by blockchain and its major impact is to bring WebApp to be truly decentralized. However, we are in the mobile internet era, even we can use Safari or Chrome on our cell phones. But most average people, not crypto enthusiasts, are likely to use native mobile apps, major users are there. 

It's important to attract these people to use Dapps of Internet Computer, by providing stable, fast, and fully integrated to Dfinity's blockchain. We likely to provide further solution to balancing the "Decentralization" and "Efficiency". But first things first, we have to make mobile native apps work.

`agent-rs` and `agent-js` are the actual lower level client-SDKs, just like `ether.js` or `web3.js` of Ethereum's ecosystem. This library is aiming to port and replicate features from them. And this library is mainly for mobile apps to connect canisters, not deploying contracts (you can do that if you want, but use dart directly).

We have tried our best to migrate most interface styles just like Javascript version, but there are limitations and differences between different programming languages, we will document them as much as possible.


### Milestones
TBD
### Documentation
TBD
### Contribution guideline
TBD



## Reference and related projects

* Official libraries from Dfinity's team:
  - [agent-rs](https://github.com/dfinity/agent-rs)
  - [agent-js](https://github.com/dfinity/agent-js)
* other projects here

---

## FAQ

### Build rust libraries for iOS/macOS
- All rust method have to be written inside `SwiftAgentDartPlugin.swift`, to avoid tree shaking of latest release build by XCode.
- The `agent_dart_podspec` should change accordingly when this repo goes 1.0.0

### Network problem in iOS and macOS

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

