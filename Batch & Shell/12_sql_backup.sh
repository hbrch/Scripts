#!/bin/bash

# Define Variables
BACKUP_DIR="/backups/mysql"
DATE=$(date +%Y-%m-%d-%H%M)
MYSQL_USER="***"
MYSQL_PASSWORD="***"
EMAIL="***"
LOG_FILE="/var/log/mysql_backup.log"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Step 1: Log backup start time
echo "Starting MySQL backup at $(date)" >> $LOG_FILE

# Step 2: Backup all databases
echo "Backing up MySQL databases..." >> $LOG_FILE
mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD --all-databases | gzip > $BACKUP_DIR/mysql_backup_$DATE.sql.gz

# Step 3: Verify backup success
if [ $? -eq 0 ]; then
    echo "Backup completed successfully at $(date)" >> $LOG_FILE
    # Step 4: Send success email
    echo "MySQL backup completed successfully at $DATE" | mail -s "MySQL Backup Successful" $EMAIL
else
    echo "Backup failed at $(date)" >> $LOG_FILE
    # Step 5: Send failure email
    echo "MySQL backup failed at $DATE" | mail -s "MySQL Backup Failed" $EMAIL
fi

# Step 6: Clean up old backups (older than 7 days)
echo "Cleaning up old backups..." >> $LOG_FILE
find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +7 -exec rm -f {} \; >> $LOG_FILE

echo "Backup process completed at $(date)" >> $LOG_FILE
