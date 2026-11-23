#!/bin/bash

#Enable strict error handling 
set -euo pipefail

#Project directories 
BASE_DIR="$HOME/linux-system-backup-automation"
BACKUP_DIR="$BASE_DIR/backup"
LOG_DIR="$BASE_DIR/logs"
REPORT_DIR="$BASE_DIR/reports"

# Create project directories if they do not exist
mkdir -p "$BACKUP_DIR" "$LOG_DIR" "$REPORT_DIR"

#Date and time 
 
CURRENT_DATE=$(date +"%Y-%m-%d_%H-%M-%S")

#Log file 

LOG_FILE="$LOG_DIR/backup.log"
REPORT_FILE="$REPORT_DIR/backup_report.txt"
# Logging Function
log_message() {
   echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2" >> "$LOG_FILE"
}

echo "==================================="
echo "Linux System Backup Automation"
echo "==================================="

echo "Backup Date: $CURRENT_DATE"
echo "Backup Directory: $BACKUP_DIR"
echo "Log File: $LOG_FILE"

# User Input
echo

# Multiple Source Directories
SOURCE_DIRS=()

if (( $# > 0 )); then
    for dir in "$@"
    do
        if [[ -d "$dir" ]]; then
            SOURCE_DIRS+=("$dir")
            echo "Directory added: $dir"
        else
            echo "ERROR: Directory does not exist: $dir"
            exit 1
        fi
    done
else
    while true
    do
        read -r -p "Enter source directory (or type done): " dir

        if [[ "$dir" == "done" ]]; then
            break
        fi

        if [[ -d "$dir" ]]; then
            SOURCE_DIRS+=("$dir")
            echo "Directory added: $dir"
        else
            echo "ERROR: Directory does not exist: $dir"
        fi
    done
fi

if (( ${#SOURCE_DIRS[@]} == 0 )); then
    echo "ERROR: No valid directories selected."
    exit 1
fi

echo "All directories selected successfully."

# Generate Backup Report
echo "Linux System Backup Report" > "$REPORT_FILE"
echo "Backup Date: $CURRENT_DATE" >> "$REPORT_FILE"

#Start Multiple Directory Backup
for dir in "${SOURCE_DIRS[@]}"
do
   DIR_NAME=$(basename "$dir")
BACKUP_FILE="$BACKUP_DIR/${DIR_NAME}_${CURRENT_DATE}.tar.gz"

echo "Starting backup for: $dir"
log_message "INFO" "Backup started for $dir"

   if tar -czf "$BACKUP_FILE" -C "$(dirname "$dir")" "$DIR_NAME"; then

echo "Backup completed: $BACKUP_FILE"
log_message "INFO" "Backup completed successfully: $BACKUP_FILE"

echo "Source Directory: $dir" >> "$REPORT_FILE"
echo "Backup File: $BACKUP_FILE" >> "$REPORT_FILE"
echo "Status: SUCCESS" >> "$REPORT_FILE"
             echo "------------------------" >> "$REPORT_FILE"
else
       echo "ERROR: Backup failed for $dir"
       log_message "ERROR" "Backup failed for $dir"
echo "Source Directory: $dir" >> "$REPORT_FILE"
echo "Status: FAILED" >>"$REPORT_FILE"
exit 1
fi
done
# Automatic Old Backup Cleanup
echo "Cleaning backup older than 7 days..."

find "$BACKUP_DIR" -type f -name '*.tar.gz' -mmin +10080 -print0 | while IFS= read -r -d '' old_backup
do
    if rm "$old_backup"; then
echo "Deleted old backup: $old_backup"
     log_message "INFO" "Deleted old backup: $old_backup"
else
echo "ERROR: Could not delete: $old_backup"
     log_message "ERROR" "Could not delete: $old_backup"
fi
done

echo "Backup cleanup completed."
echo "All backups completed."
