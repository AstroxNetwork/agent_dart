#!/bin/bash

# Setup
BUILD_DIR=platform-build
PACKAGE_NAME=agent_dart
mkdir $BUILD_DIR
cd $BUILD_DIR

# Install build dependencies
cargo install cargo-zigbuild
cargo install cargo-xwin

zig_build () {
    local TARGET="$1"
    local PLATFORM_NAME="$2"
    local LIBNAME="$3"
    echo "Build Linux ${PLATFORM_NAME} ${LIBNAME}..."
    rustup target add "$TARGET"
    cargo zigbuild --target "$TARGET" -r --package=${PACKAGE_NAME}
    mkdir "$PLATFORM_NAME"
    cp "../target/$TARGET/release/$LIBNAME" "$PLATFORM_NAME/"
    mkdir -p "dylib/$TARGET"
    cp "../target/$TARGET/release/$LIBNAME" "dylib/$TARGET/"
}

win_build () {
    local TARGET="$1"
    local PLATFORM_NAME="$2"
    local LIBNAME="$3"
    echo "Build Windows ${PLATFORM_NAME} ${LIBNAME}..."
    rustup target add "$TARGET"
    cargo xwin build --target "$TARGET" -r --package=${PACKAGE_NAME}
    mkdir "$PLATFORM_NAME"
    cp "../target/$TARGET/release/$LIBNAME" "$PLATFORM_NAME/"
    mkdir -p "dylib/$TARGET"
    cp "../target/$TARGET/release/$LIBNAME" "dylib/$TARGET/"
}

# Build all the dynamic libraries
LINUX_LIBNAME=libagent_dart.so
zig_build aarch64-unknown-linux-gnu linux-arm64 $LINUX_LIBNAME
zig_build x86_64-unknown-linux-gnu linux-x64 $LINUX_LIBNAME
WINDOWS_LIBNAME=agent_dart.dll
win_build aarch64-pc-windows-msvc windows-arm64 $WINDOWS_LIBNAME
win_build x86_64-pc-windows-msvc windows-x64 $WINDOWS_LIBNAME

# Archive the dynamic libs
tar -czvf linux.tar.gz linux-* && cp linux.tar.gz "../packages/${PACKAGE_NAME}/linux/${PACKAGE_NAME}-v0.0.0.tar.gz"
tar -czvf windows.tar.gz windows-* && cp windows.tar.gz "../packages/${PACKAGE_NAME}/windows/${PACKAGE_NAME}-v0.0.0.tar.gz"

# Archive the dynamic libs
tar -czvf other.tar.gz linux-* windows-*

# Cleanup
rm -rf linux-* windows-*