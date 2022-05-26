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

# for i in "${LINUX_ARCHS[@]}";
#   do rustup target add "$i";
# done

# cargo install cargo-lipo && cargo install cbindgen --force


dart pub global activate ffigen &&
cargo install flutter_rust_bridge_codegen



