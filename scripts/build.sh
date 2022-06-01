#!/bin/bash

# build ffi
sh ./scripts/build_dart_ffi.sh

# cargo build
cd rust 
cargo build 
cargo test
cd ..

# build various
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



