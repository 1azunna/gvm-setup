#!/bin/bash

set -eu

# Install common dependencies
sudo apt update && \
sudo apt install --no-install-recommends -y build-essential curl wget cmake pkg-config python3 python3-pip gnupg 

#Required dependencies for gvm-libs, gvmd, gsa, gsad, openvas-smb, openvas
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update && \
sudo apt install -y libglib2.0-dev libgpgme-dev libgnutls28-dev uuid-dev libssh-gcrypt-dev libhiredis-dev libxml2-dev libpcap-dev \
    libnet1-dev libpq-dev postgresql-server-dev-11 postgresql-client-11 postgresql-11 redis-server libical-dev xsltproc rsync \
    nodejs yarnpkg libmicrohttpd-dev gcc-mingw-w64 libpopt-dev libunistring-dev heimdal-dev perl-base bison libgcrypt20-dev \
    libgpgme-dev libksba-dev nmap libldap2-dev libradcli-dev texlive-latex-extra texlive-fonts-recommended xmlstarlet zip rpm \
    fakeroot dpkg nsis gnupg gpgsm sshpass openssh-client socat snmp smbclient python3-lxml gnutls-bin xml-twig-tools python3-impacket \
    libsnmp-dev python3-setuptools python3-packaging python3-wrapt python3-cffi python3-psutil python3-defusedxml python3-paramiko python3-redis


# Import GVM signing key
curl -O https://www.greenbone.net/GBCommunitySigningKey.asc && \
gpg --import GBCommunitySigningKey.asc
echo -e "5\ny\n" |  gpg --command-fd 0 --expert --edit-key 9823FAA60ED1E580 trust

exit