#!/bin/bash

# Setup
BUILD_DIR=platform-build
LIB_NAME=agent_dart


mkdir $BUILD_DIR
cd $BUILD_DIR


for TARGET in \
        aarch64-apple-darwin
do
    rustup target add $TARGET
    cargo build -r --target=$TARGET
    mkdir -p ./dylib/$TARGET
    cp ../target/$TARGET/release/lib${LIB_NAME}.dylib ./dylib/$TARGET/lib${LIB_NAME}.dylib
done



# Create XCFramework zip
FRAMEWORK="AgentDart.xcframework"
LIBNAME=libagent_dart.a
mkdir mac-lipo ios-sim-lipo
IOS_SIM_LIPO=ios-sim-lipo/$LIBNAME
MAC_LIPO=mac-lipo/$LIBNAME
lipo -create -output $IOS_SIM_LIPO \
        ../target/aarch64-apple-ios-sim/release/$LIBNAME \
        ../target/x86_64-apple-ios/release/$LIBNAME
lipo -create -output $MAC_LIPO \
        ../target/aarch64-apple-darwin/release/$LIBNAME \
        ../target/x86_64-apple-darwin/release/$LIBNAME
xcodebuild -create-xcframework \
        -library $IOS_SIM_LIPO \
        -library $MAC_LIPO \
        -library ../target/aarch64-apple-ios/release/$LIBNAME \
        -output $FRAMEWORK
zip -r $FRAMEWORK.zip $FRAMEWORK

cp -r -f $FRAMEWORK ../packages/agent_dart/ios/Frameworks
cp -r -f $FRAMEWORK ../packages/agent_dart/macos/Frameworks

# Cleanup
rm -rf ios-sim-lipo mac-lipo $FRAMEWORK