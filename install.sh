#!/bin/bash

#getting the actual repo position
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONF_POS="$HOME/.config/"

echo "Copy bash configuration?"
read answare

if [[ $answare == 'y' ]]
then
	ln -sfv $DIR/bashrc $HOME/.bashrc
fi

echo "Copy vim configuration?"
read answare

if [[ $answare == 'y' ]]
then
	ln -sfv $DIR/vimrc $HOME/.vimrc
fi

echo "Copy Wayland setup?"
read answare

if [[ $answare == 'y' ]]
then
	ln -sfv $DIR/config/sway $CONF_POS
	ln -sfv $DIR/config/alacritty $CONF_POS
	ln -sfv $DIR/config/i3status $CONF_POS
	ln -sfv $DIR/config/mako $CONF_POS
	ln -sfv $DIR/config/wofi $CONF_POS
	ln -sfv $DIR/config/wlogout $CONF_POS
	ln -sfv $DIR/config/waybar $CONF_POS
	ln -sfv $DIR/config/swaync $CONF_POS
fi

