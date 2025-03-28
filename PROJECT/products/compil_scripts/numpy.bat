@echo off

echo ##########################################################################
echo numpy %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
cd %SOURCE_DIR%

rem Generate site.cfg
echo "#" > site.cfg
echo "# Build configuration for numpy" >> site.cfg
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
%PYTHON_ROOT_DIR%\python.exe -m pip install . --prefix=%PRODUCT_INSTALL% --no-deps --no-build-isolation --log build.log

if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on python -m pip install
    exit 1
)

set PYTHONHOME=%PYTHON_ROOT_DIR%
set PYTHONPATH=%PYTHON_ROOT_DIR%\lib;%PYTHONPATH%
set PYTHONPATH=%PYTHON_ROOT_DIR%\lib\site-packages;%PYTHONPATH%
set PYTHON_SITE_PACKAGES=%PYTHON_ROOT_DIR%\lib\site-packages

%PYTHON_ROOT_DIR%\python.exe -m pip install pybind11 pythran ninja
%PYTHON_ROOT_DIR%\python.exe -m pip install cycler python-dateutil kiwisolver pyparsing six fonttools pytz contourpy
%PYTHON_ROOT_DIR%\python.exe -m pip install Sphinx sphinxcontrib_websupport sphinx_rtd_theme sphinx-intl Pygments markupsafe
%PYTHON_ROOT_DIR%\python.exe -m pip install Pillow meshio==5.3.5



echo.
echo ########## END
