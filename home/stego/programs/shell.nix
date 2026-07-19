{ config, pkgs, ... }:
{
  # Migrazione del vecchio dotfiles/bashrc (2026-07-19).
  # Non migrato di proposito: doppio guard BASHRCSOURCED, pathmunge, umask,
  # export SHELL=/bin/bash e il loop su /etc/profile.d — residui di distro
  # non-NixOS; thefuck è stato rimosso da nixpkgs 26.05.
  programs.bash = {
    enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      la = "ls -a";
      ll = "ls -l";
      vim = "nvim";
      startmining = "~/mining/startmining.sh";
      engshell = "python ~/workspace/repo/engshell/engshell.py";
      goland = "~/.local/share/JetBrains/Toolbox/apps/goland/bin/goland -Dawt.toolkit.name=WLToolkit";
      # vscode parte in xwayland anche se supporta wayland: forza ozone
      code = "ELECTRON_OZONE_PLATFORM_HINT=auto code";
    };

    sessionVariables = {
      GOPATH = "$HOME/go";
      BUN_INSTALL = "$HOME/.bun";
      NVM_DIR = "$HOME/.nvm";
    };

    initExtra = ''
      # Titolo finestra terminale
      if [ "$PS1" ] && [ -z "$PROMPT_COMMAND" ]; then
        case $TERM in
        xterm*)
          PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "''${USER}" "''${HOSTNAME%%.*}" "''${PWD/#$HOME/\~}"'
          ;;
        screen*)
          PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "''${USER}" "''${HOSTNAME%%.*}" "''${PWD/#$HOME/\~}"'
          ;;
        esac
      fi

      # Thanks @NicoNex for the PS1!
      # Per il full path usa \w, per la sola dir corrente \W
      PS1='\[\e[1;37m\][\[\e[m\]\[\e[1;33m\]\u\[\e[m\]\[\e[1;37m\]@\[\e[m\]\[\e[1;33m\]\h\[\e[m\]\[\e[1;37m\] \[\e[m\]\[\e[1;35m\]\w\[\e[m\]\[\e[1;37m\]]\[\e[m\]\[\e[1;37m\]\\$\[\e[m\] '

      # PATH utente (toolchain imperative fuori da nix)
      export PATH="$PATH:$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:$BUN_INSTALL/bin"

      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

      eval $(keychain --eval --quiet ~/.ssh/id_ed25519_personal)

      # Ambiente dev Gnammus
      [ -f ~/.gnrc ] && . ~/.gnrc
    '';
  };

  # McFly: modulo HM al posto dell'eval manuale nel bashrc
  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
  };
}
