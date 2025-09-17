{ config, pkgs, ... }:

{
  home.username = "stego";
  home.homeDirectory = "/home/stego";
  programs.git.enable = true;
  home.stateVersion = "25.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };
}
