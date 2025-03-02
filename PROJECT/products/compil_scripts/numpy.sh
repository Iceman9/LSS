#!/bin/bash

echo "##########################################################################"
echo "numpy" ${VERSION}
echo "##########################################################################"

cd ${SOURCE_DIR}

test -d .git && git submodule update --init

# Use OpenBLAS
echo "#" > site.cfg
echo "# Build configuration for numpy" >> site.cfg
echo "#" >> site.cfg
echo >> site.cfg
echo "# Section ALL to set global information for lapack dependency" >> site.cfg
echo "[openblas]" >> site.cfg
echo "libraries = openblas" >> site.cfg
echo "library_dirs = ${OPENBLAS_ROOT_DIR}/lib" >> site.cfg
echo "include_dirs = ${OPENBLAS_ROOT_DIR}/include" >> site.cfg
echo >> site.cfg
echo


echo "*** pip install . --prefix=${PRODUCT_INSTALL} --no-deps --no-build-isolation --log build.log"
${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --no-deps --no-build-isolation --log build.log

if [ $? -ne 0 ]
then
    echo "ERROR on setup install"
    exit 2
fi

if [ -f site.cfg ]; then
    rm -f site.cfg
fi

echo
echo "########## END"
