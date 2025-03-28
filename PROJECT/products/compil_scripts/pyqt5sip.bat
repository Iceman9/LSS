@echo off

echo ##########################################################################
echo pyqt5sip %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%

set python_name=python%PYTHON_VERSION%

echo.
echo --------------------------------------------------------------------------
echo Launching "python.exe -m pip install"
echo --------------------------------------------------------------------------
echo.
%PYTHON_ROOT_DIR%\python.exe -m pip install . --prefix=%PRODUCT_INSTALL% --no-deps --no-build-isolation --log build.log

if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on python -m pip install
    exit 1
)

if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include
xcopy %SOURCE_DIR%\*.h %PRODUCT_INSTALL%\include\ /E /I /Q

if not %ERRORLEVEL% == 0 (
    echo "ERROR on copying include files"
    exit 1
)

echo.
echo ########## END
