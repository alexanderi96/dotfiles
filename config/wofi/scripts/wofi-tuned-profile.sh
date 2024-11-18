#!/bin/bash

# Funzione per ottenere il profilo attuale
get_profile() {
    current_profile=$(tuned-adm active 2>/dev/null | cut -d' ' -f4-)
    case "$current_profile" in
        *"latency-performance"*)
            echo '{"class": "performance", "text": "󰓅 performance", "tooltip": "Performance Mode"}'
            ;;
        *"powersave"*)
            echo '{"class": "powersave", "text": "󰾆 powersave", "tooltip": "Power Save Mode"}'
            ;;
        *"balanced"*)
            echo '{"class": "balanced", "text": "󰾅 balanced", "tooltip": "Balanced Mode"}'
            ;;
        *"balanced-battery"*)
            echo '{"class": "battery", "text": "󰁾 battery", "tooltip": "Battery Mode"}'
            ;;
        *)
            echo '{"class": "unknown", "text": "󱐋 unknown", "tooltip": "Profile Unknown"}'
            ;;
    esac
}

# Se viene passato un argomento per il menu
if [ "$1" = "menu" ]; then
    # Mostra menu con wofi nella stessa posizione del wifi menu
    selected=$(printf "󰓅 Performance\n󰾅 Balanced\n󰁾 Battery\n󰾆 Powersave" | \
        wofi --dmenu \
            --cache-file=/dev/null \
            --insensitive \
            --width=200 \
            --height=275 \
            --no-actions \
            --location 3 \
            --xoffset -30 \
            --scrollbar=false \
            --hide-search=true \
            --prompt="Power Profile" \
            --style ~/.config/wofi/style.css)
    
    # Imposta il profilo in base alla selezione
    case "$(echo "$selected" | sed 's/^. //')" in
        "Performance")
            sudo tuned-adm profile latency-performance
            ;;
        "Balanced")
            sudo tuned-adm profile balanced
            ;;
        "Battery")
            sudo tuned-adm profile balanced-battery
            ;;
        "Powersave")
            sudo tuned-adm profile powersave
            ;;
    esac
else
    # Se non ci sono argomenti, mostra il profilo attuale
    get_profile
fi