#!/bin/bash

# Read the corresponding FRB dependency version.
if [ ! -f pubspec.lock ]; then
  flutter pub get
fi
FRB_VERSION=$(awk '/^  flutter_rust_bridge:/ { getline; while (getline > 0) { if ($0 ~ /^    version:/) { gsub(/"/, "", $2); print $2; break; } } }' pubspec.lock)
echo "flutter_rust_bridge: $FRB_VERSION"

# Force to use the same version as defined.
frb_codegen_force_install() {
  cargo install flutter_rust_bridge_codegen --version "$FRB_VERSION" --force
}

if ! command -v flutter_rust_bridge_codegen >/dev/null 2>&1; then
  frb_codegen_force_install
else
  CODEGEN_VERSION=$(flutter_rust_bridge_codegen --version | awk '{print $2}')
  if [ "$CODEGEN_VERSION" != "$FRB_VERSION" ]; then
    frb_codegen_force_install
  fi
fi

flutter_rust_bridge_codegen
