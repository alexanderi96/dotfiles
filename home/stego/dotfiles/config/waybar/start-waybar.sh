#!/bin/bash

# PID file to prevent multiple instances
PIDFILE="/tmp/waybar-start-script.pid"

# Check if script is already running
if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")
    # Check if the process is actually running
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Script already running with PID $PID"
        exit 0
    else
        # Stale PID file, remove it
        rm -f "$PIDFILE"
    fi
fi

# Create PID file with current process ID
echo $$ > "$PIDFILE"

# Cleanup function to remove PID file on exit
cleanup() {
    rm -f "$PIDFILE"
    killall waybar
}

# Set trap to cleanup on exit
trap cleanup EXIT INT TERM

# Detect which compositor is running
if pgrep -x "Hyprland" > /dev/null; then
    COMPOSITOR="hyprland"
elif pgrep -x "niri" > /dev/null; then
    COMPOSITOR="niri"
else
    echo "No supported compositor detected (Hyprland or niri)"
    exit 1
fi

echo "Detected compositor: $COMPOSITOR"

# Paths
CONFIG_DIR="$HOME/.config/waybar"
BASE_CONFIG="$CONFIG_DIR/config.base"
COMPOSITOR_CONFIG="$CONFIG_DIR/config.$COMPOSITOR"
FINAL_CONFIG="$CONFIG_DIR/config"

# Combine base config with compositor-specific config using jq
if command -v jq &> /dev/null; then
    # Merge the two JSON files: base config gets overwritten by compositor-specific config
    jq -s '.[0] * .[1]' "$BASE_CONFIG" "$COMPOSITOR_CONFIG" > "$FINAL_CONFIG"
    echo "Generated config for $COMPOSITOR"
else
    echo "Error: jq is not installed. Please install jq to use modular waybar config."
    exit 1
fi

# Files to watch for changes
CONFIG_FILES="$FINAL_CONFIG $HOME/.config/waybar/style.css $HOME/.config/waybar/colorscheme/selected.css"

# Get all arguments passed to the script
WAYBAR_ARGS="$@"

while true; do
    # Start waybar with the generated config
    waybar $WAYBAR_ARGS &
    inotifywait -e create,modify $CONFIG_FILES $BASE_CONFIG $COMPOSITOR_CONFIG
    killall waybar
    
    # Regenerate config on change
    jq -s '.[0] * .[1]' "$BASE_CONFIG" "$COMPOSITOR_CONFIG" > "$FINAL_CONFIG"
    echo "Config regenerated for $COMPOSITOR"
done
