#!/bin/bash

set -eu

#####
# Configure PostgreSQL database
#####

sudo systemctl start postgresql@11-main
sudo -u postgres bash -c "
createuser -DRS gvm && createdb -O gvm gvmd
psql -d gvmd -c 'create role dba with superuser noinherit; grant dba to gvm; create extension \"uuid-ossp\"; create extension \"pgcrypto\";'
exit
"

#Generate Admin User
sudo ldconfig
# export ADMIN_PASSWORD=$(gvmd --create-user=admin)
gvmd --create-user=admin --password=admin
gvmd --modify-setting 78eceaec-3385-11ea-b237-28d24461215b --value `gvmd --get-users --verbose | grep admin | awk '{print $2}'`

exit