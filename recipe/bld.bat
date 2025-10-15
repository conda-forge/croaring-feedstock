@echo on
setlocal enabledelayedexpansion

set CPLUS_INCLUDE_PATH=%PREFIX%\include
set LIBRARY_PATH=%PREFIX%\lib

REM Create build directory
if not exist build mkdir build
cd build

REM Configure with tests disabled, then install
cmake -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBUILD_SHARED_LIBS=ON ^
    -DROARING_DISABLE_NATIVE=ON ^
    -DENABLE_ROARING_TESTS=OFF ^
    %SRC_DIR%

cmake --build . --target install

endlocal
