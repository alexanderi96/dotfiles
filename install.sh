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
fi

