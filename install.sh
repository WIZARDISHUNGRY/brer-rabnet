#!/bin/bash
# -*- mode: bash -*-
# vi: set ft=bash :

# This runs as root on the server

# Let use use relative paths from this script even when run from interactive shell; workaround for $SSH_AUTH_SOCK
cd `dirname $0` || exit 2;

# true on ubuntu 12.4
chef_binary=/usr/local/bin/chef-solo

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    apt-get update &&
    apt-get -o Dpkg::Options::="--force-confnew" \
        --force-yes -fuy dist-upgrade &&
    # Install Ruby and Chef
    apt-get install -y ruby1.9.1 ruby1.9.1-dev make &&
    gem1.9.1 install --no-rdoc --no-ri chef --version 0.10.4
fi &&

exec "$chef_binary" -c ./solo.rb -j manifest.json
