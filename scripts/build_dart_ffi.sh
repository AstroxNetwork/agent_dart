#!/bin/bash
flutter_rust_bridge_codegen \
-r rust/src/api.rs \
-d lib/bridge/ffi/bridge_generated.dart \
-c rust/headers/bridge_generated.h