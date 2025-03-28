@echo off

echo ##########################################################################
echo omniORBpy %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT defined CYGWIN_ROOT_DIR (
  echo ERROR: Please set the environment variable: CYGWIN_ROOT_DIR
  exit 2
) else (
  echo INFO: Cygwin suite environment variable is set to: %CYGWIN_ROOT_DIR%
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%


call :NORMALIZEPATH "%BUILD_DIR%\..\omniorb\src\lib\omniORBpy"
set OMNIORBPY_WORK_DIR=%RETVAL%

cd %SOURCE_DIR%

if exist "%OMNIORBPY_WORK_DIR%" rmdir /Q /S "%OMNIORBPY_WORK_DIR%"
mkdir %OMNIORBPY_WORK_DIR%

xcopy * %OMNIORBPY_WORK_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on xcopy
  exit 1
)

cd %OMNIORBPY_WORK_DIR%
echo INFO: compilation starts now...
%CYGWIN_ROOT_DIR%\make.exe export
if NOT %ERRORLEVEL% == 0 (
   echo ERROR on make export
   exit 2
)

echo .
echo INSTALLING


if NOT exist "%OMNIORB_ROOT_DIR%\lib\python" mkdir %OMNIORB_ROOT_DIR%\lib\python

rem Go to OmniORB back and copy only the lib\python
cd %OMNIORBPY_WORK_DIR%\..\..\..\

rem Just recopy the libraries and includes.

xcopy lib %OMNIORB_ROOT_DIR%\lib /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
   echo ERROR on xcopy
   exit 4
)

xcopy include %OMNIORB_ROOT_DIR%\include /E /I /Q /Y
if NOT %ERRORLEVEL% == 0 (
   echo ERROR on xcopy
   exit 4
)

echo.
echo ########## END

:: ========== FUNCTIONS ==========
EXIT /B

rem Resolve relative path and return absolute path

:NORMALIZEPATH
  SET RETVAL=%~f1
  EXIT /B
