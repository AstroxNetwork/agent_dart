#!/bin/bash

source ./scripts/variables.sh

cd rust

for i in "${!MACOS_ARCHS[@]}";
  do
    cargo lipo --release --targets="${MACOS_ARCHS[$i]}"
    mkdir -p "../macos/cli/${MACOS_ARCHS[$i]}"
    cp "./target/${MACOS_ARCHS[$i]}/release/lib${LIB_NAME}.dylib" "../macos/cli/${MACOS_ARCHS[$i]}/lib${LIB_NAME}.dylib"
done
cp "./target/universal/release/lib${LIB_NAME}.a" "../macos/lib${LIB_NAME}.a"