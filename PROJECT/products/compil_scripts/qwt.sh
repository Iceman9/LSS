#!/bin/bash

echo "##########################################################################"
echo "qwt" ${VERSION}
echo "##########################################################################"

export TMAKEPATH=${QTDIR}/bin
export PATH=${TMAKEPATH}:${PATH}

echo
echo "*** copy source"
mkdir -p ${PRODUCT_INSTALL}
#cp -r $SOURCE_DIR/* .
cd ${SOURCE_DIR}

echo
echo "*** prepare qmake"
sed -i "s|\(QWT_INSTALL_PREFIX[[:space:]]*\)=\([[:space:]]*\)\(.*\)|\1=\2${PRODUCT_INSTALL}|g" qwtconfig.pri
sed -i "s|#\(CONFIG[[:space:]]*+=[[:space:]]*QwtSVGItem\)|\1|g" qwtconfig.pri

# rename INSTALL_DIR to QWT_INSTALL_PREFIX
sed -i "s|\(target\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/lib|g" src/src.pro
sed -i "s|\(headers\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/include|g" src/src.pro

# Uncomment installation directory in textengines...
sed -i "s|#\(target.path.*\)|\1|g" textengines/textengines.pri
sed -i "s|#\(doc.path.*\)|\1|g" textengines/textengines.pri

# Rename INSTALL_DIR to QWT_INSTALL_PREFIX
sed -i "s|\(target\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/lib|g" textengines/mathml/mathml.pro
sed -i "s|\(headers\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/include|g" textengines/mathml/mathml.pro


sed -i "s|\(target\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/plugins/designer|g" designer/designer.pro

echo
echo "** qmake"
qmake
if [ $? -ne 0 ]
then
    echo "ERROR on qmake"
    exit 1
fi

echo
echo "*** make"
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

echo
echo "########## END"
