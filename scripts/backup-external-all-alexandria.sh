#!/bin/bash

# Get all share names dynamically from /mnt/user and store them in the ShareNames array
ShareNames=($(ls -d /mnt/user/*/ | xargs -n 1 basename))

# Get existing shares on the destination (remote)
RemoteShares=($(ls -d /mnt/remotes/alexandria_backup/*/ 2>/dev/null | xargs -n 1 basename))

# Delete remote shares that are no longer present on the local server
for RemoteShare in "${RemoteShares[@]}"; do
    if [[ ! " ${ShareNames[@]} " =~ " ${RemoteShare} " ]]; then
        echo "Deleting stale remote share: ${RemoteShare}"
        rm -rf "/mnt/remotes/alexandria_backup/${RemoteShare}"
    fi
done

# Loop through each share name in the array
for ShareName in "${ShareNames[@]}"
do
    # Get the start time for the share
    StartTime=$(date "+%Y-%m-%d %H:%M:%S")
    echo "Starting Rsync for ${ShareName} at ${StartTime}"

    # Delete previous log if it exists
    echo "Deleting previous log for ${ShareName}"
    if [ -f "/mnt/user/logs/offsite_logs/${ShareName}_log.txt" ]; then
        rm "/mnt/user/logs/offsite_logs/${ShareName}_log.txt"
    fi

    echo "Running Rsync Sync of ${ShareName} Share to Offsite Server via SMB Share"

    # Rsync sync command with additional verbosity and options
    rsync -aqh -P --exclude='.Recycle.Bin/' --log-file="/mnt/user/logs/offsite_logs/${ShareName}_log.txt" \
      --stats \
      --delete \
      /mnt/user/${ShareName}/ /mnt/remotes/alexandria_backup/${ShareName}

    # Get the end time for the share
    EndTime=$(date "+%Y-%m-%d %H:%M:%S")
    echo "Rsync for ${ShareName} completed at ${EndTime}"

    # Calculate the time taken for the Rsync operation
    ElapsedTime=$((SECONDS))
    echo "Time taken for Rsync on ${ShareName}: ${ElapsedTime} seconds" | tee -a "/mnt/user/logs/offsite_logs/${ShareName}_log.txt"

    echo "Updating permissions of log file for ${ShareName}"
    chmod 755 "/mnt/user/logs/offsite_logs/${ShareName}_log.txt"

    # Reset the SECONDS counter for the next loop iteration
    SECONDS=0
done
