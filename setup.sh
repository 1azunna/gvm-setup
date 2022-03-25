#!/bin/bash

GVM_VERSION=$1

if [[ -n "$GVM_VERSION" ]]; then
    export GVM_VERSION="21.4.4"
fi

set -u

if [[ "$GVM_VERSION" == "21.4.3" ]] || [[ "$GVM_VERSION" == "21.4.4" ]]; then
    echo "WARNING!!! Using an untested version of GVM with this script."
fi

if [[ "$UID" -eq 0 ]]; then
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

# Give no password access to gvm
sudo cat /etc/sudoers | grep "gvm ALL=NOPASSWD:ALL"
if [ $? -ne 0 ]; then
    echo "gvm ALL=NOPASSWD:ALL" | sudo tee -a /etc/sudoers
fi

# Setup Requirements
bash  "$DIR/scripts/install_requirements.sh"
# Install gvm-libs
sudo -u gvm  "$DIR/scripts/gvm-libs.sh"
# Install gvmd
sudo -u gvm  "$DIR/scripts/gvmd.sh"
# Install gsa
sudo -u gvm  "$DIR/scripts/gsa.sh"
# Install gsad
sudo -u gvm  "$DIR/scripts/gsad.sh"
# Install openvas-smb
sudo -u gvm  "$DIR/scripts/openvas-smb.sh"
# Install openvas-scanner
sudo -u gvm  "$DIR/scripts/openvas.sh"
# Install ospd-openvas
sudo -u gvm  "$DIR/scripts/ospd.sh"
# Install gvm-tools
sudo -u gvm  "$DIR/scripts/gvm-tools.sh"
# Install redis
sudo -u gvm  "$DIR/scripts/redis.sh"
# Install postgres
sudo -u gvm  "$DIR/scripts/postgres.sh"
# Download gvm feed
sudo -u gvm  "$DIR/scripts/gvm-feed.sh"
# Start gvm services
sudo -u gvm  "$DIR/scripts/gvm-services.sh"