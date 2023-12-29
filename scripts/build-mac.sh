#!/bin/bash

# Setup
BUILD_DIR="platform-build"
PACKAGE_NAME="agent_dart"
RELEASE_ARCHIVE_NAME=$(grep -E "release_tag_name\s*=\s*'([^']+)" "packages/${PACKAGE_NAME}/ios/${PACKAGE_NAME}.podspec" | awk -F"'" '{print $2}')

mkdir $BUILD_DIR
cd $BUILD_DIR

# Build static libs, including [macOS Devices].
for TARGET in \
  x86_64-apple-darwin aarch64-apple-darwin; do
  rustup target add $TARGET
  cargo build -r --target=$TARGET --package=$PACKAGE_NAME
  mkdir -p ./dylib/$TARGET
  cp ../target/$TARGET/release/lib${PACKAGE_NAME}.dylib ./dylib/$TARGET/lib${PACKAGE_NAME}.dylib
done

# Create XCFramework zip
FRAMEWORK="AgentDart.xcframework"
LIB_NAME="libagent_dart.a"

mkdir mac-lipo
MAC_LIPO="mac-lipo/${LIB_NAME}"

lipo -create -output $MAC_LIPO \
  "../target/aarch64-apple-darwin/release/${LIB_NAME}" \
  "../target/x86_64-apple-darwin/release/${LIB_NAME}"
xcodebuild -create-xcframework \
  -library $MAC_LIPO \
  -output $FRAMEWORK

zip -r $FRAMEWORK.zip $FRAMEWORK
cp -f $FRAMEWORK.zip "../packages/$PACKAGE_NAME/macos/Frameworks/${RELEASE_ARCHIVE_NAME}.zip"
cp -r -f $FRAMEWORK ../packages/$PACKAGE_NAME/macos/Frameworks

# Cleanup
rm -rf mac-lipo $FRAMEWORK
