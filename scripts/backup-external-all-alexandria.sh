#!/bin/bash

echo "Running rsync of Unraid Shares to External Drive"
rsync -vrltDhH --info=progress2 --exclude={"appdata","transcode","scratch","backups/UniFi_Protect"} "/mnt/user/" "/mnt/disks/WD_Elements_25A3/" --log-file=/mnt/user/backups/Unraid/rsync_backup.log
