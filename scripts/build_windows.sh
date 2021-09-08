#!/bin/bash

source ./scripts/variables.sh

cd rust

cargo build

cp ".\\target\\debug\\${LIB_NAME}.dll" "..\\windows\\${LIB_NAME}.dll"