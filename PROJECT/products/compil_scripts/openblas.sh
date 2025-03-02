#!/bin/bash

echo "##########################################################################"
echo "openblas" ${VERSION}
echo "##########################################################################"

echo
echo "*** make" ${MAKE_OPTIONS}

# When building your own develop version, you don't need to compile for all
# architectures. But at the same time you cannot call make with DYNAMIC_ARCH=0
# as it does not act like calling just make.

if [ -n "${DYNAMIC_ARCH}" ]; then
    DYNAMIC_ARCH=1 make -C ${SOURCE_DIR} ${MAKE_OPTIONS}
else
    make -C ${SOURCE_DIR} ${MAKE_OPTIONS}
fi

if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
if [ -n "${DYNAMIC_ARCH}" ]; then
    DYNAMIC_ARCH=1 make -C ${SOURCE_DIR} install PREFIX=${PRODUCT_INSTALL}
else
    make -C ${SOURCE_DIR} install PREFIX=${PRODUCT_INSTALL}
fi

if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi
echo
echo "########## END"

# Make check to see if the libopenblas.so is okay (elf instruction allignment error
# due to binutils. See https://lists.gnu.org/archive/html/bug-binutils/2022-08/msg00003.html)

ldd $PRODUCT_INSTALL/lib/*.so > /dev/null
if [ $? -ne 0 ]
then
    echo "The libraries have an ELF issue, rebuilding without DYNAMIC_ARCH=1"

    make -C ${SOURCE_DIR} clean

    make -C ${SOURCE_DIR} ${MAKE_OPTIONS}
    if [ $? -ne 0 ]
    then
        echo "ERROR on make"
        exit 2
    fi

    echo
    echo "*** make install"
    make -C ${SOURCE_DIR} install PREFIX=${PRODUCT_INSTALL}
    if [ $? -ne 0 ]
    then
        echo "ERROR on make install"
        exit 3
    fi
fi
