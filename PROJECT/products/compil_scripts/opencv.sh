#!/bin/bash

echo "##########################################################################"
echo "opencv" ${VERSION}
echo "##########################################################################"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -GNinja"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"

# Short term solution for custom numpy build
NUMPY_INCLUDE_DIR=$(python -c "import numpy; print(numpy.get_include())")

# Fix for OpenBLAS "missing" LAPACKE header
export OpenBLAS_HOME=${OPENBLAS_ROOT_DIR}
export OpenBLAS=${OPENBLAS_ROOT_DIR}

GCCVERSION=$(gcc -dumpversion)

# Instead of just relying on OSes, take into account that maybe there are
# modified environments, e.g. modules...
if [ ${GCCVERSION%%.*} -ge "11" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_CXX_STANDARD=14"
fi

CMAKE_OPTIONS+=" -DBUILD_NEW_PYTHON_SUPPORT=ON"
CMAKE_OPTIONS+=" -DBUILD_EXAMPLES:BOOL=ON"
CMAKE_OPTIONS+=" -DPYTHON3_EXECUTABLE=${PYTHONBIN}"
CMAKE_OPTIONS+=" -DPYTHON3_NUMPY_INCLUDE_DIRS=${NUMPY_INCLUDE_DIR};${NUMPY_INCLUDE_DIR2}"
CMAKE_OPTIONS+=" -DWITH_IPP:BOOL=OFF"
CMAKE_OPTIONS+=" -DBUILD_opencv_java:BOOL=OFF"
CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_DIR=${PYTHON_ROOT_DIR}/include/python${PYTHON_VERSION}"
CMAKE_OPTIONS+=" -DPYTHON_INCLUDE_DIR2=${PYTHON_ROOT_DIR}/include/python${PYTHON_VERSION}"
CMAKE_OPTIONS+=" -DWITH_FFMPEG:BOOL=OFF"
CMAKE_OPTIONS+=" -DWITH_LAPACK:BOOL=OFF"
CMAKE_OPTIONS+=" -DWITH_CUDA:BOOL=OFF"
if [ "${SAT_Python_IS_NATIVE}" != "1" ]
then
   CMAKE_OPTIONS+=" -DPython3_INCLUDE_DIR:STRING=${PYTHON_ROOT_DIR}/include/python${PYTHON_VERSION}"
   CMAKE_OPTIONS+=" -DPython3_LIBRARY:STRING=${PYTHON_ROOT_DIR}/lib/libpython${PYTHON_VERSION}.so"
   CMAKE_OPTIONS+=" -DPython3_EXECUTABLE=${PYTHON_ROOT_DIR}/bin/python${PYTHON_VERSION}"
fi
CMAKE_OPTIONS+=" -DWITH_VTK:BOOL=OFF"
CMAKE_OPTIONS+=" -DENABLE_PRECOMPILED_HEADERS:BOOL=OFF"
CMAKE_OPTIONS+=" -DCMAKE_CXX_FLAGS=-fPIC"
CMAKE_OPTIONS+=" -DCMAKE_C_FLAGS=-fPIC"

cd ${BUILD_DIR}
echo "*** cmake ${CMAKE_OPTIONS} ${SOURCE_DIR}"
cmake ${CMAKE_OPTIONS} ${SOURCE_DIR}

if [ $? -ne 0 ]
then
    echo "ERROR on CMake"
    exit 2
fi

echo
echo "*** ninja" ${MAKE_OPTIONS}
ninja ${MAKE_OPTIONS}
if [ $? -ne 0 ]
then
    echo "ERROR on ninja"
    exit 3
fi

echo
echo "*** ninja install"
ninja install
if [ $? -ne 0 ]
then
    echo "ERROR on ninja install"
    exit 4
fi

echo
echo "########## END"
