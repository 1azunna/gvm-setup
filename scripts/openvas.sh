#!/bin/bash

set -e

##### 
# Build the OpenVAS Scanner
#####

export OPENVAS_SCANNER_VERSION="$GVM_VERSION" && \
curl -f -L https://github.com/greenbone/openvas-scanner/archive/refs/tags/v"$OPENVAS_SCANNER_VERSION".tar.gz -o "$SOURCE_DIR"/openvas-scanner-"$OPENVAS_SCANNER_VERSION".tar.gz && \
curl -f -L https://github.com/greenbone/openvas-scanner/releases/download/v"$OPENVAS_SCANNER_VERSION"/openvas-scanner-"$OPENVAS_SCANNER_VERSION".tar.gz.asc -o "$SOURCE_DIR"/openvas-scanner-"$OPENVAS_SCANNER_VERSION".tar.gz.asc && \
gpg --verify "$SOURCE_DIR"/openvas-scanner-"$OPENVAS_SCANNER_VERSION".tar.gz.asc "$SOURCE_DIR"/openvas-scanner-"$OPENVAS_SCANNER_VERSION".tar.gz

tar -C "$SOURCE_DIR" -xvzf "$SOURCE_DIR"/openvas-scanner-"$OPENVAS_SCANNER_VERSION".tar.gz && \
mkdir -p "$BUILD_DIR"/openvas-scanner && cd "$BUILD_DIR"/openvas-scanner && \
cmake "$SOURCE_DIR"/openvas-scanner-"$OPENVAS_SCANNER_VERSION" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_BUILD_TYPE=Release \
  -DSYSCONFDIR=/etc \
  -DLOCALSTATEDIR=/var \
  -DOPENVAS_FEED_LOCK_PATH=/var/lib/openvas/feed-update.lock \
  -DOPENVAS_RUN_DIR=/run/ospd && \
make -j$(nproc) && \
make DESTDIR="$INSTALL_DIR" install
sudo cp -rv "$INSTALL_DIR"/* / | if [ $? -ne 0 ] ; then rsync -av --keep-dirlinks "$INSTALL_DIR"/* / ; fi
rm -rf "${INSTALL_DIR:?}"/*
