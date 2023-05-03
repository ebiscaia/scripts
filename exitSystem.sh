#!/bin/bash

options="󰜺 cancel\n lock\n󰒲 suspend\n restart\n shutdown"
DMENU_OPTS=("-i" "-l" "50" "-fn" "mononoki NFM-20" "-h" "40" "-nb" "#191724" "-nf" "#e0def4" -"sb" "#191724" "-sf" "#59bce0")

if [ "$TERM" == "dumb" ]; then
    option=$(echo -ne "$options" | dmenu -p "Exit System: " "${DMENU_OPTS[@]}" | awk '{print $2}')
else
    option=$(echo -ne "$options" | fzf | awk '{print $2}')
fi

while true; do
    if [[ $option == 'cancel' ]]; then
        exit
    fi
    if [[ $option == "lock" ]]; then
        xautolock -locknow
        exit
    fi

    if [[ $option == "suspend" ]]; then
        xautolock -locknow
        sleep 1
        systemctl suspend
        exit
    fi

    if [[ $option == "restart" ]]; then
        if [ "$TERM" == "dumb" ]; then
            while true; do
                PASS=$(echo "" | dmenu -P -p "Enter sudo password: " "${DMENU_OPTS[@]}")
                echo "$PASS" | sudo -S reboot -f
                if [ "$PASS" == "" ]; then
                    exit
                fi
            done
        else
            sudo reboot -f
        fi
    fi
    if [[ $option == "shutdown" ]]; then
        if [ "$TERM" == "dumb" ]; then
            while true; do
                PASS=$(echo "" | dmenu -P -p "Enter sudo password: " "${DMENU_OPTS[@]}")
                echo "$PASS" | sudo -S shutdown -P
                if [ "$PASS" == "" ]; then
                    exit
                fi
            done
        else
            sudo shutdown -P
        fi
    fi
done
