#!/bin/bash

echo "###############################################"
echo "freeimage" ${VERSION}
echo "###############################################"

echo
echo "*** Copying source to ${BUILD_DIR}"

cd ${BUILD_DIR}
cp -r $SOURCE_DIR/* .

GCCVERSION=$(gcc -dumpversion)
# With GCC 10.2.0 some warnings are converted to errors.
# Use greater/equal for newer GCC compilers.
if [ ${GCCVERSION%%.*} -ge "11" ]; then
    export CXXFLAGS="${CXXFLAGS} -std=c++11"
fi

echo -n ".. Patching freeimage sources: fix build procedure..." && \
		sed -i "s%DESTDIR ?= /%DESTDIR ?= /usr%g;s%INCDIR ?= \$(DESTDIR)/usr/include%INCDIR ?= \$(DESTDIR)/include%g;s%INSTALLDIR ?= \$(DESTDIR)/usr/lib%INSTALLDIR ?= \$(DESTDIR)/lib%g;s%-o root -g root %%g" Makefile.gnu >& /dev/null && \
		sed -i "s%DESTDIR ?= /%DESTDIR ?= /usr%g;s%INCDIR ?= \$(DESTDIR)/usr/include%INCDIR ?= \$(DESTDIR)/include%g;s%INSTALLDIR ?= \$(DESTDIR)/usr/lib%INSTALLDIR ?= \$(DESTDIR)/lib%g;s%-o root -g root %%g" Makefile.fip >& /dev/null
	    if [ "$?" != "0" ] ; then
		echo
		echo "Error: problem patching freeimage sources"
		echo
		return 1
	    fi
	    echo "OK"

	    echo -n ".. Patching freeimage sources: gcc 4.7 compatibility..." && \
		sed -i 's%\(#include "OpenEXRConfig.h"\)%\1\n#include <string.h>%g' Source/OpenEXR/IlmImf/ImfAutoArray.h
	    if [ "$?" != "0" ] ; then
		echo
		echo "Error: problem patching freeimage sources"
		echo
	    fi
	    echo "OK"

echo
echo "*** FreeImage: make" $MAKE_OPTIONS
make -f Makefile.gnu
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** FreeImage: make install"
make -f Makefile.gnu DESTDIR=$PRODUCT_INSTALL install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "*** FreeImage: make clean"
make -f Makefile.gnu clean

echo
echo "*** FreeImagePlus: make" $MAKE_OPTIONS
make -f Makefile.fip
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** FreeImagePlus: make install"
make -f Makefile.fip DESTDIR=$PRODUCT_INSTALL install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "*** FreeImagePlus: make clean"
make -f Makefile.fip clean

echo
echo "########## END"

