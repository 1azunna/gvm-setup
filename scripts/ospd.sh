#!/bin/bash

set -e
######
# Build ospd and ospd-openvas
#####

export OSPD_OPENVAS_VERSION="$GVM_VERSION" && \
curl -f -L https://github.com/greenbone/ospd-openvas/archive/refs/tags/v"$OSPD_OPENVAS_VERSION".tar.gz -o "$SOURCE_DIR"/ospd-openvas-"$OSPD_OPENVAS_VERSION".tar.gz
curl -f -L https://github.com/greenbone/ospd-openvas/releases/download/v"$OSPD_OPENVAS_VERSION"/ospd-openvas-"$OSPD_OPENVAS_VERSION".tar.gz.asc -o "$SOURCE_DIR"/ospd-openvas-"$OSPD_OPENVAS_VERSION".tar.gz.asc
gpg --verify "$SOURCE_DIR"/ospd-openvas-"$OSPD_OPENVAS_VERSION".tar.gz.asc "$SOURCE_DIR"/ospd-openvas-"$OSPD_OPENVAS_VERSION".tar.gz

tar -C "$SOURCE_DIR" -xvzf "$SOURCE_DIR"/ospd-openvas-"$OSPD_OPENVAS_VERSION".tar.gz && \
cd "$SOURCE_DIR"/ospd-openvas-"$OSPD_OPENVAS_VERSION" && \
python3 -m pip install . --prefix="$INSTALL_PREFIX" --root="$INSTALL_DIR" --no-warn-script-location 
sudo cp -rv "$INSTALL_DIR"/* / | if [ $? -ne 0 ] ; then rsync -av --keep-dirlinks "$INSTALL_DIR"/* / ; fi
rm -rf "${INSTALL_DIR:?}"/*