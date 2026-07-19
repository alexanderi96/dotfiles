{ config, pkgs, lib, ... }: {
  imports = [
    ./core.nix     # CLI, shell, git — tutto ciò che serve ovunque
    ./desktop.nix  # GUI: entrambe le macchine fanno anche da desktop
  ];

  home.username = "stego";
  home.homeDirectory = "/home/stego";

  home.stateVersion = "25.05";
}
