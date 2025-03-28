@echo off

echo ##########################################################################
echo tcl %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir %BUILD_DIR%

cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

rem Just to shut up makefile.vc
echo 8.6.16 > %BUILD_DIR%/manifest.uuid

cd %BUILD_DIR%\win

echo.
echo --------------------------------------------------------------------------
echo *** nmake -f makefile.vc
echo --------------------------------------------------------------------------

nmake -nologo -f makefile.vc INSTALLDIR=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake"
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** nmake -f makefile.vc install
echo --------------------------------------------------------------------------

nmake -f makefile.vc install INSTALLDIR=%PRODUCT_INSTALL%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake install"
    exit 3
)

echo.
echo ########## END
