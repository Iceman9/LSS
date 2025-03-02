#!/bin/bash

echo "##########################################################################"
echo "scipy" ${VERSION}
echo "##########################################################################"

cd ${SOURCE_DIR}

test -d .git && git submodule update --init

echo "#" > site.cfg
echo "# Build configuration for scipy" >> site.cfg
echo "#" >> site.cfg
echo >> site.cfg
echo "# Section ALL to set global information for lapack dependency" >> site.cfg
echo "[openblas]" >> site.cfg
echo "libraries = openblas" >> site.cfg
echo "library_dirs = ${OPENBLAS_ROOT_DIR}/lib" >> site.cfg
echo "include_dirs = ${OPENBLAS_ROOT_DIR}/include" >> site.cfg
echo >> site.cfg

echo
echo "*** setup.py install"
# OP TEST
#python setup.py install --prefix=${PRODUCT_INSTALL}

# Installed in Python post-install script
# $PYTHONBIN -m pip install pybind11
# $PYTHONBIN -m pip install pythran
# $PYTHONBIN -m pip install ninja
# $PYTHONBIN -m pip install meson-python

${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --no-deps --no-build-isolation --log build.log
rm -f site.cfg
if [ $? -ne 0 ]
then
    echo "ERROR on setup install"
    rm -f site.cfg
    exit 2
fi
rm -f site.cfg

echo
echo "########## END"
