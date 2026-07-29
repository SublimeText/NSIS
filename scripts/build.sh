#!/bin/bash

# The MIT License (MIT)
# Copyright (c) 2015-2023 Jan T. Sott, Derek Willian Stavis
#
# This script builds NSIS scripts on non-Windows platforms (Mac OS X, Linux)
# using native makensis or through Wine

# GUI-launched editors inherit a minimal PATH, so prepend the usual install roots
PATH="/usr/local/bin:/opt/homebrew/bin:/opt/local/bin:/usr/bin:/bin:$PATH"

if [ $# -eq 0 ]; then
    echo >&2 "Error: No arguments passed"
    exit 1
fi

# Native makensis
if command -v makensis >/dev/null 2>&1; then
    exec makensis "$@"
fi

# Wine fallback (via https://gist.github.com/derekstavis/8288379)
echo
echo "Trying to use Wine fallback"

command -v wine >/dev/null 2>&1 || {
    echo >&2 "Error: Wine not found"
    exit 127
}

# NSIS is a 32-bit install, so a win64 prefix puts it under Program Files (x86)
find_makensis() {
    local var win_path unix_path candidate
    for var in '%PROGRAMFILES%' '%PROGRAMFILES(x86)%'; do
        # cmd terminates lines with CRLF
        win_path=$(wine cmd /c "echo $var" 2>/dev/null | tr -d '\r')
        [ -n "$win_path" ] || continue

        unix_path=$(winepath -u "$win_path" 2>/dev/null) || continue
        candidate="${unix_path%/}/NSIS/makensis.exe"

        if [ -f "$candidate" ]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done
    return 1
}

MAKENSIS=$(find_makensis) || {
    echo >&2 "Error: makensis.exe not found in the Wine prefix"
    exit 127
}

# makensis reads a leading "/" as a switch, so the unix script path has to come
# after "--" while options stay in front of it
options=()
files=()
for arg in "$@"; do
    case "$arg" in
        -*) options+=("$arg") ;;
        *)  files+=("$arg")   ;;
    esac
done

exec wine "$MAKENSIS" "${options[@]}" -- "${files[@]}"
