#!/bin/bash
# -*- mode: bash -*-
# vi: set ft=bash :

# This runs as root on the server

# Let use use relative paths from this script even when run from interactive shell; workaround for $SSH_AUTH_SOCK
cd "$(dirname "$0")" || exit 2;

binary=`which hostapd`

# Are we on a vanilla system?
if ! test -f "$binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    apt-get update &&
    apt-get -o Dpkg::Options::="--force-confnew" \
        --force-yes -fuy dist-upgrade &&
    # Install Ruby and Chef
    apt-get install -y wireless-tools hostapd bridge-utils
fi &&

