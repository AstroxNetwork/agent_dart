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
typedef RustBlsVerifyNative = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
final RustBlsVerifyFunc rustBlsVerify =
    dylib.lookup<NativeFunction<RustBlsVerifyNative>>("bls_verify").asFunction();

typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef FreeStringFuncNative = Void Function(Pointer<Utf8>);
final FreeStringFunc freeCString =
    dylib.lookup<NativeFunction<FreeStringFuncNative>>("rust_cstr_free").asFunction();

///
/// `fn rust_pbkdf2(data: *const c_char, salt: *const c_char, rounds: u32) -> *mut c_char`
///
typedef RustPbkdf2Func = Pointer<Utf8> Function(Pointer<Utf8> data, Pointer<Utf8> salt, int rounds);
typedef RustPbkdf2Native = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>, Uint32);
final RustPbkdf2Func rustPbkdf2 =
    dylib.lookup<NativeFunction<RustPbkdf2Native>>("rust_pbkdf2").asFunction();

typedef RustEncrypt = Pointer<Utf8> Function(Pointer<Utf8> data, Pointer<Utf8> password);
typedef RustEncryptNative = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
final RustEncrypt rustEncrypt =
    dylib.lookup<NativeFunction<RustEncryptNative>>("encrypt_data").asFunction();

typedef RustDecrypt = Pointer<Utf8> Function(Pointer<Utf8> data, Pointer<Utf8> password);
typedef RustDecryptNative = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
final RustDecrypt rustDecrypt =
    dylib.lookup<NativeFunction<RustDecryptNative>>("decrypt_data").asFunction();
