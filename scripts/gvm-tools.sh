#!/bin/bash

set -e


#####
# Install gvm tools
#####
python3 -m pip install --prefix="$INSTALL_PREFIX" --root="$INSTALL_DIR" --no-warn-script-location gvm-tools
sudo cp -rv "$INSTALL_DIR"/* / | if [ $? -ne 0 ] ; then rsync -av --keep-dirlinks "$INSTALL_DIR"/* / ; fi
rm -rf "${INSTALL_DIR:?}"/*