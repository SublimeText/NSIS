#!/bin/bash

# Check for arguments
if [[ $@ == '' ]]; then
    echo Error: No arguments passed
    exit
fi

# Set NSIS locations
NSIS=("makensis"
    "/bin/makensis"
    "/usr/bin/makensis"
    "/usr/local/bin/makensis"
    "/usr/local/sbin/makensis"
    "/opt/local/bin/makensis"
    "/opt/local/sbin/makensis")

# Count items in $NSIS
items=${#NSIS[@]}

# Set counter
count=0

# Iterate over $NSIS
for i in ${NSIS[*]}; do

    # Increment counter
    count=$((count+1))

    # Run makensis if found
    if [[ -e $i ]]; then
        eval $i $@
        break
    fi
done

# Display error
if [[ $count == $items ]]; then
    echo Error: makensis not found
fi