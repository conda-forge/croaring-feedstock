@echo on
setlocal enabledelayedexpansion

set CPLUS_INCLUDE_PATH=%PREFIX%\include
set LIBRARY_PATH=%PREFIX%\lib

REM Create build directory
if not exist build mkdir build
cd build

REM Configure with cmake (tests enabled)
cmake -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBUILD_SHARED_LIBS=ON ^
    -DROARING_DISABLE_NATIVE=ON ^
    -DENABLE_ROARING_TESTS=ON ^
    %SRC_DIR%

REM Build and run tests
cmake --build . --target test

REM Clean artifacts from first build, to avoid installing tests
cmake --build . --target clean

REM Reconfigure with tests disabled, then install
cmake -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBUILD_SHARED_LIBS=ON ^
    -DROARING_DISABLE_NATIVE=ON ^
    -DENABLE_ROARING_TESTS=OFF ^
    %SRC_DIR%

cmake --build . --target install

endlocal
