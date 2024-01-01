#!/bin/bash

# Setup
BUILD_DIR="platform-build"
PACKAGE_NAME="agent_dart"
RELEASE_ARCHIVE_NAME=$(grep -E "release_tag_name\s*=\s*'([^']+)" "ios/${PACKAGE_NAME}.podspec" | awk -F"'" '{print $2}')

mkdir $BUILD_DIR
cd $BUILD_DIR

TARGET_DIR="../target"

# Build static libs, including [iOS Devices, iOS Simulators, macOS Devices].
for TARGET in \
  aarch64-apple-ios \
  x86_64-apple-ios aarch64-apple-ios-sim \
  x86_64-apple-darwin aarch64-apple-darwin; do
  rustup target add $TARGET
  cargo build -r --target=$TARGET --target-dir=$TARGET_DIR
  mkdir -p ./dylib/$TARGET
  cp "${TARGET_DIR}/${TARGET}/release/lib${PACKAGE_NAME}.dylib" "./dylib/${TARGET}/lib${PACKAGE_NAME}.dylib"
done

# Create XCFramework zip
PLUGIN_NAME="AgentDartPlugin"
FRAMEWORK="AgentDart.xcframework"
LIB_NAME="libagent_dart.a"

mkdir ios-lipo ios-sim-lipo
IOS_LIPO="ios-lipo/${LIB_NAME}"
IOS_SIM_LIPO="ios-sim-lipo/${LIB_NAME}"
IOS_FRAMEWORK="ios_${FRAMEWORK}"

lipo -create -output $IOS_LIPO \
  "${TARGET_DIR}/aarch64-apple-ios/release/${LIB_NAME}"
lipo -create -output $IOS_SIM_LIPO \
  "${TARGET_DIR}/aarch64-apple-ios-sim/release/${LIB_NAME}" \
  "${TARGET_DIR}/x86_64-apple-ios/release/${LIB_NAME}"
xcodebuild -create-xcframework \
  -library $IOS_LIPO \
  -library $IOS_SIM_LIPO \
  -output $IOS_FRAMEWORK
zip -r $IOS_FRAMEWORK.zip $IOS_FRAMEWORK
cp -f $IOS_FRAMEWORK.zip "../ios/Frameworks/${RELEASE_ARCHIVE_NAME}.zip"
cp -r -f $IOS_FRAMEWORK ../ios/Frameworks

mkdir mac-lipo
MAC_LIPO="mac-lipo/${LIB_NAME}"
MAC_FRAMEWORK="macos_${FRAMEWORK}"
lipo -create -output $MAC_LIPO \
  "${TARGET_DIR}/aarch64-apple-darwin/release/${LIB_NAME}" \
  "${TARGET_DIR}/x86_64-apple-darwin/release/${LIB_NAME}"
xcodebuild -create-xcframework \
  -library $MAC_LIPO \
  -output $MAC_FRAMEWORK
zip -r $MAC_FRAMEWORK.zip $IOS_FRAMEWORK
cp -f $MAC_FRAMEWORK.zip "../macos/Frameworks/${RELEASE_ARCHIVE_NAME}.zip"
cp -r -f $MAC_FRAMEWORK ../macos/Frameworks
# Copy for flutter_test
cp -f "${TARGET_DIR}/aarch64-apple-darwin/release/${LIB_NAME}" "../test/_dylib/aarch64-apple-darwin/"
cp -f "${TARGET_DIR}/x86_64-apple-darwin/release/${LIB_NAME}" "../test/_dylib/x86_64-apple-darwin/"

# Cleanup
rm -rf ios-lipo ios-sim-lipo mac-lipo $IOS_FRAMEWORK $MAC_FRAMEWORK

# Copy headers
cd -
BRIDGE_HEADER_CONTENT=$(cat "rust/headers/bridge_generated.h")
echo -e "#import <Flutter/Flutter.h>

@interface AgentDartPlugin : NSObject<FlutterPlugin>
@end
$BRIDGE_HEADER_CONTENT" >"ios/Classes/$PLUGIN_NAME.h"
echo -e "#import <FlutterMacOS/FlutterMacOS.h>

@interface AgentDartPlugin : NSObject<FlutterPlugin>
@end
$BRIDGE_HEADER_CONTENT" >"macos/Classes/$PLUGIN_NAME.h"
