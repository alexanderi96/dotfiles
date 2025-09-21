#!/bin/bash
# NixOS-compatible update checker for waybar
TERMINAL="kitty"
CACHE_FILE="/tmp/nixos-updates-count"
LOCK_FILE="/tmp/nixos-updating.lock"

format_json() {
    # Escape special characters and format JSON properly
    local text="$1"
    local tooltip="$2"
    local class="$3"

    # Escape caratteri speciali nel tooltip
    tooltip=$(echo "$tooltip" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

    echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
}

count_updates() {
    # Se stiamo aggiornando, mostra un indicatore speciale
    if [ -f "$LOCK_FILE" ]; then
        format_json " " "Aggiornamento in corso..." "updating"
        return
    fi

    # Check for flake updates
    if [ -f "/etc/nixos/flake.lock" ]; then
        cd /etc/nixos
        # Compare current flake.lock with potential updates
        nix flake update --dry-run 2>/dev/null | grep -c "Updated" > "$CACHE_FILE" 2>/dev/null || echo "0" > "$CACHE_FILE"
        count=$(cat "$CACHE_FILE")
    else
        # Fallback for non-flake systems
        count=0
    fi

    if [ "$count" -gt 0 ]; then
        if [ "$count" -eq 1 ]; then
            header="1 aggiornamento disponibile"
        else
            header="$count aggiornamenti disponibili"
        fi

        tooltip="${header}\\n\\nEsegui nixos-rebuild per aggiornare"
        format_json "󰚰 $count" "$tooltip" "updates-available"
    else
        format_json "󰏗" "Sistema aggiornato" "up-to-date"
    fi
}

update_packages() {
    touch "$LOCK_FILE"
    pkill -RTMIN+8 waybar

    $TERMINAL -- bash -c '
        echo "Aggiornamento del sistema NixOS..."
        cd /etc/nixos
        sudo nix flake update
        sudo nixos-rebuild switch --flake .
        rm -f "'$CACHE_FILE'"
        rm -f "'$LOCK_FILE'"
        pkill -RTMIN+8 waybar
        read -p "Premi Enter per chiudere..."
    '
}

case "$1" in
    --count)
        count_updates
        ;;
    --update)
        update_packages
        ;;
    *)
        echo "Utilizzo: $0 [--count | --update]"
        ;;
esac