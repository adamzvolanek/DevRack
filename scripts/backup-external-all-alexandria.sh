#!/bin/bash

#echo "Running rsync of Unraid Shares to External Drive"
#rsync -rcltDhH --info=progress2 --size-only --no-compress --exclude={"ExcludedShare1","ExlcudedShare2","ExcludedShare3/SpecificDirectory"} "/mnt/user/" "/mnt/disks/DiskName/"

echo "Copying Shares to External Drive"

echo "Copying Share1"
cp -apP --update /mnt/user/Share1 /mnt/disks/DiskName/

echo "Copying Share2"
cp -apP --update /mnt/user/Share2 /mnt/disks/DiskName/
