@echo off

echo ##########################################################################
echo freetype %VERSION%
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

set PLATFORM_TARGET=x64

set CMAKE_OPTIONS_EXTRA= -GNinja

if NOT exist "%PRODUCT_INSTALL%" mkdir  %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %BUILD_DIR%
set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX=%PRODUCT_INSTALL%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_SHARED_LIBS=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_DISABLE_FIND_PACKAGE_HarfBuzz=TRUE
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_C_COMPILER="cl.exe" -DCMAKE_CXX_COMPILER="cl.exe" -DMSVC_TOOLSET_VERSION=143
set CMAKE_OPTIONS=%CMAKE_OPTIONS%  %CMAKE_OPTIONS_EXTRA%

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
echo *** msbuild
echo *********************************************************************
echo.

ninja
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on ninja
    exit 2
)

echo.
echo *********************************************************************
echo *** Copying ftconfig.h to %BUILD_DIR%/include/freetype/config
echo *********************************************************************
echo.

copy /Y %SOURCE_DIR%\include\freetype\config\ftconfig.h %BUILD_DIR%\include\freetype\config

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

echo.
echo *********************************************************************
echo *** COPY Freetype DLL files from %BUILD_DIR% to %PRODUCT_INSTALL%
echo *********************************************************************
echo.
if NOT exist "%PRODUCT_INSTALL%\bin"     mkdir  %PRODUCT_INSTALL%\bin
if %SAT_DEBUG% == 0 (
  copy /Y  %BUILD_DIR%\Freetype.dll %PRODUCT_INSTALL%\bin\Freetype.dll
) else (
  copy /Y  %BUILD_DIR%\*.lib %PRODUCT_INSTALL%\lib\
  copy /Y  %BUILD_DIR%\*.dll %PRODUCT_INSTALL%\bin\
  copy /Y  %BUILD_DIR%\Freetyped.dll %PRODUCT_INSTALL%\bin\Freetype.dll
  copy /Y  %BUILD_DIR%\Freetyped.lib %PRODUCT_INSTALL%\lib\Freetype.lib
)
if NOT %ERRORLEVEL% == 0 (
    echo ERROR when copying Freetype DLL
    exit 2
)

REM needed by ParaView
copy /Y %PRODUCT_INSTALL%\include\freetype2\ft2build.h %PRODUCT_INSTALL%\include\freetype2\freetype\ft2build.h
copy /Y %SOURCE_DIR%\include\freetype\config\ftconfig.h %PRODUCT_INSTALL%\include\freetype2\freetype\config\ftconfig.h

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
