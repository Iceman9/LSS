#!/bin/bash

if [ ! -d ${PRODUCT_INSTALL}/lib ] && [ -d ${PRODUCT_INSTALL}/lib64 ]; then
    ln -s ${PRODUCT_INSTALL}/lib64 ${PRODUCT_INSTALL}/lib
fi
