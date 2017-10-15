#!/bin/bash

# sublime-makensis
#
# The MIT License (MIT)
# Copyright (c) 2015-2017 Jan T. Sott, Derek Willian Stavis
#
# This script builds NSIS scripts on non-Windows platforms (Mac OS X, Linux)
# using native makensis or through Wine
#
# Installing makensis on your distribution is easy, and works -in most cases-
# through the default package manager (e.g. apt-get, brew, yum). If you want
# to use the Windows build to compile scripts, install Wine and a NSIS version
# of your choice.
#
# https://github.com/idleberg/sublime-makensis

# Set path
PATH=/usr/bin:/usr/local/bin:/opt/local/bin:/bin:$PATH

# Native makensis
if makensis -VERSION >/dev/null 
then

    # Check for arguments
    if [[ $@ == '' ]]
    then
        echo "Error: No arguments passed"
        exit 1
    fi

    makensis "$@"

    if [ $? -eq 0 ]
    then
        exit 0
    fi

# Wine fallback (via https://gist.github.com/derekstavis/8288379)
else
    echo
    echo "Trying to use Wine fallback"

    # Let' try Wine then
    command -v wine >/dev/null 2>&1 || { 
      echo >&2 "Error: Wine not found"
      exit 127
    }

    # Get Program Files path via Wine command prompt
    PROGRAMS_WIN=$(wine cmd /c 'echo %PROGRAMFILES%' 2>/dev/null)

    # Translate windows path to absolute unix path
    PROGRAMS_UNIX=$(winepath -u "${PROGRAMS_WIN}" 2>/dev/null)

    # Get makensis path
    MAKENSIS=$(printf %q "${PROGRAMS_UNIX%?}/NSIS/makensis.exe")

    # Set arguments
    if [[ $1 != '-WX' ]]
    then
        ARGUMENTS="--"
        SCRIPT=\"$@\"
    else
        ARGUMENTS="$1 --"
        SCRIPT=\"${@:2}\"
    fi

    eval wine $MAKENSIS $ARGUMENTS $SCRIPT
fi
