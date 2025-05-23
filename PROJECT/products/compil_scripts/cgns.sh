#!/bin/bash

echo "##########################################################################"
echo "cgnslib" ${VERSION}
echo "##########################################################################"

cd $BUILD_DIR

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -GNinja"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DCGNS_BUILD_SHARED:BOOL=ON"

CMAKE_OPTIONS+=" -DCGNS_ENABLE_HDF5:BOOL=ON"
CMAKE_OPTIONS+=" -DHDF5_LIBRARY=${HDF5_ROOT_DIR}/lib"
CMAKE_OPTIONS+=" -DHDF5_DIR:PATH=${HDF5_ROOT_DIR}/share/cmake"
CMAKE_OPTIONS+=" -DHDF5_INCLUDE_PATH:PATH=${HDF5_ROOT_DIR}/include"
CMAKE_OPTIONS+=" -DHDF5_LIBRARY:FILEPATH=${HDF5_ROOT_DIR}/lib/libhdf5.so"
CMAKE_OPTIONS+=" -DHDF5_NEED_ZLIB=ON"

if [ -n "$SAT_HPC" ]
then
    echo "HPC mode, activate -DHDF5_NEEDS_MPI:BOOL=ON option"
    CMAKE_OPTIONS+=" -DHDF5_NEEDS_MPI:BOOL=ON"
    if [ -n "${MPI_ROOT_DIR}" ]; then
        CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=$(which mpic++)"
        CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=$(which mpicc)"
    fi
fi

# bos #26398
if [ ${VERSION} == "4.2.0" ]; then
    echo "WARNING: switching OFF 64 bits support!"
    CMAKE_OPTIONS+=" -DCGNS_ENABLE_64BIT:BOOL=OFF"
fi

echo
echo "*** cmake" ${CMAKE_OPTIONS}
cmake ${CMAKE_OPTIONS} ${SOURCE_DIR}
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

echo
echo "*** ninja" ${MAKE_OPTIONS}
ninja ${MAKE_OPTIONS}
if [ $? -ne 0 ]
then
    echo "ERROR on ninja"
    exit 2
fi

echo
echo "*** ninja install"
ninja install
if [ $? -ne 0 ]
then
    echo "ERROR on ninja install"
    exit 3
fi

echo
echo "########## END"
