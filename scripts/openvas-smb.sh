#!/bin/bash

set -e


#####
# OpenVAS Samba Module
####

export OPENVAS_SMB_VERSION=21.4.0 && \
curl -f -L https://github.com/greenbone/openvas-smb/archive/refs/tags/v"$OPENVAS_SMB_VERSION".tar.gz -o "$SOURCE_DIR"/openvas-smb-"$OPENVAS_SMB_VERSION".tar.gz && \
curl -f -L https://github.com/greenbone/openvas-smb/releases/download/v"$OPENVAS_SMB_VERSION"/openvas-smb-"$OPENVAS_SMB_VERSION".tar.gz.asc -o "$SOURCE_DIR"/openvas-smb-"$OPENVAS_SMB_VERSION".tar.gz.asc && \
gpg --verify "$SOURCE_DIR"/openvas-smb-"$OPENVAS_SMB_VERSION".tar.gz.asc "$SOURCE_DIR"/openvas-smb-"$OPENVAS_SMB_VERSION".tar.gz

tar -C "$SOURCE_DIR" -xvzf "$SOURCE_DIR"/openvas-smb-"$OPENVAS_SMB_VERSION".tar.gz && \
mkdir -p "$BUILD_DIR"/openvas-smb && cd "$BUILD_DIR"/openvas-smb && \
cmake "$SOURCE_DIR"/openvas-smb-"$OPENVAS_SMB_VERSION" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_BUILD_TYPE=Release && \
make -j$(nproc) && \
make DESTDIR="$INSTALL_DIR" install && \
sudo cp -rv "${INSTALL_DIR:?}"/* / && \
rm -rf "${INSTALL_DIR:?}"/*