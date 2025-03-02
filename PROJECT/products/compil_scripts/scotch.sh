#!/bin/bash

echo "##########################################################################"
echo "scotch" ${VERSION}
echo "##########################################################################"

echo
echo "*** mkdir" ${PRODUCT_INSTALL}
mkdir -p ${PRODUCT_INSTALL}
if [ $? -ne 0 ]
then
    echo "ERROR on mkdir"
    exit 1
fi
cp -ar ${SOURCE_DIR}/* ${BUILD_DIR}/
cd ${BUILD_DIR}/src

echo
echo "*** Create Makefile.inc"

if [ -n "${SAT_HPC}" ]; then
    SCOTCH_TARGET=ptscotch
    ADDITIONAL_FLAGS="-DSCOTCH_PTHREADS"
    if [ "${SALOME_USE_64BIT_IDS}" == "1" ]; then
        ADDITIONAL_FLAGS+=" -DINTSIZE64"
    else
        ADDITIONAL_FLAGS+=" -DINTSIZE32"
    fi
else
    SCOTCH_TARGET=scotch
fi

# In other examples CCD was the serial compiler with the includes pointing to
# MPI headers...
cat << EOF > Makefile.inc
EXE         =
LIB         = .a
OBJ         = .o
MAKE        = make
AR          = ar
ARFLAGS     = -ruv
CAT         = cat
CCS         = gcc
CCP         = mpicc
CCD         = mpicc
CFLAGS      = ${ADDITIONAL_FLAGS} -fPIC -O3 -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_RANDOM_FIXED_SEED -DSCOTCH_RENAME -DSCOTCH_PTHREAD -Drestrict=__restrict -DIDXSIZE64
CLIBFLAGS   =
LDFLAGS     = -lz -lm -lrt -pthread -lpthread
CP          = cp
LEX         = flex -Pscotchyy -olex.yy.c
LN          = ln
MKDIR       = mkdir -p
MV          = mv
RANLIB      = ranlib
YACC        = bison -pscotchyy -y -b y

EOF

echo "*** make" ${MAKE_OPTIONS} ${SCOTCH_TARGET}
make ${MAKE_OPTIONS} ${SCOTCH_TARGET}
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** Install"
cd $BUILD_DIR
for d in include lib bin; do
    cp -r $d $PRODUCT_INSTALL/$d
    if [ $? -ne 0 ]; then
    	echo "FATAL: failed to deploy: $d"
    	exit 3
    fi
done

echo
echo "########## END"
