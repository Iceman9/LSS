#!/bin/bash

echo "##########################################################################"
echo "med" ${VERSION}
echo "##########################################################################"

CONFIGURE_FLAGS=
CONFIGURE_FLAGS+=' CFLAGS=-m64 CXXFLAGS=-m64' 
CONFIGURE_FLAGS+=' --enable-python=yes'
CONFIGURE_FLAGS+=' --enable-mesgerr'

if [ "${HDF5_VERSION}" == "1.12.1" ]; then
    echo "WARNING: ensure compatibility with HDF 1.12"
    CONFIGURE_FLAGS+=' CPPFLAGS=-DH5_USE_110_API'
fi

if [ -n "${SAT_HPC}" ]; then
    export CXX=${MPI_CXX_COMPILER}
    export CC=${MPI_C_COMPILER}
    CONFIGURE_FLAGS+=' --with-swig=yes'
    CONFIGURE_FLAGS+=' --enable-parallel'
else
    export F77=gfortran
fi

if [ "${SALOME_USE_64BIT_IDS}" == "1" ]; then
    echo "WARNING: user requested 64 bits encoding for integers..."
    export  FFLAGS="-g -O2 -ffixed-line-length-none -fdefault-integer-8"
    export FCFLAGS="-fdefault-integer-8"
    CONFIGURE_FLAGS+=' --with-med_int=long'
else
    export  FFLAGS="-g -O2 -ffixed-line-length-none"
    export FCFLAGS="-g -O2 -ffixed-line-length-none"
fi

echo
echo "*** configure   --prefix=$PRODUCT_INSTALL FFLAGS=\"${FFLAGS}\"   FCFLAGS=\"${FCFLAGS}\"   ${CONFIGURE_FLAGS}"
${SOURCE_DIR}/configure --prefix=$PRODUCT_INSTALL FFLAGS="${FFLAGS}"     FCFLAGS="${FCFLAGS}"     ${CONFIGURE_FLAGS}
if [ $? -ne 0 ]; then
    echo "ERROR on configure"
    exit 1
fi
echo
echo "*** make" ${MAKE_OPTIONS}
make ${MAKE_OPTIONS}
if [ $? -ne 0 ]; then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]; then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"
