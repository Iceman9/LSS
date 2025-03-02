#!/bin/bash

echo "##########################################################################"
echo "PyQt" ${VERSION}
echo "##########################################################################"


echo  "*** build in SOURCE directory"
cd ${SOURCE_DIR}

if [ -d ${SOURCE_DIR}/build ]; then
    rm -rf ${SOURCE_DIR}/build
fi

# First install pyqt-build
${PYTHONBIN} -m pip install "pyqt-builder>=1.14.1" --no-deps --no-build-isolation
# Use PIP to install package

echo
# Set MAKEFLAGS in order to compile in parallel
export MAKEFLAGS=${MAKE_OPTIONS}
echo "*** install with MAKEFLAGS=${MAKE_OPTIONS} ${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --no-deps --no-build-isolation --log build.log --config-settings --confirm-license="
# https://stackoverflow.com/questions/73714829/pip-install-pyqt5-it-cannot-go-on
${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --no-deps --no-build-isolation --log build.log --config-settings --confirm-license=
if [ $? -ne 0 ]
then
    echo "ERROR on install"
    exit 3
fi

echo
echo "########## END"
