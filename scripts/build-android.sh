#!/bin/bash

# Setup
BUILD_DIR="platform-build"
PACKAGE_NAME="agent_dart"
RELEASE_ARCHIVE_NAME=$(grep -E 'set\(LibraryVersion "(.+)"\)' "packages/${PACKAGE_NAME}/android/CMakeLists.txt" | awk -F'"' '{print $2}')

mkdir $BUILD_DIR
cd $BUILD_DIR

# Create the jniLibs build directory
JNI_DIR=jniLibs
mkdir $JNI_DIR

# Set up cargo-ndk
cargo install cargo-ndk
rustup target add \
        aarch64-linux-android \
        armv7-linux-androideabi \
        x86_64-linux-android \
        i686-linux-android

# Build the android libraries in the jniLibs directory
cargo ndk -o $JNI_DIR \
        --manifest-path "../packages/agent_dart_ffi/native/agent_dart/Cargo.toml" \
        -t armeabi-v7a \
        -t arm64-v8a \
        -t x86 \
        -t x86_64 \
        build --release

cp -r -f $JNI_DIR "../packages/${PACKAGE_NAME}/android/src/main"

# Archive the dynamic libs
cd $JNI_DIR
tar -czvf ../android.tar.gz *
cd -

# Cleanup
cp -f android.tar.gz "../packages/${PACKAGE_NAME}/android/${RELEASE_ARCHIVE_NAME}.tar.gz"
rm -rf $JNI_DIR
