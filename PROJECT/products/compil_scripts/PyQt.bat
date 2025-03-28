@echo off

echo ##########################################################################
echo PyQt %VERSION%
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

%PYTHON_ROOT_DIR%\python.exe -m pip install "pyqt-builder>=1.14.1" --no-deps --no-build-isolation

echo.
echo --------------------------------------------------------------------------
echo Launching "python.exe -m pip install"
echo --------------------------------------------------------------------------
echo.
set TMPDIR=%BUILD_DIR%\TempDir
rem %PYTHON_ROOT_DIR%\python.exe -m pip -v install . --target-dir=%PRODUCT_INSTALL% --no-deps --no-build-isolation --log build.log --no-clean --config-settings --no-dbus-python  --no-designer-plugin --no-qml-plugin --confirm-license=
sip-install --target-dir=%PRODUCT_INSTALL%\Lib --scripts-dir=%PRODUCT_INSTALL%\Scripts --no-dbus-python  --no-designer-plugin --no-qml-plugin --confirm-license --jobs %NUMBER_OF_PROCESSORS%


if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on python -m pip install
    exit 1
)

echo.
echo ########## END
