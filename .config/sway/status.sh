#!/bin/bash

# battery
battery_status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
if [ -z "$battery_status" ]; then
    battery_status="N/A"
fi
battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)

# volume
volume=$(wpctl get-volume @DEFAULT_SINK@ 2>/dev/null | awk '{print $2 * 100}' | sed 's/%//')
muted=$(wpctl get-volume @DEFAULT_SINK@ 2>/dev/null | grep -o 'MUTED' | head -n 1)
#volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
#muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o 'yes' | head -n 1)

# time in HH:MM format
time=$(date +"%Y-%m-%d %H:%M")

echo "$volume% $muted | $battery_capacity% $battery_status | $time"
