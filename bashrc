#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# store colors
MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[01;33m\]"
BLUE="\[\033[00;34m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
GREEN="\[\033[00;32m\]"
RED="\[\033[0;31m\]"
VIOLET='\[\033[01;35m\]'
NOCOLOR='\e[m'

function color_my_prompt {
  local __user_and_host="\u@\h"
  local __user="\u"
  local __cur_location="$RED\w"           # capital 'W': current directory, small 'w': full file path
  local __git_branch_color="$GREEN"
  local __prompt_tail="$"
  local __user_input_color=""
    
  # Build the PS1 (Prompt String)
  export PS1="[$__user_and_host: $__cur_location$NOCOLOR]$__prompt_tail \[$(tput sgr0)\]"
}
 
# configure PROMPT_COMMAND which is executed each time before PS1
export PROMPT_COMMAND=color_my_prompt

# if tou installed mcfly trough yay:
if [[ -r /usr/share/doc/mcfly/mcfly.bash ]]; then
  source /usr/share/doc/mcfly/mcfly.bash
fi

export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local"
export GOPATH=$HOME/go

# Aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'

#ssh
eval $(keychain --eval --quiet ~/.ssh/id_rsa)

