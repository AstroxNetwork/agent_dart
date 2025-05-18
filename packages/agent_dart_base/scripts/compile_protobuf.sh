#!/bin/sh

cd $(dirname "$0")
cd ../
# brew install cproto
# dart pub global activate protoc_plugin
protoc --proto_path=protobuf \
    --dart_out=lib/protobuf \
    protobuf/ic_base_types/pb/v1/types.proto \
    protobuf/ic_ledger/pb/v1/types.proto
