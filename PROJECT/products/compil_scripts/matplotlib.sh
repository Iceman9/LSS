#!/bin/bash

echo "##########################################################################"
echo "matplotlib" ${VERSION}
echo "##########################################################################"

cd ${SOURCE_DIR}

echo "#" > mplsetup.cfg
echo "# Build configuration for matplotlib" >> mplsetup.cfg
echo "#" >> mplsetup.cfg
echo >> mplsetup.cfg
echo "# Section to specify system libraries" >> mplsetup.cfg
echo "[libs]" >> mplsetup.cfg
echo "system_freetype = false" >> mplsetup.cfg
echo >> mplsetup.cfg


# Note: Freetype should be located with pkg-config. But since the location of
# freetype is located in a custom location, explicit location of the include
# and library has to be provided

export CFLAGS=-I${FREETYPE_ROOT_DIR}/include/freetype2
export LDFLAGS=-L${FREETYPE_ROOT_DIR}/lib


# Forcing setup.py to install matplotlib in separate locations
MATPLOTLIB_INSTALL=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
mkdir -p ${MATPLOTLIB_INSTALL}
PYTHONPATH=${MATPLOTLIB_INSTALL}:${PYTHONPATH}

echo
echo "*** setup.py install"

# Another try for bamboo downloading qhull.
if test -n "${bamboo_GITUSERNAME}"; then
    echo "You should see this if running on a bamboo CI agent"
    mkdir -p build

    if [ ! -e v8.0.2.tar.gz ]; then
        wget https://github.com/qhull/qhull/archive/refs/tags/v8.0.2.tar.gz
    fi

    if [ ! -e build/qhull-2020.2 ]; then
        tar xf v8.0.2.tar.gz -C build
        mv build/qhull-8.0.2 build/qhull-2020.2
    fi
fi

${PYTHONBIN} -m pip install . --prefix=${PRODUCT_INSTALL} --no-deps --log build.log
if [ $? -ne 0 ]
then
    echo "ERROR on setup install"
    exit 2
fi

echo
echo "########## END"

