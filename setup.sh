#!/bin/bash

if [[ -n "$1" ]]; then
    export GVM_VERSION="21.4.4"
else
    GVM_VERSION=$1
fi

if ! [[ "$GVM_VERSION" == "21.4.3" ]] || [[ "$GVM_VERSION" == "21.4.4" ]]; then
    echo "WARNING!!! Using an untested version of GVM with this script."
fi

if [[ "$UID" -eq 0 ]]; then
    echo "This setup should not be run as root. Ensure user has sudo access."
    exit 1
fi

echo "export GVM_VERSION=$GVM_VERSION" >> ~/.bashrc

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
# sudo cat /etc/sudoers | grep "gvm ALL=NOPASSWD:ALL"
# if [ $? -ne 0 ]; then
#     echo "gvm ALL=NOPASSWD:ALL" | sudo tee -a /etc/sudoers
# fi

# Setup Requirements
bash  "$DIR/scripts/install_requirements.sh"

set -eu
# Install gvm-libs
bash  "$DIR/scripts/gvm-libs.sh"
# Install gvmd
bash  "$DIR/scripts/gvmd.sh"
# Install gsa
bash  "$DIR/scripts/gsa.sh"
# Install gsad
bash  "$DIR/scripts/gsad.sh"
# Install openvas-smb
bash  "$DIR/scripts/openvas-smb.sh"
# Install openvas-scanner
bash  "$DIR/scripts/openvas.sh"
# Install ospd-openvas
bash  "$DIR/scripts/ospd.sh"
# Install gvm-tools
bash  "$DIR/scripts/gvm-tools.sh"
# Install redis
bash  "$DIR/scripts/redis.sh"
# Install postgres
bash  "$DIR/scripts/postgres.sh"
# Download gvm feed
bash  "$DIR/scripts/gvm-feed.sh"
# Start gvm services
bash  "$DIR/scripts/gvm-services.sh"

exit $?