#!/bin/bash

path="/mnt/user/Backups/Unraid/CA_Backup/Appdata_Backup/"
timestamp=$(date +%Y%m%d_%H%M%S)    
filename=clear_15day_log_$timestamp.txt    
log=$path$filename
days=15

START_TIME=$(date +%s)

find $path -maxdepth 1 -name "*.txt"  -type f -mtime +$days  -print -delete >> $log

echo "Backup:: Script Start -- $(date +%Y%m%d_%H%M)" >> $log

END_TIME=$(date +%s)

ELAPSED_TIME=$(( $END_TIME - $START_TIME ))


echo "Backup :: Script End -- $(date +%Y%m%d_%H%M)" >> $log
echo "Elapsed Time ::  $(date -d 00:00:$ELAPSED_TIME +%Hh:%Mm:%Ss) "  >> $log
