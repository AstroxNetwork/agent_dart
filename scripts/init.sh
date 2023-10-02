#!/bin/bash

source ./scripts/variables.sh

echo "${OS_ARCH}-archs"

for i in "${ANDROID_ARCHS[@]}";
  do rustup target add "$i" ;
done

for i in "${IOS_ARCHS[@]}";
  do rustup target add "$i";
done

for i in "${MACOS_ARCHS[@]}";
  do rustup target add "$i";
done

for i in "${WIN_ARCHS[@]}";
  do rustup target add "$i";
done


dart pub global activate ffigen ^8.0.0 &&
cargo install flutter_rust_bridge_codegen --version 1.78.0 --force
