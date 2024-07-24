#!/bin/bash

# Global options
export TZ="Europe/Paris"
export BORG_PASSPHRASE='123456'

# Script options
DATE="$(date +"%Y-%m-%d_%T")"
HOSTNAME="$(hostname)"

# Borg options
BORG_REPO="/etc/backups"
BORG_OPTS="--stats --one-file-system --compression lz4 --checkpoint-interval 86400 --progress"

ROOT_ARCHIVE_NAME="$HOSTNAME-root-$DATE"
HOME_ARCHIVE_NAME="$HOSTNAME-home-$DATE"

# Create a new backup
sudo borg create $BORG_OPTS \
  "$BORG_REPO::$ROOT_ARCHIVE_NAME" \
  / /boot \
  --exclude /proc \
  --exclude /sys \
  --exclude /dev \
  --exclude /run \
  --exclude /tmp \
  --exclude /var/tmp \
  --exclude /var/run \
  --exclude /var/lib/docker/devicemapper \
  --exclude /mnt \
  --exclude /media \
  --exclude /swapfile \
  --exclude /home \
  --exclude /snap \
  --exclude /root/.cache \
  --exclude "$BORG_REPO"

# Create home backup
sudo borg create $BORG_OPTS \
  "$BORG_REPO::$HOME_ARCHIVE_NAME" \
  /home \
  --exclude 'sh:home/*/.cache'

sudo borg delete --list --first 2 --sort timestamp $BORG_REPO

sudo aws s3 sync "$BORG_REPO" "s3://syncovery-backup/backups/backup-$DATE"