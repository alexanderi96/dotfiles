#!/bin/bash

CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css $HOME/.config/waybar/colorscheme/selected.css"

trap "killall waybar" EXIT

# Prende tutti gli argomenti passati allo script e li salva
WAYBAR_ARGS="$@"

while true; do
    # Passa gli argomenti a waybar usando $WAYBAR_ARGS
    waybar $WAYBAR_ARGS &
    inotifywait -e create,modify $CONFIG_FILES
    killall waybar
done