@echo off

echo ##########################################################################
echo qwt %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir %BUILD_DIR%

cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)
cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** prepare qmake
echo --------------------------------------------------------------------------
echo.

rem # Replace the slashes in the PRODUCT_INSTALL
set str=%PRODUCT_INSTALL%
set str=%str:\=/%

sed -i "s|\(QWT_INSTALL_PREFIX[[:space:]]*\)=\([[:space:]]*\)\(.*\)|\1=\2%str%|g" qwtconfig.pri
sed -i "s|#\(CONFIG[[:space:]]*+=[[:space:]]*QwtSVGItem\)|\1|g" qwtconfig.pri

rem rename INSTALL_DIR to QWT_INSTALL_PREFIX
sed -i "s|\(target\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/lib|g" src\src.pro
sed -i "s|\(headers\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/include|g" src\src.pro

rem Uncomment installation directory in textengines...
sed -i "s|#\(target.path.*\)|\1|g" textengines\textengines.pri
sed -i "s|#\(doc.path.*\)|\1|g" textengines\textengines.pri

rem Rename INSTALL_DIR to QWT_INSTALL_PREFIX
sed -i "s|\(target\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/lib|g" textengines\mathml\mathml.pro
sed -i "s|\(headers\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/include|g" textengines\mathml\mathml.pro


sed -i "s|\(target\.path[[:space:]]*\)=\([[:space:]]*\).*|\1=\2\$\$QWT_INSTALL_PREFIX/plugins/designer|g" designer\designer.pro

REM remove debug build (building release only)
sed -i "s|\(CONFIG[[:space:]]*+=[[:space:]]*debug_and_release\)|#\1|g" qwtbuild.pri
sed -i "s|\(CONFIG[[:space:]]*+=[[:space:]]*build_all\)|#\1|g" qwtbuild.pri

echo.
echo --------------------------------------------------------------------------
echo *** qmake
echo --------------------------------------------------------------------------
echo.

qmake
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on qmake : %ERRORLEVEL%
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** nmake
echo --------------------------------------------------------------------------
echo.

nmake
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on nmake
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** nmake install
echo --------------------------------------------------------------------------
echo.

nmake install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on nmake install
    exit 3
)

echo.
echo ########## END
