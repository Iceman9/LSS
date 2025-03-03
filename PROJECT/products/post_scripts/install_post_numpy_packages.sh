#!/bin/bash

# For IMAS-AC-Python
echo "Installing build..."
PATH=${PYTHON_ROOT_DIR}/bin LD_LIBRARY_PATH=${PYTHON_ROOT_DIR}/lib python -m pip install build

PACKAGES="pybind11 pythran ninja" # Scipy
PACKAGES+=" cycler python-dateutil kiwisolver pyparsing six fonttools pytz contourpy" # Matplotlib
PACKAGES+=" Sphinx sphinxcontrib_websupport sphinx_rtd_theme sphinx-intl Pygments markupsafe" # Sphinx
PACKAGES+=" Pillow meshio==5.3.5" # Miscellaneous

echo " pip install ${PACKAGES}"
PATH=${PYTHON_ROOT_DIR}/bin LD_LIBRARY_PATH=${PYTHON_ROOT_DIR}/lib python -m pip install ${PACKAGES}
