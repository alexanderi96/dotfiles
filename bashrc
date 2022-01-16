#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# if tou installed mcfly trough yay:
if [[ -r /usr/share/doc/mcfly/mcfly.bash ]]; then
  source /usr/share/doc/mcfly/mcfly.bash
fi

export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export GOPATH="$HOME/go"

# Aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'

#ssh
eval $(keychain --eval --quiet ~/.ssh/id_ed25519)

