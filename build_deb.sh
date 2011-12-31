#!/bin/sh

# Dependencies:
#   apt-get install build-essential debhelper fakeroot e2fslibs-dev libbz2-dev zlib1g-dev libssl-dev libattr1-dev libacl1-dev

version=$1
url="https://www.tarsnap.com/download/tarsnap-autoconf-${version}.tgz"

wget -q -O - $url | tar -xz
cd "tarsnap-autoconf-${version}"
ln -s pkg/debian . && dpkg-buildpackage
cd ..
rm -rf "tarsnap-autoconf-${version}"
