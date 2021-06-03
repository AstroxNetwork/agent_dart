#!/bin/bash

source ./scripts/variables.sh

cd rust

# Build iOS
cargo lipo --release

cbindgen ./src/lib.rs -c cbindgen.toml | grep -v \#include | uniq | cat > target/bindings.h

cp "./target/universal/release/lib${LIB_NAME}.a" "../ios/lib${LIB_NAME}.a"

echo "#import <Flutter/Flutter.h>

@interface PolkadotDartPlugin : NSObject<FlutterPlugin>
@end" > ../ios/Classes/PolkadotDartPlugin.h

cat ./target/bindings.h >> ../ios/Classes/PolkadotDartPlugin.h