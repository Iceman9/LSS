@echo off

echo ##########################################################################
echo omniORB %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT defined CYGWIN_ROOT_DIR (
  echo ERROR: Please set the environment variable: CYGWIN_ROOT_DIR
  exit 1
) else (
  echo INFO: Cygwin suite environment variable is set to: %CYGWIN_ROOT_DIR%
)


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir %BUILD_DIR%

cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on xcopy
  exit 2
)

REM select the correct platform
set CONFIG_MK=%BUILD_DIR%\config\config.mk

echo INFO: activating platform target: x86_win32_vs_16
sed -i "s/#platform = x86_win32_vs_16/platform = x86_win32_vs_16/g" %CONFIG_MK%

REM target our Python in the configuration file
set PLATFORM_MK=%BUILD_DIR%\mk\platforms\x86_win32_vs_16.mk

echo Setting path to Python binary"to python.exe
sed -i "s|#PYTHON = /cygdrive/c/Python310/python|PYTHON = python|g" %PLATFORM_MK%

cd %BUILD_DIR%\src
echo INFO: compilation starts now...
rem set PATH=%PATH%;%PYTHON_ROO_DIR%
%CYGWIN_ROOT_DIR%\make.exe export

cd %BUILD_DIR%

if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include


xcopy bin %INSTALL_DIR%\bin /E /I /Q
if NOT %ERRORLEVEL% == 0 (
   echo ERROR on xcopy
   exit 4
)

xcopy lib %INSTALL_DIR%\lib /E /I /Q
if NOT %ERRORLEVEL% == 0 (
   echo ERROR on xcopy
   exit 4
)

xcopy include %INSTALL_DIR%\include /E /I /Q
if NOT %ERRORLEVEL% == 0 (
   echo ERROR on xcopy
   exit 4
)


echo.
echo ########## END
