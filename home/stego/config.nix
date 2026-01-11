{ config, pkgs, ... }: {
  

  xdg.configFile = {
    "opencode" = { source = ./dotfiles/config/opencode; recursive = true; };
  };
}