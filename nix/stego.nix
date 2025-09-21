{ config, pkgs, ... }:

{
  # Tutto quello che è "user environment" va qui

  home.username = "stego";
  home.homeDirectory = "/home/stego";

  # Pacchetti utente (non globali)
  home.packages = with pkgs; [
    neovim
  ];

  programs.git = {
    enable = true;
    userName = "Alessandro Ianne";
    userEmail = "alessandro.ianne96@gmail.com";
  };

  home.stateVersion = "25.05";
}

