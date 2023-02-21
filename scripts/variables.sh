#!/bin/bash

# Change this name to the rust library name
LIB_NAME=agent_dart
API_LEVEL=23
# SYSTEM_ARCH=`arch`

ANDROID_ARCHS=(aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android)
# ANDROID_FOLDER=(arm64-v8a armeabi-v7a x86 x86_64)
ANDROID_FOLDER=(arm64-v8a armeabi-v7a x86 x86_64)
ANDROID_BIN_PREFIX=(aarch64-linux-android armv7a-linux-androideabi i686-linux-android)
IOS_ARCHS=(aarch64-apple-ios x86_64-apple-ios)
MACOS_ARCHS=(aarch64-apple-darwin x86_64-apple-darwin)
WIN_ARCHS=(x86_64-pc-windows-msvc)
# LINUX_ARCHS=(x86_64-unknown-linux-gnu)
OS_ARCH=$(uname | tr '[:upper:]' '[:lower:]')
# MAKER="$NDK_HOME/build/tools/make_standalone_toolchain.py"
ANDROID_PREBUILD_BIN="$NDK_HOME/toolchains/llvm/prebuilt/${OS_ARCH}-x86_64/bin"
