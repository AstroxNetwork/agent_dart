# Agent Dart API Overview

This document provides a high-level overview of the public `agent_dart` APIs for Internet Computer client developers.

## Core Modules

- Agent: request signing, transport, and canister calls.
- Identity: key management and request authentication.
- Candid: encoding/decoding service arguments.
- Principal: Internet Computer principal representation.

## Agent Lifecycle

1. Create or load an identity.
2. Configure an agent with host and identity.
3. Fetch root key for local replica/devnet.
4. Build canister actor or direct query/update calls.
5. Decode responses with Candid types.

## Documentation Goals

This guide is a starting point for issue #13 and can be expanded with dartdoc comments for each public class and method.
