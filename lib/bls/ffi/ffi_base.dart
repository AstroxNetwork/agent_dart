import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'ffi_helper.dart';

///
/// rust func: `fn bls_init() -> bool`
///
typedef RustBlsInitFunc = Pointer<Utf8> Function();
typedef RustBlsInitNative = Pointer<Utf8> Function();
final RustBlsInitFunc rustBlsInit =
    dylib.lookup<NativeFunction<RustBlsInitNative>>("bls_init").asFunction();

///
/// rust func: `fn bls_init() -> bool`
///
typedef RustBlsVerifyFunc = Pointer<Utf8> Function(
    Pointer<Utf8> sig, Pointer<Utf8> m, Pointer<Utf8> w);
typedef RustBlsVerifyNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
final RustBlsVerifyFunc rustBlsVerify = dylib
    .lookup<NativeFunction<RustBlsVerifyNative>>("bls_verify")
    .asFunction();

typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef FreeStringFuncNative = Void Function(Pointer<Utf8>);
final FreeStringFunc freeCString = dylib
    .lookup<NativeFunction<FreeStringFuncNative>>("rust_cstr_free")
    .asFunction();
