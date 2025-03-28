@echo off

echo ##########################################################################
echo netcdf %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -GNinja
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=Release
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_LIBDIR:STRING=lib
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHONBIN%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_NETCDF_4=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_DAP=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_UTILITIES=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED_LIBS=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_TESTS=OFF

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_INCLUDE_DIR:STRING=%LIBXML2_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_LIBRARIES:STRING=%LIBXML2_ROOT_DIR:\=/%/lib/libxml2.lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DLIBXML2_XMLLINT_EXECUTABLE=%LIBXML2_ROOT_DIR:\=/%/bin/xmllint.exe

set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_DIR:PATH=%HDF5_ROOT_DIR:\=/%/cmake/hdf5
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_INCLUDE_DIRS:PATH=%HDF5_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_USE_STATIC_LIBRARIES:BOOL=OFF
set MSBUILDDISABLENODEREUSE=1

echo.
echo *********************************************************************
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS%
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
