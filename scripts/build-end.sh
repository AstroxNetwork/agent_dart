cargo build
mkdir -p "./dylib/debug"
cp "./target/debug/lib${LIB_NAME}.dylib" "./dylib/debug/lib${LIB_NAME}.dylib"
