#!/bin/bash

source ./scripts/variables.sh

cd rust

# Build iOS
# cargo lipo --release
cargo lipo --release

# cbindgen ./src/lib.rs -c cbindgen.toml | grep -v \#include | uniq | cat > target/bindings.h

cp "./target/universal/release/lib${LIB_NAME}.a" "../ios/lib${LIB_NAME}.a"
# cp "./target/debug/lib${LIB_NAME}.a" "../ios/lib${LIB_NAME}.a"

echo "#import <Flutter/Flutter.h>

@interface AgentDartPlugin : NSObject<FlutterPlugin>
@end" > ../ios/Classes/AgentDartPlugin.h

cat ./headers/bridge_generated.h >> ../ios/Classes/AgentDartPlugin.h
