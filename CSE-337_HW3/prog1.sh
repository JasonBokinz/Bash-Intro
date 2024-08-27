#!/bin/bash

# check if source or destination path are provided
if [ "$#" -ne 2 ]; then
    echo "src and dest dirs missing"
    exit 1
fi

source_directory=$1
destination_directory=$2

# check if source direcotry path exists
if [ ! -d "$source_directory" ]; then
    echo "$source_directory not found"
    exit 0
fi
# check if destination directory path exists, if not create it
if [ ! -d "$destination_directory" ]; then
    mkdir -p "$destination_directory"
fi

# search for .c files in source directory and store them in a list and iterate though that list
c_files=$(find "$source_directory" -type f -name "*.c")
for c_file in $c_files; do
    # store path to such .c file to construct destination file path and form a directory
    relative_path=${c_file#$source_directory}
    destination_file="$destination_directory$relative_path"
    mkdir -p "$(dirname "$destination_file")"

    # based on the number of .c files in the directory prompt user if necessary then copy current file to destination directory
    if [ $(find "$(dirname "$c_file")" -type f -name "*.c" | wc -l) -lt 3 ]; then
        mv "$c_file" "$destination_file"
    else
        echo "Do you want to move this file? (y/n):"
        read can_move
        if [ "$can_move" = "y" ] || [ "$can_move" = "Y" ]; then
            mv "$c_file" "$destination_file"
        fi
    fi
    # remove any temporary files
    rm -rf "$destination_directory"/*.tmp
done