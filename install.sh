#!/bin/bash

echo "Copy bash configuration?"
read answare

if [[ $answare == 'y' ]] && [[ -f $HOME/.bashrc ]] || [[ -f $HOME/.bash_profile ]]
then
	echo "It seems thst some files are already thre"
	echo "Do you want to overwrite them? (it's not possible to rollback the changes)"
	read overwrite
fi

if [[ $answare == 'y' ]] || [[ $overwrite == 'y' ]]
then
	ln -sfv $PWD/bashrc $HOME/.bashrc
	ln -sfv $PWD/bash_profile $HOME/.bash_profile
fi

echo "Copy Wayland setup?"
read answare

if [[ $answare == 'y' ]]
then
	mkdir -p $HOME/.config/sway
	ln -sv $PWD/config/sway/config $HOME/.config/sway/config

	mkdir $HOME/.config/alacritty
	ln -sv $PWD/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

	mkdir $HOME/.config/waybar
	ln -sv $PWD/config/waybar/style.css $HOME/.config/waybar/style.css
	ln -sv $PWD/config/waybar/config $HOME/.config/waybar/config
fi

