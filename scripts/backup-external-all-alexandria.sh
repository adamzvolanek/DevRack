#!/bin/bash

# Define the parent directory and the destination
SOURCE_DIR="/mnt/user/"
DEST_DIR="/mnt/disks/WD_Elements_25A3/"
LOG_DIR="/mnt/user/logs/external_backup/"

# Define shares to exclude
EXCLUDED_SHARES=("Share1" "Share2" "Share3")

# Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Loop through all directories in the source directory
for SHARE in "$SOURCE_DIR"*; do
    # Get the base name of the share
    SHARE_NAME=$(basename "$SHARE")

    # Check if the share is in the excluded list
    if [[ ! " ${EXCLUDED_SHARES[@]} " =~ " ${SHARE_NAME} " ]]; then
        echo "Running rsync of Unraid Share: $SHARE_NAME"

        # Define the log file for this specific share
        LOG_FILE="${LOG_DIR}${SHARE_NAME}.log"

        # Delete any existing log file for this share
        if [ -f "$LOG_FILE" ]; then
            rm "$LOG_FILE"
            echo "Deleted existing log file: $LOG_FILE"
        fi

        # Record the start time
        START_TIME=$(date +%s)

        # Run rsync without specifying excludes in the command
        rsync -a --human-readable --info=progress2 --update --delete --partial \
            "$SHARE/" "$DEST_DIR$SHARE_NAME/" >> "$LOG_FILE" 2>&1

        # Record the end time
        END_TIME=$(date +%s)

        # Calculate the total transfer time in seconds
        TOTAL_TIME=$(( END_TIME - START_TIME ))

        # Convert total time to a human-readable format (HH:MM:SS)
        printf "Total transfer time for %s: %02d:%02d:%02d\n" "$SHARE_NAME" $((TOTAL_TIME/3600)) $(((TOTAL_TIME%3600)/60)) $((TOTAL_TIME%60)) >> "$LOG_FILE"

        if [ $? -eq 0 ]; then
            echo "Backup of $SHARE_NAME completed successfully." >> "$LOG_FILE"
        else
            echo "Backup of $SHARE_NAME failed. Check the log for details." >> "$LOG_FILE"
        fi
    else
        echo "Skipping excluded share: $SHARE_NAME"
    fi
done
