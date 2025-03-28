@echo off

echo ##########################################################################
echo matplotlib %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
cd %SOURCE_DIR%

rem Generate the mplsteup.cfg
echo "#" > mplsetup.cfg
echo "# Build configuration for matplotlib" >> mplsetup.cfg
echo "#" >> mplsetup.cfg
echo >> mplsetup.cfg
echo "# Section to specify system libraries" >> mplsetup.cfg
echo "[libs]" >> mplsetup.cfg
echo "system_freetype = false" >> mplsetup.cfg
echo >> mplsetup.cfg

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

echo.
echo ########## END
