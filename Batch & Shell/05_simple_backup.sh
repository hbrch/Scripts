#!/bin/bash
# Created 11.4.2023

# Directories
SOURCE_DIRS="/home /etc /var/www"
BACKUP_DIR="/mnt/backup"
LOGFILE="/var/log/backup.log"
TIMESTAMP=$(date +%F_%T)

# Create the BACKUP_DIRECTORY
mkdir -p $BACKUP_DIR

echo "Starting backup at $TIMESTAMP" | tee -a $LOGFILE
for DIR in $SOURCE_DIRS; do
    ARCHIVE="$BACKUP_DIR/$(basename $DIR)_$TIMESTAMP.tar.gz"
    tar -czf $ARCHIVE $DIR
    echo "Backed up $DIR to $ARCHIVE" | tee -a $LOGFILE
done

echo "Backup completed." | tee -a $LOGFILE
