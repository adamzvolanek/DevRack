#!/bin/bash

BACKUP_DIR="</backuplocation>"

echo "Clearing previous Paperless-ngx backup contents"
echo "Backup directory: $BACKUP_DIR"

rm -rf "${BACKUP_DIR:?}"/*

echo "Previous backup contents removed"
echo "Running document exporter to the export volume mount using filename format"
echo "Export volume is defined: $BACKUP_DIR"

docker exec paperless_ngx document_exporter ../export -f -nt -na

echo "paperless_ngx document_exporter command complete"
echo "Running permission updates"

chmod -R 777 "$BACKUP_DIR"

echo "Completed permission updates!"
