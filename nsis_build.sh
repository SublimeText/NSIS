#!/bin/bash

# sublime-makensis
#
# The MIT License (MIT)
# Copyright (c) 2015 Jan T. Sott, Derek Willian Stavis
#
# This script builds NSIS scripts on non-Windows platforms (Mac OS X, Linux)
# using native makensis or through Wine
#
# Installing makensis on your distribution is easy, and works -in most cases-
# through the default package manager (e.g. apt-get, brew, yum). If you want
# to use the Windows builds to compile scripts, install Wine and the NSIS
# version of your choice.
#
# https://github.com/idleberg/sublime-makensis

# Check for arguments
if [[ $@ == '' ]]; then
    echo "Error: No arguments passed"
    exit 1
fi

### Native makensis

# Set NSIS locations
NSIS=(
    "/usr/bin/makensis"
    "/usr/local/bin/makensis"
    "/opt/local/bin/makensis"
    "/bin/makensis"
    )

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
    echo "Error: makensis not found"
else
    exit 0
fi

### Wine fallback (via https://gist.github.com/derekstavis/8288379)

echo
echo "Trying to use Wine fallback"

# Let' try Wine then
command -v wine >/dev/null 2>&1 || { 
    echo >&2 "Error: Wine not found"
    exit 127
}

# Get Program Files path via Wine command prompt
PROGRAMFILES=$(wine cmd /c 'echo %PROGRAMFILES%' 2>/dev/null)

# Translate windows path to absolute unix path
PATH=$(winepath -u "${PROGRAMFILES}" 2>/dev/null)

# Get makensis path
MAKENSIS=$(printf %q "${PATH%?}/NSIS/makensis.exe")

# Set WINE locations
WINE=(
    "/usr/bin/wine"
    "/usr/local/bin/wine"
    "/opt/local/bin/wine"
    "/bin/wine"
    )

# Iterate over $WINE
for i in ${WINE[*]}; do

    # Run makensis if found
    if [[ -e $i ]]; then
        eval $i $MAKENSIS -- $@
        break
    fi
done