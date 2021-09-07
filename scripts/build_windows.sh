#!/bin/bash

source ./scripts/variables.sh

cd rust

cargo build

cp "./target/debug/lib${LIB_NAME}.dll" "../linux/lib${LIB_NAME}.dll"