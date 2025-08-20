@echo on
setlocal enabledelayedexpansion

set CPLUS_INCLUDE_PATH=%PREFIX%\include
set LIBRARY_PATH=%PREFIX%\lib

REM Create build directory
if not exist build mkdir build
cd build

REM Configure with cmake
cmake -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_BINDIR=%LIBRARY_BIN% ^
    -DCMAKE_INSTALL_INCLUDEDIR=%LIBRARY_INC% ^
    -DCMAKE_INSTALL_LIBDIR=%LIBRARY_LIB% ^
    -DROARING_DISABLE_NATIVE=ON ^
    %SRC_DIR%

REM Build and install
cmake --build . --target install

REM Run tests
cmake --build . --target test

endlocal
