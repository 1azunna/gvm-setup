#!/bin/bash

set -eu


#####
# Install gvm tools
#####
python3 -m pip install --prefix="$INSTALL_PREFIX" --root="$INSTALL_DIR" --no-warn-script-location gvm-tools
sudo cp -rv "${INSTALL_DIR:?}"/* / 
rm -rf "${INSTALL_DIR:?}"/*

exit