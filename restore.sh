#!/bin/bash

# Global options
export TZ="Europe/Paris"
export BORG_PASSPHRASE='123456'

# Borg options
BORG_REPO="/etc/backups"
BORG_ROOT_BACKUP="$1"
BORG_HOME_BACKUP="$2"

cd /

sudo -E borg extract --verbose --progress "$BORG_REPO"::"$BORG_ROOT_BACKUP"

# shellcheck disable=SC2181
if [[ $? -eq 0 ]]; then
  echo "Root backup finished successfully";
else
  echo "Root backup did not finished successfully";
fi

sudo -E borg extract --verbose --progress "$BORG_REPO"::"$BORG_HOME_BACKUP"

# shellcheck disable=SC2181
if [[ $? -eq 0 ]]; then
  echo "Home backup finished successfully";
else
  echo "Home backup did not finished successfully";
fi
