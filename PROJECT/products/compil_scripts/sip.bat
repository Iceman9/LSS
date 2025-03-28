@echo off

echo ##########################################################################
echo sip %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%

# Generate the _version file
echo Generating %BUILD_DIR%/sipbuild/_version.py
echo version_tuple = (6, 10, 0) > %BUILD_DIR%/sipbuild/_version.py
echo version = '6.10.0' >> %BUILD_DIR%/sipbuild/_version.py

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

if NOT exist "%PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%\site-packages\sipbuild\module\source" mkdir %PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%\site-packages\sipbuild\module\source
xcopy %BUILD_DIR%\sipbuild\module\source\12 %PRODUCT_INSTALL%\lib\site-packages\sipbuild\module\source\12 /E /I
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on xcopy /E /I %BUILD_DIR%/sipbuild/module/source/12 %PRODUCT_INSTALL%/lib/site-packages/sipbuild/module/source
    exit 1
)

xcopy %BUILD_DIR%\sipbuild\module\source\13 %PRODUCT_INSTALL%\Lib\site-packages\sipbuild\module\source\13 /E /I
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on xcopy /E /I %BUILD_DIR%\sipbuild\module\source\13 %PRODUCT_INSTALL%\Lib\site-packages\sipbuild\module\source
    exit 1
)

echo.
echo ########## END
