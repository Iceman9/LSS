@echo off

echo ##########################################################################
echo hdf5 %VERSION%
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

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED_LIBS:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_ENABLE_THREADSAFE:BOOL=ON 
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_ALLOW_EXTERNAL_SUPPORT:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DALLOW_UNSUPPORTED:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_BUILD_TOOLS:BOOL=ON  
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_BUILD_HL_LIB:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_BUILD_CPP_LIB:BOOL=ON
if DEFINED SAT_HPC (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_ENABLE_PARALLEL:BOOL=ON
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMPI_LINK_FLAGS:STRING=-Wl
) else (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_ENABLE_PARALLEL:BOOL=OFF
)
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_C_COMPILER="cl.exe" -DCMAKE_CXX_COMPILER="cl.exe" -DMSVC_TOOLSET_VERSION=143
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -GNinja

set MSBUILDDISABLENODEREUSE=1

cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on CMake
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** ninja
echo --------------------------------------------------------------------------

ninja
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on ninja
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** ninja install
echo --------------------------------------------------------------------------

ninja install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on ninja install
    exit 3
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
