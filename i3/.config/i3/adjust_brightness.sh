#!/bin/bash

# Get current brightness
current_brightness=$(xrandr --verbose | grep -i brightness | awk '{print $2}')
current_brightness=${current_brightness#0.}  # Strip leading 0.

# Check if the action is to increase or decrease
case "$1" in
    up)
        new_brightness=$(echo "$current_brightness + 0.1" | bc)
        ;;
    down)
        new_brightness=$(echo "$current_brightness - 0.1" | bc)
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac

# Clamp brightness values to the range [0, 1]
if (( $(echo "$new_brightness > 1" | bc -l) )); then
    new_brightness=1
elif (( $(echo "$new_brightness < 0" | bc -l) )); then
    new_brightness=0
fi

# Set the new brightness
xrandr --output eDP-1 --brightness "$new_brightness"

