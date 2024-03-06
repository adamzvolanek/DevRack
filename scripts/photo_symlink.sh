#!/bin/bash

# Check if source directory is provided as argument, if not, prompt the user
if [ -z "$1" ]; then
    read -r -p "Enter source directory path: " source_dir
else
    source_dir="$1"
fi

# Check if destination directory is provided as argument, if not, prompt the user
if [ -z "$2" ]; then
    read -r -p "Enter destination directory path: " destination_dir
else
    destination_dir="$2"
fi

# Check if source directory exists
if [ ! -d "$source_dir" ]; then
    echo "Source directory '$source_dir' does not exist."
    exit 1
fi

# Check if destination directory exists
if [ ! -d "$destination_dir" ]; then
    echo "Destination directory '$destination_dir' does not exist."
    exit 1
fi

# Loop through files in source directory
for file in "$source_dir"/*; do
    # Extract filename from path
    filename=$(basename "$file")
    
    # Create symbolic link in destination directory
    ln -s "$file" "$destination_dir/$filename"
    
    # Preserve modification time
    touch -h -r "$file" "$destination_dir/$filename"
    
    # Print a message for each symlink created
    echo "Created symlink for $filename"
done

echo "All symlinks created successfully."
