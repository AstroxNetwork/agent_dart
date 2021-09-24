#!/bin/bash

# source ./scripts/variables.sh


# cd ./rust

# Build iOS
# cargo lipo --release

# cbindgen ./src/lib.rs -c cbindgen.toml | grep -v \#include | uniq | cat > target/bindings.h

# cp "./target/universal/release/lib${LIB_NAME}.a" "../ios/lib${LIB_NAME}.a"

# # build for macos and linux
# cargo build

# SYSTEM=`uname -s`
# if [ "$SYSTEM" = "Darwin" ] 
#   then
#     if [ "$(cp ./target/debug/lib${LIB_NAME}.dylib ../macos/lib${LIB_NAME}.dylib)" != "abc" ];
#       then echo "lib${LIB_NAME}.dylib for macos created"; 
#       else echo "lib${LIB_NAME}.dylib failed to create";
#     fi 
# elif [ "$SYSTEM" = "Linux" ]
#   then  cp "./target/debug/lib${LIB_NAME}.so" "../linux/lib${LIB_NAME}.so"
# fi


# echo "#import <Flutter/Flutter.h>

# @interface PolkadotDartPlugin : NSObject<FlutterPlugin>
# @end" > ../ios/Classes/PolkadotDartPlugin.h

# cat ./target/bindings.h >> ../ios/Classes/PolkadotDartPlugin.h




# CC_aarch64_linux_android="${ANDROID_PREBUILD_BIN}/aarch64-linux-android${API_LEVEL}-clang" \
# AR_aarch64_linux_android="${ANDROID_PREBUILD_BIN}/aarch64-linux-android-ar" \
# CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="${ANDROID_PREBUILD_BIN}/aarch64-linux-android${API_LEVEL}-clang" \
#   cargo build --target aarch64-linux-android --release

# CC_armv7_linux_androideabi="${ANDROID_PREBUILD_BIN}/armv7a-linux-androideabi${API_LEVEL}-clang" \
# AR_armv7_linux_androideabi="${ANDROID_PREBUILD_BIN}/arm-linux-androideabi-ar" \
# CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER="${ANDROID_PREBUILD_BIN}/armv7a-linux-androideabi${API_LEVEL}-clang" \
#   cargo build --target armv7-linux-androideabi --release

# CC_i686_linux_android="${ANDROID_PREBUILD_BIN}/i686-linux-android${API_LEVEL}-clang" \
# AR_i686_linux_android="${ANDROID_PREBUILD_BIN}/i686-linux-android-ar" \
# CARGO_TARGET_I686_LINUX_ANDROID_LINKER="${ANDROID_PREBUILD_BIN}/i686-linux-android${API_LEVEL}-clang" \
#   cargo  build --target i686-linux-android --release

# CC_x86_64_linux_android="${ANDROID_PREBUILD_BIN}/x86_64-linux-android${API_LEVEL}-clang" \
# AR_x86_64_linux_android="${ANDROID_PREBUILD_BIN}/x86_64-linux-android-ar" \
# CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER="${ANDROID_PREBUILD_BIN}/x86_64-linux-android${API_LEVEL}-clang" \
#   cargo  build --target x86_64-linux-android --release

# for i in "${!ANDROID_ARCHS[@]}";
#   do
#     mkdir -p "../android/src/main/jniLibs/${ANDROID_FOLDER[$i]}"
#     cp "./target/${ANDROID_ARCHS[$i]}/release/lib${LIB_NAME}.so" "../android/src/main/jniLibs/${ANDROID_FOLDER[$i]}/lib${LIB_NAME}.so"
# done

SYSTEM=`uname -s`
if [ "$SYSTEM" = "Darwin" ] 
  then
    sh ./scripts/build_ios.sh
    sh ./scripts/build_android.sh 
    sh ./scripts/build_macos.sh 
    sh ./scripts/build_end.sh 
elif [ "$SYSTEM" = "Linux" ]
  then
    bash ./scripts/build_android.sh
    bash ./scripts/build_linux.sh
elif [ "$SYSTEM" = "Windows" ]
  then
    bash ./scripts/build_windows.sh
fi



