@echo off

echo ##########################################################################
echo tk %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

rem Just to shut up makefile.vc
echo 8.6.16 > %BUILD_DIR%/manifest.uuid

cd %BUILD_DIR%\win

echo.
echo ****************************************************************
where.exe nmake


call :NORMALIZEPATH "%BUILD_DIR%\..\tcl"
set TCLDIR=%RETVAL%

echo.
echo --------------------------------------------------------------------------
echo *** nmake -f makefile.vc TCLDIR=%TCLDIR% TMP_DIR=%BUILD_DIR%
echo --------------------------------------------------------------------------

nmake -f makefile.vc TCLDIR=%TCLDIR% TMP_DIR=%BUILD_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake"
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** nmake -f makefile.vc install TCLDIR=%TCLDIR% TMP_DIR=%BUILD_DIR% INSTALLDIR=%TCLHOME%
echo --------------------------------------------------------------------------

nmake -f makefile.vc install TCLDIR=%TCLDIR% TMP_DIR=%BUILD_DIR% INSTALLDIR=%TCLHOME%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake install"
    exit 2
)

echo.
echo ########## END

:: ========== FUNCTIONS ==========
EXIT /B

rem Resolve relative path and return absolute path

:NORMALIZEPATH
  SET RETVAL=%~f1
  EXIT /B
