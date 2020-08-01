#!/bin/bash

#getting the actual repo position
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Copy bash configuration?"
read answare


if [[ $answare == 'y' ]]
then
	ln -sfv $DIR/bashrc $HOME/.bashrc
	ln -sfv $DIR/bash_profile $HOME/.bash_profile
fi

echo "Copy Wayland setup?"
read answare

if [[ $answare == 'y' ]]
then
	mkdir -p $HOME/.config/sway
	ln -sfv $DIR/config/sway/config $HOME/.config/sway/config

	mkdir $HOME/.config/alacritty
	ln -sfv $DIR/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

	mkdir $HOME/.config/waybar
	ln -sfv $DIR/config/waybar/style.css $HOME/.config/waybar/style.css
	ln -sfv $DIR/config/waybar/config $HOME/.config/waybar/config

	mkdir $HOME/.config/i3status-rust
	ln -sfv $DIR/config/i3status-rust/config.toml $HOME/.config/i3status-rust/config.toml
fi

