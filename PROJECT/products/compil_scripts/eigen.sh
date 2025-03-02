#!/bin/bash

echo "##########################################################################"
echo "eigen" ${VERSION}
echo "##########################################################################"

CMAKE_OPTIONS="-GNinja -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"

echo
echo "*** cmake ${CMAKE_OPTIONS}"
cmake ${CMAKE_OPTIONS} ${SOURCE_DIR}
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
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
