#!/bin/bash

# Define the ShareName variable
ShareName="ShareName"

echo "Deleting previous log"

# Check if log file exists and delete if it does
if [ -f "[DEFINED_LOG_LOCATION]/${ShareName}.log" ]; then
    echo "Deleting previous log"
    rm "[DEFINED_LOG_LOCATION]/${ShareName}.log"
fi

echo "Running RClone Sync of ${ShareName} Share to B2 ${ShareName} Bucket"
rclone sync \
  --progress \
  --transfers 8 \
  --verbose \
  --exclude .Recycle.Bin/** \
  --links \
  --log-file [DEFINED_LOG_LOCATION]/${ShareName}.log \
    /mnt/user/${ShareName}/ \
    b2_buckets:${ShareName}...

echo "Updating permissions of log file"
chmod 755 [DEFINED_LOG_LOCATION]/${ShareName}.log
