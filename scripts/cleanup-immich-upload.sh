#!/bin/bash

# -------------------------
# Configurable variable
# -------------------------
BASE_DIR="/mnt/user/photos-immich/upload"  # Change this to your target directory
# -------------------------

# Ensure BASE_DIR is an absolute path
BASE_DIR="$(realpath "$BASE_DIR")"

echo "Searching for empty directories under $BASE_DIR"

find "$BASE_DIR" -type d -empty -print -delete
