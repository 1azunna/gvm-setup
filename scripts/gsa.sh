#!/bin/bash

set -e

######
# Build the Greenbone Security Assistant
######

export GSA_VERSION="$GVM_VERSION" && \
curl -f -L https://github.com/greenbone/gsa/archive/refs/tags/v"$GSA_VERSION".tar.gz -o "$SOURCE_DIR"/gsa-"$GSA_VERSION".tar.gz && \
curl -f -L https://github.com/greenbone/gsa/releases/download/v"$GSA_VERSION"/gsa-"$GSA_VERSION".tar.gz.asc -o "$SOURCE_DIR"/gsa-"$GSA_VERSION".tar.gz.asc && \
gpg --verify "$SOURCE_DIR"/gsa-"$GSA_VERSION".tar.gz.asc "$SOURCE_DIR"/gsa-"$GSA_VERSION".tar.gz


tar -C "$SOURCE_DIR" -xvzf "$SOURCE_DIR"/gsa-"$GSA_VERSION".tar.gz && \
cd "$SOURCE_DIR"/gsa-"$GSA_VERSION" && \
[ -d "./build" ] && rm -rf build 
yarnpkg 
yarnpkg build
sudo mkdir -p "$INSTALL_PREFIX"/share/gvm/gsad/web/ && \
sudo cp -r build/* "$INSTALL_PREFIX"/share/gvm/gsad/web/