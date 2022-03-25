#!/bin/sh

GVM_VERSION=$1

if [[ -n "$GVM_VERSION" ]]; then
    export GVM_VERSION="21.4.4"
fi

set -eu

if [[ "$GVM_VERSION" == "21.4.3" ]] || [[ "$GVM_VERSION" == "21.4.4"]]; then
    echo "WARNING!!! Using an untested version of GVM with this script."
fi

if [[ "$EUID" -eq 0 ]]; then
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
sudo /bin/su -c "$DIR/scripts/install_reuirements.sh" - gvm
# Install gvm-libs
sudo /bin/su -c "$DIR/scripts/gvm-libs.sh" - gvm
# Install gvmd
sudo /bin/su -c "$DIR/scripts/gvmd.sh" - gvm
# Install gsa
sudo /bin/su -c "$DIR/scripts/gsa.sh" - gvm
# Install gsad
sudo /bin/su -c "$DIR/scripts/gsad.sh" - gvm
# Install openvas-smb
sudo /bin/su -c "$DIR/scripts/openvas-smb.sh" - gvm
# Install openvas-scanner
sudo /bin/su -c "$DIR/scripts/openvas.sh" - gvm
# Install ospd-openvas
sudo /bin/su -c "$DIR/scripts/ospd.sh" - gvm
# Install gvm-tools
sudo /bin/su -c "$DIR/scripts/gvm-tools.sh" - gvm
# Install redis
sudo /bin/su -c "$DIR/scripts/redis.sh" - gvm
# Install postgres
sudo /bin/su -c "$DIR/scripts/postgres.sh" - gvm
# Download gvm feed
sudo /bin/su -c "$DIR/scripts/gvm-feed.sh" - gvm
# Start gvm services
sudo /bin/su -c "$DIR/scripts/gvm-services.sh" - gvm























