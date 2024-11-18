#!/bin/bash

# Input da wofi
query="$@"

# Se il comando non esiste come applicazione o comando shell
if ! command -v "$query" &> /dev/null && ! which "$query" &> /dev/null; then
    # Crea menu di opzioni con icone fighe
    action=$(echo -e "🌐 Search Web\n💻 Run in Shell" | wofi --dmenu --prompt="Not found. What now?" --width 200 --height 100)
    
    case "$action" in
        "🌐 Search Web")
            search_query=$(echo "$query" | sed 's/ /+/g')
            hyprctl dispatch exec "[float] firefox '$search_query'" ;;
        "💻 Run in Shell")
            hyprctl dispatch exec "[float] kitty -e bash -c \"$query; echo 'Press Enter to close...'; read\"" ;;
    esac
fi