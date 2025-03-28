@echo off

echo ##########################################################################
echo scipy %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
cd %SOURCE_DIR%

rem Generate site.cfg
echo "#" > site.cfg
echo "# Build configuration for scipy" >> site.cfg
echo "#" >> site.cfg
echo >> site.cfg
echo "# Section ALL to set global information for lapack dependency" >> site.cfg
echo "[openblas]" >> site.cfg
echo "libraries = openblas" >> site.cfg
echo "library_dirs = %OPENBLAS_ROOT_DIR%/lib" >> site.cfg
echo "include_dirs = %OPENBLAS_ROOT_DIR%/include" >> site.cfg
echo >> site.cfg
echo

echo.
echo --------------------------------------------------------------------------
echo Launching "python.exe -m pip install"
echo --------------------------------------------------------------------------
echo.

rem Setting the RTOOLS binaries
set FC=ifx
set SCIPY_USE_PYTHRAN=0
%PYTHON_ROOT_DIR%\python.exe -m pip install . -Csetup-args="-Duse-pythran=false" --prefix=%PRODUCT_INSTALL% --no-deps --no-build-isolation --log build.log --verbose

if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on python -m pip install
    exit 1
)

echo.
echo ########## END
