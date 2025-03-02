#!/bin/bash

echo "##########################################################################"
echo "sip" ${VERSION}
echo "##########################################################################"

echo  "*** build in SOURCE directory"
cd ${SOURCE_DIR}

# Generate the _version file
echo "Generating ${SOURCE_DIR}/sipbuild/_version.py"
echo "version_tuple = (6, 10, 0)" > ${SOURCE_DIR}/sipbuild/_version.py
echo "version = '6.10.0'" >> ${SOURCE_DIR}/sipbuild/_version.py

echo
# Set MAKEFLAGS in order to compile in parallel
export MAKEFLAGS=${MAKE_OPTIONS}
echo "*** install with MAKEFLAGS=${MAKE_OPTIONS} ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --no-deps --no-build-isolation --log build.log"
${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --no-deps --no-build-isolation --log build.log
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 3
fi

# Install source files that are not installed
mkdir -p ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/sipbuild/module/source
cp -rf ${SOURCE_DIR}/sipbuild/module/source/12 ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/sipbuild/module/source
cp -rf ${SOURCE_DIR}/sipbuild/module/source/13 ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages/sipbuild/module/source

if [ $? -ne 0 ]
then
    echo "ERROR on installing module/source files"
    exit 3
fi

echo
echo "########## END"
