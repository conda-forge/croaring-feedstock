#!/bin/bash

export CPLUS_INCLUDE_PATH=${PREFIX}/include
export LIBRARY_PATH=${PREFIX}/lib

if [ `uname` == "Darwin" ]; then
    touch header_snippet
    echo -e "#define _DARWIN_C_SOURCE\n" > header_snippet
    mv ${SRC_DIR}/tests/cpp_unit.cpp ${SRC_DIR}/tests/cpp_unit.cpp2
    cat header_snippet ${SRC_DIR}/tests/cpp_unit.cpp2 > ${SRC_DIR}/tests/cpp_unit.cpp
    rm ${SRC_DIR}/tests/cpp_unit.cpp2
fi

mkdir -p build
cd build
cmake -G "Ninja" \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
    -DROARING_DISABLE_NATIVE=ON \
    ${SRC_DIR}

cmake --build . --target install

if [[ "${BUILD_PLATFORM}" == "osx-64" && "${HOST_PLATFORM}" == "osx-arm64" ]]; then
    echo "Skipping tests, osx-arm64 tests are not runnable on osx-64"
else
    cmake --build . --target test
fi
