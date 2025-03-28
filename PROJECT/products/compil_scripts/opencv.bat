@echo off

echo ##########################################################################
echo opencv %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 17 2022"
)


if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=Release
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DWITH_CUDA:BOOL=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DWITH_EIGEN:BOOL=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DSTATIC_LIBRARY_FLAGS:STRING="/machine:x64"
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_EXECUTABLE=%PYTHON_ROOT_DIR:\=/%/python.exe
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_INCLUDE_DIR:STRING=%PYTHON_ROOT_DIR:\=/%/include
if %SAT_DEBUG% == 0 (
  set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_LIBRARY:STRING=%PYTHON_ROOT_DIR:\=/%/libs/python%PYTHON_VERSION:.=%.lib
) else (
  set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPYTHON_LIBRARY:STRING=%PYTHON_ROOT_DIR:\=/%/libs/python%PYTHON_VERSION:.=%_d.lib
)
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_opencv_java:STRING=OFF
REM OpenBLAS triggers a compilation issue / So stay as we were before the introduction of OpenBLAS
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DWITH_LAPACK:BOOL=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -GNinja

cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on CMake
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** ninja
echo --------------------------------------------------------------------------

ninja
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on ninja
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** ninja install
echo --------------------------------------------------------------------------

ninja install
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on ninja install
    exit 3
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
