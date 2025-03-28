@echo off

echo ##########################################################################
echo ispc %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin

echo running command: xcopy %SOURCE_DIR%\bin\* %PRODUCT_INSTALL%\bin /E /I /Q /Y
xcopy %SOURCE_DIR%\bin\* %PRODUCT_INSTALL%\bin /E /I /Q /Y

if NOT %ERRORLEVEL% == 0 (
    echo ERROR on copyying bin
    exit 1
)

echo.
echo ########## END
