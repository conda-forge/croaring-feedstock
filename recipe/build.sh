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

# Create build directory
mkdir -p build
cd build

# Run tests
if [[ "${build_platform}" == "osx-64" && "${target_platform}" == "osx-arm64" ]]; then
    echo "Skipping tests, osx-arm64 tests are not runnable on osx-64"
else
    # Configure with cmake (tests enabled)
    cmake -G "Ninja" \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
        -DBUILD_SHARED_LIBS=ON \
        -DROARING_DISABLE_NATIVE=ON \
        -DENABLE_ROARING_TESTS=ON \
        ${SRC_DIR}
    cmake --build . --target test
fi

# Clean artifacts from first build, to avoid installing tests
cmake --build . --target clean

# Reconfigure with tests disabled, then install
cmake -G "Ninja" \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
    -DBUILD_SHARED_LIBS=ON \
    -DROARING_DISABLE_NATIVE=ON \
    -DENABLE_ROARING_TESTS=OFF \
    ${SRC_DIR}

cmake --build . --target install
