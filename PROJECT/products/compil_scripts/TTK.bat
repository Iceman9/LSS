@echo off

echo ##########################################################################
echo TTK %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_LIBDIR:STRING=lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DTTK_BUILD_PARAVIEW_PLUGINS=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -Dembree_DIR:PATH=%EMBREE_ROOT_DIR:\=/%/lib/cmake/embree-3.12.2
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DEMBREE_INCLUDE_DIR=%EMBREE_ROOT_DIR:\=/%/include

REM Boost settings
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBOOST_ROOT:PATH=%BOOST_ROOT_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_ADDITIONAL_VERSIONS=%Boost_ADDITIONAL_VERSIONS%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBOOST_INCLUDEDIR=%Boost_INCLUDE_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_INCLUDE_DIR=%Boost_INCLUDE_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_NO_BOOST_CMAKE:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_NO_SYSTEM_PATHS:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBoost_NO_BOOST_CMAKE=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -GNinja
cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on cgnslib
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
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 INSTALL.vcxproj
echo --------------------------------------------------------------------------

ninja install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on ninja install
    exit 3
)

echo.
echo ########## END
