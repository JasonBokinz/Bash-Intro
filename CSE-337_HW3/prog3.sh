#!/bin/bash

# Check if the data file is provided
if [ -z "$1" ]; then
    echo "Error: missing data file"
    exit 1
fi

# Assign the data file and weights
data_file="$1"
weights=("${@:2}")

# Read the header to determine the number of parts (excluding ID)
IFS=',' read -ra header < "$data_file"
num_arguments=$(( ${#header[@]} - 1 ))

# Check if the number of weights is less than the number of parts
if [ ${#weights[@]} -lt $num_arguments ]; then
    # If less, assume remaining weights are 1
    for ((i=${#weights[@]}; i<$num_arguments; i++)); do
        weights+=("1")
    done
elif [ ${#weights[@]} -gt $num_arguments ]; then
    # If more, ignore additional weights
    weights=("${weights[@]:0:$num_arguments}")
fi

# Calculate the weighted average using awk
awk -v num_arguments=$num_arguments -v weights="${weights[*]}" '
    BEGIN { split(weights, w); sum_weight = 0; sum_score = 0; }
    NR > 1 {
        for (i=2; i<=NF; i++) {
            sum_weight += w[i-1];
            sum_score += w[i-1] * $i;
        }
    }
    END {
        avg = sum_score / sum_weight;
        printf("Overall weighted average of all students: %.0f\n", int(avg));
    }
' FS=',' "$data_file"