@echo off

REM Setup
set BUILD_DIR="platform-build"
set PACKAGE_NAME="agent_dart"
set RELEASE_ARCHIVE_NAME="agent_dart-v0.0.0"

mkdir %BUILD_DIR%
cd %BUILD_DIR%

set JNI_DIR="jniLibs"
mkdir %JNI_DIR%

REM Install build dependencies
cargo install cargo-ndk
rustup target add ^
  aarch64-linux-android ^
  armv7-linux-androideabi ^
  x86_64-linux-android ^
  i686-linux-android

REM Build the android libraries in the jniLibs directory
cargo ndk -o %JNI_DIR% ^
  --manifest-path "..\packages\agent_dart_ffi\native\agent_dart\Cargo.toml" ^
  -t armeabi-v7a ^
  -t arm64-v8a ^
  -t x86 ^
  -t x86_64 ^
  build --release

REM Archive the dynamic libs
cd %JNI_DIR%
tar -czvf "..\android.tar.gz" *
cd ..
copy /y android.tar.gz "..\packages\%PACKAGE_NAME%\android\%RELEASE_ARCHIVE_NAME%.tar.gz"
del /s /q %JNI_DIR%
exit /b
