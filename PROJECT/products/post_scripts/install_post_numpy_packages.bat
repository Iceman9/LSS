
rem IMAS-AC-Python
set PACKAGES=build
rem Scipy
set PACKAGES=%PACKAGES% pybind11 pythran
rem Matplotlibt
set PACKAGES=%PACKAGES% cycler python-dateutil kiwisolver pyparsing six fonttools pytz contourpy
rem Sphinx
set PACKAGES=%PACKAGES% Sphinx sphinxcontrib_websupport sphinx_rtd_theme sphinx-intl Pygments markupsafe
rem Miscellaneous
set PACKAGES=%PACKAGES% Pillow meshio==5.3.5

echo " pip install ${PACKAGES}"
set PYTHONPATH=%PRODUCT_INSTALL%/lib
%PYTHON_ROOT_DIR%/python -m pip install %PACKAGES%
