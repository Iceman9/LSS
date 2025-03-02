#!/bin/bash

echo "##########################################################################"
echo pyqt5sip ${VERSION}
echo "##########################################################################"

echo  "*** build in SOURCE directory"

cd ${SOURCE_DIR}

echo
echo "*** build with ${PYTHONBIN}"
${PYTHONBIN} setup.py build
if [ $? -ne 0 ]
then
    echo "ERROR on build"
    exit 2
fi

echo
echo "*** install with ${PYTHONBIN}"
${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --no-deps --no-build-isolation --log build.log
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 3
fi

echo
echo "*** Copying headers to ${PRODUCT_INSTALL}/include"
mkdir ${PRODUCT_INSTALL}/include
cp ${SOURCE_DIR}/*.h ${PRODUCT_INSTALL}/include

if [ $? -ne 0 ]
then
    echo "ERROR on installing headers!"
    exit 3
fi

echo
echo "########## END"
