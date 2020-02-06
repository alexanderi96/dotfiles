#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

if [[ -r ~/development/mcfly.bash ]]; then
  source $HOME/development/mcfly.bash
fi

