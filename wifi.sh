#!/bin/bash

connection=$(nmcli -m tabular -f BARS,SSID device wifi list)
# connection=$(echo "$connection" | column -t -o '     ')
connection=$(echo "$connection" | awk 'NR > 1')

if [ "$TERM" != "dumb" ]; then
    connection=$(echo "$connection" | fzf)
else
    connection=$(echo "$connection" | dmenu -i -l 50 -p "Choose WiFi to connect" -fn "mononoki NFM-20" -h 40 -nb "#191724" -nf "#e0def4" -sb "#191724" -sf "#59bce0")
fi

connection=$(echo "$connection" | awk '{sub(/^[^ ]+[ ]+/, ""); print}')
connection=$(echo "$connection" | awk '{sub(/ +$/, ""); print}')

if [ "$connection" == "" ]; then
    exit
fi

dir=/etc/NetworkManager/system-connections
file="$dir"/"$connection".nmconnection

if [ -f "$file" ]; then
    nmcli dev wifi con "$connection" >> /dev/null 2>&1
    notify-send -t 5000 -a "Network Manager" " " "Connection to $connection successful."
else
    while true; do
        if [ "$TERM" != "dumb" ]; then
            echo -ne "Enter password: "
            read -sr password
            echo
        else
            password=$(dmenu -P -p "Enter Wifi password: " -fn "mononoki NFM-20" -h 40 -nb "#191724" -nf "#e0def4" -sb "#191724" -sf "#59bce0")
        fi

        nmcli dev wifi con "$connection" password "$password" >> /dev/null 2>&1

        if [ $? -eq 0 ]; then
            notify-send -t 5000 -a "Network Manager" " " "Connection to $connection successful."
            break
        fi

        if [ "$password" == "" ]; then
            notify-send -t 5000 -u critical -a "Network Manager" " " "Connection to $connection failed.\nTry again soon."
            nmcli connection delete "$connection" >> /dev/null 2>&1
            break
        fi
        nmcli connection delete "$connection" >> /dev/null 2>&1
    done
fi
