#!/bin/bash
echo "Deleting previous log"

# Check if log file exists and delete if it does
if [ -f "{logLocation}/restore_{shareName}_log.txt" ]; then
    echo "Deleting previous log"
    rm "{logLocation}/restore_{shareName}_log.txt"
fi

# Restores data without deleting local share items
echo "Running RClone Sync of B2 {shareName} Bucket to {shareName} Share"
rclone sync \
  --progress \
  --transfers 8 \
  --verbose \
  --exclude .Recycle.Bin/** \
  --links \
  --log-file /mnt/user/logs/BackBlaze_Logs/restore_{shareName}_log.txt \
  b2_buckets:{bucketName}/ \
  /mnt/user/{shareName}/

echo "Updating permissions of log file"
chmod 755 {logLocation}/restore_{shareName}_log.txt
