#!/bin/bash

# Check if temporary directory is provided as argument, if not, prompt the user
if [ -z "$1" ]; then
    read -r -p "Enter temporary directory path: " temporary_dir
else
    temporary_dir="$1"
fi

# Check if source directory is provided as argument, if not, prompt the user
if [ -z "$2" ]; then
    read -r -p "Enter source directory path: " source_dir
else
    source_dir="$2"
fi

# Check if destination directory is provided as argument, if not, prompt the user
if [ -z "$3" ]; then
    read -r -p "Enter destination directory path: " destination_dir
else
    destination_dir="$3"
fi

# Check if temporary directory exists
if [ ! -d "$temporary_dir" ]; then
    echo "Temporary directory '$temporary_dir' does not exist."
    exit 1
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

# Loop through files in temporary directory
for file in "$temporary_dir"/*; do
    # Extract filename from path
    filename=$(basename "$file")
    
    # Check if the file already exists in the destination directory
    if [ -e "$destination_dir/$filename" ]; then
        echo "File '$filename' already exists in destination directory. Skipping..."
    else
        # Create symbolic link in destination directory
        ln -s "$source_dir/$filename" "$destination_dir/$filename"
        
        # Preserve modification time
        touch -h -r "$source_dir/$filename" "$destination_dir/$filename"
        
        # Print a message for each symlink created
        echo "Created symlink for $filename"
    fi
done

# Display the details of symlinked files in destination directory
echo "Symlinked files in destination directory:"
ls -l "$destination_dir"

echo "All symlinks created successfully."
