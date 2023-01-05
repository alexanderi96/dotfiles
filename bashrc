#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Thanks @NicoNex for the PS1!
PS1='\[\e[1;37m\][\[\e[m\]\[\e[1;33m\]\u\[\e[m\]\[\e[1;37m\]@\[\e[m\]\[\e[1;33m\]\h\[\e[m\]\[\e[1;37m\] \[\e[m\]\[\e[1;35m\]\W\[\e[m\]\[\e[1;37m\]]\[\e[m\]\[\e[1;37m\]\\$\[\e[m\] '

# if tou installed mcfly trough yay:
if [[ -r /usr/share/doc/mcfly/mcfly.bash ]]; then
  source /usr/share/doc/mcfly/mcfly.bash
fi

export PATH="$PATH:$HOME/.local/bin"
export GOPATH="$HOME/go"
export PATH="/usr/local/go/bin:$PATH:$GOPATH/bin"


# Aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'

alias startmining='~/mining/startmining.sh'

alias alacritty='~/apps/alacritty/alacritty'

#ssh
eval $(keychain --eval --quiet ~/.ssh/id_ed25519)
