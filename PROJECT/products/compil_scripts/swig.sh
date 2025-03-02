#!/bin/bash

echo "##########################################################################"
echo "swig" $VERSION
echo "##########################################################################"

cd ${BUILD_DIR}

# If configure is missing, then obtain the correct release.
# source code isn't always release code
echo
echo "*** configure --without-pcre --without-octave"
${SOURCE_DIR}/configure --prefix=${PRODUCT_INSTALL} --without-pcre --without-octave

if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" ${MAKE_OPTIONS}
make ${MAKE_OPTIONS}
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo

echo
echo "########## END"
