#!/bin/bash

source ./scripts/variables.sh

cd rust

cargo build

cp ".\\target\\debug\\lib${LIB_NAME}.dll" "..\\windows\\lib${LIB_NAME}.dll"