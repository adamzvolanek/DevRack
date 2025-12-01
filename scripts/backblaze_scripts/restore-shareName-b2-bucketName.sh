#!/bin/bash

# Define variables
ShareName="ShareName"
BucketName="YourBucketName"
LogLocation="/mnt/user/logs/BackBlaze_Logs"

echo "Deleting previous log"

# Check if log file exists and delete it if it does
if [ -f "${LogLocation}/${ShareName}.log" ]; then
    echo "Deleting previous log"
    rm "${LogLocation}/${ShareName}.log"
fi

echo "Running RClone Sync of B2 ${ShareName} Bucket to ${ShareName} Share"

rclone sync \
  --progress \
  --transfers 8 \
  --verbose \
  --exclude .Recycle.Bin/** \
  --links \
  --log-file "${LogLocation}/${ShareName}.log" \
  "b2_buckets:${BucketName}/" \
  "/mnt/user/${ShareName}/"

echo "Updating permissions of log file"
chmod 755 "${LogLocation}/${ShareName}.log"
