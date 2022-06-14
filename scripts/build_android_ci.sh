#!/bin/bash

source ./scripts/variables.sh

cd rust

export CC_aarch64_linux_android="${ANDROID_PREBUILD_BIN}/aarch64-linux-android${API_LEVEL}-clang"
export AR_aarch64_linux_android="${ANDROID_PREBUILD_BIN}/aarch64-linux-android-ar"
export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="${ANDROID_PREBUILD_BIN}/aarch64-linux-android${API_LEVEL}-clang"
export TARGET_CC="${ANDROID_PREBUILD_BIN}/aarch64-linux-android${API_LEVEL}-clang"
export TARGET_AR="${ANDROID_PREBUILD_BIN}/aarch64-linux-android-ar"
cargo build --target aarch64-linux-android --release

export CC_armv7_linux_androideabi="${ANDROID_PREBUILD_BIN}/armv7a-linux-androideabi${API_LEVEL}-clang"
export AR_armv7_linux_androideabi="${ANDROID_PREBUILD_BIN}/arm-linux-androideabi-ar"
export CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER="${ANDROID_PREBUILD_BIN}/armv7a-linux-androideabi${API_LEVEL}-clang"
export TARGET_CC="${ANDROID_PREBUILD_BIN}/armv7a-linux-androideabi${API_LEVEL}-clang"
export TARGET_AR="${ANDROID_PREBUILD_BIN}/arm-linux-androideabi-ar"
cargo build --target armv7-linux-androideabi --release

export CC_i686_linux_android="${ANDROID_PREBUILD_BIN}/i686-linux-android${API_LEVEL}-clang"
export AR_i686_linux_android="${ANDROID_PREBUILD_BIN}/i686-linux-android-ar"
export CARGO_TARGET_I686_LINUX_ANDROID_LINKER="${ANDROID_PREBUILD_BIN}/i686-linux-android${API_LEVEL}-clang"
export TARGET_CC="${ANDROID_PREBUILD_BIN}/i686-linux-android${API_LEVEL}-clang"
export TARGET_AR="${ANDROID_PREBUILD_BIN}/i686-linux-android-ar"
cargo build --target i686-linux-android --release

export CC_x86_64_linux_android="${ANDROID_PREBUILD_BIN}/x86_64-linux-android${API_LEVEL}-clang"
export AR_x86_64_linux_android="${ANDROID_PREBUILD_BIN}/x86_64-linux-android-ar"
export CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER="${ANDROID_PREBUILD_BIN}/x86_64-linux-android${API_LEVEL}-clang"
export TARGET_CC="${ANDROID_PREBUILD_BIN}/x86_64-linux-android${API_LEVEL}-clang"
export TARGET_AR="${ANDROID_PREBUILD_BIN}/x86_64-linux-android-ar"
cargo build --target x86_64-linux-android --release

for i in "${!ANDROID_ARCHS[@]}";
  do
    mkdir -p "../android/src/main/jniLibs/${ANDROID_FOLDER[$i]}"
    cp "./target/${ANDROID_ARCHS[$i]}/release/lib${LIB_NAME}.so" "../android/src/main/jniLibs/${ANDROID_FOLDER[$i]}/lib${LIB_NAME}.so"
done