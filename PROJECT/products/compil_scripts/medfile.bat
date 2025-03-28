@echo off

echo ##########################################################################
echo med %VERSION%
echo ##########################################################################

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET CMAKE_OPTIONS=
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -GNinja
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_BUILD_STATIC_LIBS:BOOL=OFF
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_BUILD_SHARED_LIBS:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DHDF5_ROOT_DIR:STRING=%HDF5_ROOT_DIR%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_IMPORT_LIBRARY_PREFIX=""
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_IMPORT_LIBRARY_SUFFIX=".lib"
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_Fortran_COMPILER=""
if DEFINED SALOME_USE_64BIT_IDS (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMED_MEDINT_TYPE:STRING="long long"
)

if DEFINED SAT_HPC (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_USE_MPI:BOOL=ON
) else (
    SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DMEDFILE_USE_MPI:BOOL=OFF
)

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

REM rename documentation directory
cd  %PRODUCT_INSTALL%\share\doc
mv med-fichier* med

taskkill /F /IM "mspdbsrv.exe"


echo.
echo ########## END
