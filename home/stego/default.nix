{ config, pkgs, lib, ... }: {
  imports = [
    ./programs/git.nix
    ./programs/shell.nix
    ./programs/vscode.nix
    ./programs/direnv.nix
    ./programs/vicinae.nix
    ./config.nix
    # ./hyprland.nix  # Modulo creato precedentemente per la parte Hyprland
  ];

  home.username = "stego";
  home.homeDirectory = "/home/stego";

  # === Programmi Utente (Spostati da programs.nix) ===
  home.packages = with pkgs; [
    # Productivity & GUI
    firefox
    obsidian
    beeper
    vscode # Se preferisci gestirlo interamente come utente
    
    # Communication
    discord
    telegram-desktop
    
    # Multimedia
    vlc
    gimp

    # Shell enhancements (configurazioni puramente utente)
    mcfly
    thefuck
  ];

  # ============================================================================
  #                          DOTFILES INTEGRATION
  # ============================================================================

  xdg.configFile = {
    "scripts" = { source = ./dotfiles/config/scripts; recursive = true; };
    "nvim/init.vim".source = ./dotfiles/config/nvim/init.vim;
  };

  home.file = {
    ".vimrc".source = ./dotfiles/vimrc;
    ".bashrc".source = ./dotfiles/bashrc;
    "Pictures/Screenshots/.keep".text = "";
  };

  home.stateVersion = "25.05";
}