#!/bin/bash

#getting the actual repo position
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
CONF_POS="$HOME/.config/"

# Verifica che siamo nella directory corretta
if [ ! -d "$DIR/config" ]; then
    echo "❌ Errore: Script deve essere eseguito dalla directory home/stego/dotfiles/"
    echo "Directory corrente: $DIR"
    exit 1
fi

# Controlla se è passato il flag -y
auto_yes=false
if [[ $1 == "-y" ]]; then
  auto_yes=true
fi

# Funzione per ottenere conferma
get_confirmation() {
  local prompt="$1"
  if $auto_yes; then
    echo "$prompt: Yes (auto)"
    return 0
  fi
  read -p "$prompt [y/N]: " answare
  [[ $answare == 'y' || $answare == 'Y' ]]
}

if get_confirmation "Copy bash configuration?"; then
  ln -sfv $DIR/bashrc $HOME/.bashrc
fi

if get_confirmation "Copy vim configuration?"; then
  ln -sfv $DIR/vimrc $HOME/.vimrc
  ln -sfv $DIR/config/nvim $CONF_POS
fi

ln -sfv $DIR/config/scripts $CONF_POS

if get_confirmation "Copy Sway setup?"; then
  ln -sfv $DIR/config/sway $CONF_POS
  ln -sfv $DIR/config/alacritty $CONF_POS
  ln -sfv $DIR/config/wofi $CONF_POS
  ln -sfv $DIR/config/wlogout $CONF_POS
  ln -sfv $DIR/config/waybar $CONF_POS
  ln -sfv $DIR/config/swaync $CONF_POS
  ln -sfv $DIR/config/sov $CONF_POS
fi

if get_confirmation "Copy Hypr setup?"; then
  ln -sfv $DIR/config/hypr $CONF_POS
  ln -sfv $DIR/config/waybar $CONF_POS
  ln -sfv $DIR/config/walker $CONF_POS
  ln -sfv $DIR/config/wlogout $CONF_POS
  ln -sfv $DIR/config/kitty $CONF_POS
  ln -sfv $DIR/config/waypaper $CONF_POS
fi
