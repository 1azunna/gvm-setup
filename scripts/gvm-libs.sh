#!/bin/bash

set -e

########
#Build GVM libraries
#######

export GVM_LIBS_VERSION="$GVM_VERSION"

curl -f -L https://github.com/greenbone/gvm-libs/archive/refs/tags/v"$GVM_LIBS_VERSION".tar.gz -o "$SOURCE_DIR"/gvm-libs-"$GVM_LIBS_VERSION".tar.gz && \
curl -f -L https://github.com/greenbone/gvm-libs/releases/download/v"$GVM_LIBS_VERSION"/gvm-libs-"$GVM_LIBS_VERSION".tar.gz.asc -o "$SOURCE_DIR"/gvm-libs-"$GVM_LIBS_VERSION".tar.gz.asc && \
gpg --verify "$SOURCE_DIR"/gvm-libs-"$GVM_LIBS_VERSION".tar.gz.asc "$SOURCE_DIR"/gvm-libs-"$GVM_LIBS_VERSION".tar.gz

tar -C "$SOURCE_DIR" -xvzf "$SOURCE_DIR"/gvm-libs-"$GVM_LIBS_VERSION".tar.gz
mkdir -p "$BUILD_DIR"/gvm-libs && cd "$BUILD_DIR"/gvm-libs && \
cmake "$SOURCE_DIR"/gvm-libs-"$GVM_LIBS_VERSION" \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -DCMAKE_BUILD_TYPE=Release \
  -DSYSCONFDIR=/etc \
  -DLOCALSTATEDIR=/var \
  -DGVM_PID_DIR=/run/gvm && \
make -j"$(nproc)" && \
make DESTDIR="$INSTALL_DIR" install
sudo cp -rv "$INSTALL_DIR"/* / | if [ $? -ne 0 ] ; then rsync -av --keep-dirlinks "$INSTALL_DIR"/* /; fi
rm -rf "${INSTALL_DIR:?}"/*