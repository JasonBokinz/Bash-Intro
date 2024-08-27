#!/bin/bash

# check to see if the data or output paths are not provided
if [ "$#" -ne 2 ]; then
    echo "data file or output file not found"
    exit 1
fi

data_file=$1
output_file=$2

# check if the data file path exists
if [ ! -f "$data_file" ]; then
    echo "$data_file not found"
    exit 1
fi

# using awk extract columns based on specified format, and compute column sums to be written in the output file
awk -F '[,;:]' '{
    for (i = 1; i <= NF; i++) {
        columnSum[i] += $i
    }
}
END {
    for (i = 1; i <= NF; i++) {
        print "Col " i " : " columnSum[i] > "'"$output_file"'"
    }
}' "$data_file"