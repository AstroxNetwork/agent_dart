#!/bin/bash
rm -rf lib/protobuf &&
mkdir lib/protobuf &&
protoc --proto_path=protobuf --dart_out=lib/protobuf protobuf/ic_base_types/pb/v1/types.proto protobuf/ic_ledger/pb/v1/types.proto