#!/bin/bash

set -e

# NOTE: buildDeps may have to be extended to include some lib*-dev packages
#       such as libmariadb-client-lgpl-dev libpq-dev libsqlite3-dev libexpat1-dev
buildDeps='
  cpanminus
  build-essential
'
apt-get update -y
apt-get install -y $buildDeps

for arg
do
	[ -f "$arg/cpanfile" ] && cpanm --installdeps --with-recommends "$arg"
done
# Cleanup the cache and remove the build dependencies to reduce the disk footprint
rm -rf /var/lib/apt/lists/* /root/.cpanm
apt-get purge -y --auto-remove $buildDeps

