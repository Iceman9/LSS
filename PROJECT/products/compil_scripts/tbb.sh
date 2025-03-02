#!/bin/bash

echo "##########################################################################"
echo "tbb" ${VERSION}
echo "##########################################################################"

echo
echo "*** Copying sources to ${BUILD_DIR}"

cd ${BUILD_DIR}
cp -r ${SOURCE_DIR}/* ${BUILD_DIR}/

echo
echo "*** make"
make #compiler=gcc
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

mkdir -p ${PRODUCT_INSTALL}
cp -r ${BUILD_DIR}/include ${PRODUCT_INSTALL}/include
cp -r ${BUILD_DIR}/build/linux*_release ${PRODUCT_INSTALL}/lib

# Installing cmake files
cd cmake
cmake -DINSTALL_DIR=${PRODUCT_INSTALL} -DSYSTEM_NAME=Linux -DLIB_PATH=$PRODUCT_INSTALL/lib -DINC_PATH=$PRODUCT_INSTALL/include -P tbb_config_installer.cmake

echo
echo "########## END"
