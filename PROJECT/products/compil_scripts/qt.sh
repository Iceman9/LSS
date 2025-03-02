#!/bin/bash

echo "##########################################################################"
echo "qt" ${VERSION}
echo "##########################################################################"


# https://forum.qt.io/topic/115827/build-on-linux-qt-xcb-option/9
# Required packages for xcb
# libxcb-devel
# libxkbcommon-devel
# xcb-util-devel
# xcb-util-image-devel
# xcb-util-keysyms-devel
# xcb-util-renderutil-devel
# xcb-util-wm-devel
# mesa-libGL-devel
if [ -n "$SAT_DEBUG" ]
then
    BUILD_TYPE="-debug"
else
    BUILD_TYPE="-release"
fi

CONFIGURE_FLAGS=""
CONFIGURE_FLAGS+=" -prefix ${PRODUCT_INSTALL} ${BUILD_TYPE}"
CONFIGURE_FLAGS+=" -opensource -confirm-license"
# The whole build is a lot of output, just don't make it more verbose. For
# debugging sure, but try to reduce the ammount of output
# CONFIGURE_FLAGS+=" -verbose"
CONFIGURE_FLAGS+=" -no-rpath"
CONFIGURE_FLAGS+=" -nomake tests -nomake examples"
CONFIGURE_FLAGS+=" -no-separate-debug-info -no-openssl -no-glib -no-jasper"
CONFIGURE_FLAGS+=" -qt-libpng -qt-harfbuzz"
# This one was a problem. How to avoid including the whole XCB stack to the
# packages for Qt 5.15+
CONFIGURE_FLAGS+=" -xcb -xcb-xlib -bundled-xcb-xinput"
CONFIGURE_FLAGS+=" -no-eglfs"
CONFIGURE_FLAGS+=" -dbus-runtime"
CONFIGURE_FLAGS+=" -skip qtlocation -skip qtpurchasing -skip wayland"
CONFIGURE_FLAGS+=" -skip qtwebengine -skip qtgamepad -skip qtdoc"

echo
echo "*** ${SOURCE_DIR}/configure ${CONFIGURE_FLAGS}"

$SOURCE_DIR/configure ${CONFIGURE_FLAGS}

if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 2
fi

echo
echo "*** make" ${MAKE_OPTIONS}
make ${MAKE_OPTIONS}
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 3
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 4
fi

echo
echo "########## END"
