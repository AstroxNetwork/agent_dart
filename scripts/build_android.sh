#!/bin/bash

source ./scripts/variables.sh

cd rust

CC_aarch64_linux_android="${ANDROID_PREBUILD_BIN}/aarch64-linux-android${API_LEVEL}-clang" \
AR_aarch64_linux_android="${ANDROID_PREBUILD_BIN}/aarch64-linux-android-ar" \
CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="${ANDROID_PREBUILD_BIN}/aarch64-linux-android${API_LEVEL}-clang" \
  cargo ndk --bindgen -t aarch64-linux-android -o ../android/src/main/jniLibs build

CC_armv7_linux_androideabi="${ANDROID_PREBUILD_BIN}/armv7a-linux-androideabi${API_LEVEL}-clang" \
AR_armv7_linux_androideabi="${ANDROID_PREBUILD_BIN}/arm-linux-androideabi-ar" \
CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER="${ANDROID_PREBUILD_BIN}/armv7a-linux-androideabi${API_LEVEL}-clang" \
  cargo ndk --bindgen -t armv7-linux-androideabi -o ../android/src/main/jniLibs build

CC_i686_linux_android="${ANDROID_PREBUILD_BIN}/i686-linux-android${API_LEVEL}-clang" \
AR_i686_linux_android="${ANDROID_PREBUILD_BIN}/i686-linux-android-ar" \
CARGO_TARGET_I686_LINUX_ANDROID_LINKER="${ANDROID_PREBUILD_BIN}/i686-linux-android${API_LEVEL}-clang" \
  cargo ndk --bindgen -t i686-linux-android -o ../android/src/main/jniLibs build

CC_x86_64_linux_android="${ANDROID_PREBUILD_BIN}/x86_64-linux-android${API_LEVEL}-clang" \
AR_x86_64_linux_android="${ANDROID_PREBUILD_BIN}/x86_64-linux-android-ar" \
CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER="${ANDROID_PREBUILD_BIN}/x86_64-linux-android${API_LEVEL}-clang" \
  cargo ndk --bindgen -t x86_64-linux-android -o ../android/src/main/jniLibs build
