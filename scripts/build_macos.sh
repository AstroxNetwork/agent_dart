#!/bin/bash

# Setup
BUILD_DIR="platform-build"
PACKAGE_NAME="agent_dart"
RELEASE_ARCHIVE_NAME=$(grep -E "release_tag_name\s*=\s*'([^']+)" "packages/${PACKAGE_NAME}/ios/${PACKAGE_NAME}.podspec" | awk -F"'" '{print $2}')

mkdir $BUILD_DIR
cd $BUILD_DIR

TARGET_DIR="../target"

# Build static libs, including [macOS Devices].
for TARGET in \
  x86_64-apple-darwin aarch64-apple-darwin; do
  rustup target add $TARGET
  cargo build -r --target=$TARGET --target-dir=$TARGET_DIR
  mkdir -p ./dylib/$TARGET
  cp "${TARGET_DIR}/${TARGET}/release/lib${PACKAGE_NAME}.dylib" "./dylib/${TARGET}/lib${PACKAGE_NAME}.dylib"
done

# Create XCFramework zip
FRAMEWORK="AgentDart.xcframework"
LIB_NAME="libagent_dart.a"

mkdir mac-lipo
MAC_LIPO="mac-lipo/${LIB_NAME}"

lipo -create -output $MAC_LIPO \
  "${TARGET_DIR}/aarch64-apple-darwin/release/${LIB_NAME}" \
  "${TARGET_DIR}/x86_64-apple-darwin/release/${LIB_NAME}"
xcodebuild -create-xcframework \
  -library $MAC_LIPO \
  -output $FRAMEWORK

zip -r $FRAMEWORK.zip $FRAMEWORK
cp -f $FRAMEWORK.zip "../macos/Frameworks/${RELEASE_ARCHIVE_NAME}.zip"
cp -r -f $FRAMEWORK ../macos/Frameworks

# Cleanup
rm -rf mac-lipo $FRAMEWORK
