#!/bin/bash

set -e

#######
# Build the Greenbone Vulnerability Manager Daemon
######

export GVMD_VERSION=21.4.5 && \
curl -f -L https://github.com/greenbone/gvmd/archive/refs/tags/v"$GVMD_VERSION".tar.gz -o "$SOURCE_DIR"/gvmd-"$GVMD_VERSION".tar.gz && \
curl -f -L https://github.com/greenbone/gvmd/releases/download/v"$GVMD_VERSION"/gvmd-"$GVMD_VERSION".tar.gz.asc -o "$SOURCE_DIR"/gvmd-"$GVMD_VERSION".tar.gz.asc && \
gpg --verify "$SOURCE_DIR"/gvmd-"$GVMD_VERSION".tar.gz.asc "$SOURCE_DIR"/gvmd-"$GVMD_VERSION".tar.gz

tar -C "$SOURCE_DIR" -xvzf "$SOURCE_DIR"/gvmd-"$GVMD_VERSION".tar.gz
mkdir -p "$BUILD_DIR"/gvmd && cd "$BUILD_DIR"/gvmd && \
cmake "$SOURCE_DIR"/gvmd-"$GVMD_VERSION" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLOCALSTATEDIR=/var \
  -DSYSCONFDIR=/etc \
  -DGVM_DATA_DIR=/var \
  -DGVM_RUN_DIR=/run/gvm \
  -DOPENVAS_DEFAULT_SOCKET=/run/ospd/ospd-openvas.sock \
  -DGVM_FEED_LOCK_PATH=/var/lib/gvm/feed-update.lock \
  -DSYSTEMD_SERVICE_DIR=/lib/systemd/system \
  -DDEFAULT_CONFIG_DIR=/etc/default \
  -DLOGROTATE_DIR=/etc/logrotate.d && \
make -j"$(nproc)" && \
make DESTDIR="$INSTALL_DIR" install && \
sudo cp -rv "${INSTALL_DIR:?}"R/* / && \
rm -rf "${INSTALL_DIR:?}"/*

exit
