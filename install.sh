#!/bin/bash

#getting the actual repo position
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Copy various configurations?"
read answare

if [[ $answare == 'y' ]]
then
	ln -sfv $DIR/bashrc $HOME/.bashrc
	ln -sfv $DIR/vimrc $HOME/.vimrc
	ln -sfv $DIR/Xresousces $HOME/.Xresources
fi

echo "Copy i3 setup?"
read answare

if [[ $answare == 'y' ]]
then
	mkdir -p $HOME/.config/i3
	ln -sfv $DIR/config/i3/config $HOME/.config/i3/config

	mkdir $HOME/.config/i3status
	ln -sfv $DIR/config/i3status/config $HOME/.config/i3status/config

	mkdir $HOME/.config/rofi
	ln -sfv $DIR/config/rofi/config.rasi $HOME/.config/rofi/config.rasi

	mkdir $HOME/.config/conky
	ln -sfv $DIR/config/conky/conky.conf $HOME/.config/conky/conky.conf

	mkdir $HOME/.config/picom
	ln -sfv $DIR/config/picom/picom.conf $HOME/.config/picom/picom.conf

	mkdir $HOME/.config/alacritty
	ln -svf $DIR/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
fi

