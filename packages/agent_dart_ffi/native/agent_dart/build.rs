use std::env;
use std::ffi::OsStr;
use std::path::PathBuf;
use std::process::Command;

/// The Clang version that the NDK version pinned in `gradle.properties` should be using.
const ANDROID_NDK_CLANG_VERSION: &str = "17";

fn main() {
    setup_x86_64_android_workaround();
}

/// Adds a temporary workaround for [an issue] with the Rust compiler and Android when
/// compiling for x86_64 devices.
///
/// The Android NDK used to include `libgcc` for unwind support (which is required by Rust
/// among others). From NDK r23, `libgcc` is removed, replaced by LLVM's `libunwind`.
/// However, `libgcc` was ambiently providing other compiler builtins, one of which we
/// require: `__extenddftf2` for software floating-point emulation. This is used by SQLite
/// (via the `rusqlite` crate), which defines a `LONGDOUBLE_TYPE` type as `long double`.
///
/// Rust uses a `compiler-builtins` crate that does not provide `__extenddftf2` because
/// [it involves floating-point types that are not supported by Rust][unsupported]. For
/// some reason, they _do_ export this symbol for `aarch64-linux-android`, but they do not
/// for `x86_64-linux-android`. Thus we run into a problem when trying to compile and run
/// the SDK on an x86_64 emulator.
///
/// The workaround comes from [this Mozilla PR]: we tell Cargo to statically link the
/// builtins from the Clang runtime provided inside the NDK, to provide this symbol.
///
/// [an issue]: https://github.com/rust-lang/rust/issues/109717
/// [this Mozilla PR]:https://github.com/mozilla/application-services/pull/5442
/// [unsupported]: https://github.com/rust-lang/compiler-builtins#unimplemented-functions
fn setup_x86_64_android_workaround() {
    let target_os = env::var("CARGO_CFG_TARGET_OS").expect("CARGO_CFG_TARGET_OS not set");
    let target_arch = env::var("CARGO_CFG_TARGET_ARCH").expect("CARGO_CFG_TARGET_ARCH not set");

    if target_arch == "x86_64" && target_os == "android" {
        let cc = if let Some(cc) = env::var_os("RUST_ANDROID_GRADLE_CC") {
            // We are building in the context of the `org.mozilla.rust-android-gradle`
            // plugin, which knows where the NDK is and provides the Clang path.
            PathBuf::from(cc)
        } else {
            // We are probably building directly on the CLI. Construct a path to Clang.
            let android_ndk_home =
                env::var_os("ANDROID_NDK_HOME").expect("ANDROID_NDK_HOME not set");
            let build_os = match env::consts::OS {
                "linux" => "linux",
                "macos" => "darwin",
                "windows" => "windows",
                _ => panic!(
                    "Unsupported OS. You must use either Linux, MacOS or Windows to build the crate."
                ),
            };

            let mut cc = PathBuf::from(android_ndk_home);
            cc.push("toolchains");
            cc.push("llvm");
            cc.push("prebuilt");
            cc.push(format!("{build_os}-x86_64"));
            cc.push("bin");
            cc.push("clang");
            cc.set_extension(env::consts::EXE_EXTENSION);
            cc
        };

        let mut link_path = cc
            .ancestors()
            .nth(2)
            .expect("path format is known")
            .join("lib");
        link_path.push("clang");
        link_path.push(get_clang_version(&cc));
        link_path.push("lib");
        link_path.push("linux");

        if link_path.exists() {
            println!("cargo:rustc-link-search={}", link_path.display());
            println!("cargo:rustc-link-lib=static=clang_rt.builtins-x86_64-android");
        } else {
            panic!("Path {} does not exist", link_path.display());
        }
    }
}

fn get_clang_version(cc: impl AsRef<OsStr>) -> String {
    let clang_version_output = Command::new(cc)
        .arg("--version")
        .output()
        .ok()
        .and_then(|o| String::from_utf8(o.stdout).ok());
    clang_version_output
        .as_deref()
        .and_then(|s| s.split_once("clang version "))
        .and_then(|(_, s)| s.split_once('.'))
        .map(|(major_version, _)| major_version)
        // If we couldn't run Clang for some reason, default to the Clang version that the
        // NDK version pinned in `gradle.properties` should be using.
        .unwrap_or(ANDROID_NDK_CLANG_VERSION)
        .into()
}
