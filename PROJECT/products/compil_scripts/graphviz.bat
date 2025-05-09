@echo off

echo ##########################################################################
echo graphviz %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)

if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %BUILD_DIR%
set PATH=%SOURCE_DIR%\windows\dependencies\graphviz-build-utilities;%PATH%
set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX=%PRODUCT_INSTALL%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED_LIBS:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_C_COMPILER="cl.exe" -DCMAKE_CXX_COMPILER="cl.exe" -DMSVC_TOOLSET_VERSION=143
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -GNinja

set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo *********************************************************************
echo.

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo *********************************************************************
echo *** ninja
echo *********************************************************************
echo.
ninja
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on ninja
    exit 2
)

echo.
echo *********************************************************************
echo *** installation...
echo *********************************************************************
echo.
ninja install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on ninja install
    exit 3
)

SET PATH=%PRODUCT_INSTALL%\bin;%PATH%
cd %PRODUCT_INSTALL%\bin
dot -c
taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
