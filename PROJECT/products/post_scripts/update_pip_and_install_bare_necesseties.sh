#!/bin/bash

echo "Upgrading pip..."
PATH=${PRODUCT_INSTALL}/bin LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib python -m pip install --upgrade pip
echo "Installing wheel..."
PATH=${PRODUCT_INSTALL}/bin LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib python -m pip install wheel

echo "Installing setuptools"
PATH=${PRODUCT_INSTALL}/bin LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib python -m pip install "setuptools>=59.8.0,<70"

echo "Installing Cython"
PATH=${PRODUCT_INSTALL}/bin LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib python -m pip install "Cython>=3"

# For IMAS-AC-Core
echo "Installing packages required by IMAS-AC-Core..."
PATH=${PRODUCT_INSTALL}/bin LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib python -m pip install scikit-build-core

# For PyQt5
echo "Installing packages required by PyQt5..."
PATH=${PRODUCT_INSTALL}/bin LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib python -m pip install toml

# For PyQt5
echo "Installing packages required by NumPy..."
PATH=${PRODUCT_INSTALL}/bin LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib python -m pip install meson-python

# Miscaleneaus
PATH=${PRODUCT_INSTALL}/bin LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib python -m pip install pyyaml psutil

