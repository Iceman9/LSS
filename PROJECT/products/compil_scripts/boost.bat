@echo off

echo ##########################################################################
echo boost %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q /Y
cd %BUILD_DIR%



set VC_VERSION=vc143
echo.
echo --------------------------------------------------------------------------
echo *** call bootstrap.bat %VC_VERSION%
echo --------------------------------------------------------------------------

call bootstrap.bat %VC_VERSION%

echo.
echo --------------------------------------------------------------------------
echo *** Compilation
echo --------------------------------------------------------------------------

set PLATFORM_TARGET=64

.\b2 --prefix=%PRODUCT_INSTALL% --build-type=complete architecture=x86 address-model=%PLATFORM_TARGET% variant=release threading=multi link=shared runtime-link=shared install

REM Even on normal success it returns non zero code.
rem if NOT %ERRORLEVEL% == 0 (
rem     echo ERROR running b2 --prefix=%PRODUCT_INSTALL% architecture=x86 address-model=%PLATFORM_TARGET% --build-type=complete stage variant=%PRODUCT_BUILD_TYPE% threading=multi link=shared runtime-link=shared install
rem     exit 1
rem )


echo.
echo ########## END
