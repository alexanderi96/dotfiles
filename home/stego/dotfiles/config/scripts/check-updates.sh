#!/bin/bash
TERMINAL="kitty"
CACHE_FILE="/tmp/dnf-updates-count"
LOCK_FILE="/tmp/dnf-updating.lock"
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
    count=$(dnf check-update --refresh 2>/dev/null | awk '/^[a-zA-Z0-9]/ {count++} END {print count+0}')

    if [ "$count" -gt 0 ]; then
        if [ "$count" -eq 1 ]; then
            header="1 aggiornamento disponibile"
        else
            header="$count aggiornamenti disponibili"
        fi

        # Formatta la lista dei pacchetti
        packages=$(dnf list --upgrades 2>/dev/null | tail -n +2 | awk '{printf "• %s -> %s\\n", $1, $2}')
        tooltip="${header}\\n\\nPacchetti:\\n${packages}"

        format_json "󰚰 $count" "$tooltip" "updates-available"
    else
        format_json "󰏗" "Sistema aggiornato" "up-to-date"
    fi
}
update_packages() {
    touch "$LOCK_FILE"
    pkill -RTMIN+8 waybar

    $TERMINAL -- bash -c '
        sudo dnf upgrade -y
        rm -f "$CACHE_FILE"
        rm -f "$LOCK_FILE"
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