#!/bin/bash

source ./scripts/variables.sh

cd rust

for i in "${!MACOS_ARCHS[@]}";
  do
    cargo lipo --release --targets="${MACOS_ARCHS[$i]}"
    mkdir -p "../macos/cli/${MACOS_ARCHS[$i]}"
    cp "./target/${MACOS_ARCHS[$i]}/release/lib${LIB_NAME}.dylib" "../macos/cli/${MACOS_ARCHS[$i]}/lib${LIB_NAME}.dylib"
done

echo "#import <FlutterMacOS/FlutterMacOS.h>

@interface AgentDartPlugin : NSObject<FlutterPlugin>
@end" > ../macos/Classes/AgentDartPlugin.h
cat ./headers/bridge_generated.h >> ../macos/Classes/AgentDartPlugin.h

lipo -create -output "../macos/lib${LIB_NAME}.a" "./target/aarch64-apple-darwin/release/libagent_dart.a" "./target/x86_64-apple-darwin/release/libagent_dart.a"
