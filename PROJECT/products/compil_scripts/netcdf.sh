#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "netcdf" ${VERSION}
echo "##########################################################################"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -GNinja"
if [ -n "${SAT_HPC}" ]  && [ -n "${MPI_ROOT_DIR}" ]; then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    CMAKE_OPTIONS+=" -DCMAKE_CXX_COMPILER:STRING=${MPI_CXX_COMPILER}"
    CMAKE_OPTIONS+=" -DCMAKE_C_COMPILER:STRING=${MPI_C_COMPILER}"
fi

# Do not use the flag -Wshorten-64-to-32 as it is not recognized by gcc 10.x.x
CMAKE_OPTIONS+=" -DENABLE_CONVERSION_WARNINGS:BOOL=OFF"

# Pthread not linked!!!!
CMAKE_OPTIONS+=" -DCMAKE_SHARED_LINKER_FLAGS=-pthread"
CMAKE_OPTIONS+=" -DCMAKE_C_FLAGS=-pthread"

CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"
CMAKE_OPTIONS+=" -DENABLE_NETCDF_4=ON"
echo "Remote DAP service disabled!"
CMAKE_OPTIONS+=" -DENABLE_DAP=OFF"
CMAKE_OPTIONS+=" -DBUILD_UTILITIES=ON"
CMAKE_OPTIONS+=" -DBUILD_SHARED_LIBS=ON"
CMAKE_OPTIONS+=" -DENABLE_TESTS=ON"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHONBIN}"

### libxml2 settings
if [ -n "$LIBXML2_ROOT_DIR" ] && [ "${SAT_libxml2_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
    CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
    CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
fi

# HDF5
if [ -n "$HDF5_ROOT_DIR" ] && [ "${SAT_hdf5_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DHDF5_DIR:PATH=${HDF5_ROOT_DIR}/share/cmake/hdf5"
    CMAKE_OPTIONS+=" -DHDF5_USE_STATIC_LIBRARIES:BOOL=OFF"
    CMAKE_OPTIONS+=" -DHDF5_ROOT:PATH=${HDF5_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DHDF5_HL_LIBRARY=${HDF5_ROOT_DIR}/lib/libhdf5_hl.so"
    CMAKE_OPTIONS+=" -DHDF5_C_LIBRARY=${HDF5_ROOT_DIR}/lib/libhdf5.so"
    CMAKE_OPTIONS+=" -DHDF5_INCLUDE_DIR=${HDF5_ROOT_DIR}/include"
fi

### libxml2 settings
if [ -n "$LIBXML2_ROOT_DIR" ] && [ "${SAT_libxml2_IS_NATIVE}" != "1" ]; then
    CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
    CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
    CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
fi

echo
echo "*** cmake" ${CMAKE_OPTIONS}
cd  ${BUILD_DIR}
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
