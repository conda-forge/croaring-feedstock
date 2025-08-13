@echo off
setlocal enabledelayedexpansion

set CPLUS_INCLUDE_PATH=%PREFIX%\include
set LIBRARY_PATH=%PREFIX%\lib

REM Create build directory
if not exist build mkdir build
cd build

REM Configure with cmake
cmake -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%PREFIX% ^
    -DCMAKE_INSTALL_LIBDIR=%PREFIX%\lib ^
    -DROARING_DISABLE_NATIVE=ON ^
    %SRC_DIR%

REM Build and install
cmake --build . --target install

REM Run tests
cmake --build . --target test

endlocal
