#!/bin/bash

# Setup
BUILD_DIR="platform-build"
mkdir $BUILD_DIR
cd $BUILD_DIR

TARGET_DIR="target"

# Install build dependencies
cargo install cargo-zigbuild
cargo install cargo-xwin

zig_build() {
  local TARGET="$1"
  local PLATFORM_NAME="$2"
  local LIB_NAME="$3"
  rustup target add "$TARGET"
  cargo zigbuild --target "$TARGET" -r --target-dir $TARGET_DIR
  mkdir "$PLATFORM_NAME"
  cp "$TARGET_DIR/$TARGET/release/$LIB_NAME" "$PLATFORM_NAME/"
  mkdir -p "./dylib/$TARGET"
  cp "$TARGET_DIR/$TARGET/release/$LIB_NAME" "./dylib/$TARGET/"
}

win_build() {
  local TARGET="$1"
  local PLATFORM_NAME="$2"
  local LIB_NAME="$3"
  rustup target add "$TARGET"
  cargo xwin build --target "$TARGET" -r --target-dir $TARGET_DIR
  mkdir "$PLATFORM_NAME"
  cp "$TARGET_DIR/$TARGET/release/$LIB_NAME" "$PLATFORM_NAME/"
  mkdir -p ./dylib/$TARGET
  cp "$TARGET_DIR/$TARGET/release/$LIB_NAME" "./dylib/$TARGET/"
}

# Build all the dynamic libraries
LINUX_LIB_NAME=libagent_dart.so
zig_build aarch64-unknown-linux-gnu linux-arm64 $LINUX_LIB_NAME
zig_build x86_64-unknown-linux-gnu linux-x64 $LINUX_LIB_NAME
cp -f linux-x64/$LINUX_LIB_NAME "../linux/$LINUX_LIB_NAME"
WINDOWS_LIB_NAME=agent_dart.dll
win_build aarch64-pc-windows-msvc windows-arm64 $WINDOWS_LIB_NAME
win_build x86_64-pc-windows-msvc windows-x64 $WINDOWS_LIB_NAME
cp -f windows-x64/$WINDOWS_LIB_NAME "../windows/$WINDOWS_LIB_NAME"

# Archive the dynamic libs
tar -czvf other.tar.gz linux-* windows-*
#tar -czvf other.tar.gz linux-*
#tar -czvf other.tar.gz windows-*
cp -f other.tar.gz ../linux/
cp -f other.tar.gz ../windows/

# Cleanup
rm -rf linux-* windows-*
