#!/bin/bash

FILES="$HOME/.screenlayout/*.sh"

if [ "$TERM" == "dumb" ]; then
    SELECTOR=("dmenu" "-l" "50" "-h" "30" "-p" "Select Screen Profile" "-i" "-l" "50" "-fn" "mononoki NFM-20" "-h" "40" "-nb" "#191724" "-nf" "#e0def4" -"sb" "#191724" "-sf" "#59bce0")
else
    SELECTOR=("fzf")
fi

SCREEN=$(ls $FILES | awk '{sub(/^.*\//,""); sub(/.sh/,""); print}' | "${SELECTOR[@]}")

if [ "$SCREEN" == "" ]; then
    exit
fi

DIR=$HOME/.screenlayout
FILE="$DIR"/"$SCREEN".sh

echo "$FILE"

if [ -f "$FILE" ]; then
    $FILE
fi
