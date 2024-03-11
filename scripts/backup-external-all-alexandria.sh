#!/bin/bash

echo "Running RClone Sync of Unraid Shares to External Drive"
rsync -avHAX --info=progress2 --exclude {dir}} /mnt/user/ /mnt/disks/{external_drive}/ --log-file={dir}
