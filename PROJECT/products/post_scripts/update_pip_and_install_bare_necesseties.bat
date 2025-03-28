
set PYTHONPATH=%PRODUCT_INSTALL%/lib

echo "Ensureing pip..."
%PRODUCT_INSTALL%/python -m ensurepip


echo "Upgrading pip..."
%PRODUCT_INSTALL%/python.exe -m pip install --upgrade pip
echo "Installing wheel..."
%PRODUCT_INSTALL%/python.exe -m pip install wheel

echo "Installing setuptools"
%PRODUCT_INSTALL%/python.exe -m pip install "setuptools>=59.8.0,<70"

echo "Installing Cython"
%PRODUCT_INSTALL%/python.exe -m pip install "Cython>=3"

# For IMAS-AC-Core
echo "Installing packages required by IMAS-AC-Core..."
%PRODUCT_INSTALL%/python.exe -m pip install scikit-build-core

# For PyQt5
echo "Installing packages required by PyQt5..."
%PRODUCT_INSTALL%/python.exe -m pip install toml

# For PyQt5
echo "Installing packages required by NumPy..."
%PRODUCT_INSTALL%/python.exe -m pip install meson-python

# Miscaleneaus
%PRODUCT_INSTALL%/python.exe -m pip install pyyaml psutil

