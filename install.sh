#!/bin/bash
# -*- mode: bash -*-
# vi: set ft=sh :

# This runs as root on the server

export INTERFACES=/etc/network/interfaces
export INTERFACE=wlan0
export HOSTAPD=/etc/hostapd/hostapd.conf

export SIMPLE_BACKUP_SUFFIX=.`date +%s`

# Let use use relative paths from this script even when run from interactive shell; workaround for $SSH_AUTH_SOCK
cd "$(dirname "$0")" || exit 2;

function inform {
  echo -ne "\033[32m"
  echo -ne "$*"
  echo -e  "\033[0m"
}

function append {
  TEMP=`mktemp`
  inform Appending to $1 from $2
  cat "$1" "$2" 2> /dev/null | tee "$TEMP"
  echo -ne "\033[32m"
  cp -vb "$TEMP" "$1"
  echo -en  "\033[0m"
  rm $TEMP
}

function pause {
  echo -ne "\033[32m"
  echo -n Press enter to continue.
  echo -e  "\033[0m"
  read
}

function test_append {
  if ! test -f "$1"; then
    inform Generating new $1
    append "$1" "$2"
    return
  fi
  grep -q "$3" "$1" &&
  inform Skipping appending to $1 from $2\; matched \"$3\". && cat "$2" && return
  append "$1" "$2"
}

binary=`which hostapd`
if ! test -f "$binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    apt-get update &&
    apt-get -o Dpkg::Options::="--force-confnew" \
        --force-yes -fuy dist-upgrade &&
    apt-get install -y wireless-tools hostapd bridge-utils
fi

inform "Writing out configuration files..."
test_append $INTERFACES templates/`basename $INTERFACES` $INTERFACE ; pause
#test_append $HOSTAPD templates/`basename $HOSTAPD` $INTERFACE ; pause
