#!/bin/bash

echo "##########################################################################"
echo "boost" ${VERSION}
echo "##########################################################################"

cd ${SOURCE_DIR}

echo
echo "*** bootstrap.sh"
./bootstrap.sh --prefix=${PRODUCT_INSTALL}
if [ $? -ne 0 ]
then
    echo "ERROR on bootstrap"
    exit 1
fi

echo "*** b2 ${MAKE_OPTIONS} install"

./b2  ${MAKE_OPTIONS} install

if [ $? -ne 0 ]
then
    echo "ERROR (that can be ignored) on b2 install."
    # Do not worry if compiling fails with GCC 8.3.1
    # exit 3
fi

echo
echo "########## END"
