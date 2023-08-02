#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Thanks @NicoNex for the PS1!
PS1='\[\e[1;37m\][\[\e[m\]\[\e[1;33m\]\u\[\e[m\]\[\e[1;37m\]@\[\e[m\]\[\e[1;33m\]\h\[\e[m\]\[\e[1;37m\] \[\e[m\]\[\e[1;35m\]\W\[\e[m\]\[\e[1;37m\]]\[\e[m\]\[\e[1;37m\]\\$\[\e[m\] '

# McFly
eval "$(mcfly init bash)"

export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:/usr/local/go/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:/media/Storage/aurispi/dotnet"

# Dotnet used for assetto corsa server
export DOTNET_ROOT=/media/Storage/aurispi/Assetto/dotnet

# Aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'

alias startmining='~/mining/startmining.sh'
alias vim='nvim'
alias aurispi='ssh 192.168.1.157' # -L 9901:localhost:5901'
alias engshell='python ~/workspace/repo/engshell/engshell.py'

#ssh
eval $(keychain --eval --quiet ~/.ssh/id_ed25519)
