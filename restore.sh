#!/bin/bash

BORG_REPO="/etc/backups"
BORG_BACKUP="$1"

cd /

sudo borg extract --verbose --progress "$BORG_REPO"::"$BORG_BACKUP"

# shellcheck disable=SC2181
if [[ $? -eq 0 ]]; then
  echo "oui";
else
  echo "non";
fi
