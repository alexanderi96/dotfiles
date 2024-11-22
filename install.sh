#!/bin/bash

#getting the actual repo position
DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" >/dev/null 2>&1 && pwd)"
CONF_POS="$HOME/.config/"

echo "Copy bash configuration?"
read answare

if [[ $answare == 'y' ]]; then
  ln -sfv $DIR/bashrc $HOME/.bashrc
fi

echo "Copy vim configuration?"
read answare

if [[ $answare == 'y' ]]; then
  ln -sfv $DIR/vimrc $HOME/.vimrc
  ln -sfv $DIR/config/nvim $CONF_POS
fi

ln -sfv $DIR/config/scripts $CONF_POS

echo "Copy Sway setup?"
read answare

if [[ $answare == 'y' ]]; then
  ln -sfv $DIR/config/sway $CONF_POS
  ln -sfv $DIR/config/alacritty $CONF_POS
  ln -sfv $DIR/config/wofi $CONF_POS
  ln -sfv $DIR/config/wlogout $CONF_POS
  ln -sfv $DIR/config/waybar $CONF_POS
  ln -sfv $DIR/config/swaync $CONF_POS
  ln -sfv $DIR/config/sov $CONF_POS
fi

echo "Copy Hypr setup?"
read answare

if [[ $answare == 'y' ]]; then
  ln -sfv $DIR/config/hypr $CONF_POS
  ln -sfv $DIR/config/waybar $CONF_POS
  ln -sfv $DIR/config/wofi $CONF_POS
  ln -sfv $DIR/config/wlogout $CONF_POS
  ln -sfv $DIR/config/kitty $CONF_POS
  ln -sfv $DIR/config/waypaper $CONF_POS
fi
