import 'dart:ffi';
import 'dart:io' show Platform;
// import 'package:args/args.dart';

const libName = "agent_dart";
const androidlibName = "lib$libName.so";

final dylib = Platform.isAndroid
    ? DynamicLibrary.open(androidlibName)
    : Platform.isIOS
        ? DynamicLibrary.process()
        : Platform.isMacOS
            ? Platform.environment["_"] == null ||
                    (Platform.environment["_"] != null &&
                        Platform.environment["FLUTTER_ENGINE_SWITCH_1"] !=
                            null) // see if we use 'dart xx.dart' to test directly,otherwise we see it's a flutter app.
                ? DynamicLibrary.open("lib$libName.dylib")
                : DynamicLibrary.open("macos/lib$libName.dylib")
            : Platform.isLinux
                ? Platform.environment["_"] == null ||
                        (Platform.environment["_"] != null &&
                            Platform.environment["FLUTTER_ENGINE_SWITCH_1"] !=
                                null) // see if we use 'dart xx.dart' to test directly,otherwise we see it's a flutter app.
                    ? DynamicLibrary.open("lib$libName.dylib")
                    : DynamicLibrary.open("linux/lib$libName.so")
                : Platform.isWindows // not tested in windows, should see if anything different
                    ? DynamicLibrary.open("windows/$libName.dll")
                    : DynamicLibrary.open("rust/target/debug/lib$libName.dylib");
