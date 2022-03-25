#!/bin/bash

set -e

######
# Configure Redis
#####

sudo cp "$SOURCE_DIR"/openvas-scanner-"$OPENVAS_SCANNER_VERSION"/config/redis-openvas.conf /etc/redis/ && \
sudo chown redis:redis /etc/redis/redis-openvas.conf && \
echo "db_address = /run/redis-openvas/redis.sock" | sudo tee -a /etc/openvas/openvas.conf

sudo systemctl start redis-server@openvas.service && \
sudo systemctl enable redis-server@openvas.service

sudo usermod -aG redis gvm && \
sudo chown -R gvm:gvm /var/lib/gvm && \
sudo chown -R gvm:gvm /var/lib/openvas && \
sudo chown -R gvm:gvm /var/log/gvm && \
sudo chown -R gvm:gvm /run/gvm && \
sudo chmod -R g+srw /var/lib/gvm && \
sudo chmod -R g+srw /var/lib/openvas && \
sudo chmod -R g+srw /var/log/gvm && \
sudo chown gvm:gvm /usr/local/sbin/gvmd && \
sudo chmod 6750 /usr/local/sbin/gvmd

sudo chown gvm:gvm /usr/local/bin/greenbone-nvt-sync && \
sudo chmod 740 /usr/local/sbin/greenbone-feed-sync && \
sudo chown gvm:gvm /usr/local/sbin/greenbone-*-sync && \
sudo chmod 740 /usr/local/sbin/greenbone-*-sync

echo "# allow users of the gvm group run openvas
%gvm ALL = NOPASSWD: /usr/local/sbin/openvas" | sudo tee -a /etc/sudoers

exit