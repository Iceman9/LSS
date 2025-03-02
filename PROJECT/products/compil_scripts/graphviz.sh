#!/bin/bash

echo "##########################################################################"
echo "graphviz" ${VERSION}
echo "##########################################################################"

echo "graphviz compilation"

cd ${BUILD_DIR}

echo
echo "*** ./configure --prefix=${PRODUCT_INSTALL}  --enable-tcl=no --with-expat=no --with-qt=no  --enable-perl=no --enable-ocaml=no"
${SOURCE_DIR}/configure --prefix=${PRODUCT_INSTALL} --enable-tcl=no --with-expat=no --with-qt=no  --enable-perl=no --enable-ocaml=no --with-ghostscript=no --enable-python=no --enable-java=no

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

echo "*** make install"

export PATH=${PRODUCT_INSTALL}/bin:${PATH}
export LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib:${PRODUCT_INSTALL}/lib/graphviz:${LD_LIBRARY_PATH}

make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"
