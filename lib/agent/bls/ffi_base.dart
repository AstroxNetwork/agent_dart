import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'ffi_helper.dart';

///
/// rust func: `fn bls_init() -> bool`
///
typedef RustBlsInitFunc = int Function();
typedef RustBlsInitNative = Int32 Function();
final RustBlsInitFunc rustBlsInit =
    dylib.lookup<NativeFunction<RustBlsInitNative>>("bls_init").asFunction();

///
/// rust func: `fn bls_init() -> bool`
///
typedef RustBlsVerifyFunc = int Function(Pointer<Utf8> sig, Pointer<Utf8> m, Pointer<Utf8> w);
typedef RustBlsVerifyNative = Int32 Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
final RustBlsVerifyFunc rustBlsVerify =
    dylib.lookup<NativeFunction<RustBlsVerifyNative>>("bls_verify").asFunction();
