@echo off

echo ##########################################################################
echo FreeImage %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
REM TODO: NGH: not Tested yet
rem if %SAT_DEBUG% == 1 (
rem   set PRODUCT_BUILD_TYPE=Debug
rem )

set PLATFORM_TARGET=x64

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib
if NOT exist "%PRODUCT_INSTALL%\bin" mkdir %PRODUCT_INSTALL%\bin

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET MSBUILDDISABLENODEREUSE=1
cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on xcopy
    exit 1
)

cd %BUILD_DIR%
REM Upgrade to current version of MSVC
echo.
echo *** devenv %BUILD_DIR%\FreeImage.2017.sln /upgrade
devenv %BUILD_DIR%\FreeImage.2017.sln /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)

:: Get the latest Windows SDK version installed
for /f "delims=" %%i in ('dir /b /ad "%ProgramFiles(x86)%\Windows Kits\10\Include"') do (
    set "sdk_version=%%i"
)

:: Check if we got the SDK version
if not defined sdk_version (
    echo No Windows SDK version found.
    exit /b
)

REM Upgrade the Sources/*/*.vcxproj to Visual studio 2022
for /r %%f in (*.vcxproj) do (
    echo Updating: %%f

    :: Replace PlatformToolset v141, v142 with v143 (Visual Studio 2022)
    powershell -Command "(Get-Content \"%%f\") -replace '<PlatformToolset>v[0-9]+</PlatformToolset>', '<PlatformToolset>v143</PlatformToolset>' | Set-Content \"%%f\""

    :: Replace the WindowsTargetPlatformVersion with the latest SDK version found
    powershell -Command "(Get-Content '%%f') -replace '<WindowsTargetPlatformVersion>.*</WindowsTargetPlatformVersion>', '<WindowsTargetPlatformVersion>%sdk_version%</WindowsTargetPlatformVersion>' | Set-Content '%%f'"

    echo Updated: %%f
)

REM Compilation
echo.
echo *** %BUILD_DIR%\FreeImage.2017.sln /t:build /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=%PLATFORM_TARGET%;PlatformToolset=v143
msbuild %BUILD_DIR%\FreeImage.2017.sln /t:Rebuild /p:Configuration=%PRODUCT_BUILD_TYPE%;Platform=%PLATFORM_TARGET%;PlatformToolset=v143
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild
    exit 2
)


echo.
echo *** COPY FreeImage DLL to %PRODUCT_INSTALL%

if %SAT_DEBUG% == 1 (
  copy /Y %BUILD_DIR%\Dist\%PLATFORM_TARGET%\*.dll %PRODUCT_INSTALL%\bin\
  copy /Y %BUILD_DIR%\Dist\%PLATFORM_TARGET%\*.lib %PRODUCT_INSTALL%\lib\
  copy /Y %BUILD_DIR%\Dist\%PLATFORM_TARGET%\*.pdb %PRODUCT_INSTALL%\lib\
  copy /Y %BUILD_DIR%\Dist\%PLATFORM_TARGET%\*.h %PRODUCT_INSTALL%\include\
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\%PLATFORM_TARGET%\*.dll %PRODUCT_INSTALL%\bin\
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\%PLATFORM_TARGET%\*.lib %PRODUCT_INSTALL%\lib\
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\%PLATFORM_TARGET%\*.pdb %PRODUCT_INSTALL%\lib\
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\%PLATFORM_TARGET%\*.h %PRODUCT_INSTALL%\include\
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\%PLATFORM_TARGET%\FreeImagePlusd.dll %PRODUCT_INSTALL%\bin\FreeImagePlus.dll
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\%PLATFORM_TARGET%\FreeImagePlusd.lib %PRODUCT_INSTALL%\lib\FreeImagePlus.lib
  copy /Y %BUILD_DIR%\Dist\%PLATFORM_TARGET%\FreeImaged.dll %PRODUCT_INSTALL%\bin\FreeImage.dll
  copy /Y %BUILD_DIR%\Dist\%PLATFORM_TARGET%\FreeImaged.lib %PRODUCT_INSTALL%\lib\FreeImage.lib
) else (
  copy /Y %BUILD_DIR%\Dist\%PLATFORM_TARGET%\FreeImage.dll %PRODUCT_INSTALL%\bin\FreeImage.dll
  copy /Y %BUILD_DIR%\Dist\%PLATFORM_TARGET%\FreeImage.lib %PRODUCT_INSTALL%\lib\FreeImage.lib
  copy /Y %BUILD_DIR%\Dist\%PLATFORM_TARGET%\FreeImage.h %PRODUCT_INSTALL%\include\FreeImage.h
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\%PLATFORM_TARGET%\FreeImagePlus.dll %PRODUCT_INSTALL%\bin\FreeImagePlus.dll
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\%PLATFORM_TARGET%\FreeImagePlus.lib %PRODUCT_INSTALL%\lib\FreeImagePlus.lib
  copy /Y %BUILD_DIR%\Wrapper\FreeImagePlus\dist\%PLATFORM_TARGET%\FreeImagePlus.h %PRODUCT_INSTALL%\include\FreeImagePlus.h
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
