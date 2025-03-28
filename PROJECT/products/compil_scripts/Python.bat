@echo off

echo ##########################################################################
echo python %VERSION%
echo ##########################################################################

rem if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
rem if NOT exist "%PRODUCT_INSTALL%\libs" mkdir %PRODUCT_INSTALL%\libs
rem REM clean BUILD directory
rem if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
rem mkdir %BUILD_DIR%

rem set buildConfiguration=Debug

SET MSBUILDDISABLENODEREUSE=1

rem SET TargetPlatformVersion=10.0.17134.0
cd %SOURCE_DIR%\PCbuild

rem REM Upgrade to current version of MSVC
rem echo.
rem echo *** devenv pcbuild.sln /upgrade
rem devenv pcbuild.sln /upgrade
rem if NOT %ERRORLEVEL% == 0 (
rem     echo ERROR on devenv
rem     exit 1
rem )

REM Compilation

rem Dont use PGO as test_embed fails a lot for random reasons such as relative
rem paths, etc...

echo.
echo *** build.bat -c Release "/p:OutDir=%PRODUCT_INSTALL%" "/p:Platform=x64"
call build.bat -c Release "/p:OutDir=%PRODUCT_INSTALL%/" "/p:Platform=x64"

if NOT %ERRORLEVEL% == 0 (
    echo ERROR on build.bat
    exit 2
)


REM Installation of additional files
echo.
echo *** Installation of additional files
cd ..
xcopy /I /E %SOURCE_DIR%\include %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy include
    exit 4
)
xcopy /I /E %SOURCE_DIR%\lib %PRODUCT_INSTALL%\lib
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy lib
    exit 4
)

move %PRODUCT_INSTALL%\pyconfig.h %PRODUCT_INSTALL%\include
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on move %PRODUCT_INSTALL%\pyconfig.h
    exit 5
)

if NOT exist "%PRODUCT_INSTALL%\libs" mkdir %PRODUCT_INSTALL%\libs
move %PRODUCT_INSTALL%\*.lib %PRODUCT_INSTALL%\libs
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on move *.lib
    exit 6
)

copy %PRODUCT_INSTALL%\python.exe %PRODUCT_INSTALL%\python3.exe /Y

taskkill /F /IM "mspdbsrv.exe"

echo.
echo *** Calling python -m ensurepip
rem Ensure pip
set PYTHONHOME=%PRODUCT_INSTALL%
set PYTHONPATH=%PRODUCT_INSTALL%\lib;%PYTHONPATH%
set PYTHONPATH=%PRODUCT_INSTALL%\lib\site-packages;%PYTHONPATH%
set PYTHON_SITE_PACKAGES=%PRODUCT_INSTALL%\lib\site-packages
%PRODUCT_INSTALL%/python -m ensurepip
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on ensurepip
    exit 7
)

echo "Upgrading pip..."
%PRODUCT_INSTALL%\python.exe -m pip install --upgrade pip
echo "Installing wheel..."
%PRODUCT_INSTALL%\python.exe -m pip install wheel

echo "Installing setuptools"
%PRODUCT_INSTALL%\python.exe -m pip install "setuptools>=59.8.0,<70"

echo "Installing Cython"
%PRODUCT_INSTALL%\python.exe -m pip install "Cython>=3"

# For IMAS-AC-Core
echo "Installing packages required by IMAS-AC-Core..."
%PRODUCT_INSTALL%\python.exe -m pip install scikit-build-core

# For PyQt5
echo "Installing packages required by PyQt5..."
%PRODUCT_INSTALL%\python.exe -m pip install toml

# For PyQt5
echo "Installing packages required by NumPy..."
%PRODUCT_INSTALL%\python.exe -m pip install meson-python

# Miscaleneaus
%PRODUCT_INSTALL%\python.exe -m pip install pyyaml psutil setuptools_scm

echo.
echo ########## END
