#!/bin/sh

cd packages
rm agent_dart/native agent_dart_base/native
cp -r agent_dart_ffi/native agent_dart/native
git rm --cached agent_dart/native
cp -r agent_dart_ffi/native agent_dart_base/native
git rm --cached agent_dart_base/native
