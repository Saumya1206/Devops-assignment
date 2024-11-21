#!/bin/bash

SOURCE_DIR=$1
DEST_DIR=$2
COMPRESS=$3
LOG_FILE="/var/log/backup.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

if [ -z "$SOURCE_DIR" ] || [ -z "$DEST_DIR" ]; then
    log_message "Error: Source or destination directory not provided"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    log_message "Error: Source directory does not exist"
    exit 1
fi

mkdir -p "$DEST_DIR"

BACKUP_DATE=$(date '+%Y%m%d_%H%M%S')

if [ "$COMPRESS" = "yes" ]; then
    BACKUP_NAME="backup_${BACKUP_DATE}.tar.gz"
    tar -czf "${DEST_DIR}/${BACKUP_NAME}" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
    if [ $? -eq 0 ]; then
        log_message "Success: Created compressed backup ${BACKUP_NAME}"
    else
        log_message "Error: Failed to create compressed backup"
        exit 1
    fi
else
    cp -r "$SOURCE_DIR" "${DEST_DIR}/backup_${BACKUP_DATE}"
    if [ $? -eq 0 ]; then
        log_message "Success: Created uncompressed backup backup_${BACKUP_DATE}"
    else
        log_message "Error: Failed to create uncompressed backup"
        exit 1
    fi
fi

find "$DEST_DIR" -name "backup_*" -type d -o -name "backup_*.tar.gz" -mtime +7 -exec rm -rf {} \;
log_message "Cleanup: Removed backups older than 7 days"