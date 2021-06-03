import 'dart:ffi';
import 'dart:io' show Platform;

const libName = "agent_dart";
const androidlibName = "lib$libName.so";

final dylib = Platform.isAndroid
    ? DynamicLibrary.open(androidlibName)
    : Platform.isIOS
        ? DynamicLibrary.process()
        : Platform.isMacOS
            ? DynamicLibrary.open("macos/lib$libName.dylib")
            : Platform.isLinux
                ? DynamicLibrary.open("linux/lib$libName.so")
                : Platform.isWindows
                    ? DynamicLibrary.open("windows/lib$libName.dll")
                    : DynamicLibrary.open("rust/target/debug/lib$libName.dylib");
