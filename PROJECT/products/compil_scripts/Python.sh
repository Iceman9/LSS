#!/bin/bash

echo "##########################################################################"
echo "Python" ${VERSION}
echo "##########################################################################"

if [ ${#VERSION} -lt 5 ]
then
    echo "ERROR : VERSION argument of Python compilation script has not the expected x.y.z format"
    exit 1
fi
PYTHON_VERSION="${VERSION:0:3}"
PYTHON_VERSION_MAJ=${PYTHON_VERSION:0:1}

CONFIGURE_ARGUMENTS="--enable-shared --with-ensurepip=install --enable-loadable-sqlite-extensions --enable-optimizations"
if [ "${SAT_ENABLE_PYTHON_PYMALLOC}" == "1" ]; then
    CONFIGURE_ARGUMENTS+=" --with-pymalloc"
else
    CONFIGURE_ARGUMENTS+=" --without-pymalloc"
fi

echo
echo   "*** configure --prefix=${PRODUCT_INSTALL} ${CONFIGURE_ARGUMENTS}"
${SOURCE_DIR}/configure --prefix=${PRODUCT_INSTALL} ${CONFIGURE_ARGUMENTS}
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

if [ ${PYTHON_VERSION_MAJ} == 3 ]
then
    # OP trick for Python 3.6.1
    #cd ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/config-${PYTHON_VERSION}
    cd ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/config-${PYTHON_VERSION}*
else
    cd ${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/config
fi

if [ ! -e libpython${PYTHON_VERSION}.so ]
then
    echo
    echo "*** create missing link"
    ln -sf ../../libpython${PYTHON_VERSION}.so .
    if [ $? -ne 0 ]
    then
        echo "ERROR when creating missing link"
        # no error here
    fi
fi

# Python is Python3
if [ ${PYTHON_VERSION_MAJ} == 3 ]
then
    cd ${PRODUCT_INSTALL}/bin
    ln -s python3 python
    ln -s pip3 pip
fi

echo
echo "########## END"
