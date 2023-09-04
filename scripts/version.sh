#!/bin/bash

CURR_VERSION=agent_dart-v`awk '/^version: /{print $2}' packages/agent_dart_ffi/pubspec.yaml`

# iOS & macOS
APPLE_HEADER="release_tag_name = '$CURR_VERSION' # generated; do not edit"
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/agent_dart/ios/agent_dart.podspec
sed -i.bak "1 s/.*/$APPLE_HEADER/" packages/agent_dart/macos/agent_dart.podspec
rm packages/agent_dart/macos/*.bak packages/agent_dart/ios/*.bak

# CMake platforms (Linux, Windows, and Android)
CMAKE_HEADER="set(LibraryVersion \"$CURR_VERSION\") # generated; do not edit"
for CMAKE_PLATFORM in android linux windows
do
    sed -i.bak "1 s/.*/$CMAKE_HEADER/" packages/agent_dart/$CMAKE_PLATFORM/CMakeLists.txt
    rm packages/agent_dart/$CMAKE_PLATFORM/*.bak
done

git add packages/agent_dart/