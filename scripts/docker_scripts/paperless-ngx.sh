#!/bin/bash
echo 'Deleting previous backup'
rm -rf /mnt/user/backups/Adam/Documents/*

echo 'Running document exporter to the export volume mount using filename format'
docker exec paperless_ngx document_exporter ../export -f

echo 'Done'
