#!/bin/bash

rm -rf lib/protobuf
mkdir lib/protobuf

# Activate protoc_plugin with `dart pub global activate protoc_plugin`.
if ! command -v protoc-gen-dart >/dev/null 2>&1; then
  dart pub global activate protoc_plugin
fi

# Download protoc from https://github.com/protocolbuffers/protobuf/releases/latest.
./scripts/protoc \
  --proto_path=protobuf \
  --dart_out=lib/protobuf \
  protobuf/ic_base_types/pb/v1/types.proto \
  protobuf/ic_ledger/pb/v1/types.proto

dart format lib/protobuf
