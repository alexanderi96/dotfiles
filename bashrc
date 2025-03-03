# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prevent doublesourcing
if [ -z "$BASHRCSOURCED" ]; then
  BASHRCSOURCED="Y"

  # Shell Options
  shopt -s histappend   # Append to history instead of overwriting
  shopt -s checkwinsize # Check window size after each command

  # Prompt configuration
  if [ "$PS1" ]; then
    if [ -z "$PROMPT_COMMAND" ]; then
      declare -a PROMPT_COMMAND
      case $TERM in
      xterm*)
        PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
        ;;
      screen*)
        PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
        ;;
      esac
    fi

    # Colorized PS1 with full path option
    # To switch between \w (full path) and \W (current directory), change the corresponding character
    PS1='\[\e[1;37m\][\[\e[m\]\[\e[1;33m\]\u\[\e[m\]\[\e[1;37m\]@\[\e[m\]\[\e[1;33m\]\h\[\e[m\]\[\e[1;37m\] \[\e[m\]\[\e[1;35m\]\w\[\e[m\]\[\e[1;37m\]]\[\e[m\]\[\e[1;37m\]\\$\[\e[m\] '
  fi

  # Path configuration
  pathmunge() {
    case ":${PATH}:" in
    *:"$1":*) ;;
    *)
      if [ "$2" = "after" ]; then
        PATH=$PATH:$1
      else
        PATH=$1:$PATH
      fi
      ;;
    esac
  }

  # Set default umask if not already set
  [ $(umask) -eq 0 ] && umask 022

  # Environment variables
  export SHELL=/bin/bash
  export PATH="$PATH:$HOME/go/bin"
  export PATH="$PATH:$HOME/.local/bin"
  export PATH="$PATH:/usr/local/go/bin"
  export PATH="$PATH:$HOME/.cargo/bin"
  export GOPATH="$HOME/go"
  #  export PATH="$PATH:/media/Storage/aurispi/dotnet"
  #  export DOTNET_ROOT=/media/Storage/aurispi/Assetto/dotnet

  # McFly configuration
  eval "$(mcfly init bash)"

  # Aliases
  alias ls='ls --color=auto'
  alias la='ls -a'
  alias ll='ls -l'
  alias startmining='~/mining/startmining.sh'
  alias vim='nvim'
  alias engshell='python ~/workspace/repo/engshell/engshell.py'
  #alias powertop='ssh powertop'


  alias goland='~/.local/share/JetBrains/Toolbox/apps/goland/bin/goland -Dawt.toolkit.name=WLToolkit'

  # fixes vscode opening in xwayland even though supporting wayland
  alias code='ELECTRON_OZONE_PLATFORM_HINT=auto code'

  # Source additional configurations
  for i in /etc/profile.d/*.sh; do
    if [ -r "$i" ]; then
      if [ "$PS1" ]; then
        . "$i"
      else
        . "$i" >/dev/null
      fi
    fi
  done

  unset i
  unset -f pathmunge
fi

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# SSH keychain
#    eval $(keychain --eval --quiet ~/.ssh/id_ed25519_personal)

eval $(thefuck --alias)
# You can use whatever you want as an alias, like for Mondays:
eval $(thefuck --alias FUCK)

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

. "$HOME/.apikeys"
