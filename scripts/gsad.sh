#!/bin/bash

set -e

######
# Build the Greenbone Security Assistant Daemon
######

export GSAD_VERSION=$GVM_VERSION && \
curl -f -L https://github.com/greenbone/gsad/archive/refs/tags/v"$GSAD_VERSION".tar.gz -o "$SOURCE_DIR"/gsad-"$GSAD_VERSION".tar.gz && \
curl -f -L https://github.com/greenbone/gsad/releases/download/v"$GSAD_VERSION"/gsad-"$GSAD_VERSION".tar.gz.asc -o "$SOURCE_DIR"/gsad-"$GSAD_VERSION".tar.gz.asc && \
gpg --verify "$SOURCE_DIR"/gsad-"$GSAD_VERSION".tar.gz.asc "$SOURCE_DIR"/gsad-"$GSAD_VERSION".tar.gz

tar -C "$SOURCE_DIR" -xvzf "$SOURCE_DIR"/gsad-"$GSAD_VERSION".tar.gz && \
mkdir -p "$BUILD_DIR"/gsad && cd "$BUILD_DIR"/gsad && \
cmake "$SOURCE_DIR"/gsad-"$GSAD_VERSION" \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DSYSCONFDIR=/etc \
  -DLOCALSTATEDIR=/var \
  -DGVM_RUN_DIR=/run/gvm \
  -DGSAD_PID_DIR=/run/gvm \
  -DLOGROTATE_DIR=/etc/logrotate.d && \
make -j"$(nproc)" && \
make DESTDIR="$INSTALL_DIR" install && \
sudo cp -rv "${INSTALL_DIR:?}"/* / && \
rm -rf "${INSTALL_DIR:?}"/*

exit