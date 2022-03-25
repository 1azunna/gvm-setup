#!/bin/sh

GVM_VERSION=$1

if [ -n "$GVM_VERSION" ]; then
    export GVM_VERSION="21.4.4"
fi

set -eu

if [ "$GVM_VERSION" == "21.4.3" ] || [ "$GVM_VERSION" == "21.4.4" ]; then
    echo "WARNING!!! Using an untested version of GVM with this script."
fi

if [ "$UID" -eq 0 ]; then
    echo "This setup should not be run as root. Ensure user has sudo access."
    exit 1
fi

DIR=$(pwd)

# Setup GVM Install paths
sudo useradd -r -M -U -G sudo -s /usr/sbin/nologin gvm && \
sudo usermod -aG gvm "$USER" && sudo su -- "$USER"

export PATH=$PATH:/usr/local/sbin
export INSTALL_PREFIX=/usr/local
export SOURCE_DIR=$HOME/source && mkdir -p "$SOURCE_DIR"
export BUILD_DIR=$HOME/build && mkdir -p "$BUILD_DIR"
export INSTALL_DIR=$HOME/install && mkdir -p "$INSTALL_DIR"

# Setup Requirements
sudo su gvm -s $DIR/scripts/install_reuirements.sh
# Install gvm-libs
sudo su gvm -s $DIR/scripts/gvm-libs.sh
# Install gvmd
sudo su gvm -s $DIR/scripts/gvmd.sh
# Install gsa
sudo su gvm -s $DIR/scripts/gsa.sh
# Install gsad
sudo su gvm -s $DIR/scripts/gsad.sh
# Install openvas-smb
sudo su gvm -s $DIR/scripts/openvas-smb.sh
# Install openvas-scanner
sudo su gvm -s $DIR/scripts/openvas.sh
# Install ospd-openvas
sudo su gvm -s $DIR/scripts/ospd.sh
# Install gvm-tools
sudo su gvm -s $DIR/scripts/gvm-tools.sh
# Install redis
sudo su gvm -s $DIR/scripts/redis.sh
# Install postgres
sudo su gvm -s $DIR/scripts/postgres.sh
# Download gvm feed
sudo su gvm -s $DIR/scripts/gvm-feed.sh
# Start gvm services
sudo su gvm -s $DIR/scripts/gvm-services.sh