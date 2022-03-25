#!/bin/bash

set -eu

sudo -u gvm greenbone-nvt-sync
sudo -u gvm greenbone-feed-sync --type GVMD_DATA
sudo -u gvm greenbone-feed-sync --type SCAP
sudo -u gvm greenbone-feed-sync --type CERT
sudo -u gvm gvm-manage-certs -a

### Scheduled Jobs

sudo touch /usr/local/bin/openvas-update
sudo chown gvm:gvm /usr/local/bin/openvas-update
sudo chmod a+x /usr/local/bin/openvas-update
echo "/usr/local/bin/greenbone-nvt-sync
/usr/local/bin/greenbone-feed-sync --type GVMD_DATA
/usr/local/bin/greenbone-feed-sync --type SCAP
/usr/local/bin/greenbone-feed-sync --type CERT" | sudo tee -a /usr/local/bin/openvas-update

(crontab -l 2>/dev/null || true; echo "0 0 * * * gvm /usr/local/bin/openvas-update") | crontab -