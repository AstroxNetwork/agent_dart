@echo off

REM Setup
set BUILD_DIR=platform-build
set PACKAGE_NAME=agent_dart
mkdir %BUILD_DIR%
cd %BUILD_DIR%

REM Install build dependencies
cargo install cargo-xwin

REM Build all the dynamic libraries
call :win_build aarch64-pc-windows-msvc windows-arm64 agent_dart.dll
call :win_build x86_64-pc-windows-msvc windows-x64 agent_dart.dll

REM Archive the dynamic libs
tar -czvf windows.tar.gz windows-* && copy windows.tar.gz "..\packages\%PACKAGE_NAME%\windows\%PACKAGE_NAME%-v0.0.0.tar.gz"

REM Archive the dynamic libs
tar -czvf other.tar.gz linux-* windows-*

REM Cleanup
del /s /q linux-* windows-*
exit /b

:win_build
    set TARGET=%~1
    set PLATFORM_NAME=%~2
    set LIBNAME=%~3
    IF "%TARGET%"=="" (
        echo TARGET is empty. Exiting...
        goto :EOF
    )
    echo Build Windows %TARGET% %PLATFORM_NAME% %LIBNAME%...
    rustup target add %TARGET%
    cargo xwin build --target %TARGET% -r --package=%PACKAGE_NAME%
    mkdir %PLATFORM_NAME%
    copy "..\target\%TARGET%\release\%LIBNAME%" "%PLATFORM_NAME%\"
    mkdir "dylib\%TARGET%"
    copy "..\target\%TARGET%\release\%LIBNAME%" "dylib\%TARGET%\"
    goto :EOF
